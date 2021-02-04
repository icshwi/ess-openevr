-- ===========================================================================
--! @file pulse_gen_controller.vhd
--! @brief  
--!
--! @details
--!
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--!
--! @date 20210201
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


--! pulse_gen_controller includes the control logic for the individual pulse generators
entity pulse_gen_controller is
    generic (
        --! Amount of pulse generators to instantiate 
        g_PULSE_GEN_CNT     : natural := c_PULSE_GENS_CNT
    );
    port (
        --! Event clock (DC compensated)
        i_event_clk     : in std_logic;
        --! Array containing the record with the configuration register for each PGen
        i_pgen_ctrl_reg : in pgen_ctrl_regs;
        --! Record with the control bits coming from the mapping RAM
        i_pgen_map_reg  : in pgen_map_reg;
        --! Output from each Pulse Generator
        o_pgen_pxout    : out std_logic_vector(c_PULSE_GENS_CNT-1 downto 0)
        
    );
end entity;

architecture rtl of pulse_gen_controller is

    -- Intermediate arrays which enable masking the signals coming from the mapping RAM
    signal pgen_trigx, pgen_setx, pgen_resetx : std_logic_vector(g_PULSE_GEN_CNT-1 downto 0) := (others => '0') ;

    -- Array with all the pulses coming from the pulse generators
    signal pgen_pxout : std_logic_vector(g_PULSE_GEN_CNT-1 downto 0) := (others => '0') ;


begin

    -- Trigger, set and reset signals coming from the mapping RAM can be masked using bits
    -- from the configuration register.
    -- Software Set & Reset are also available using the configuration register
    i_pgen_ctrl_generate : for I in 0 to g_PULSE_GEN_CNT-1 generate
        pgen_trigx(I)  <= i_pgen_ctrl_reg(I).control(1) and  i_pgen_map_reg.triggerx(I);
        pgen_setx(I)   <= (i_pgen_ctrl_reg(I).control(2) and i_pgen_map_reg.setx(I))   or i_pgen_ctrl_reg(I).control(6);
        pgen_resetx(I) <= (i_pgen_ctrl_reg(I).control(3) and i_pgen_map_reg.resetx(I)) or i_pgen_ctrl_reg(I).control(5);
    end generate;

    i_pgen_generate : for I in 0 to g_PULSE_GEN_CNT-1 generate
        i_pgenx : pulse_generator
            port map (
                i_event_clk  => i_event_clk,
                i_enable     => i_pgen_ctrl_reg(I).control(0),
                i_trigger    => pgen_trigx(I),
                i_set        => pgen_setx(I),
                i_reset      => pgen_resetx(I),
                i_polarity   => i_pgen_ctrl_reg(I).control(4),
                i_delay_val  => i_pgen_ctrl_reg(I).delay,
                i_width_val  => i_pgen_ctrl_reg(I).width,
                o_pulse      => pgen_pxout(I)
            );
    end generate;

    -- Extra register stage needed?
    o_pgen_pxout <= pgen_pxout;

    

end architecture;