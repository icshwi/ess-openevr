-- =============================================================================
--! @file   pulse_gen_tb.vhd
--! @brief  Simple test bench for Pulse Generator module
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--!
--! @date 2020201
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

entity pulse_gen_tb is
end pulse_gen_tb;

architecture behaviour of pulse_gen_tb is

    constant c_CLK_PERIOD : time := 1 ns;
    
    signal tb_clk   : std_logic := '0';
    signal tb_rst   : std_logic := '0';

    -- Signals for the device under test
    signal enable    : std_logic := '0';
    signal trigger   : std_logic := '0';
    signal set       : std_logic := '0';
    signal reset       : std_logic := '0';
    signal polarity  : std_logic := '0';
    signal delay_val : std_logic_vector(31 downto 0) := (others => '0');
    signal width_val : std_logic_vector(31 downto 0) := (others => '0');
    signal pulse     : std_logic;


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

    dut: pulse_generator
        port map (
            i_event_clk  => tb_clk,
            i_enable     => enable,
            i_trigger    => trigger,
            i_set        => set,
            i_reset      => reset,
            i_polarity   => polarity,
            i_delay_val  => delay_val,
            i_width_val  => width_val,
            o_pulse      => pulse
        );
    
    stimulus : process 
    begin
        tb_rst <= '1';
        wait for c_CLK_PERIOD * 10;
        tb_rst <= '0';
        wait for c_CLK_PERIOD * 2;

        -- Initial configuration values ---------------------------------------

        delay_val <= x"0000_000A"; width_val <= x"0000_000A";
        trigger <= '0'; set <= '0'; reset <= '0'; polarity <= '0';
        wait for c_CLK_PERIOD;

        assert pulse = '0' report "Pulse Generator: Bad initial status" severity error;

        -- Test 1: regular operation - Send a trigger check the pulse is properly set up
        --         A pulse with a HIGH time of 10 clock cycles - 10 ns

        enable <= '1';
        wait for c_CLK_PERIOD;
        trigger <= '1';
        wait for c_CLK_PERIOD;
        trigger <= '0';
        report "Pulse Generator - TEST4: Trigger sent" severity note;
        --wait for c_CLK_PERIOD;
        assert pulse = '0' report "Pulse Generator - TEST1 : Pulse level incorrect after trigger" severity error;
        wait for 10*c_CLK_PERIOD;
        assert pulse = '1' report "Pulse Generator - TEST1 : Pulse level incorrect during width counter" severity error;
        assert pulse = '0' report "Pulse Generator - TEST1 : Pulse going HIGH" severity note;
        wait for 10*c_CLK_PERIOD;
        assert pulse = '0' report "Pulse Generator - TEST1 : Pulse level incorrect after width counter" severity error;
        assert pulse = '1' report "Pulse Generator - TEST1 : Pulse going LOW" severity note;

        wait for 4*c_CLK_PERIOD;

        -- Test 2: Set & Reset
        set <= '1';
        wait for c_CLK_PERIOD;
        assert pulse = '1' report "Pulse Generator - TEST2 : Pulse level incorrect after set" severity error;
        -- Reset takes priority over Set
        reset <= '1';
        wait for c_CLK_PERIOD;
        assert pulse = '0' report "Pulse Generator - TEST2 : Pulse level incorrect after reset" severity error;

        -- Test 3: Set&Reset priority over the normal counters
        trigger <= '1'; reset <= '0'; set <= '0';
        wait for c_CLK_PERIOD;
        trigger <= '0';
        wait for 4*c_CLK_PERIOD;
        -- At this moment the output should be LOW (delay counting)
        assert pulse = '0' report "Pulse Generator - TEST3 : Incorrect initialization (1)" severity error;
        set <= '1';
        wait for c_CLK_PERIOD;
        -- Delay counter is still counting but the Set input takes over the output
        assert pulse = '1' report "Pulse Generator - TEST3 : Pulse level incorrect after set" severity error;

        -- Let's restart the regular behaviour
        trigger <= '1'; reset <= '0'; set <= '0';
        wait for c_CLK_PERIOD;
        trigger <= '0';
        wait for 12*c_CLK_PERIOD;
        -- At this moment the output should be HIGH (width counting)
        assert pulse = '1' report "Pulse Generator - TEST3 : Incorrect initialization (2)" severity error;
        reset <= '1';
        wait for c_CLK_PERIOD;
        -- Width counter is still counting but the Reset input takes over the output
        assert pulse = '0' report "Pulse Generator - TEST3 : Pulse level incorrect after reset" severity error;

        wait for 4*c_CLK_PERIOD;

        -- Test 4: Polarity
        trigger <= '1'; reset <= '0'; set <= '0'; polarity <= '1';
        wait for c_CLK_PERIOD;
        trigger <= '0';
        report "Pulse Generator - TEST4: Trigger sent" severity note;
        --wait for c_CLK_PERIOD;
        assert pulse = '1' report "Pulse Generator - TEST4 : Pulse level incorrect after trigger" severity error;
        wait for 10*c_CLK_PERIOD;
        assert pulse = '0' report "Pulse Generator - TEST4 : Pulse level incorrect during width counter" severity error;
        assert pulse = '1' report "Pulse Generator - TEST4 : Pulse going LOW" severity note;
        wait for 10*c_CLK_PERIOD;
        assert pulse = '1' report "Pulse Generator - TEST4 : Pulse level incorrect after width counter" severity error;
        assert pulse = '0' report "Pulse Generator - TEST4 : Pulse going HIGH" severity note;

        wait for 4*c_CLK_PERIOD;

        set <= '1';
        wait for c_CLK_PERIOD;
        assert pulse = '0' report "Pulse Generator - TEST4 : Pulse level incorrect after set" severity error;
        reset <= '1';
        wait for c_CLK_PERIOD;
        assert pulse = '1' report "Pulse Generator - TEST4 : Pulse level incorrect after reset" severity error;        

        sim_end := true;
        wait;
    end process;
end;