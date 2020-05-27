--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_axi.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-13
-- Last update : 2019-03-07
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : Regiser bank with AXI4-Lite interface.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2019 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-03-07  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library essffw;
use essffw.axi4.all;

library reg_bank;
use reg_bank.register_bank_config.all;
use reg_bank.register_bank_components.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity register_bank_axi  is
  generic (
    AXI_ADDR_WIDTH  : integer := ADDRESS_WIDTH+2;
    REG_ADDR_WIDTH	: integer	:= ADDRESS_WIDTH;                                 --! Width of the address signals
    AXI_WSTRB_WIDTH : integer := 4;                                             --! Width of the AXI wstrb signal, may be determined by ADDRESS_WIDTH
    REGISTER_WIDTH  : integer := REGISTER_WIDTH;                                --! Width of the registers
    AXI_DATA_WIDTH  : integer	:= AXI4L_DATA_WIDTH                               --! Width of the AXI data signals
  );
  port (
    s_axi_aclk              : in  std_logic;                                    --! Clock of the whole block and the AXI interface
    s_axi_aresetn           : in  std_logic;                                    --! Synchronous reset, active-low

    ----------------------------------------------------------------------------
    --! @name AXI4-Lite interface. The width of the address and data signals is
    --!       configured by generics.
    --!@{
    ----------------------------------------------------------------------------
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
    --@}

    transfer_shadow_group_i : in  transfer_shadow_group_t;

    register_data_o         : out logic_read_data_t;                            --! Record with output values of the individual registers
    register_return_i       : in  logic_return_t                                --! Record with the return values to the individual registers
  );
end entity register_bank_axi;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
architecture struct of register_bank_axi is

  signal write_en       : std_logic;
  signal write_address  : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
  signal bus_write_data : std_logic_vector(REGISTER_WIDTH-1 downto 0);
  signal read_en        : std_logic;
  signal read_address   : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
  signal bus_read_data  : std_logic_vector(REGISTER_WIDTH-1 downto 0);
  signal write_error    : std_logic;
  signal read_error     : std_logic;

begin

  axi_write : axi_write_ctrl
    generic map (
      AXI_ADDR_WIDTH  => AXI_ADDR_WIDTH,
      REG_ADDR_WIDTH  => REG_ADDR_WIDTH,
      AXI_WSTRB_WIDTH => AXI_WSTRB_WIDTH,
      AXI_DATA_WIDTH  => AXI_DATA_WIDTH,
      REGISTER_WIDTH  => REGISTER_WIDTH
    )
    port map (
      s_axi_aclk    => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,
      s_axi_awaddr  => s_axi_awaddr,
      s_axi_awprot  => s_axi_awprot,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_awready => s_axi_awready,
      s_axi_wdata   => s_axi_wdata,
      s_axi_wstrb   => s_axi_wstrb,
      s_axi_wvalid  => s_axi_wvalid,
      s_axi_wready  => s_axi_wready,
      s_axi_bresp   => s_axi_bresp,
      s_axi_bvalid  => s_axi_bvalid,
      s_axi_bready  => s_axi_bready,
      write_en_o    => write_en,
      address_o     => write_address,
      bus_data_o    => bus_write_data,
      error_i       => write_error
    );

  register_bank_inst : register_bank
    generic map (
      ADDRESS_WIDTH  => REG_ADDR_WIDTH,
      REGISTER_WIDTH => REGISTER_WIDTH
    )
    port map (
      clock_i                 => s_axi_aclk,
      reset_n_i               => s_axi_aresetn,
      decode_error_write_o    => write_error,
      decode_error_read_o     => read_error,
      write_en_i              => write_en,
      write_address_i         => write_address,
      bus_write_data_i        => bus_write_data,
      read_en_i               => read_en,
      read_address_i          => read_address,
      bus_read_data_o         => bus_read_data,
      transfer_shadow_group_i => transfer_shadow_group_i,
      logic_data_o            => register_data_o,
      logic_return_i          => register_return_i
    );

  axi_read : axi_read_ctrl
    generic map (
      AXI_ADDR_WIDTH => AXI_ADDR_WIDTH,
      REG_ADDR_WIDTH => REG_ADDR_WIDTH,
      AXI_DATA_WIDTH => AXI_DATA_WIDTH,
      REGISTER_WIDTH => REGISTER_WIDTH
    )
    port map (
      s_axi_aclk    => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,
      s_axi_araddr  => s_axi_araddr,
      s_axi_arprot  => s_axi_arprot,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_arready => s_axi_arready,
      s_axi_rdata   => s_axi_rdata,
      s_axi_rresp   => s_axi_rresp,
      s_axi_rvalid  => s_axi_rvalid,
      s_axi_rready  => s_axi_rready,
      read_en_o     => read_en,
      address_o     => read_address,
      bus_data_i    => bus_read_data,
      error_i       => read_error
    );

end architecture struct;
