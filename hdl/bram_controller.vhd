-- ===========================================================================
--! @file bram_controller.vhd
--! @brief A simple Block RAM controller for the picoEVR mapping RAM
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--!
--! @date 20210209
--! @version 0.1
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

--!@brief bram_controller is a simple controller to fetch data from the BRAM holding
--!       the content of the "mapping RAM".
--!@details
--! The "mapping RAM" feature of the picoEVR is implemented using a dual port RAM.
--! One port is used by the host CPU using an intermediate AXI controller. The host
--! CPU is responsible for writing the content of the mapping RAM, according to the
--! restrictions of the timing protocol. This port can be used either to read or to
--! write content.
--! The second port is used by the ESS-openEVR IP core. This core is never meant to
--! write/modify any of the content of the mapping RAM. The main use of the mapping
--! RAM is linking event codes with internal functions, so the core knows what to
--! do when a particular event code is received from the master.
--! The RAM's shape is quite simple: 256 words of 128 bit. One word per event code.
--! When an event code is received, the BRAM controller uses the code to address the
--! configuration word linked to the event and sends out the data word to the 
--! Event decoder which will transform the information into pulses.
--! The latency of the controller is 3 cycles so the upstream module has to properly
--! hold the event code while the configuration word is fetch and written into the 
--! configuration register.
--! \image html "bram_controller.png"
entity bram_controller is
    port (
        --! Event clock (DC compensated) - use the same clock as the one used for the
        --! port going to the BRAM in order to avoid CDC issues.
        i_evnt_clk  : in std_logic;
        --! Rx path reset is a good reset source for this module 
        i_reset     : in std_logic;
        --! Active Event code
        i_evnt_rxd  : in event_code;
        --! Data output from the BRAM module (unregistered)
        i_bram_do   : in std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0);
        --! Read enable line for the port connected to the controller
        o_bram_rden   : out std_logic;
        --! Address line for the port connected to the controller
        o_bram_addr : out std_logic_vector(c_EVNT_MAP_ADDR_WIDTH-1 downto 0);
        --! Flag indicating when a data word is ready to be read from the port
        o_data_rdy  : out std_logic;
        --! Data word linked to the event used for addressing - 3 cycles latency
        o_evnt_cfg  : out std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0)        
    );
end entity bram_controller;

architecture behaviour of bram_controller is

    type ctrl_state is (IDLE, FETCH, READ, READNFETCH);
    signal ctrl_cur, ctrl_next : ctrl_state := IDLE;

    signal bram_en   : std_logic := '0';
    signal bram_addr : std_logic_vector(c_EVNT_MAP_ADDR_WIDTH-1 downto 0) := (others => '0');
    signal data_rdy  : std_logic := '0';
    signal evnt_cfg  : std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0) := (others => '0');

begin

    -- FSM state update
    process (i_evnt_clk)
    begin
        if rising_edge(i_evnt_clk) then
            if i_reset = '1' then
                ctrl_cur <= IDLE;
            else
                ctrl_cur <= ctrl_next;
            end if;
        end if;
    end process;

    -- Moore FSM for the BRAM controller
    -- ---------------------------------
    -- * IDLE: wait until a valid event code is present in the input port (all but the NULL event).
    -- * FETCH: when a valid event code is present, the port of the BRAM is enabled and the address
    --   is written into the address bus. 1 cycle is needed before reading the data.
    -- * READ: Read the data from the output register of the BRAM, signal a data word is ready
    -- * READNFETCH: if a new event code was received during the FETCH stage, the controller combines
    --   the READ stage for the data fetched during FETCH stage and initiates a new FETCH stage.
    --   This way, the controller won't be blocked more than 1 cycle, i.e. it can handle consecutive
    --   arrivals of many event codes (hopefully... fingers crossed!).
    process(ctrl_cur, i_evnt_rxd)
    begin
        ctrl_next <= ctrl_cur;

        case ctrl_cur is
            when IDLE       =>
                data_rdy    <= '0';
                bram_addr   <= (others => '0');
                bram_en     <= '0';
                evnt_cfg    <= (others => '0');

                if i_evnt_rxd /= c_EVENT_NULL then
                    ctrl_next <= FETCH;
                else
                    ctrl_next <= IDLE;
                end if;

            when FETCH      =>
                bram_addr   <= i_evnt_rxd;
                data_rdy    <= '0';
                bram_en     <= '1';
                evnt_cfg    <= (others => '0');

                if i_evnt_rxd /= c_EVENT_NULL then
                    ctrl_next <= READNFETCH);;
                else
                    ctrl_next <= READ;
                end if;

            WHEN READ       =>
                evnt_cfg    <= i_bram_do;
                data_rdy    <= '1';
                bram_en     <= '0';
                bram_addr   <= (others => '0');

                if i_evnt_rxd /= c_EVENT_NULL then
                    ctrl_next <= FETCH;
                else
                    ctrl_next <= IDLE;
                end if;

            WHEN READNFETCH =>
                bram_addr   <= i_evnt_rxd;
                bram_en     <= '1';
                evnt_cfg    <= i_bram_do;
                data_rdy    <= '1';

                if i_evnt_rxd /= c_EVENT_NULL then
                    ctrl_next <= READNFETCH;
                else
                    ctrl_next <= READ;
                end if;

        end case;
    end process;

    -- Register the outputs
    process (i_evnt_clk)
    begin
        if rising_edge(i_evnt_clk) then
            o_bram_rden <= bram_en;
            o_bram_addr <= bram_addr;
            o_data_rdy  <= data_rdy;
            o_evnt_cfg  <= evnt_cfg;            
        end if;
    end process;

    

end architecture;