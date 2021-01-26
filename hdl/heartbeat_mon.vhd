-- ===========================================================================
--! @file   heartbeat_mon.vhd
--! @brief  Simple Heartbeat monitor
--!
--! @details
--!
--! At ESS, the Timing Master will send periodically the event 0x7A
--! downstream, at a rate of one event per second.
--! Downstream nodes should monitor receiving this event once per
--! second. If not, an error is raised to the EPICS controller.
--! The timeout is set to 1.6 seconds. So after 1.6 seconds from
--! the last received Heartbeat event, a flag will be raised.
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--!
--! @date 20210122
--! @version 0.2
--!
--! Company: European Spallation Source ERIC \n
--! Platform: picoZED 7030 \n
--! Carrier board: Tallinn picoZED carrier board (aka FPGA-based IOC) rev. B \n
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
-- ===========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.evr_pkg.ALL;
use work.sizing.ALL;

--! heartbeat_mon monitors receiving periodically the event 0x7A

--! The heartbeat_mon entity reads all the received events from
--! the link, and holds a counter to ensure that the event 0x7A
--! is received with a rate approx. of 1 Hz.
--! When the counter reaches the timeout value, a flag is driven
--! HIGH until the event 0x7A is received again. That moment, the
--! flag is driven LOW without any user intervention needed (no
--! ACK is needed from the sw).
--! The counter is reset using the i_reset in port.
entity heartbeat_mon is
    generic (
        g_PRESCALER_SIZE : natural := bit_size(c_HEARTBEAT_TIMEOUT)
    );
    port (
        --! Ref clock for the EVR GT
        i_ref_clk     : in std_logic;
        --! Reset - Rx path domain
        i_reset         : in std_logic;
        --! Read event - output from the Rx FIFO (delay compensated)
        i_event_rxd     : in event_code;
        --! Target event
        i_target_evnt   : in event_code;
        --! Heartbeat timeout flag.
        o_heartbeat_ov  : out std_logic;
        --! Missed heartbeat counter. Increases every time 0x7A wasn't 
        --! received on time 
        o_heartbeat_ov_cnt : out unsigned(c_HEARTBEAT_CNT_SIZE-1 downto 0)
    );
end entity;

architecture rtl of heartbeat_mon is

    attribute mark_debug : string;

    signal counter          : unsigned(g_PRESCALER_SIZE-1 downto 0) := (others => '0');
    attribute mark_debug of counter : signal is "true";
    signal heartbeat_ov_cnt : unsigned(c_HEARTBEAT_CNT_SIZE-1 downto 0) := (others => '0');    
    signal rst_rcv          : std_logic := '0';
    attribute mark_debug of rst_rcv : signal is "true";

    signal counter_ov       : std_logic := '0';
    attribute mark_debug of counter_ov : signal is "true";

    type mon_status is (DISABLED, COUNTING, TIMEOUT, POST_TIMEOUT);
    signal state            : mon_status := DISABLED;

begin

    prescaler: process (i_ref_clk)
    begin
        if rising_edge(i_ref_clk) then
            if rst_rcv = '1' OR i_reset = '1' then
                counter     <= (others => '0');
                counter_ov  <= '0';
            
            elsif counter < c_HEARTBEAT_TIMEOUT then
                counter     <= counter + 1;
                counter_ov  <= '0';
            else
                counter     <= (others => '0');
                counter_ov  <= '1';
            end if;
        end if;
    end process;

    controller: process (i_ref_clk)
    begin
        if rising_edge(i_ref_clk) then
            if i_reset = '1' then
                state               <= COUNTING;
                o_heartbeat_ov      <= '0';
                heartbeat_ov_cnt    <= (others => '0');

            else
                
                case state is
                    when DISABLED =>
                        if i_target_evnt = c_EVENT_NULL then
                            state   <= DISABLED;
                        else
                            state   <= COUNTING;
                            rst_rcv <= '1';
                        end if;

                    when COUNTING =>
                        if i_target_evnt = c_EVENT_NULL then
                            state   <= DISABLED;
                        elsif i_event_rxd = i_target_evnt then
                            rst_rcv <= '1';
                            state   <= COUNTING;
                        elsif counter_ov = '1' then
                            state   <= TIMEOUT;
                            rst_rcv <= '0';
                        else
                            state   <= COUNTING;
                            rst_rcv <= '0';
                        end if;

                        o_heartbeat_ov     <= '0';
                        o_heartbeat_ov_cnt <= heartbeat_ov_cnt;

                    when TIMEOUT =>
                        -- Avoid overflow of this counter
                        if heartbeat_ov_cnt < (heartbeat_ov_cnt'left-1 downto 0 => '1') then
                            heartbeat_ov_cnt  <= heartbeat_ov_cnt + 1;
                        end if;

                        o_heartbeat_ov     <= '1';
                        o_heartbeat_ov_cnt <= heartbeat_ov_cnt;
                        state             <= POST_TIMEOUT;
                        rst_rcv           <= '1';

                    when POST_TIMEOUT =>
                        if i_target_evnt = c_EVENT_NULL then
                            state   <= DISABLED;
                        elsif i_event_rxd = i_target_evnt then
                            rst_rcv <= '1';
                            state   <= COUNTING;
                        elsif counter_ov = '1' then
                            state   <= TIMEOUT;
                            rst_rcv <= '0';
                        else
                            state   <= POST_TIMEOUT;
                            rst_rcv <= '0';
                        end if;

                        o_heartbeat_ov     <= '1';
                        o_heartbeat_ov_cnt <= heartbeat_ov_cnt;

                    when OTHERS =>
                        state <= COUNTING;

                end case;
            end if;
        end if;
    end process;


end architecture;