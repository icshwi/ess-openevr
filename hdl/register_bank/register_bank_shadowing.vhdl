--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_shadowing.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-05-28
-- Last update : 2018-05-28
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
-- 0.1 : 2018-05-28  Christian Amstutz
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
entity register_bank_shadowing is
  port (
    clock_i                 : in  std_logic;
    reset_n_i               : in  std_logic;

    transfer_shadow_group_i : in  transfer_shadow_group_t;

    logic_data_i            : in  logic_read_data_t;
    logic_data_o            : out logic_read_data_t
  );
end entity register_bank_shadowing;

--------------------------------------------------------------------------------
--! @brief
--------------------------------------------------------------------------------
architecture rtl of register_bank_shadowing is
begin



  logic_data_o.master_reset <= logic_data_i.master_reset;
  logic_data_o.rxpath_reset <= logic_data_i.rxpath_reset;
  logic_data_o.txpath_reset <= logic_data_i.txpath_reset;


end architecture rtl;
