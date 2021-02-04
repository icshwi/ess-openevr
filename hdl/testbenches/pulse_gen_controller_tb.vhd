-- =============================================================================
--! @file   pulse_gen_controller_tb.vhd
--! @brief  Simple test bench for Pulse Generator controller module
--!
--! @details
--! In order to simply writing this test, setting a small value for
--! the constant c_PULSE_GENS_CNT would be the best option. So that,
--! this testbench will consider that variable is defined with the
--! value 3 (3 Pulse Generators). Bear in mind that it will be 
--! needed to manually set that value in the package before running
--! this testbench if using the repository code (which usually targets
--! 8-16 Pulse Generators).
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--!
--! @date 2020203
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

entity pulse_gen_controller_tb is
end entity;

architecture rtl of pulse_gen_controller_tb is
    constant c_CLK_PERIOD : time := 1 ns;
    
    signal tb_clk   : std_logic := '0';
    signal tb_rst   : std_logic := '0';

    signal pgen_ctrl_reg : pgen_ctrl_regs;
    signal pgenx_map_reg  : pgen_map_reg;
    signal pgen_pxout    : std_logic_vector(c_PULSE_GENS_CNT-1 downto 0) := (others => '0');


    shared variable sim_end : boolean := false;

begin

    clock_gen : process
    begin
        if sim_end = false then
            tb_clk <= '1';
            wait for c_CLK_PERIOD/2;
            tb_clk <= '0';
            wait for c_CLK_PERIOD/2;
        else
            wait;
        end if;
    end process clock_gen;

    dut : pulse_gen_controller 
        generic map(
            g_PULSE_GEN_CNT  => c_PULSE_GENS_CNT
        )
        port map (
            i_event_clk     => tb_clk,
            i_pgen_ctrl_reg => pgen_ctrl_reg,
            i_pgen_map_reg  => pgenx_map_reg,
            o_pgen_pxout    => pgen_pxout            
        );

    stimulus : process
    begin
        -- Initialization of the configuration registers

        -- All Pulse Generators will be disabled
        pgenx_map_reg.triggerx <= (others => '0');
        pgenx_map_reg.setx     <= (others => '0');
        pgenx_map_reg.resetx   <= (others => '0');
        for I in 0 to c_PULSE_GENS_CNT-1 loop
            pgen_ctrl_reg(I).control <= "0000001"; -- All Pulse Generators will be enabled
            pgen_ctrl_reg(I).width <= x"0000000A"; -- 10 cycle pulse
            pgen_ctrl_reg(I).delay <= x"0000000A"; -- 10 cycle after the trigger pulse
        end loop;

        tb_rst <= '1';
        wait for 4*c_CLK_PERIOD;
        tb_rst <= '0';
        wait for 4*c_CLK_PERIOD;
        report "Test 1 -------------------------------";

        -- Test1: SW-like pulse generation.
        --        In this test, all the logic that is linked to the mappin RAM is not used.
        --        The test will emulate a manual set&reset triggered by a regular SW program, i.e.
        --        no event driven pulses.
        -- Test1.1: Sw Set for all the Pulse Generators

        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0000" report "Test1: Incorrect values at initialization: FAIL" severity error;

        for I in 0 to c_PULSE_GENS_CNT-1 loop
            pgen_ctrl_reg(I).control(6) <= '1'; -- All Pulse Generators will be enabled
        end loop;

        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "1111" report "Test1.1: Incorrect values after Set: FAIL" severity error;

        -- Test1.2: Sw Reset for all Pulse Generators (takes priority over set)
        for I in 0 to c_PULSE_GENS_CNT-1 loop
            pgen_ctrl_reg(I).control(5) <= '1'; -- All Pulse Generators will be enabled
        end loop;

        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0000" report "Test1.2: Incorrect values after Reset: FAIL" severity error;

        -- Test1.3: Check the enable signal and check the polarity thing by the way
        for I in 0 to c_PULSE_GENS_CNT-1 loop
            pgen_ctrl_reg(I).control(5) <= '0'; -- Keep the Set bit HIGH
        end loop;
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "1111" report "Test1.3: Incorrect values after Reset LOW: FAIL" severity error;
        
        for I in 0 to c_PULSE_GENS_CNT-1 loop
            pgen_ctrl_reg(I).control(4) <= '1'; -- Polarity inverted
        end loop;
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0000" report "Test1.4: Incorrect values after polarity HIGH: FAIL" severity error;
        for I in 0 to c_PULSE_GENS_CNT-1 loop
            pgen_ctrl_reg(I).control(4) <= '0'; -- Clear polarity bit
        end loop;
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "1111" report "Test1.5: Incorrect values after polarity LOW: FAIL" severity error;
        -- Finally, disable the Pulse Generators
        for I in 0 to c_PULSE_GENS_CNT-1 loop
            pgen_ctrl_reg(I).control(0) <= '0'; -- Clear polarity bit
        end loop;
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0000" report "Test1.6: Incorrect values after disable: FAIL" severity error;


        -- Back to normal operation
        for I in 0 to c_PULSE_GENS_CNT-1 loop
            pgen_ctrl_reg(I).control(6 downto 0) <= "0000001";
        end loop;

        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0000" report "Test1: Incorrect values at end of the test: FAIL" severity error;

        wait for 4*c_CLK_PERIOD;
        report "Test 2 -------------------------------";

        -- Test2: Use of the logic that will be driven to the mapping RAM

        -- Enable all the logic from the mappin RAM
        for I in 0 to c_PULSE_GENS_CNT-1 loop
            pgen_ctrl_reg(I).control(3 downto 1) <= "111"; -- Trigger, set and reset is enabled from the mapping RAM
        end loop;
        wait for c_CLK_PERIOD;

        -- Test2.1: Trigger the Pulse Generators 1 and 4
        pgenx_map_reg.triggerx <= "1001";
        report "Test2.1: Sending trigger to Pulse Counters 1 and 4";
        wait for c_CLK_PERIOD;
        pgenx_map_reg.triggerx <= "0000";
        wait for 8*c_CLK_PERIOD;
        -- The outputs should be LOW at this moment, since the clock has ticket 9 times
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0000" report "Test2.1: Incorrect value before delay overflow: FAIL" severity error;
        wait for 4*c_CLK_PERIOD;
        -- At this moment, the outputs should be HIGH
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "1001" report "Test2.1: Incorrect value after delay overflow: FAIL" severity error;

        wait for 10*c_CLK_PERIOD;
        report "Test 2.2 ----------------------------";

        -- Let's delay 1 cycle the Pulse generator 4 respect to the 1
        pgen_ctrl_reg(3).delay <= x"0000000B";
        pgenx_map_reg.triggerx <= "1001";
        report "Test2.2: Sending trigger to Pulse Counters 1 and 4";
        wait for c_CLK_PERIOD;
        pgenx_map_reg.triggerx <= "0000";
        wait for 8*c_CLK_PERIOD;
        -- The outputs should be LOW at this moment, since the clock has ticket 9 times
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0000" report "Test2.2: Incorrect initial value: FAIL" severity error;
        wait for 2*c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0001" report "Test2.2: Incorrect sequence value 1: FAIL" severity error;
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "1001" report "Test2.2: Incorrect sequence value 2: FAIL" severity error;
        wait for 9*c_CLK_PERIOD;
        -- At this moment, the outputs should be HIGH
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "1000" report "Test2.2: Incorrect sequence value 3: FAIL" severity error;
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0000" report "Test2.2: Incorrect final value: FAIL" severity error;
        
        wait for 4*c_CLK_PERIOD;
        report "Test 2.3 ----------------------------";
        -- Test 2.3: Let's simulate an event driving Set bits for Pulse Generators 1 & 2 and another
        --           event driving the Reset bits.
        pgenx_map_reg.setx <= "0110";
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0110" report "Test2.3: Incorrect value set test: FAIL" severity error;
        wait for 2*c_CLK_PERIOD;
        -- Now the reset "event" (setx are still HIGH, testing reset priority over set)
        pgenx_map_reg.resetx <= "0110";
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0000" report "Test2.3: Incorrect value reset test: FAIL" severity error;
        -- clear both registers
        pgenx_map_reg.setx   <= "0000";
        pgenx_map_reg.resetx <= "0000";
        wait for 4*c_CLK_PERIOD;
        report "Test 2.4 ----------------------------";

        -- Test 2.4: Let's combine stuff. A Set for PGen 0, a trigger for PGen 1 and a Reset in the
        --           middle of PGen1 width counter.
        pgenx_map_reg.setx     <= "0001";
        pgenx_map_reg.triggerx <= "0010";
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0001" report "Test2.4: Incorrect value set test: FAIL" severity error;
        wait for 12*c_CLK_PERIOD;
        -- At this moment, the PGen controlled by the trigger enable, should be in the Width counter stage
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0011" report "Test2.4: Incorrect value width counter test: FAIL" severity error;
        -- Let's send a reset before it ends the counting process
        pgenx_map_reg.resetx <= "0010";
        wait for c_CLK_PERIOD;
        assert pgen_pxout(c_PULSE_GENS_CNT-1 downto 0) = "0001" report "Test2.4: Incorrect value reset test: FAIL" severity error;
        wait for 4*c_CLK_PERIOD;
        
        report "TEST END";

        sim_end := true;
        wait;
    end process;

end architecture;