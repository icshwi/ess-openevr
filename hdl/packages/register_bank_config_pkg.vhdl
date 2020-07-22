--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_config_pkg.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-14
-- Last update : 2018-05-28
-- Platform    :
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description :
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.01 : 2018-05-28  Christian Amstutz
--        Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package register_bank_config is

  constant ADDRESS_WIDTH         : integer   := 12;
  constant REGISTER_WIDTH        : integer   := 32;
  constant UNDEFINED_FIELD_VALUE : std_logic := '0';

  -- register_write_en_t
  type register_write_en_t is record
     master_reset         : std_logic;
     rxpath_reset         : std_logic;
     txpath_reset         : std_logic;
  end record;

  -- field_write_en_t
  type field_write_en_t is record
     master_reset         : std_logic;
     rxpath_reset         : std_logic;
     txpath_reset         : std_logic;
  end record;

  -- field_data_t
  type field_data_t is record
     master_reset         : std_logic_vector(31 downto 0);
     rxpath_reset         : std_logic_vector(31 downto 0);
     txpath_reset         : std_logic_vector(31 downto 0);
  end record;

  -- register_bus_read_t
  type register_bus_read_t is record
     master_reset         : std_logic_vector(REGISTER_WIDTH-1 downto 0);
     rxpath_reset         : std_logic_vector(REGISTER_WIDTH-1 downto 0);
     txpath_reset         : std_logic_vector(REGISTER_WIDTH-1 downto 0);
  end record;

  -- logic_read_data_t
  type logic_read_data_t is record
     master_reset         : std_logic_vector(31 downto 0);
     rxpath_reset         : std_logic_vector(31 downto 0);
     txpath_reset         : std_logic_vector(31 downto 0);
  end record;

  -- logic_return_t
  type logic_return_t is record
     master_reset         : std_logic_vector(31 downto 0);
     rxpath_reset         : std_logic_vector(31 downto 0);
     txpath_reset         : std_logic_vector(31 downto 0);
  end record;

  type transfer_shadow_group_t is record
    none : std_logic;
  end record;


  

end register_bank_config;
