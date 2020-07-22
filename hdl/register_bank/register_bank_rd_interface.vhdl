--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_rd_interface.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-05-21
-- Last update : 2018-05-31
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
-- 0.1 : 2018-05-31  Christian Amstutz
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
entity register_bank_rd_interface is
  port (
    field_value_i      : in  field_data_t;
    logic_value_i      : in  field_data_t;

    register_data_o    : out register_bus_read_t
  );
end entity register_bank_rd_interface;

--------------------------------------------------------------------------------
--! @brief
--------------------------------------------------------------------------------
architecture rtl of register_bank_rd_interface is
begin

  read_interface_cores : process (field_value_i, logic_value_i)
  begin

    -- Make all undefined registers/fields read as UNDEFINED_FIELD_VALUE
    register_data_o <= (others => (others => UNDEFINED_FIELD_VALUE));

    read_interface_logic(32, 0, field_value_i.master_reset, logic_value_i.master_reset, register_data_o.master_reset);
    read_interface_logic(32, 0, field_value_i.rxpath_reset, logic_value_i.rxpath_reset, register_data_o.rxpath_reset);
    read_interface_logic(32, 0, field_value_i.txpath_reset, logic_value_i.txpath_reset, register_data_o.txpath_reset);


  end process read_interface_cores;

end architecture rtl;
