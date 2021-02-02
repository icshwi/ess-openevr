-- ===========================================================================
--! @file pulse_gen.vhd
--! @brief A Pulse Generator generates an event triggered programable pulse
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--!
--! @date 20210128
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

--! @brief pulse_generator implements the MRF Pulse Generators from the EVR
--! @details
--! A Pulse Generator produces a configurable width pulse which is triggered
--! by the arrival of a particular event. It can be also configured to 
--! produce a HIGH or LOW steady level.
--! When a particular event is received by the picoEVR, the event is decoded
--! thanks to the mapping RAM unit into actions. The mapping RAM holds the
--! expected behaviour of each Pulse Generator, thus most of the signals
--! included in the interface of this entity should be driven from the 
--! output of the mapping RAM.
entity pulse_generator is
    port (
        --! Rx clock with DC : Used for the time counter.
        i_event_clk   : in std_logic;
        --! Enable    : Activates the logic of the Pulse Generator.
        --!             When LOW, the output of the module is set to LOW as well.
        --!             When HIGH, the output depends on the rest of the inputs
        i_enable      : in std_logic;
        --! Trigger   : Activates the delay counter
        i_trigger     : in std_logic;
        --! Set       : Asynchronously sets the output to HIGH level (watch polarity)
        i_set         : in std_logic;
        --! Reset     : Asynchronously sets the output to LOW level (watch polarity)
        i_reset       : in std_logic;
        --! Output polarity : LOW -> Normal polarity | HIGH -> Inverted polarity
        --!                   Affects the output value always but when i_enable = '0'.
        i_polarity    : in std_logic;
        --! Delay value : Value for the delay counter. 
        --!               This value relates to the amount of time the output is set to LOW
        --!               level after a rising edge on the trigger signal was received.
        i_delay_val   : in std_logic_vector(31 downto 0);
        --! Width value : Value for the width counter.
        --!               This value relates to the amount of time the output is set to HIGH
        --!               level after the delay counter is overflowed.
        i_width_val   : in std_logic_vector(31 downto 0);
        --! Output pulse : Output of a D-FlipFlop with asynchronous Set, Reset and Enable inputs.
        o_pulse       : out std_logic
    );
end entity;

architecture rtl of pulse_generator is

    -- Pulse output from the counter stage
    signal int_pulse         : std_logic := '0';
    -- Signal to enable any of the counters (delay or width)
    signal encounter         : std_logic := '0';
    -- Local value for the active counter (delay or width)
    signal counter           : unsigned(31 downto 0) := (others => '0');

    -- FSM states:
    -- * WAITING : Idle state, waiting for the trigger signal
    -- * DELAY_CNT : State in which the delay counter is active. When the counter reaches the delay target value,
    --               the internal pulse goes HIGH and the FSM moves to the width counter. 
    -- * WIDTH_CNT : State in wich the width counter is active. This is the amount of time the pulse is hold in HIGH
    --               value. After the counter reaches the target value, the FSM moves to WAITING and sets back the 
    --               the pulse to the LOW value.
    type pgen_state is (WAITING, DELAY_CNT, WIDTH_CNT);
    signal fsmstate_next, fsmstate_cur : pgen_state := WAITING;

begin

    -- FSM state update
    process (i_event_clk)
    begin
        if rising_edge(i_event_clk) then
            if i_reset = '1' or i_set = '1' then
                fsmstate_cur <= WAITING;
            else
                fsmstate_cur <= fsmstate_next;
            end if;            
        end if;
    end process;

    -- Counter for the FSM's Delay and Width states
    cnt : process (i_event_clk)
    begin
        if rising_edge(i_event_clk) then
            if i_reset = '1' then
                counter <= (others => '0');
            elsif encounter = '1' then
                counter <= counter + 1;
            else
                counter <= (others => '0'); 
            end if;

        end if;
    end process;

    -- FSM to handle the pulse width.
    process (fsmstate_cur, counter, i_trigger, i_delay_val, i_width_val)
    begin
        fsmstate_next <= fsmstate_cur;

        case fsmstate_cur is
            when WAITING   =>
                int_pulse         <= '0';
                encounter         <= '0';

                if i_trigger = '1' then
                    fsmstate_next <= DELAY_CNT;
                else
                    fsmstate_next <= WAITING;
                end if;

            when DELAY_CNT =>
                -- Generate the LOW part of the pulse
                int_pulse         <= '0'; 

                -- Two cycles from the rising edge of the trigger signal to the 
                -- start of the counter
                if counter >= unsigned(i_delay_val)-3 then
                    fsmstate_next <= WIDTH_CNT;
                    encounter     <= '0'; -- Reset the counter for the next state
                else
                    encounter     <= '1';
                    fsmstate_next <= DELAY_CNT;
                end if;

            when WIDTH_CNT =>
                -- Generate the HIGH part of the pulse
                int_pulse         <= '1';

                -- The output flop consumes a cycle
                if counter >= unsigned(i_width_val)-1 then
                    fsmstate_next <= WAITING;
                    encounter     <= '0'; -- Reset the counter for the next state
                else
                    encounter     <= '1';
                    fsmstate_next <= WIDTH_CNT;
                end if;
            end case;

    end process;

    -- D-FlipFlop with asynchronous SET & RESET inputs and polarity module at the output
    d_flipflop : process (i_event_clk, i_reset, i_set, i_enable)
    begin
        if i_reset = '1' and i_enable = '1' then
            o_pulse <= '0' xor i_polarity;
        elsif i_set = '1' and i_enable = '1' then
            o_pulse <= '1' xor i_polarity;
        elsif rising_edge(i_event_clk) then
            if i_enable = '1' then
                o_pulse <= int_pulse xor i_polarity;
            else
                o_pulse <= '0'; -- Not considering the polarity
            end if;
        end if;
    end process;
   

end architecture;