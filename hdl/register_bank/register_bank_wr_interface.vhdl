--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_wr_interface.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-05-21
-- Last update : 2018-05-23
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description :
--               Combinatorial block.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-05-23  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library reg_bank;
use reg_bank.register_bank_config.all;
use reg_bank.register_bank_functions.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity register_bank_wr_interface  is
  port (
    register_write_en_i   : in  register_write_en_t;
    data_bus_i            : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);

    current_field_value_i : in  field_data_t;

    field_write_en_o      : out field_write_en_t;
    field_data_o          : out field_data_t
  );
end entity register_bank_wr_interface;

--------------------------------------------------------------------------------
--! @brief
--------------------------------------------------------------------------------
architecture rtl of register_bank_wr_interface is

    signal master_reset_write_en : std_logic_vector(0 downto 0);
    signal rxpath_reset_write_en : std_logic_vector(0 downto 0);
    signal txpath_reset_write_en : std_logic_vector(0 downto 0);


begin

  write_interface_cores : process (register_write_en_i, data_bus_i, current_field_value_i)
  begin

    master_reset_write_en(0) <= register_write_en_i.master_reset;
    write_interface_core((0 => 0), (0 => WRITE), master_reset_write_en, data_bus_i, field_write_en_o.master_reset, field_data_o.master_reset, current_field_value_i.master_reset);

    rxpath_reset_write_en(0) <= register_write_en_i.rxpath_reset;
    write_interface_core((0 => 0), (0 => WRITE), rxpath_reset_write_en, data_bus_i, field_write_en_o.rxpath_reset, field_data_o.rxpath_reset, current_field_value_i.rxpath_reset);

    txpath_reset_write_en(0) <= register_write_en_i.txpath_reset;
    write_interface_core((0 => 0), (0 => WRITE), txpath_reset_write_en, data_bus_i, field_write_en_o.txpath_reset, field_data_o.txpath_reset, current_field_value_i.txpath_reset);



  end process write_interface_cores;

end architecture rtl;
