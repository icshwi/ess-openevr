--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-08
-- Last update : 2018-06-04
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : Core of the register bank that contains and controls the
--               separate register bank cells.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-06-04  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library reg_bank;
use reg_bank.register_bank_config.all;
use reg_bank.register_bank_components.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity register_bank is
  generic (
    ADDRESS_WIDTH  : integer := ADDRESS_WIDTH;
    REGISTER_WIDTH : integer := REGISTER_WIDTH
  );
  port (
    clock_i                  : in  std_logic;
    reset_n_i                : in  std_logic;

    decode_error_write_o     : out std_logic;
    decode_error_read_o      : out std_logic;

    write_en_i               : in  std_logic;
    write_address_i          : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    bus_write_data_i         : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);
    read_en_i                : in  std_logic;
    read_address_i           : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    bus_read_data_o          : out std_logic_vector(REGISTER_WIDTH-1 downto 0);

    transfer_shadow_group_i  : in transfer_shadow_group_t;

    logic_data_o             : out logic_read_data_t;
    logic_return_i           : in  logic_return_t
  );
end entity register_bank;

--------------------------------------------------------------------------------
--! @brief Structural description of the ADC preprocessing
--------------------------------------------------------------------------------
architecture struct of register_bank is

  signal register_write_en   : register_write_en_t;
  signal register_write_data : std_logic_vector(REGISTER_WIDTH-1 downto 0);

  signal current_field_data  : field_data_t;
  signal current_logic_data  : field_data_t;
  signal field_write_en      : field_write_en_t;
  signal field_write_data    : field_data_t;

  signal logic_data          : logic_read_data_t;

  signal register_read_data  : register_bus_read_t;

begin

  write_address_decoder : register_bank_address_decoder
    port map (
      clock_i             => clock_i,
      reset_n_i           => reset_n_i,
      decode_error_o      => decode_error_write_o,
      write_en_i          => write_en_i,
      address_i           => write_address_i,
      bus_data_i          => bus_write_data_i,
      register_write_en_o => register_write_en,
      register_data_o     => register_write_data
    );

  write_interface : register_bank_wr_interface
    port map (
      register_write_en_i   => register_write_en,
      data_bus_i            => register_write_data,
      current_field_value_i => current_field_data,
      field_write_en_o      => field_write_en,
      field_data_o          => field_write_data
    );

  fields : register_bank_core
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => field_write_en,
      bus_write_data_i => field_write_data,
      current_data_o   => current_field_data,
      logic_to_bus_o   => current_logic_data,
      logic_data_o     => logic_data,
      logic_return_i   => logic_return_i
    );

  shadowing : register_bank_shadowing
    port map (
      clock_i                 => clock_i,
      reset_n_i               => reset_n_i,
      transfer_shadow_group_i => transfer_shadow_group_i,
      logic_data_i            => logic_data,
      logic_data_o            => logic_data_o
    );

  read_interface : register_bank_rd_interface
    port map (
      field_value_i   => current_field_data,
      logic_value_i   => current_logic_data,
      register_data_o => register_read_data
    );

  read_data_select : register_bank_rd_encoder
    port map (
      clock_i         => clock_i,
      reset_n_i       => reset_n_i,
      decode_error_o  => decode_error_read_o,
      read_en_i       => read_en_i,
      address_i       => read_address_i,
      register_data_i => register_read_data,
      bus_data_o      => bus_read_data_o
    );

end architecture struct;
