----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.06.2020 14:03:24
-- Design Name: 
-- Module Name: timestamp - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.evr_pkg.ALL;

entity timestamp is  
  Port (
    -- Event clock and codes from RX transceiver
    event_clk    : in  std_logic;
    event_code   : in  std_logic_vector(7 downto 0);
    reset        : in  std_logic;
    MAP14        : in  std_logic;
    -- Registers
    evr_ctrl     : in evr_ctrl_reg;
    ts_regs      : out ts_regs;
    -- External timestamp request mechanism
    ts_req       : in  std_logic;
    ts_data      : out std_logic_vector(63 downto 0);
    ts_valid     : out std_logic;
    -- 512-sample Timestamp event FIFO buffer interface
    buffer_pop   : in  std_logic;
    buffer_data  : out std_logic_vector(71 downto 0);
    buffer_valid : out std_logic );
end timestamp;

architecture Behavioral of timestamp is

    -- Signals
    -- Timestamping counter and registers
    signal seconds_shift_reg         : std_logic_vector(31 downto 0) := (others => '0');
    signal seconds_reg               : std_logic_vector(31 downto 0) := (others => '0');
    signal seconds_latch             : std_logic_vector(31 downto 0) := (others => '0');
    signal ts_event_count            : std_logic_vector(31 downto 0) := (others => '0');
    signal ts_latch                  : std_logic_vector(31 downto 0) := (others => '0');
    
    -- Event buffer FIFO 
    signal fifo_empty                : std_logic := '0';
    signal fifo_full                 : std_logic := '0';
    signal fifo_almost_empty         : std_logic := '0';
    signal fifo_almost_full          : std_logic := '0';
    signal fifo_wr_en                : std_logic := '0';
    signal fifo_rd_en                : std_logic := '0';
    signal fifo_buffer_valid         : std_logic := '0';
    signal fifo_count                : std_logic_vector(8 downto 0)  := (others => '0');
    signal fifo_event_data_in        : std_logic_vector(71 downto 0) := (others => '0');
    signal fifo_event_data_out       : std_logic_vector(71 downto 0) := (others => '0');
    
    -- External trigger timestamp
    signal ext_trig_ts_data          : std_logic_vector(63 downto 0) := (others => '0');
    signal ext_trig_ts_valid         : std_logic := '0';
    signal ext_trig_pulse            : std_logic := '0';
    signal ext_reg_t                 : std_logic := '0';
    -- 2-tap TDL of 64-bit values
    type   ts_delay_line is array (0 to 1) of std_logic_vector(63 downto 0);
    signal ext_trig_ts_tdl           : ts_delay_line;
    
    -- Enable debug
    attribute mark_debug : string;
    attribute mark_debug of seconds_shift_reg : signal is "true";
    attribute mark_debug of seconds_reg : signal is "true";
    attribute mark_debug of seconds_latch : signal is "true";
    attribute mark_debug of ts_event_count : signal is "true";
    attribute mark_debug of ts_latch : signal is "true";
    
    attribute mark_debug of fifo_empty : signal is "true";
    attribute mark_debug of fifo_full : signal is "true";
    attribute mark_debug of fifo_wr_en : signal is "true";
    attribute mark_debug of fifo_rd_en : signal is "true";
    attribute mark_debug of fifo_buffer_valid : signal is "true";
    attribute mark_debug of fifo_count : signal is "true";
    attribute mark_debug of fifo_event_data_in : signal is "true";
    attribute mark_debug of fifo_event_data_out : signal is "true";
    
    attribute mark_debug of ext_trig_ts_data : signal is "true";
    attribute mark_debug of ext_trig_ts_valid : signal is "true";
    attribute mark_debug of ext_trig_ts_tdl : signal is "true";

    component fifo_generator_0 IS
      PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(71 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(71 DOWNTO 0);
        full : OUT STD_LOGIC;
        almost_full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC;
        almost_empty : OUT STD_LOGIC;
        data_count : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
      );
    end component fifo_generator_0;

begin
  
  -- Process to load a '0' or '1' into the 32-bit seconds shift register  
  seconds_shift : process(event_clk, reset)
  begin
    if reset = '1' then 
      seconds_shift_reg <= (others => '0');
    else
      if rising_edge(event_clk) then
        if event_code = C_EVENT_SECONDS_0 then
          seconds_shift_reg <= seconds_shift_reg(30 downto 0) & '0';
        elsif event_code = C_EVENT_SECONDS_1 then
          seconds_shift_reg <= seconds_shift_reg(30 downto 0) & '1';
        end if;
      end if;
    end if;            
  end process seconds_shift;
  
  -- Process to register the value of the seconds_shift_reg when the reset event is received
  latch_seconds : process(event_clk, reset)
  begin
    if reset = '1' then
      seconds_reg <= (others => '0');
    else
      if rising_edge(event_clk) then 
        if event_code = C_EVENT_TS_COUNT_RESET then
          seconds_reg <= seconds_shift_reg;
        end if;
      end if;
    end if;
  end process latch_seconds;
  
  -- Process to implement a 32-bit timestamp event counter
  ts_event_counter : process(event_clk, reset)
  begin
    if reset = '1' then
      ts_event_count <= (others => '0');
    else
      if rising_edge(event_clk) then
        if (event_code = C_EVENT_TS_COUNT_RESET) OR (evr_ctrl.rst_ts = '1') then
          ts_event_count <= (others => '0');   
        else
          ts_event_count <= std_logic_vector(unsigned(ts_event_count) + 1);
        end if;
      end if;
    end if;  
  end process ts_event_counter;
  
  -- Process to latch timestamp values
  ts_latch_proc : process(event_clk, reset)
  begin
    if reset = '1' then
      ts_latch      <= (others => '0');
    else
      if rising_edge(event_clk) then
        if evr_ctrl.rst_ts = '1' then
          ts_latch <= (others => '0');  
        elsif (MAP14 = '1') OR (evr_ctrl.latch_ts = '1') then
          ts_latch <= ts_event_count;
        end if;
      end if;
    end if;
  end process ts_latch_proc;
  
  -- Process to latch seconds values
  sec_latch : process(event_clk, reset)
  begin
    if reset = '1' then
      seconds_latch <= (others => '0');
    else
      if rising_edge(event_clk) then
        if MAP14 = '1'  then
          seconds_latch <= seconds_reg;
        end if;
      end if;
    end if;
  end process sec_latch;
      
  -- Generate write control signals for FIFO
  fifo_wr_ctrl : process(event_clk, reset)
  begin
    if reset = '1' then
      fifo_wr_en <= '0';
      fifo_event_data_in <= (others => '0');
    else
      if rising_edge(event_clk) then
        -- Concat timestamp data and event data
        fifo_event_data_in <= seconds_reg & ts_event_count & event_code;  
        -- Don't push to FIFO if full
        if fifo_full = '1' then
          fifo_wr_en <= '0';
        else
          -- ignore null events
          if event_code = x"00" then
            fifo_wr_en <= '0';
          else
            fifo_wr_en <= '1';
          end if;  
        end if;
      end if;  
    end if;
  end process fifo_wr_ctrl;
  
  -- Generate read control signals for FIFO
  -- Don't pop empty FIFO
  fifo_rd_en <= not(fifo_empty) AND buffer_pop; 
  
  -- It takes one clock cycle for a valid sample to 
  -- propagate to FIFO dout after rd_en goes high.
  buffer_valid_reg : process(event_clk)
  begin
    if rising_edge(event_clk) then
      fifo_buffer_valid <= fifo_rd_en;
    end if;
  end process;
  
  -- Handling of external trigger
  ext_trig : process(event_clk)
  begin
    -- External trigger input is double-flopped at the top-level
    -- boundary. Maintain a 2-tap delay-line to align trigger with
    -- historical timestamps.
    if rising_edge(event_clk) then
      ext_reg_t <= ts_req;
      ext_trig_ts_tdl(1) <= ext_trig_ts_tdl(0);
      ext_trig_ts_tdl(0) <= seconds_reg & ts_event_count;
      if ext_trig_pulse = '1' then
        ext_trig_ts_data  <= ext_trig_ts_tdl(1);
      end if;
      ext_trig_ts_valid <= ext_trig_pulse; 
    end if;
  end process ext_trig;
  
  -- Rising-edge detector
  ext_trig_pulse <= ts_req AND not(ext_reg_t);
  
  -- Instantiate event FIFO
  event_fifo : fifo_generator_0
  port map (
    clk          => event_clk,
    srst         => reset,
    din          => fifo_event_data_in,
    wr_en        => fifo_wr_en,
    rd_en        => fifo_rd_en,
    dout         => fifo_event_data_out,
    full         => fifo_full,
    almost_full  => fifo_almost_full,
    empty        => fifo_empty,
    almost_empty => fifo_almost_empty,
    data_count   => fifo_count );

  -- Assign outputs
  buffer_data  <= fifo_event_data_out;
  buffer_valid <= fifo_buffer_valid;
  ts_data      <= ext_trig_ts_data;
  ts_valid     <= ext_trig_ts_valid;
  
  -- Populate registers
  ts_regs.sec_shift_reg     <= seconds_shift_reg;
  ts_regs.sec_counter       <= seconds_reg;
  ts_regs.event_counter     <= ts_event_count;
  ts_regs.sec_latch         <= seconds_latch;
  ts_regs.event_count_latch <= ts_latch;
  ts_regs.event_fifo_sec    <= fifo_event_data_out(71 downto 40);
  ts_regs.event_fifo_cnt    <= fifo_event_data_out(39 downto 8);
  ts_regs.event_fifo_code   <= x"00" & fifo_event_data_out(7 downto 0);

end Behavioral;
