-- ===========================================================================
--! @file   event_decoder.vhd
--! @brief  Module which translates event codes into actions
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--!
--! @date 20210127
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

--! @brief event_decoder integrates the mapping RAM controller and the event
--! decoder controller.
--! @details
--! The event_decoder module is in charge of translating event codes into 
--! actions. Actions are listed on page 59 of the DCManual by MRF.
--! The module includes a simple controller to access the configuration 
--! data which should be stored using RAM.
--! Another simple controller receives the configuration word and activates
--! flags for the selected functions.
--!
--! When a new event code is available in the input port, the logic is 
--! triggered to fetch the configuration word linked to that event. 
--! The configuration word is read from the RAM interface and sent to the
--! Event Decoder Controller. This element will handle the configuration 
--! word and perform actions based on that word. The result is a set of
--! pulses which are sent using the output port o_int_func and 
--! o_pgen_map_reg. External modules shall use that interface instead of 
--! directly reading the register with the received event.
entity event_decoder is
    port (
        --! Ref clock for the GT0 - logic enabled when no link is present
        i_ref_clk   : in std_logic;
        --! Rx clock with DC - aligned with the event stream
        i_event_clk : in std_logic;
        --! GT Rx path reset
        i_reset     : in std_logic;
        --! Enable line controlled by bit MAPEN (ess-openEVR CSR)
        i_enable    : in std_logic;

        --!@name BRAM lines
        --!@{
        --! Address port
        o_bram_addr : out std_logic_vector(c_EVNT_MAP_ADDR_WIDTH-1 downto 0);
        --! Data out port
        o_bram_data : out std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0);
        --! Data in port
        i_bram_data : in  std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0);
        --! Write enable line
        o_bram_rden : out std_logic;
        --!@}

        --! Rx event code - Output from the FIFO (delay compensated)
        i_event_rxd : in  event_code;

        -- Internal picoEVR control signals
        o_int_func  : out picoevr_int_func;

        --! Interface with the Pulse Generator controller
        o_pgen_map_reg : out pgen_map_reg
    );
end entity;

architecture rtl of event_decoder is

    signal event_rdy     : std_logic := '0';
    signal evnt_cfg_word : std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0) := (others => '0');

    component bram_controller is
    port (
        i_evnt_clk  : in std_logic;
        i_reset     : in std_logic;

        i_evnt_rxd  : in event_code;
        i_bram_do   : in std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0);

        o_bram_rden : out std_logic;
        o_bram_addr : out std_logic_vector(c_EVNT_MAP_ADDR_WIDTH-1 downto 0);
        o_data_rdy  : std_logic;
        o_evnt_cfg  : out std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0)
    );
    end component;

    component evnt_dec_controller is
    port (
        i_evnt_clk      : in std_logic;
        i_reset         : in std_logic;

        i_evnt_rdy      : in std_logic;

        i_evnt_cfg      : in std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0);

        o_pgen_map_reg  : out pgen_map_reg;
        o_int_func_reg  : out picoevr_int_func
    );
    end component;

begin

    i_bram_ctrl : bram_controller
    port map (
        i_evnt_clk  => i_event_clk,
        i_reset     => i_reset,
        i_evnt_rxd  => i_event_rxd,
        i_bram_do   => i_bram_data,
        o_bram_rden => o_bram_rden,
        o_bram_addr => o_bram_addr,
        o_data_rdy  => event_rdy,
        o_evnt_cfg  => evnt_cfg_word
    );

    i_evnt_ctrl : evnt_dec_controller
    port map (
        i_evnt_clk      => i_event_clk,
        i_reset         => i_reset,
        i_evnt_rdy      => event_rdy,
        i_evnt_cfg      => evnt_cfg_word,
        o_pgen_map_reg  => o_pgen_map_reg,
        o_int_func_reg  => o_int_func
    );

end architecture;