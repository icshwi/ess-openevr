--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_components_pkg.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-09
-- Last update : 2019-03-07
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
-- 0.01 : 2019-07-03  Christian Amstutz
--        Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library essffw;
use essffw.axi4.all;

library ESS_openEVR_RegMap;
use ESS_openEVR_RegMap.register_bank_config.all;

package register_bank_components is

  ------------------------------------------------------------------------------
  component register_bank_axi
    generic (
      AXI_ADDR_WIDTH  : integer := ADDRESS_WIDTH + 2;
      REG_ADDR_WIDTH  : integer := ADDRESS_WIDTH;
      AXI_WSTRB_WIDTH : integer := 4;
      REGISTER_WIDTH  : integer := REGISTER_WIDTH;
      AXI_DATA_WIDTH  : integer := AXI4L_DATA_WIDTH
    );
    port (
      s_axi_aclk              : in  std_logic;
      s_axi_aresetn           : in  std_logic;
      s_axi_awaddr            : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      s_axi_awprot            : in  std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
      s_axi_awvalid           : in  std_logic;
      s_axi_awready           : out std_logic;
      s_axi_wdata             : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      s_axi_wstrb             : in  std_logic_vector(AXI_WSTRB_WIDTH-1 downto 0);
      s_axi_wvalid            : in  std_logic;
      s_axi_wready            : out std_logic;
      s_axi_bresp             : out std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
      s_axi_bvalid            : out std_logic;
      s_axi_bready            : in  std_logic;
      s_axi_araddr            : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      s_axi_arprot            : in  std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
      s_axi_arvalid           : in  std_logic;
      s_axi_arready           : out std_logic;
      s_axi_rdata             : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      s_axi_rresp             : out std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
      s_axi_rvalid            : out std_logic;
      s_axi_rready            : in  std_logic;
      transfer_shadow_group_i : in  transfer_shadow_group_t;
      register_data_o         : out logic_read_data_t;
      register_return_i       : in  logic_return_t
    );
  end component register_bank_axi;

  ------------------------------------------------------------------------------
  component register_bank
    generic (
      ADDRESS_WIDTH  : integer := ADDRESS_WIDTH;
      REGISTER_WIDTH : integer := REGISTER_WIDTH
    );
    port (
      clock_i                 : in  std_logic;
      reset_n_i               : in  std_logic;
      decode_error_write_o    : out std_logic;
      decode_error_read_o     : out std_logic;
      write_en_i              : in  std_logic;
      write_address_i         : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
      bus_write_data_i        : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);
      read_en_i               : in  std_logic;
      read_address_i          : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
      bus_read_data_o         : out std_logic_vector(REGISTER_WIDTH-1 downto 0);
      transfer_shadow_group_i : in  transfer_shadow_group_t;
      logic_data_o            : out logic_read_data_t;
      logic_return_i          : in  logic_return_t
    );
  end component register_bank;

  ------------------------------------------------------------------------------
  component axi_write_ctrl
    generic (
      REG_ADDR_WIDTH  : integer := 8;
      AXI_ADDR_WIDTH  : integer := 10;
      AXI_WSTRB_WIDTH : integer := 1;
      AXI_DATA_WIDTH  : integer := 32;
      REGISTER_WIDTH  : integer := 32
    );
    port (
      s_axi_aclk    : in  std_logic;
      s_axi_aresetn : in  std_logic;
      s_axi_awaddr  : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      s_axi_awprot  : in  std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
      s_axi_awvalid : in  std_logic;
      s_axi_awready : out std_logic;
      s_axi_wdata   : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      s_axi_wstrb   : in  std_logic_vector(AXI_WSTRB_WIDTH-1 downto 0);
      s_axi_wvalid  : in  std_logic;
      s_axi_wready  : out std_logic;
      s_axi_bresp   : out std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
      s_axi_bvalid  : out std_logic;
      s_axi_bready  : in  std_logic;
      write_en_o    : out std_logic;
      address_o     : out std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
      bus_data_o    : out std_logic_vector(REGISTER_WIDTH-1 downto 0);
      error_i       : in  std_logic
    );
  end component axi_write_ctrl;

  ------------------------------------------------------------------------------
  component axi_read_ctrl
    generic (
      REG_ADDR_WIDTH  : integer := 8;
      AXI_ADDR_WIDTH  : integer := 10;
      AXI_DATA_WIDTH  : integer := 32;
      REGISTER_WIDTH  : integer := 32
    );
    port (
      s_axi_aclk    : in  std_logic;
      s_axi_aresetn : in  std_logic;
      s_axi_araddr  : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
      s_axi_arprot  : in  std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
      s_axi_arvalid : in  std_logic;
      s_axi_arready : out std_logic;
      s_axi_rdata   : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      s_axi_rresp   : out std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
      s_axi_rvalid  : out std_logic;
      s_axi_rready  : in  std_logic;
      read_en_o     : out std_logic;
      address_o     : out std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
      bus_data_i    : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);
      error_i       : in  std_logic
    );
  end component axi_read_ctrl;

  ------------------------------------------------------------------------------
  component register_bank_address_decoder
    port (
      clock_i             : in  std_logic;
      reset_n_i           : in  std_logic;
      decode_error_o      : out std_logic;
      write_en_i          : in  std_logic;
      address_i           : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
      bus_data_i          : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);
      register_write_en_o : out register_write_en_t;
      register_data_o     : out std_logic_vector(REGISTER_WIDTH-1 downto 0)
    );
  end component register_bank_address_decoder;

  ------------------------------------------------------------------------------
  component register_bank_wr_interface
    port (
      register_write_en_i   : in  register_write_en_t;
      data_bus_i            : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);
      current_field_value_i : in  field_data_t;
      field_write_en_o      : out field_write_en_t;
      field_data_o          : out field_data_t
    );
  end component register_bank_wr_interface;

  ------------------------------------------------------------------------------
  component register_bank_core
    port (
      clock_i          : in  std_logic;
      reset_n_i        : in  std_logic;
      write_en_i       : in  field_write_en_t;
      bus_write_data_i : in  field_data_t;
      current_data_o   : out field_data_t;
      logic_to_bus_o   : out field_data_t;
      logic_data_o     : out logic_read_data_t;
      logic_return_i   : in  logic_return_t
    );
  end component register_bank_core;

  ------------------------------------------------------------------------------
  component register_bank_shadowing
    port (
      clock_i                 : in  std_logic;
      reset_n_i               : in  std_logic;
      transfer_shadow_group_i : in  transfer_shadow_group_t;
      logic_data_i            : in  logic_read_data_t;
      logic_data_o            : out logic_read_data_t
    );
  end component register_bank_shadowing;

  ------------------------------------------------------------------------------
  component register_bank_rd_interface
    port (
      field_value_i   : in  field_data_t;
      logic_value_i   : in  field_data_t;
      register_data_o : out register_bus_read_t
    );
  end component register_bank_rd_interface;

  ------------------------------------------------------------------------------
  component register_bank_rd_encoder
    port (
      clock_i         : in  std_logic;
      reset_n_i       : in  std_logic;
      decode_error_o  : out std_logic;
      read_en_i       : in  std_logic;
      address_i       : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
      register_data_i : in  register_bus_read_t;
      bus_data_o      : out std_logic_vector(REGISTER_WIDTH-1 downto 0)
    );
  end component register_bank_rd_encoder;

  ------------------------------------------------------------------------------
  component field_core  is
    generic (
      RESET_VALUE      : std_logic_vector;
      WIDTH            : integer
    );
    port (
      clock_i          : in  std_logic;
      reset_n_i        : in  std_logic;
      write_en_i       : in  std_logic;
      bus_write_data_i : in  std_logic_vector(WIDTH-1 downto 0);
      field_value_o    : out std_logic_vector(WIDTH-1 downto 0);
      logic_to_bus_o   : out std_logic_vector(WIDTH-1 downto 0);
      logic_data_o     : out std_logic_vector(WIDTH-1 downto 0);
      logic_return_i   : in  std_logic_vector(WIDTH-1 downto 0)
    );
  end component field_core;

end register_bank_components;
