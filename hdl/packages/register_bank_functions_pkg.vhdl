--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_functions_pkg.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-07
-- Last update : 2019-03-01
-- Platform    :
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description :
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2019 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.01 : 2019-03-01  Chrisian Amstutz
--        Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

package register_bank_functions is

  type t_integer_arr is array (integer range <>) of integer;
  type t_wr_if_modes is (WRITE, SET, CLEAR);
  type t_wr_if_modes_arr is array (integer range <>) of t_wr_if_modes;

  ------------------------------------------------------------------------------
  --!
  ------------------------------------------------------------------------------
  procedure write_interface_core (
    constant offsets        : in  t_integer_arr;
    constant interface_mode : in  t_wr_if_modes_arr;
    signal write_en         : in  std_logic_vector;
    signal bus_data         : in  std_logic_vector;
    signal field_wr_en   : out std_logic;
    signal field_wr_data : out std_logic_vector;
    signal field_value   : in  std_logic_vector
  );

  ------------------------------------------------------------------------------
  --!
  ------------------------------------------------------------------------------
  procedure read_interface_readback (
    constant width          : in  integer;
    constant offset         : in  integer;
    signal register_value   : in  std_logic_vector;
    signal logic_value      : in  std_logic_vector;
    signal register_rd_data : out std_logic_vector
  );

  ------------------------------------------------------------------------------
  --!
  ------------------------------------------------------------------------------
  procedure read_interface_logic (
    constant width          : in  integer;
    constant offset         : in  integer;
    signal register_value   : in  std_logic_vector;
    signal logic_value      : in  std_logic_vector;
    signal register_rd_data : out std_logic_vector
  );

  ------------------------------------------------------------------------------
  --!
  ------------------------------------------------------------------------------
  procedure read_interface_none (
    constant width          : in  integer;
    constant offset         : in  integer;
    signal register_value   : in  std_logic_vector;
    signal logic_value      : in  std_logic_vector;
    signal register_rd_data : out std_logic_vector
  );

end register_bank_functions;

package body register_bank_functions is

  ------------------------------------------------------------------------------
  procedure write_interface_core (
    constant offsets        : in  t_integer_arr;
    constant interface_mode : in  t_wr_if_modes_arr;
    signal write_en         : in  std_logic_vector;
    signal bus_data         : in  std_logic_vector;
    signal field_wr_en      : out std_logic;
    signal field_wr_data    : out std_logic_vector;
    signal field_value      : in  std_logic_vector
  ) is
    variable bus_wr_data_field : std_logic_vector(field_wr_data'length-1 downto 0);
  begin

    field_wr_en <= xor_reduce(write_en);

    for i in 0 to write_en'length-1 loop
      bus_wr_data_field := bus_data(offsets(i)+field_wr_data'length-1 downto offsets(i));
      if (write_en(i) = '1') then
        case interface_mode(i) is
          when WRITE =>
            field_wr_data <= bus_wr_data_field;
          when SET =>
            field_wr_data <= bus_wr_data_field or field_value;
          when CLEAR =>
            field_wr_data <= not(bus_wr_data_field) and field_value;
          when others =>
            field_wr_data <= bus_wr_data_field;
          end case;
      end if;
    end loop;

  end write_interface_core;

  ------------------------------------------------------------------------------
  procedure read_interface_readback (
    constant width          : in  integer;
    constant offset         : in  integer;
    signal register_value   : in  std_logic_vector;
    signal logic_value      : in  std_logic_vector;
    signal register_rd_data : out std_logic_vector
  ) is
  begin
    register_rd_data(offset+width-1 downto offset) <= register_value;
  end read_interface_readback;

  ------------------------------------------------------------------------------
  procedure read_interface_logic (
    constant width          : in  integer;
    constant offset         : in  integer;
    signal register_value   : in  std_logic_vector;
    signal logic_value      : in  std_logic_vector;
    signal register_rd_data : out std_logic_vector
  ) is
  begin
    register_rd_data(offset+width-1 downto offset) <= logic_value;
  end read_interface_logic;

  ------------------------------------------------------------------------------
  procedure read_interface_none (
    constant width          : in  integer;
    constant offset         : in  integer;
    signal register_value   : in  std_logic_vector;
    signal logic_value      : in  std_logic_vector;
    signal register_rd_data : out std_logic_vector
  ) is
  begin
    register_rd_data(offset+width-1 downto offset) <= (others => '0');
  end read_interface_none;

end register_bank_functions;
