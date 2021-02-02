-- ===========================================================================
--! @file   interrupt_ctrl.vhd
--! @brief  Controller to drive the interrupt line to processor
--!
--! @details
--!
--! A controller to monitor the interrupt sources, and drive the
--! interrupt line to the processor.
--! Two registers are used for control and status of the interrupt
--! controller: evr_irq_en and evr_irq_flags.
--!
--! @author Ross Elliot <ross.elliot@ess.eu>
--!
--! @date 20210128
--! @version 0.1
--!
--! Company: European Spallation Source ERIC \n
--! Platform: picoZED 7030 \n
--! Carrier board: Tallinn picoZED carrier board (aka FPGA-based IOC) rev. B \n
--!
--! @copyright
--!
--! Copyright (C) 2019- 2021 European Spallation Source ERIC \n
--! This program is free software: you can redistribute it and/or modify
--! it under the terms of the GNU General Public License as published by
--! the Free Software Foundation, either version 3 of the License, or
--! (at your option) any later version. \n
--! This program is distributed in the hope that it will be useful,
--! but WITHOUT ANY WARRANTY; without even the implied warranty of
--! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--! GNU General Public License for more details. \n
--! You should have received a copy of the GNU General Public License
--! along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- ===========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.evr_pkg.ALL;

library ESS_openEVR_RegMap;
use ESS_openEVR_RegMap.register_bank_config.all;

entity interrupt_ctrl is
    generic (
        --! Width of the interrupt register
        g_IRQ_WIDTH         : integer := 32;
        --! Interrupt Flag register address
        g_IRQ_FLAG_REG_ADDR : integer := 8;
        --! Width of the register bank address
        g_REG_ADDR_WIDTH    : integer := ADDRESS_WIDTH;
        --! Width of the AXI-Lite address signal
        g_AXI_ADDR_WIDTH    : integer := ADDRESS_WIDTH+2
    );
    port (
        --! System clock
        i_sys_clk         : in std_logic;
        --! Reset - Rx path domain
        i_reset           : in std_logic;
        --! Record containing interrupt flags from logic
        i_logic_irq_flags : irq_flags;
        --! Flag values received from processor
        i_irq_flags       : in std_logic_vector(g_IRQ_WIDTH-1 downto 0);
        --! Irq enables from processor
        i_irq_en          : in std_logic_vector(g_IRQ_WIDTH-1 downto 0);
        --! Flag values to processor
        o_irq_flags       : out std_logic_vector(g_IRQ_WIDTH-1 downto 0);
        --! Interrupt out (to processor)
        o_irq             : out std_logic;
        -- AXI-lite read signals ------------------------------------
        --! AXI-Lite clock
        i_s_axi_aclk      : in std_logic;
        --! AXI-Lite active-low reset
        i_s_axi_aresetn   : in std_logic;
        --! AXI-Lite read enable
        i_s_axi_arvalid   : in std_logic;
        --! AXI-Lite read address
        i_s_axi_araddr    : std_logic_vector(g_AXI_ADDR_WIDTH-1 downto 0)
    );
end interrupt_ctrl;

architecture Behavioral of interrupt_ctrl is

    signal evr_irq_en      : irq_en;
    signal evr_irq_flag    : irq_flags;
    signal irq_en_t        : std_logic_vector(g_IRQ_WIDTH-1 downto 0) := (others => '0');
    signal irq_flags_t     :  std_logic_vector(g_IRQ_WIDTH-1 downto 0) := (others => '0');
    signal irq_flags_t_out : std_logic_vector(g_IRQ_WIDTH-1 downto 0) := (others => '0');
    signal irq_logic       : std_logic_vector(g_IRQ_WIDTH-1 downto 0) := (others => '0');
    signal irq_logic_t     : std_logic_vector(g_IRQ_WIDTH-1 downto 0) := (others => '0');
    signal irq_flagged     : std_logic := '0';
    signal flag_read_in_progress : std_logic := '0';
    signal flag_read_in_progress_t : std_logic_vector(1 downto 0) := (others => '0');
    
    -- DEBUG
    attribute mark_debug : string;
    attribute mark_debug of evr_irq_en : signal is "true";
    attribute mark_debug of evr_irq_flag : signal is "true";
    attribute mark_debug of irq_en_t : signal is "true";
    attribute mark_debug of irq_flags_t : signal is "true";
    attribute mark_debug of irq_flagged : signal is "true";
    attribute mark_debug of flag_read_in_progress : signal is "true";
    attribute mark_debug of flag_read_in_progress_t : signal is "true";
    attribute mark_debug of irq_flags_t_out : signal is "true";
    attribute mark_debug of irq_logic : signal is "true";
    attribute mark_debug of irq_logic_t : signal is "true";
    
    -- TEMP SIGNALS FOR ILA ONLY
    signal s_axi_aresetn, s_axi_arvalid : std_logic;
    signal s_axi_araddr : std_logic_vector(g_AXI_ADDR_WIDTH-1 downto 0);
    signal s_axi_araddr_check : std_logic_vector(g_REG_ADDR_WIDTH-1 downto 0);
    attribute mark_debug of s_axi_aresetn : signal is "true";
    attribute mark_debug of s_axi_arvalid : signal is "true";
    attribute mark_debug of s_axi_araddr : signal is "true";
    attribute mark_debug of s_axi_araddr_check : signal is "true";

    -- State machine states
    type irq_states is (IDLE, TRIGGER);
    signal state : irq_states := IDLE;
    attribute mark_debug of state : signal is "true";

begin
    -- Simple 2-state state machine
    ctrl : process(i_reset, i_sys_clk)
    begin
        if i_reset = '1' then
            state <= IDLE;
            irq_flags_t <= (others => '0');
            irq_logic_t <= (others => '0');
            irq_flags_t_out <= (others => '0');
            flag_read_in_progress_t <= (others => '0');
        elsif rising_edge(i_sys_clk) then
            -- Transfer flag read from s_axi_clk domain to sys_clk domain
            flag_read_in_progress_t(0) <= flag_read_in_progress;
            flag_read_in_progress_t(1) <= flag_read_in_progress_t(0);
            
            case state is
                -- IDLE state.
                -- Stay in this state until we get a flag from the hardware
                when IDLE =>
                    if evr_irq_en.IrqEn = '1' then
                        -- Check if any flags have been raised
                        case irq_logic is 
                            when x"00000000" => irq_flagged <= '0';
                            when others      => irq_flagged <= '1';
                        end case; 
                      
                        if irq_flagged = '1' then
                            state <= TRIGGER;
                            -- hold input flag values from trigger point
                            irq_logic_t <= irq_logic;
                            irq_flags_t <= i_irq_flags;
                        else
                            state <= IDLE;
                        end if;
                    end if;
                -- Stay in trigger state until we get a response from
                -- the SW 
                when TRIGGER =>
                    if evr_irq_en.IrqEn = '1' then
                        -- The register has been read from software
                        if flag_read_in_progress_t(1) = '1' then 
                            -- Check if flag needs cleared
                            -- If a flag value of '1' is received from the proessor
                            -- clear the flag value in the register.
                            for I in 0 to g_IRQ_WIDTH-1 loop
                                if irq_flags_t(I) = '1' then
                                    irq_flags_t_out(I) <= '0';
                                else 
                                    -- Keep flag value from when triggered
                                    irq_flags_t_out(I) <= irq_logic_t(I);
                                end if;
                            end loop;
                            state <= IDLE;
                        else
                            state <= TRIGGER;
                        end if;
                    else
                        state <= IDLE;
                    end if;
                when OTHERS =>
                    state <= IDLE;
                    irq_flags_t <= (others => '0');
                    irq_flags_t_out <= (others => '0');
            end case;
        end if; 
    end process;

    -- Internal signal assignments
    assignment : process(i_reset, i_sys_clk)
    begin

        if (i_reset = '1') then
            irq_en_t <= (others => '0');
            irq_logic <= (others => '0');
        elsif rising_edge(i_sys_clk) then
            -- Register enable values
            irq_en_t    <= i_irq_en;

            -- Assign values to enable record
            evr_irq_en.IrqEn           <= irq_en_t(31);
            evr_irq_en.SeqOverflow     <= irq_en_t(20);
            evr_irq_en.SeqHalfway      <= irq_en_t(16);
            evr_irq_en.SeqStop         <= irq_en_t(12);
            evr_irq_en.SeqStart        <= irq_en_t(8);
            evr_irq_en.SegDataBuf      <= irq_en_t(7);
            evr_irq_en.LinkStateChange <= irq_en_t(6);
            evr_irq_en.DataBuf         <= irq_en_t(5);
            evr_irq_en.Hardware        <= irq_en_t(4);
            evr_irq_en.Event           <= irq_en_t(3);
            evr_irq_en.Heartbeat       <= irq_en_t(2);
            evr_irq_en.FIFOFull        <= irq_en_t(1);
            evr_irq_en.RxViolation     <= irq_en_t(0);

            -- Assign values to flag record
            evr_irq_flag.SeqOverflow     <= irq_flags_t_out(20);
            evr_irq_flag.SeqHalfway      <= irq_flags_t_out(16);
            evr_irq_flag.SeqStop         <= irq_flags_t_out(12);
            evr_irq_flag.SeqStart        <= irq_flags_t_out(8);
            evr_irq_flag.SegDataBuf      <= irq_flags_t_out(7);
            evr_irq_flag.LinkStateChange <= irq_flags_t_out(6);
            evr_irq_flag.DataBuf         <= irq_flags_t_out(5);
            evr_irq_flag.Hardware        <= irq_flags_t_out(4);
            evr_irq_flag.Event           <= irq_flags_t_out(3);
            evr_irq_flag.Heartbeat       <= irq_flags_t_out(2);
            evr_irq_flag.FIFOFull        <= irq_flags_t_out(1);
            evr_irq_flag.RxViolation     <= irq_flags_t_out(0);

            -- Assign irq_logic vector
            irq_logic(5) <= i_logic_irq_flags.DataBuf;
            irq_logic(3) <= i_logic_irq_flags.Event;
            irq_logic(2) <= i_logic_irq_flags.Heartbeat;
            irq_logic(1) <= i_logic_irq_flags.FIFOFull;
            irq_logic(0) <= i_logic_irq_flags.RxViolation;
            
        end if;
        
    end process;
    
  -- Process to monitor the AXI-Lite register interface,
  -- and get the register address of the current read
  -- operation, and raise a flag if it is the interrupt
  -- flag register. 
  check_flag_reg_read : process(i_s_axi_aclk)
    constant read_addr : std_logic_vector(g_REG_ADDR_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(g_IRQ_FLAG_REG_ADDR, g_REG_ADDR_WIDTH));
  begin
    if rising_edge(i_s_axi_aclk) then
      if i_s_axi_aresetn = '0' then
        flag_read_in_progress <= '0';
      else
        if i_s_axi_arvalid = '1' then
            if i_s_axi_araddr(g_REG_ADDR_WIDTH-1 downto 0) = read_addr then
                flag_read_in_progress <= '1';
            end if;
        else
            flag_read_in_progress <= '0';
        end if;
      end if;
      
      s_axi_aresetn <= i_s_axi_aresetn;
      s_axi_araddr <= i_s_axi_araddr;
      s_axi_arvalid <= i_s_axi_arvalid;
      s_axi_araddr_check <= read_addr;
      
    end if;
  end process check_flag_reg_read;

  ---------------------------------------------------------------------------
  -- Assign outputs ---------------------------------------------------------
  ---------------------------------------------------------------------------

  -- Flag values to register
  o_irq_flags <= irq_flags_t_out;

  -- Interrupt signal to processor
  --
  -- A single interrupt is driven to the processor.
  -- The ISR then checks the EVR IrqFlag register to determine the soure
  -- of the interrupt, then acts accordingly.

  o_irq <= ( (evr_irq_flag.SeqHalfway      and evr_irq_en.SeqHalfway)      or
             (evr_irq_flag.SeqStop         and evr_irq_en.SeqStop)         or
             (evr_irq_flag.SeqStart        and evr_irq_en.SeqStart)        or
             (evr_irq_flag.SegDataBuf      and evr_irq_en.SegDataBuf)      or
             (evr_irq_flag.LinkStateChange and evr_irq_en.LinkStateChange) or
             (evr_irq_flag.DataBuf         and evr_irq_en.DataBuf)         or
             (evr_irq_flag.Hardware        and evr_irq_en.Hardware)        or
             (evr_irq_flag.Event           and evr_irq_en.Event)           or
             (evr_irq_flag.Heartbeat       and evr_irq_en.Heartbeat)       or
             (evr_irq_flag.FIFOFull        and evr_irq_en.FIFOFull)        or
             (evr_irq_flag.RxViolation     and evr_irq_en.RxViolation))
              when evr_irq_en.IrqEn = '1' else
           '0' when evr_irq_en.IrqEn = '0';

end Behavioral;
