-- =============================================================================
--! @file   interrupt_tb.vhd
--! @brief  Simple test bench for  interrupt controller
--!
--! @details
--!
--! Simple test bench for interrupt controller
--!
--! @author Ross Elliot <ross.elliot@ess.eu>
--!
--! @date 2021203
--! @version 0.1
--!
--! Company: European Spallation Source ERIC \n
--! Standard: VHDL08
--!
--! @copyright
--!
--! Copyright (C) 2019- 2020 European Spallation Source ERIC \n
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
-- =============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.evr_pkg.ALL;

library ESS_openEVR_RegMap;
use ESS_openEVR_RegMap.register_bank_config.all;

entity interrupt_tb is
end interrupt_tb;

architecture Behavioral of interrupt_tb is

    constant c_CLK_PERIOD        : time := 1 ns;
    constant c_AXI_CLK_PERIOD    : time := 0.8 ns;
    constant c_AXI_ADDR_WIDTH    : integer := ADDRESS_WIDTH+2;
    constant c_REG_ADDR_WIDTH    : integer := ADDRESS_WIDTH;
    constant c_IRQ_FLAG_WIDTH    : integer := 32;
    constant c_IRQ_FLAG_REG_ADDR : integer :=  8;

    signal tb_clk      : std_logic := '0';
    signal tb_axi_clk  : std_logic := '0';
    signal tb_rst      : std_logic := '0';
    signal tb_axi_rstn : std_logic := '1';

    signal axi_arvalid : std_logic := '0';
    signal axi_araddr  : std_logic_vector(c_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
    signal axi_awvalid : std_logic := '0';
    signal axi_awaddr  : std_logic_vector(c_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');

    signal evr_irq_en         : irq_en := (others => '0');
    signal evr_irq_flag       : irq_flags := (others => '0');
    signal evr_irq_logic_flag : irq_flags := (others => '0');

    signal irq_en          : std_logic_vector(c_IRQ_FLAG_WIDTH-1 downto 0) := (others => '0');
    signal irq_flags_in    : std_logic_vector(c_IRQ_FLAG_WIDTH-1 downto 0) := (others => '0');
    signal irq_flags_out   : std_logic_vector(c_IRQ_FLAG_WIDTH-1 downto 0) := (others => '0');

    signal IRQ : std_logic := '0';

    shared variable sim_end : boolean := false;

begin

    clock_gen : process
    begin
        if sim_end = false then
            tb_clk <= '0';
            wait for c_CLK_PERIOD/2;
            tb_clk <= '1';
            wait for c_CLK_PERIOD/2;
        else
            wait;
        end if;
    end process clock_gen;

    axi_clock_gen : process
    begin
        if sim_end = false then
            tb_axi_clk <= '0';
            wait for c_AXI_CLK_PERIOD/2;
            tb_axi_clk <= '1';
            wait for c_AXI_CLK_PERIOD/2;
        else
            wait;
        end if;
    end process axi_clock_gen;

    -- Interrupt controller
  interrupt_controller : interrupt_ctrl
      generic map (
          g_IRQ_WIDTH         => c_IRQ_FLAG_WIDTH,
          g_IRQ_FLAG_REG_ADDR => 8,
          g_REG_ADDR_WIDTH    => c_REG_ADDR_WIDTH,
          g_AXI_ADDR_WIDTH    => c_AXI_ADDR_WIDTH
      )
      port map (
          i_sys_clk         => tb_clk,
          i_reset           => tb_rst,
          i_logic_irq_flags => evr_irq_logic_flag,
          i_irq_flags       => irq_flags_in,
          i_irq_en          => irq_en,
          o_irq_flags       => irq_flags_out,
          o_irq             => IRQ,
          i_s_axi_aclk      => tb_axi_clk,
          i_s_axi_arvalid   => axi_arvalid,
          i_s_axi_aresetn   => tb_axi_rstn,
          i_s_axi_araddr    => axi_araddr,
          i_s_axi_awvalid   => axi_awvalid,
          i_s_axi_awaddr    => axi_awaddr
      );

      -- Enable register
        irq_en(31) <= evr_irq_en.IrqEn;
        irq_en(0)  <= evr_irq_en.RxViolation;

        -- Flag register loopback
        irq_flags_in <= irq_flags_out;

    -- Interrupt controller flow:
    --  1. Reset is de-asserted
    --  2. FSM in IDLE state while master IRQ is disabled
    --  3. With master IRQ enabled, wait for IRW flag from openEVR logic
    --  4. When a flag is raised, move to TRIGGER state.
    --     Toggle o_IRQ high to signal interrupt to processor IF corresponding
    --       enable bit is set
    --  5. Stay in TRIGGER state until the flag register is read from software,
    --       OR master IRQ enable is de-asserted.
    --  6. On software read, clear flags as neccessary, and re-enter IDLE state.
    stimulus : process
    begin
        tb_rst      <= '1';
        tb_axi_rstn <= '0';
        wait for c_CLK_PERIOD * 10;
        tb_rst <= '0';
        wait for c_CLK_PERIOD * 2;
        wait for 20 ns;

        -- First test: IRQ should be de-asserted after releasing reset
        assert IRQ /= '0' report "1. Interrupt controller disabled: OK" severity note;
        assert IRQ = '0' report  "1. Interrupt controller disabled: FAILED" severity error;

        evr_irq_logic_flag.RxViolation <= '1';
        wait for 20 ns;

        -- Second test: IRQ should be de-asserted with an IRQ flagged from logic
        --              - Master IRQ is not enabled yet
        assert IRQ /= '0' report "2. Interrupt controller disabled: OK" severity note;
        assert IRQ = '0' report  "2. Interrupt controller disabled: FAILED" severity error;

        -- Enable RxViolation interrupt
        evr_irq_en.RxViolation <= '1';
        wait for 20 ns;

        -- Third test: IRQ should be de-asserted with an IRQ flagged from logic
        --              and corresponding enable bit set
        --              - Master IRQ is not enabled
        assert IRQ /= '0' report "3. Interrupt controller disabled: OK" severity note;
        assert IRQ = '0' report  "3. Interrupt controller disabled: FAILED" severity error;

        -- Enable master interrupt bit
        evr_irq_en.IrqEn <= '1';
        wait for 20 ns;

        -- Fourth test: IRQ should be asserted
        --              and corresponding enable bit set
        --              - Master IRQ is now enabled
        assert IRQ /= '1' report "4. Interrupt controller enabled: OK" severity note;
        assert IRQ = '1' report  "4. Interrupt controller enabled: FAILED" severity error;


        -- Set AXI read address to flag register address
        axi_araddr(c_REG_ADDR_WIDTH-1 downto 0) <=
                std_logic_vector(to_unsigned(c_IRQ_FLAG_REG_ADDR, c_REG_ADDR_WIDTH));
        wait for 20 ns;


        tb_axi_rstn <= '1';
        wait for 20 ns;
        -- Toggle axi read address valid signal for one clock cycle
        axi_arvalid <= '1';
        wait for c_AXI_CLK_PERIOD;
        axi_arvalid <= '0';
        wait for 3 ns;        
        
        -- Set AXI write address to flag register address
        axi_awaddr(c_REG_ADDR_WIDTH-1 downto 0) <=
                std_logic_vector(to_unsigned(c_IRQ_FLAG_REG_ADDR, c_REG_ADDR_WIDTH));
        wait for 20 ns;
        
        -- Toggle axi read address valid signal for one clock cycle
        axi_awvalid <= '1';
        wait for c_AXI_CLK_PERIOD;
        axi_awvalid <= '0';
        wait for 2  * c_AXI_CLK_PERIOD;
        
        -- Sixth test: IRQ should be de-asserted, as register has been written to clear flag
        assert IRQ /= '1' report "5. Interrupt controller disabled: OK" severity note;
        assert IRQ = '1' report  "5. Interrupt controller disabled: FAILED" severity error;

        evr_irq_logic_flag.RxViolation <= '0';
        evr_irq_logic_flag.Heartbeat <= '1';
        wait for 20 ns;

        sim_end := true;
        wait;
    end process;
end Behavioral;
