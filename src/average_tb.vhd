----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2020 03:28:47 PM
-- Design Name: 
-- Module Name: average_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity average_tb is
end average_tb;

architecture behavioral_sw of average_tb is

    component average is
    generic (
        NAT_BITS  : integer := 16;
        FRAC_BITS : integer := 16);
    port (
        clk             : in std_logic;
        value_in        : in std_logic_vector(NAT_BITS-1 downto 0);
        value_valid     : in std_logic;
        reset           : in std_logic;
        average_out     : out std_logic_vector(NAT_BITS+FRAC_BITS-1 downto 0);
        average_valid   : out std_logic
    );
    end component;
    
    -- PROCEDURES

    

    -- inputs
    signal sim_clk           : std_logic := '0';
    signal sim_rst_n         : std_logic := '1';
    signal sim_value_in      : std_logic_vector(3 DOWNTO 0);
    signal sim_value_valid   : std_logic;
    signal sim_average_out   : std_logic_vector(7 DOWNTO 0);
    signal sim_averge_valid  : std_logic;
    
    constant c_clk_period : time := 10 ns;
    
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

    DUT: average
    GENERIC MAP
    (
        NAT_BITS  => 4,
        FRAC_BITS => 4
    )
    PORT MAP
    (
        clk         => sim_clk,
        value_in    => sim_value_in,
        value_valid => sim_value_valid,
        reset       => not sim_rst_n,
        average_out => sim_average_out,
        average_valid => sim_averge_valid
    );
    

    TestBench: PROCESS
        PROCEDURE write_value (new_value : in std_logic_vector(4-1 downto 0)) IS
        BEGIN
            sim_value_valid <= '0';
            sim_value_in <= new_value;
            wait for c_clk_period;
            sim_value_valid <= '1';
            wait for c_clk_period;
            sim_value_valid <= '0';
        END write_value;
    BEGIN
        -- Gobal reset
        sim_rst_n <= '0';
        wait for 100 ns;
        
        
       -- wait for 100 ns;
        sim_rst_n <= '1';
        
        -- Set stimulus
            for i in 0 to 15 loop
                write_value(std_logic_vector(to_unsigned(i,4)));
            end loop;
        
        -- Allow to process the last value
        wait for 100 ns;

     -- Set stimulus
            for i in 1 to 64 loop
                write_value(std_logic_vector(to_unsigned(1,4)));
            end loop;
        wait for 100 ns;

        sim_end := true;

        wait; -- wait forever
    END PROCESS TestBench;


end Behavioral_sw;
