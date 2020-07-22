--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : axi_read_ctrl.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-13
-- Last update : 2019-03-07
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : AXI4-Lite read controller to access the register bank.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2019 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2019-03-07  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library essffw;
use essffw.axi4.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity axi_read_ctrl  is
  generic (
    REG_ADDR_WIDTH  : integer := 8;                                                --! Width of the address signals
    AXI_ADDR_WIDTH  : integer := 10;
    AXI_DATA_WIDTH  : integer := 32;                                               --! Width of the AXI data signals
    REGISTER_WIDTH  : integer := 32                                                --! Width of a register
  );
  port (
    s_axi_aclk        : in  std_logic;                                             --! Clock of the whole block and the AXI interface
    s_axi_aresetn     : in  std_logic;                                             --! Synchronous reset, active-low

    ----------------------------------------------------------------------------
    --! @name AXI4-Lite read interface
    --!@{
    ----------------------------------------------------------------------------
    s_axi_araddr      : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    s_axi_arprot      : in  std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
    s_axi_arvalid     : in  std_logic;
    s_axi_arready     : out std_logic;
    s_axi_rdata       : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    s_axi_rresp       : out std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
    s_axi_rvalid      : out std_logic;
    s_axi_rready      : in  std_logic;
    --!@}

    read_en_o         : out std_logic;                                             --! Read enable towards the register bank
    address_o         : out std_logic_vector(REG_ADDR_WIDTH-1 downto 0);           --! Address of the register to access
    bus_data_i        : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);           --! Data read from the register bank
    error_i           : in  std_logic                                              --! Error signal from register bank
  );
end entity axi_read_ctrl;

--------------------------------------------------------------------------------
--! @brief
--------------------------------------------------------------------------------
architecture rtl of axi_read_ctrl is

  type   axi_read_state_t is (IDLE, DELAY_READ, READING);       --! States of the data read FSM
  signal axi_read_state   : axi_read_state_t;                   --! The next state of the FSM
  signal axi_read_state_r : axi_read_state_t;                   --! Registered state of the FSM, current state

  signal arready          : std_logic;                          --! Internal AXI arready signal to read from
  signal rvalid           : std_logic;                          --! Internal AXI rvalid signal to read from

  signal reg_address      : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);

begin

  -- Place internal signals on the AXI bus
  s_axi_arready <= arready;
  s_axi_rvalid  <= rvalid;

  reg_address <= s_axi_araddr(AXI_ADDR_WIDTH-1 downto (AXI_ADDR_WIDTH-REG_ADDR_WIDTH));

  -- Read address control
  axi_read_addr_ctrl : process(all)
  begin
    if rising_edge(s_axi_aclk) then
      if s_axi_aresetn = '0' then
        arready <= '0';
        read_en_o <= '0';
        address_o <= (others => '1');
      else
        if (arready = '0' and s_axi_arvalid = '1') then
          arready <= '1';
          read_en_o <= '1';
          address_o <= reg_address;
        else
          arready <= '0';
          read_en_o <= '0';
        end if;
      end if;
    end if;
  end process axi_read_addr_ctrl;

  -- Read data control FSM
  axi_read_fsm_reg : process(all)
  begin
    if rising_edge(s_axi_aclk) then
      if s_axi_aresetn = '0' then
        axi_read_state_r <= IDLE;
      else
        axi_read_state_r <= axi_read_state;
      end if;
    end if;
  end process axi_read_fsm_reg;

  axi_read_fsm : process(all)
  begin
    rvalid         <= '0';
    s_axi_rresp    <= AXI4_RESP_OKAY;
    s_axi_rdata    <= (others => '0');
    axi_read_state <= axi_read_state_r;

    case axi_read_state_r is

      when IDLE =>
        if (arready = '1' and s_axi_arvalid = '1' and rvalid = '0') then
          axi_read_state <= DELAY_READ;
        end if;

      when DELAY_READ =>
        axi_read_state <= READING;

      when READING =>
        if error_i = '0' then
           rvalid <= '1';
           s_axi_rresp <= AXI4_RESP_OKAY;
           s_axi_rdata <= bus_data_i;
        else
           rvalid <= '1';
           s_axi_rresp  <= AXI4_RESP_SLVERR;
        end if;

        if s_axi_rready = '1' then
          axi_read_state <= IDLE;
        end if;

      when others =>
        axi_read_state <= IDLE;

    end case;

  end process;

end architecture rtl;
