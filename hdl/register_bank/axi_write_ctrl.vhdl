--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : axi_write_ctrl.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-13
-- Last update : 2019-03-07
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : AXI4-Lite write controller to access the register bank.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2019 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-06-04  Christian Amstutz
--       Created
--
-- 0.2 : 2019-03-07  Christian Amstutz
--       Change to FSM
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library essffw;
use essffw.axi4.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity axi_write_ctrl  is
  generic (
    REG_ADDR_WIDTH  : integer := 8;
    AXI_ADDR_WIDTH  : integer := 10;
    AXI_WSTRB_WIDTH : integer := 1;                                             --! Width of the AXI wstrb signal, may be determined by ADDRESS_WIDTH
    AXI_DATA_WIDTH  : integer := 32;                                            --! Width of the AXI data signals
    REGISTER_WIDTH  : integer := 32                                             --! Width of a register
  );
  port (
    s_axi_aclk    : in  std_logic;                                              --! Clock of the whole block and the AXI interface
    s_axi_aresetn : in  std_logic;                                              --! Synchronous reset, active-low

    ----------------------------------------------------------------------------
    --! @name AXI4-Lite write interface
    --!@{
    ----------------------------------------------------------------------------
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
    --!@}

    write_en_o    : out std_logic;                                              --! Write enable towards the register bank
    address_o     : out std_logic_vector(REG_ADDR_WIDTH-1 downto 0);            --! Address of the register to be written
    bus_data_o    : out std_logic_vector(REGISTER_WIDTH-1 downto 0);            --! Data that is written to the register
    error_i       : in  std_logic                                               --! Error signal from register bank
  );
end entity axi_write_ctrl;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
architecture rtl of axi_write_ctrl is

  type   axi_write_state_t is (READY, WAIT_AWVALID, WAIT_WVALID, WRITE_DATA, RESPONSE);     --! States of the data write FSM
  signal axi_write_state   : axi_write_state_t;                                 --! The next state of the FSM
  signal axi_write_state_r : axi_write_state_t;                                 --! Registered state of the FSM, current state

  signal reg_address_in : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
  signal reg_address    : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
  signal reg_address_r  : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
  signal data           : std_logic_vector(REGISTER_WIDTH-1 downto 0);
  signal data_r         : std_logic_vector(REGISTER_WIDTH-1 downto 0);

begin

  reg_address_in <= s_axi_awaddr(REG_ADDR_WIDTH-1 downto 0);

  -- Write data control FSM
  axi_write_fsm_reg : process(all)
  begin
    if rising_edge(s_axi_aclk) then
      if s_axi_aresetn = '0' then
        axi_write_state_r <= READY;
      else
        axi_write_state_r <= axi_write_state;
        reg_address_r <= reg_address;
        data_r <= data;
      end if;
    end if;
  end process axi_write_fsm_reg;

  axi_write_fsm_comb : process(all)
  begin

    s_axi_awready <= '0';
    s_axi_wready <= '0';
    s_axi_bvalid <= '0';
    s_axi_bresp <= AXI4_RESP_OKAY;
    write_en_o <= '0';
    reg_address <= reg_address_r;
    data <= data_r;
    axi_write_state <= axi_write_state_r;

    case axi_write_state_r is

      when READY =>
        s_axi_awready <= '1';
        s_axi_wready <= '1';
        if (s_axi_awvalid = '1') and (s_axi_wvalid = '0') then
          reg_address <= reg_address_in;
          axi_write_state <= WAIT_WVALID;
        elsif (s_axi_awvalid = '0') and (s_axi_wvalid = '1') then
          data <= s_axi_wdata;
          axi_write_state <= WAIT_AWVALID;
        elsif (s_axi_awvalid = '1') and (s_axi_wvalid = '1') then
          reg_address <= reg_address_in;
          data <= s_axi_wdata;
          axi_write_state <= WRITE_DATA;
        end if;

      when WAIT_AWVALID =>
        s_axi_awready <= '1';
        if (s_axi_awvalid = '1') then
          reg_address <= reg_address_in;
          axi_write_state <= WRITE_DATA;
        end if;

      when WAIT_WVALID =>
        s_axi_wready <= '1';
        if (s_axi_wvalid = '1') then
          data <= s_axi_wdata;
          axi_write_state <= WRITE_DATA;
        end if;

      when WRITE_DATA =>
        write_en_o <= '1';
        if (s_axi_awvalid = '0') and (s_axi_wvalid = '0') then
          axi_write_state <= RESPONSE;
        end if;

      when RESPONSE =>
        s_axi_bvalid <= '1';
        if (s_axi_bready = '1') then
          axi_write_state <= READY;
        end if;

      when others =>
        axi_write_state <= READY;

    end case;

  end process;

  address_o <= reg_address_r;
  bus_data_o <= data_r;

end architecture rtl;
