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

Library UNISIM;
use UNISIM.vcomponents.all;

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
        --! Read enable line
        o_bram_rden : out std_logic;
        --!@}

        --! Rx event code - Output from the FIFO (delay compensated)
        i_event_rxd : in  event_code;

        --! Rx event code delayed to adjust it to the processing latency of the
        --! block.
        o_event_rxd : out event_code;

        -- Internal picoEVR control signals
        o_int_func  : out picoevr_int_func;

        --! Interface with the Pulse Generator controller
        o_pgen_map_reg : out pgen_map_reg
    );
end entity;

architecture rtl of event_decoder is

    -- Number of clock cycles between the arrival of an event code and the
    -- output from the decoder_controller.
    constant LATENCY : natural := 4;

    signal event_local_clk  : std_logic := '0';
    signal event_rdy        : std_logic := '0';
    signal evnt_cfg_word    : std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0) := (others => '0');

    type event_chain  is array (0 to LATENCY) of std_logic_vector(c_EVENT_CODE_BITS-1 downto 0);
    signal event_rcv_chain : event_chain;

begin

    crossbar_clk_buf : BUFHCE
       port map (
          O => event_local_clk,
          CE => i_enable,
          I => i_event_clk
       );

    -- The event decoding is performed in 2 stages:

    -- 1st stage: the event code is used to fetch the associated configuration
    --            from the mapping RAM
    i_bram_ctrl : bram_controller
    port map (
        i_evnt_clk  => event_local_clk,
        i_reset     => i_reset,
        i_evnt_rxd  => i_event_rxd,
        i_bram_do   => i_bram_data,
        o_bram_rden => o_bram_rden,
        o_bram_addr => o_bram_addr,
        o_data_rdy  => event_rdy,
        o_evnt_cfg  => evnt_cfg_word
    );

    -- 2nd stage: the configuration word is ready, during this stage, the word
    --            is sliced and the associated logic rises/lowers bits
    --            according to the input word.
    i_evnt_ctrl : evnt_dec_controller
    port map (
        i_evnt_clk      => event_local_clk,
        i_reset         => i_reset,
        i_evnt_rdy      => event_rdy,
        i_evnt_cfg      => evnt_cfg_word,
        o_pgen_map_reg  => o_pgen_map_reg,
        o_int_func_reg  => o_int_func
    );

    -- The set of control bits and other associated flags are ready
    -- to drive the inputs of external modules. A register chain is
    -- used to adjust the 4 cycles latency
    event_rcv_chain(0) <= i_event_rxd;
    o_event_rxd    <= event_rcv_chain(LATENCY);

    event_buffer : process(event_local_clk)
    begin
        if rising_edge(event_local_clk) then
            for I in 1 to LATENCY loop
                event_rcv_chain(I) <= event_rcv_chain(I-1);
            end loop;
        end if;
    end process event_buffer;

    -- Not yet used ports
    o_bram_data <= (others => '0');

end architecture;
