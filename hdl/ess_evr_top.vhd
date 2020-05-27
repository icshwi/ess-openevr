-- =============================================================================
--! @file   ess_evr_top.vhd
--! @brief  OpenEVR Top entity supporting the picoZED carrier by Tallinn
--!
--! @details
--!
--! Top entity to include MRF's openEVR in the FPGA-IOC rev. B carrier board.
--! The GTX wrapper and the databuf modules are not yet touched. The only
--! modifications to the MRF's code has been motivated by the use of a
--! different carrier board.
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--! @author Ross Elliot <ross.elliot@ess.eu>
--!
--! @date 20200421
--! @version 0.4
--!
--! Company: European Spallation Source ERIC \n
--! Platform: picoZED 7030 \n
--! Carrier board: Tallinn picoZED carrier board (aka FPGA-based IOC) rev. B \n
--!
--! @copyright
--!
--! Copyright (C) 2019- 2020 European Spallation Source ERIC \n
--! This program is free software: you can redistribute it and/or modify
--! it under the terms of the GNU General Public License as published by
--! the Free Software Foundation, either version 3 of the License, or
--! (at your option) any later version. \n
--! This program is distributed in the hope that it will be useful,
--! but WITHOUT ANY WARRANTY; without even the implied warranty of
--! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--! GNU General Public License for more details. \n
--! You should have received a copy of the GNU General Public License
--! along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- =============================================================================


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.evr_pkg.ALL;

library essffw;
use essffw.axi4.all;

library reg_bank;
use reg_bank.register_bank_config.all;
use reg_bank.register_bank_components.all;

--!  @brief ess_evr_top: Top entity for the ESS openEVR
entity ess_evr_top is
  Generic (
    --! width of debug port
    g_DEBUG_WIDTH   : integer := 5;
    AXI_ADDR_WIDTH  : integer := ADDRESS_WIDTH+2;
    REG_ADDR_WIDTH  : integer := ADDRESS_WIDTH;    --! Width of the address signals
    AXI_WSTRB_WIDTH : integer := 4;                --! Width of the AXI wstrb signal, may be determined by ADDRESS_WIDTH
    REGISTER_WIDTH  : integer := REGISTER_WIDTH;   --! Width of the registers
    AXI_DATA_WIDTH  : integer := AXI4L_DATA_WIDTH  --! Width of the AXI data signals
    );
  Port (
    --! AXI4-Lite Register interface
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
  
    --! Global logic clock, differential input from Si5346 Out2
    i_ZYNQ_MRCC_LVDS_P : in std_logic;
    i_ZYNQ_MRCC_LVDS_N : in std_logic;

    --! MGT reference clock 0, differential input from Si5346 Out0
    i_ZYNQ_CLKREF0_P : in std_logic;
    i_ZYNQ_CLKREF0_N : in std_logic;

    --! SFP Tx&Rx lines
    o_EVR_TX_P     : out std_logic;
    o_EVR_TX_N     : out std_logic;
    i_EVR_RX_P     : in std_logic;
    i_EVR_RX_N     : in std_logic;

    --! SFP Link LED
    o_EVR_LINK_LED : out std_logic;
    --! SFP Event LED
    o_EVR_EVNT_LED : out std_logic;
    --! EVR event single-ended clock output - 88.0525 MHz
    o_EVR_EVENT_CLK  : out std_logic;
    --! Global logic single-ended clock output - 100 MHz
    o_GLBL_LOGIC_CLK : out std_logic;

    --! Debug port (to connect to fmc-dio-5ch-ttl mezzanine card)
    o_DEBUG          : out std_logic_vector(g_DEBUG_WIDTH-1 downto 0));
end ess_evr_top;

architecture rtl of ess_evr_top is

  signal gnd     : std_logic := '0';
  signal vcc     : std_logic := '1';

  --------------- Clocks  -------------------
  --! Global system clock - 88.0525 MHz
  signal sys_clk       : std_logic;
  signal sys_clk_buf   : std_logic;
  --! Recovered clock from the transveiver
  signal refclk        : std_logic;
  --! Recovered clock with Delay Compensation
  signal event_clk     : std_logic;
  --! Downscaled clock from sys_clk (sys_clk/8)
  signal local_clk     : std_logic := '0';
  --! Single-ended clock from transceiver wrapper
  signal event_clk_se  : std_logic;
  --! Reference clock for the EVR GT - single ended
  signal gt0_refclk0   : std_logic;

  --------------- Resets ------------------
  --! Reset signal needed by the GTX. This reset should be driven
  --! from an external element. Locally generated by now.
  signal transceiver_reset : std_logic := '0';
  signal local_transceiver_reset : std_logic := '0';

  ----------- Module parameters -----------
  --! Delay Compensation Enable
  signal dc_mode : std_logic := '1';
  --! Place in the network topology.
  signal topology_addr      : std_logic_vector(31 downto 0);
  --! Target value for the DC module
  signal delay_comp_target  : std_logic_vector(31 downto 0) := x"02100000";


  signal event_link_ok : std_logic;

  signal event_rxd       : std_logic_vector(7 downto 0);
  signal dbus_rxd        : std_logic_vector(7 downto 0);
  signal databuf_rxd     : std_logic_vector(7 downto 0);
  signal databuf_rx_k    : std_logic;
  signal databuf_rx_ena  : std_logic;
  signal databuf_rx_mode : std_logic := '1';

  signal rx_link_ok      : std_logic;
  signal rx_violation    : std_logic;
  signal rx_clear_viol   : std_logic;

  signal event_txd       : std_logic_vector(7 downto 0);
  signal dbus_txd        : std_logic_vector(7 downto 0);
  signal databuf_txd     : std_logic_vector(7 downto 0);
  signal databuf_tx_k    : std_logic;
  signal databuf_tx_ena  : std_logic;
  signal databuf_tx_mode : std_logic := '1';

  signal delay_comp_locked  : std_logic;
  signal delay_comp_update  : std_logic;
  signal delay_comp_value   : std_logic_vector(31 downto 0);


  signal dc_status             : std_logic_vector(31 downto 0);
  signal delay_comp_rx_status : std_logic_vector(31 downto 0);

  signal databuf_dc_addr     : std_logic_vector(10 downto 2);
  signal databuf_dc_data_out : std_logic_vector(31 downto 0);
  signal databuf_dc_size_out : std_logic_vector(31 downto 0);
  signal databuf_sirq_ena    : std_logic_vector(0 to 127);
  signal databuf_rx_flag     : std_logic_vector(0 to 127);
  signal databuf_cs_flag     : std_logic_vector(0 to 127);
  signal databuf_ov_flag     : std_logic_vector(0 to 127);
  signal databuf_clear_flag  : std_logic_vector(0 to 127);
  signal databuf_irq_dc      : std_logic;

  signal debug_out           : std_logic_vector(g_DEBUG_WIDTH-1 downto 0) := (others => '0');
  
  signal transfer_shadow_group_t : transfer_shadow_group_t;
  signal logic_read_data_t       : logic_read_data_t;
  signal logic_return_t          : logic_return_t;

begin

  sys_clk_bufds : IBUFDS
    generic map (
      DIFF_TERM => FALSE,
      IBUF_LOW_PWR => FALSE,
      IOSTANDARD => "LVDS_25")
    port map (
      O   => sys_clk_buf,
      I   => i_ZYNQ_MRCC_LVDS_P,
      IB  => i_ZYNQ_MRCC_LVDS_N);

  sys_clk_buffer : BUFG
    port map (
      O => sys_clk,
      I => sys_clk_buf);

  gt0_ref_clk_bufds : IBUFDS_GTE2
    port map (
      O     => gt0_refclk0,
      ODIV2 => open,
		  CEB   => gnd,
      I     => i_ZYNQ_CLKREF0_P,
      IB    => i_ZYNQ_CLKREF0_N);

  -- Send single-ended clock signal to top-level
  o_GLBL_LOGIC_CLK <= sys_clk;

  i_evr_dc : evr_dc
    generic map (
      RX_POLARITY => '0',
      TX_POLARITY => '0',
      refclksel => '1')
    port map (
      sys_clk => sys_clk,
      refclk_out => refclk,
      event_clk_out => event_clk,

      -- Receiver side connections
      event_rxd => event_rxd,
      dbus_rxd => dbus_rxd,
      databuf_rxd => databuf_rxd,
      databuf_rx_k => databuf_rx_k,
      databuf_rx_ena => databuf_rx_ena,
      databuf_rx_mode => databuf_rx_mode,
      dc_mode => dc_mode,

      rx_link_ok => rx_link_ok,
      rx_violation => rx_violation,
      rx_clear_viol => rx_clear_viol,

      -- Transmitter side connections
      event_txd => event_txd,
      dbus_txd => dbus_txd,
      databuf_txd => databuf_txd,
      databuf_tx_k => databuf_tx_k,
      databuf_tx_ena => databuf_tx_ena,
      databuf_tx_mode => databuf_tx_mode,

      reset => transceiver_reset,

      delay_comp_update => delay_comp_update,
      delay_comp_value => delay_comp_value,
      delay_comp_target => delay_comp_target,
      delay_comp_locked_out => delay_comp_locked,

      i_mgt_ref0clk  => gt0_refclk0,
      i_mgt_ref1clk  => gnd,

      MGTRX2_N => i_EVR_RX_N,
      MGTRX2_P => i_EVR_RX_P,

      MGTTX2_N => o_EVR_TX_N,
      MGTTX2_P => o_EVR_TX_P);

  o_EVR_EVENT_CLK <= event_clk;

  databuf_dc : databuf_rx_dc
    port map (
      data_out => databuf_dc_data_out,
      size_data_out => databuf_dc_size_out,
      addr_in(10 downto 2) => databuf_dc_addr,
      clk => sys_clk,

      databuf_data => databuf_rxd,
      databuf_k => databuf_rx_k,
      databuf_ena => databuf_rx_ena,
      event_clk => event_clk,

      delay_comp_update => delay_comp_update,
      delay_comp_rx => delay_comp_value,
      delay_comp_status => delay_comp_rx_status,
      topology_addr => topology_addr,

      irq_out => databuf_irq_dc,

      sirq_ena => databuf_sirq_ena,
      rx_flag => databuf_rx_flag,
      cs_flag => databuf_cs_flag,
      ov_flag => databuf_ov_flag,
      clear_flag => databuf_clear_flag,

      reset => transceiver_reset);
  
  axi_reg_bank : register_bank_axi
    generic map (    
      AXI_ADDR_WIDTH => ADDRESS_WIDTH+2,
      REG_ADDR_WIDTH	=> ADDRESS_WIDTH,    --! Width of the address signals
      AXI_WSTRB_WIDTH => 4,                  --! Width of the AXI wstrb signal, may be determined by ADDRESS_WIDTH
      REGISTER_WIDTH  => REGISTER_WIDTH,     --! Width of the registers
      AXI_DATA_WIDTH  => AXI4L_DATA_WIDTH)   --! Width of the AXI data signals
    port map (
      --! AXI4-Lite Register interface
      s_axi_aclk     => s_axi_aclk,    
      s_axi_aresetn  => s_axi_aresetn, 
      s_axi_awaddr   => s_axi_awaddr,  
      s_axi_awprot   => s_axi_awprot,  
      s_axi_awvalid  => s_axi_awvalid, 
      s_axi_awready  => s_axi_awready, 
      s_axi_wdata    => s_axi_wdata,   
      s_axi_wstrb    => s_axi_wstrb,   
      s_axi_wvalid   => s_axi_wvalid,  
      s_axi_wready   => s_axi_wready,  
      s_axi_bresp    => s_axi_bresp,   
      s_axi_bvalid   => s_axi_bvalid,  
      s_axi_bready   => s_axi_bready,  
      s_axi_araddr   => s_axi_araddr,  
      s_axi_arprot   => s_axi_arprot, 
      s_axi_arvalid  => s_axi_arvalid, 
      s_axi_arready  => s_axi_arready, 
      s_axi_rdata    => s_axi_rdata,   
      s_axi_rresp    => s_axi_rresp,   
      s_axi_rvalid   => s_axi_rvalid,  
      s_axi_rready   => s_axi_rready,
      
      transfer_shadow_group_i => transfer_shadow_group_t,
      register_data_o         => logic_read_data_t,
      register_return_i       => logic_return_t);


  dbus_txd <= X"00";
  databuf_txd <= X"00";
  databuf_tx_k <= '0';

  -- Reset signal for the Transceiver ---------------

  --! @brief local_clk_scaler: Slow clock from sys_clk (sys_clk/8)
  --!
  --! Generate a low speed clock from the sys clock
  --! sys_clk = 11 ns * 8 = 88 ns period / 50% duty cycle

  local_clk_scaler : process (sys_clk)
    variable scaler : unsigned(2 downto 0) := "000";
  begin
    if rising_edge(sys_clk) then
      if scaler < "100" then
        local_clk <= '1';
      else
        local_clk <= '0';
      end if;

      scaler := scaler + "001";
    end if;
  end process local_clk_scaler;

  --! @brief gtx_reset: local reset generator after GSR
  --!
  --! While a valid reset signal is generated by any element in the PS,
  --! a valid reset signal is needed to drive the reset input of the GT.
  --
  --! Wait for 6 cycles of the local_clk after GSR, then
  --! assert the reset signal for 1 period

  gtx_reset : process (local_clk)
    variable count : unsigned(2 downto 0) := "000";
  begin
    if rising_edge(local_clk) then
      if count <= "101" then
        local_transceiver_reset <= '0';
        count := count + "001";
      elsif count <= "110" then
        local_transceiver_reset <= '1';
        count := count + "001";
      else
        local_transceiver_reset <= '0';
      end if;
    end if;
  end process gtx_reset;

  transceiver_reset <= local_transceiver_reset OR logic_read_data_t.master_reset(0);

  -- Process to send out event 0x01 periodically
  process (refclk)
    variable count : unsigned(31 downto 0) := X"FFFFFFFF";
  begin
    if rising_edge(refclk) then
      event_txd <= X"00";
      if count(26) = '0' then
        event_txd <= X"01";
        count := X"FFFFFFFF";
      end if;
      count := count - 1;
    end if;
  end process;

  --TODO: drive the LEDs from a meaningful source
  o_EVR_LINK_LED <= rx_link_ok;
  o_EVR_EVNT_LED <= '0';

  -- Debug port signal assignment
  o_DEBUG <= event_clk & sys_clk & refclk & rx_link_ok & event_clk;

  -- process (sys_clk)
  --   variable count : std_logic_vector(31 downto 0) := X"FFFFFFFF";
  -- begin
  --   if rising_edge(sys_clk) then
      -- rx_clear_viol <= PL_PB1;
      -- tx_reset <= PL_PB2;
      -- sys_reset <= PL_PB3;
      -- PL_LED1 <= rx_violation;
      -- PL_LED2 <= rx_link_ok;
--      PL_LED3 <= event_rxd(0);
  --     PL_LED4 <= count(25);
  --     count := count - 1;
  --   end if;
  -- end process;

  --  process (event_clk)
  --  begin
  --    if rising_edge(event_clk) then
  --      TRIG0(7 downto 0) <= event_rxd;
  --      TRIG0(15 downto 8) <= dbus_rxd;
  --      TRIG0(23 downto 16) <= databuf_rxd;
  --      TRIG0(24) <= databuf_rx_k;
  --      TRIG0(25) <= databuf_rx_ena;
  --      TRIG0(26) <= databuf_rx_mode;
  --      TRIG0(27) <= rx_link_ok;
  --      TRIG0(28) <= rx_violation;
  --      TRIG0(29) <= rx_clear_viol;
  --      TRIG0(30) <= delay_comp_locked;
  --      TRIG0(31) <= delay_comp_update;
  --      TRIG0(63 downto 32) <= delay_comp_value;
  --      TRIG0(95 downto 64) <= delay_comp_target;
  --      TRIG0(127 downto 96) <= dc_status;
  --      TRIG0(159 downto 128) <= delay_comp_rx_status;
  --      TRIG0(191 downto 160) <= topology_addr;
  --      TRIG0(255 downto 192) <= (others => '0');
  --    end if;
  --  end process;

end rtl;
