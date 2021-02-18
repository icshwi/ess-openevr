-- =============================================================================
--! @file   bram_controller_tb.vhd
--! @brief  Test bench for bram_controller
--!
--! @details
--!
--! Test bench for the BRAM controller module
--!
--! @author Ross Elliot <ross.elliot@ess.eu>
--!
--! @date 2021215
--! @version 0.1
--!
--! Company: European Spallation Source ERIC \n
--! Standard: VHDL08
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
-- =============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.evr_pkg.all;

library unisim;
use unisim.vcomponents.all;

entity bram_controller_tb is
end bram_controller_tb;

architecture Behavioral of bram_controller_tb is

    component blk_mem_gen_0 is
      PORT (
        clka  : in  std_logic;
        ena   : in  std_logic;
        wea   : in  std_logic_vector(0 downto 0);
        addra : in  std_logic_vector(9 downto 0);
        dina  : in  std_logic_vector(31 downto 0);
        douta : out std_logic_vector(31 downto 0);
        clkb  : in  std_logic;
        enb   : in  std_logic;
        web   : in  std_logic_vector(0 downto 0);
        addrb : in  std_logic_vector(c_EVNT_MAP_ADDR_WIDTH-1 downto 0);
        dinb  : in  std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0);
        doutb : out std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0)
      );
    end component blk_mem_gen_0;

    constant c_CLK_PERIOD : time := 1 ns;
    constant c_WAIT       : time := 10*c_CLK_PERIOD;

    signal tb_clka, tb_clkb : std_logic := '0';
    signal tb_rst           : std_logic := '1';
    
    signal bram_addr        : std_logic_vector(c_EVNT_MAP_ADDR_WIDTH-1 downto 0) := (others => '0');
    signal bram_enb         : std_logic := '0';
    signal bram_din         : std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0) := (others => '0');
    signal bram_dout        : std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0) := (others => '0');
    signal bram_web         : std_logic_vector(0 downto 0) := (others => '0');
    
    signal event_rxd : event_code := c_EVENT_NULL;
    signal data_ready : std_logic := '0';
    signal event_cfg_word : std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0);
    
    signal pgen_ctrl_reg  : pgen_map_reg := (others => (others => '0'));
    signal internal_func_reg : picoevr_int_func := (others => '0');
    
    shared variable sim_end : boolean := false;
    
begin

    clock_gen : process
    begin
        if sim_end = false then
            tb_clkb <= '0';
            wait for c_CLK_PERIOD/2;
            tb_clkb <= '1';
            wait for c_CLK_PERIOD/2;
        else
            wait;
        end if;
    end process clock_gen;


    bram_instance_0 : blk_mem_gen_0
    port map (
        clka   => tb_clka,
        ena    => '0',
        wea    => (others => '0'),
        addra  => (others => '0'),
        dina   => (others => '0'),
        douta  => open,
        clkb   => tb_clkb,
        enb    => bram_enb,
        web    => bram_web,
        addrb  => bram_addr,
        dinb   => bram_din,
        doutb  => bram_dout
    );
    
    bram_ctrl_0 : bram_controller
    port map (
        i_evnt_clk  => tb_clkb,
        i_reset     => tb_rst,
        i_evnt_rxd  => event_rxd,
        i_bram_do   => bram_dout,
        o_bram_rden => bram_enb, 
        o_bram_addr => bram_addr,
        o_data_rdy  => data_ready,
        o_evnt_cfg  => event_cfg_word    
    );
    
    evnt_dec_ctrl_0 : evnt_dec_controller
    port map (
        i_evnt_clk      => tb_clkb,
        i_reset         => tb_rst,
        i_evnt_rdy      => data_ready,
        i_evnt_cfg      => event_cfg_word,
        o_pgen_map_reg  => pgen_ctrl_reg,
        o_int_func_reg  => internal_func_reg
    );
    
    stimulus : process 
    begin
        tb_rst <= '1';
        wait for c_CLK_PERIOD * 2;
        tb_rst <= '0';
        wait for c_CLK_PERIOD * 2;
        wait for c_WAIT;
        
        -- T1
        event_rxd <= x"0A";
        wait for c_CLK_PERIOD;
        event_rxd <= c_EVENT_NULL;
        wait for c_WAIT;
        
        -- T2
        event_rxd <= x"0B";
        wait for c_CLK_PERIOD;
        event_rxd <= c_EVENT_NULL;
        wait for 10*c_CLK_PERIOD;
        event_rxd <= x"0C";
        wait for c_CLK_PERIOD;
        event_rxd <= c_EVENT_NULL;
        wait for c_WAIT; 
        
        -- T3
        event_rxd <= x"0B";
        wait for c_CLK_PERIOD;
        event_rxd <= x"0C";
        wait for c_CLK_PERIOD;
        event_rxd <= c_EVENT_NULL;
        wait for c_WAIT; 
        
        -- T4
        event_rxd <= x"0A";
        wait for c_CLK_PERIOD;
        event_rxd <= x"0B";
        wait for c_CLK_PERIOD;
        event_rxd <= x"0C";
        wait for c_CLK_PERIOD;
        event_rxd <= c_EVENT_NULL;
        wait for c_WAIT; 
        
        sim_end := true;
        wait;
    end process stimulus;
    
end Behavioral;
