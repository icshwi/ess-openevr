--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : axi4_pkg.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-07
-- Last update : 2018-06-04
-- Platform    :
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : Package containing definitions about the AXI4 standard.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.01 : 2018-06-04  Christian Amstutz
--        Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
--! Package containing definitions about the AXI4 standard and records to model
--! different types of AXI4 buses.
--------------------------------------------------------------------------------
package axi4 is

  --! Width of burst length signals (AWLEN, ARLEN)
  constant AXI4_LEN_WIDTH     : integer := 8;

  --! Width of burst size signals (AWSIZE, ARSIZE)
  constant AXI4_SIZE_WIDTH    : integer := 3;

  --! Width of burst type signals (AWBURST, ARBURST)
  constant AXI4_BURST_WIDTH   : integer := 2;

  --! Width of memory type signals (AWCACHE, ARCACHE)
  constant AXI4_CACHE_WIDTH   : integer := 4;

  --! Default value for AXI4 CACHE signals as recomended by Xilinx
  constant AXI4_CACHE_DEFAULT : std_logic_vector(AXI4_CACHE_WIDTH-1 downto 0) := "0011";

  --! Width of lock signals (AWCLOCK, ARLOCK)
  constant AXI4_LOCK_WIDTH    : integer := 1;

  --! Default value for AXI4 lock signals
  constant AXI4_LOCK_DEFAULT  : std_logic_vector(AXI4_LOCK_WIDTH-1 downto 0) := "0";

  --! Width of access permission signals (AWPROT, ARPROT)
  constant AXI4_PROT_WIDTH    : integer := 3;

  --! Width of quality of service (QOS) signals (AWQOS, ARQOS)
  constant AXI4_QOS_WIDTH     : integer := 4;

  --! Default value for AXI4 QOS signals
  constant AXI4_QOS_DEFAULT   : std_logic_vector(AXI4_QOS_WIDTH-1 downto 0) := (others => '0');

  --! Width of region signals (AWREGION, ARREGION)
  constant AXI4_REGION_WIDTH  : integer := 4;

  --! Width of response signals (BRESP, RRESP)
  constant AXI4_RESP_WIDTH    : integer := 2;

  constant AXI4_RESP_OKAY   : std_logic_vector(AXI4_RESP_WIDTH-1 downto 0) := "00";
  constant AXI4_RESP_EXOKAY : std_logic_vector(AXI4_RESP_WIDTH-1 downto 0) := "01";
  constant AXI4_RESP_SLVERR : std_logic_vector(AXI4_RESP_WIDTH-1 downto 0) := "10";
  constant AXI4_RESP_DECERR : std_logic_vector(AXI4_RESP_WIDTH-1 downto 0) := "11";

  --! Width of data signal for Xilinx AXI4-Lite interfaces
  constant AXI4L_DATA_WIDTH   : integer := 32;

  --! Width of strobe signal for Xilinx AXI4-Lite interfaces
  constant AXI4L_STRB_WIDTH   : integer := 4;

  ------------------------------------------------------------------------------
  -- The following code is contains unconstrained records from VHDL-2008, which
  -- are not yet supported by Vivado (2018.1).
  -- The code still can be used as templates by also defining the unconstrained
  -- std_logic_vector elements.
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- type axi4_ms_t is
  -- record
  --   awid    : std_logic_vector;
  --   awaddr  : std_logic_vector;
  --   awlen   : std_logic_vector(AXI4_LEN_WIDTH-1 downto 0);
  --   awsize  : std_logic_vector(AXI4_SIZE_WIDTH-1 downto 0);
  --   awburst : std_logic_vector(AXI4_BURST_WIDTH-1 downto 0);
  --   awprot  : std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
  --   awvalid : std_logic;
  --   wdata   : std_logic_vector;
  --   wstrb   : std_logic_vector;
  --   wlast   : std_logic;
  --   wvalid  : std_logic;
  --   bready  : std_logic;
  --   arid    : std_logic_vector;
  --   araddr  : std_logic_vector;
  --   arlen   : std_logic_vector(AXI4_LEN_WIDTH-1 downto 0);
  --   arsize  : std_logic_vector(AXI4_SIZE_WIDTH-1 downto 0);
  --   arburst : std_logic_vector(AXI4_BURST_WIDTH-1 downto 0);
  --   arprot  : std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
  --   arvalid : std_logic;
  --   rready  : std_logic;
  -- end record;
  --
  -- type t_axi4_sm is
  -- record
  --   awready : std_logic;
  --   wready  : std_logic;
  --   bid     : std_logic_vector;
  --   bresp   : std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
  --   bvalid  : std_logic;
  --   arready : std_logic;
  --   rid     : std_logic_vector;
  --   rdata   : std_logic_vector;
  --   rresp   : std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
  --   rlast   : std_logic;
  --   rvalid  : std_logic;
  -- end record;
  --
  -- type t_axi4_ms_array  is array (natural range<>) of t_axi4_ms;
  -- type t_axi4_sm_array  is array (natural range<>) of t_axi4_sm;
  --
  -- ------------------------------------------------------------------------------
  -- type t_axi4_writeonly_ms is
  -- record
  --   awid    : std_logic_vector;
  --   awaddr  : std_logic_vector;
  --   awlen   : std_logic_vector(AXI4_LEN_WIDTH-1 downto 0);
  --   awsize  : std_logic_vector(AXI4_SIZE_WIDTH-1 downto 0);
  --   awburst : std_logic_vector(AXI4_BURST_WIDTH-1 downto 0);
  --   awprot  : std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
  --   awvalid : std_logic;
  --   wdata   : std_logic_vector;
  --   wstrb   : std_logic_vector;
  --   wlast   : std_logic;
  --   wvalid  : std_logic;
  --   bready  : std_logic;
  -- end record;
  --
  -- type t_axi4_writeonly_sm is
  -- record
  --   awready : std_logic;
  --   wready  : std_logic;
  --   bid     : std_logic_vector;
  --   bresp   : std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
  --   bvalid  : std_logic;
  -- end record;
  --
  -- type t_axi4_writeonly_ms_array  is array (natural range<>) of axi4_writeonly_ms;
  -- type t_axi4_writeonly_sm_array  is array (natural range<>) of axi4_writeonly_sm;
  --
  -- ------------------------------------------------------------------------------
  -- type t_axi4l_ms is
  -- record
  --   awaddr  : std_logic_vector;
  --   awprot  : std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
  --   awvalid : std_logic;
  --   wdata   : std_logic_vector(AXI4L_DATA_WIDTH-1 downto 0);
  --   wstrb   : std_logic_vector(AXI4L_STRB_WIDTH-1 downto 0);
  --   wvalid  : std_logic;
  --   bready  : std_logic;
  --   araddr  : std_logic_vector;
  --   arprot  : std_logic_vector(AXI4_PROT_WIDTH-1 downto 0);
  --   arvalid : std_logic;
  --   rready  : std_logic;
  -- end record;
  --
  -- type t_axi4l_sm is
  -- record
  --   awready : std_logic;
  --   wready  : std_logic;
  --   bresp   : std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
  --   bvalid  : std_logic;
  --   arready : std_logic;
  --   rdata   : std_logic_vector(AXI4L_DATA_WIDTH-1 downto 0);
  --   rresp   : std_logic_vector(AXI4_RESP_WIDTH-1 downto 0);
  --   rvalid  : std_logic;
  -- end record;
  --
  -- type t_axi4l_ms_array_t is array (natural range<>) of axi4l_ms;
  -- type t_axi4l_sm_array_t is array (natural range<>) of axi4l_sm;
  --
  -- ------------------------------------------------------------------------------
  -- type t_axi4s_minimal is
  -- record
  --   tvalid : std_logic;
  --   tdata  : std_logic_vector;
  -- end record;
  --
  -- type t_axi4s_minimal_array is array (natural range<>) of t_axi4s_minimal;
  --
  -- ------------------------------------------------------------------------------
  -- type t_axi4s_minimal_clk is
  -- record
  --   aclk   : std_logic;
  --   tvalid : std_logic;
  --   tdata  : std_logic_vector;
  -- end record;
  --
  -- type t_axi4s_minimal_clk_array_t  is array (natural range<>) of axi4s_minimal_clk;

end package axi4;
