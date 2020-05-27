--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_core.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-12
-- Last update : 2018-05-24
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : Collection of the register fields belonging to the register
--               bank.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-05-24  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library reg_bank;
use reg_bank.register_bank_config.all;
use reg_bank.register_bank_functions.all;
use reg_bank.register_bank_components.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity register_bank_core  is
  port (
    clock_i          : in  std_logic;                                           --! The system clock that is a multiple of the ADC clock
    reset_n_i        : in  std_logic;                                           --! Low active reset signal

    write_en_i       : in  field_write_en_t;                                    --! Record of write enable signals, one for each register
    bus_write_data_i : in  field_data_t;                                        --! Write data from the data bus
    current_data_o   : out field_data_t;                                        --! Output of all the register values that can be read
    logic_to_bus_o   : out field_data_t;

    logic_data_o     : out logic_read_data_t;                                   --! Output values of the registers and register parts towards the logic
    logic_return_i   : in  logic_return_t                                       --! Return values of the registers and register parts from the logic
  );

  attribute dont_touch : string;
  attribute dont_touch of register_bank_core : entity is "true";

end entity register_bank_core;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
architecture rtl of register_bank_core is
begin

    -- Register: master_reset
    field_master_reset : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.master_reset,
      bus_write_data_i => bus_write_data_i.master_reset,
      field_value_o    => current_data_o.master_reset,
      logic_to_bus_o   => logic_to_bus_o.master_reset,
      logic_data_o     => logic_data_o.master_reset,
      logic_return_i   => logic_return_i.master_reset
    );

    -- Register: rxpath_reset
    field_rxpath_reset : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.rxpath_reset,
      bus_write_data_i => bus_write_data_i.rxpath_reset,
      field_value_o    => current_data_o.rxpath_reset,
      logic_to_bus_o   => logic_to_bus_o.rxpath_reset,
      logic_data_o     => logic_data_o.rxpath_reset,
      logic_return_i   => logic_return_i.rxpath_reset
    );

    -- Register: txpath_reset
    field_txpath_reset : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.txpath_reset,
      bus_write_data_i => bus_write_data_i.txpath_reset,
      field_value_o    => current_data_o.txpath_reset,
      logic_to_bus_o   => logic_to_bus_o.txpath_reset,
      logic_data_o     => logic_data_o.txpath_reset,
      logic_return_i   => logic_return_i.txpath_reset
    );



end architecture rtl;
