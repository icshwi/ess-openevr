-- =============================================================================
--! @file   heartbeat_mon_tb.vhd
--! @brief  Simple test bench for heartbeat_mon entity
--!
--! @details
--!
--! Simple test bench for row module
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--!
--! @date 20201022
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
use work.sizing.ALL;

entity heartbeat_mon_tb is
end heartbeat_mon_tb;

architecture behaviour of heartbeat_mon_tb is

    constant c_CLK_PERIOD : time := 4 ns;
    constant c_PRESCALER_SIZE : natural := 4;
    -- Remember: Check the value for c_HEARTBEAT_TIMOUT in the package!
    constant c_MAX : integer := 2**(c_PRESCALER_SIZE-2)-1;

    signal tb_clk : std_logic := '0';
    signal tb_rst : std_logic := '0';
    signal event_rxd : event_code := c_EVENT_NULL;
    signal heartbeat_ov : std_logic := '0';
    signal heartbeat_ov_cnt : unsigned(c_HEARTBEAT_CNT_SIZE-1 downto 0) := (others => '0');

    signal heartbeat_gen_cnt : unsigned(c_PRESCALER_SIZE-2 downto 0) := (others => '0');
    signal heartbeat_gen_en  : std_logic := '1';


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

    heartbeat_gen: process (tb_clk, heartbeat_gen_en)
    begin
        if heartbeat_gen_en = '1' then
            if rising_edge(tb_clk) then
                if heartbeat_gen_cnt = c_MAX then
                    event_rxd           <= c_EVENT_HEARTBEAT;
                    heartbeat_gen_cnt   <= (others => '0');
                else
                    event_rxd           <= c_EVENT_NULL;
                    heartbeat_gen_cnt   <= heartbeat_gen_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    dut: heartbeat_mon
    generic map (
        g_PRESCALER_SIZE => c_PRESCALER_SIZE
    )
    port map (
        --! Recovered clock from the link with delay compensation
        i_event_clk     => tb_clk,
        --! Reset - Rx path domain
        i_reset         => tb_rst,
        --! Read event - output from the Rx FIFO (delay compensated)
        i_event_rxd     => event_rxd,
        --! Heartbeat timeout flag.
        o_heartbeat_ov  => heartbeat_ov,
        --! Missed heartbeat counter. Increases every time 0x7A wasn't 
        --! received on time 
        o_heartbeat_ov_cnt => heartbeat_ov_cnt
    );
    
    stimulus : process 
    begin
        tb_rst <= '1';
        wait for c_CLK_PERIOD * 2;
        tb_rst <= '0';
        wait for c_CLK_PERIOD * 2;
        heartbeat_gen_en <= '1';
        wait for 100 ns;
        assert heartbeat_ov_cnt /= 0 report "Heartbeat events received with the expected rate: OK" severity note;
        assert heartbeat_ov_cnt = 0 report "Heartbeat events received with the expected rate: FAILED" severity error;

        heartbeat_gen_en <= '0';
        wait for 100 ns;
        assert heartbeat_ov_cnt = 0 report "Heartbeat timeout counter check: OK" severity note;
        assert heartbeat_ov_cnt /= 0 report "Heartbeat timeout counter check: FAILED" severity error;

        tb_rst <= '1';
        wait for c_CLK_PERIOD * 2;
        tb_rst <= '0';
        wait for c_CLK_PERIOD * 2;
        heartbeat_gen_en <= '1';
        wait for 100 ns;
        assert heartbeat_ov_cnt /= 0 report "Heartbeat events received with the expected rate: OK" severity note;
        assert heartbeat_ov_cnt = 0 report "Heartbeat events received with the expected rate: FAILED" severity error;

        sim_end := true;
        wait;
    end process;
end;