----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/18/2020 07:53:42 AM
-- Design Name: 
-- Module Name: delay_measure_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- require for writing/reading std_logic etc.
use ieee.math_real.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity delay_measure_tb is
end delay_measure_tb;

architecture Behavioral of delay_measure_tb is

component delay_measure is
  generic (
        MAX_DELAY_BITS         : integer := 16;
        FRAC_DELAY_BITS        : integer := 16;
        CYCLE_CNT_BITS_0       : integer := 10;
        CYCLE_CNT_BITS_1       : integer := 16;
        CYCLE_CNT_BITS_2       : integer := 20);
  port (
        clk              : in std_logic;
        beacon_0         : in std_logic;
        beacon_1         : in std_logic;
    
        fast_adjust      : in std_logic;
        slow_adjust      : in std_logic;
        reset            : in std_logic;
        
        delay_out        : out std_logic_vector(31 downto 0);
        slow_delay_out   : out std_logic_vector(31 downto 0);
        delay_update_out : out std_logic;
        init_done        : out std_logic;

        debug_out        : out std_logic_vector(31 downto 0)
    );
    end component delay_measure;

    -- Signals
    signal sim_clk              : std_logic;
    signal sim_beacon_0         : std_logic := '0';
    signal sim_beacon_1         : std_logic := '0';
    signal sim_fast_adjust      : std_logic := '0';
    signal sim_slow_adjust      : std_logic := '0';
    signal sim_reset            : std_logic := '1';
    signal sim_delay_out        : std_logic_vector(31 downto 0);
    signal sim_slow_delay_out   : std_logic_vector(31 downto 0);
    signal sim_delay_update_out : std_logic;
    signal sim_init_done        : std_logic;
    signal sim_debug_out        : std_logic_vector(31 downto 0);
    
    constant c_clk_period : time := 10 ns;
    constant beacon_delay : integer := 20; -- simulate clock cycle delay between beacons
    
    SHARED VARIABLE sim_end : boolean := false;
    
begin
    
    clock_gen : PROCESS
    BEGIN
        if sim_end = false THEN
            sim_clk <= '0';
            wait for c_clk_period/2;
            sim_clk <= '1';
            wait for c_clk_period/2;
        else
            wait;
            --sim_clk <= not sim_clk after c_clk_period/2 ns;
        end if;
    END PROCESS clock_gen;
    
    DUT : delay_measure
    generic map (
        MAX_DELAY_BITS   => 16,
        FRAC_DELAY_BITS  => 16,
        CYCLE_CNT_BITS_0 => 10,
        CYCLE_CNT_BITS_1 => 16,
        CYCLE_CNT_BITS_2 => 20
    )
    port map (
        clk              => sim_clk,
        beacon_0         => sim_beacon_0,
        beacon_1         => sim_beacon_1,
        fast_adjust      => sim_fast_adjust,
        slow_adjust      => sim_slow_adjust, 
        reset            => sim_reset,
        delay_out        => sim_delay_out,
        slow_delay_out   => sim_slow_delay_out,
        delay_update_out => sim_delay_update_out,
        init_done        => sim_init_done,
        debug_out        => sim_debug_out
    ); 
        
    stimulus : PROCESS
        variable variance     : integer := 0;
        variable r            : real;
        variable seed1, seed2 : positive;

    BEGIN
        -- global reset
        sim_reset <= '1';               wait for 100ns;
        sim_reset <= '0';               wait for 100ns;
        
        sim_fast_adjust <= '1';                     
        -- sim_slow_adjust <= '1';         wait for 10ns;
        
        -- Clock line beacons
        for i in 0 to (1048576 + 1) loop -- 2^20 + 1
            if i mod 65535*4 = 0 then -- Generate a psuedo-random integer between 0 - 10
                uniform(seed1, seed2, r);
                variance := integer(round(r * real(10)));
            end if; 
            sim_beacon_0 <= '1';        wait for 10ns;
            sim_beacon_0 <= '0';        wait for (beacon_delay - 1 + variance) * 10ns; --time delay between beacons
            sim_beacon_1 <= '1';        wait for 10 ns;
            sim_beacon_1 <= '0';        wait for 100ns;
        end loop;
               
                                        wait for 10000ns;
    
        sim_end := true;
        wait;
    END PROCESS stimulus;    
        
end Behavioral;
