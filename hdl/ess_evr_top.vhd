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

library ESS_openEVR_RegMap;
use ESS_openEVR_RegMap.register_bank_config.all;
use ESS_openEVR_RegMap.register_bank_components.all;
use ESS_openEVR_RegMap.register_bank_functions.all;

--!  @brief ess_evr_top: Top entity for the ESS openEVR
entity ess_evr_top is
  Generic (
    g_CARRIER_VER   : string  := "revE";           --! Target carrier board hw revision: revE or revD
    g_DEBUG_WIDTH   : integer := 5;                --! Width of debug port
    g_HAS_DEBUG_CLK : boolean := true;             --! Enable an input for a free running clock to drive ILA cores
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

    --! Global logic clock, LVCMOS input from Si5332 Out2
    i_ZYNQ_MRCC1 : in std_logic;

    --! MGT reference clock 0, differential input from Si5346 Out0
    i_ZYNQ_CLKREF0_P : in std_logic;
    i_ZYNQ_CLKREF0_N : in std_logic;

    --! SFP Tx&Rx lines
    o_EVR_TX_P     : out std_logic;
    o_EVR_TX_N     : out std_logic;
    i_EVR_RX_P     : in std_logic;
    i_EVR_RX_N     : in std_logic;

    --! SFP MOD 0 line (module detected, active-low)
    i_EVR_MOD_0    : in std_logic;

    --! External timestamp request
    i_TS_req   : in  std_logic;
    o_TS_data  : out std_logic_vector(63 downto 0);
    o_TS_valid : out std_logic;

    --! SFP Link LED
    o_EVR_LINK_LED : out std_logic;
    --! SFP Event LED
    o_EVR_EVNT_LED : out std_logic;
    --! EVR event single-ended clock output - 88.0525 MHz
    o_EVR_EVENT_CLK  : out std_logic;
    --! Global logic single-ended clock output - 100 MHz
    o_GLBL_LOGIC_CLK : out std_logic;

    --! Debug port (to connect to fmc-dio-5ch-ttl mezzanine card)
    o_DEBUG          : out std_logic_vector(g_DEBUG_WIDTH-1 downto 0);

    --! Optional input clock to drive the ILA logic
    i_DEBUG_clk      : in std_logic);
end ess_evr_top;

architecture rtl of ess_evr_top is
  attribute keep : string;

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
  --! Single-ended clock from transceiver wrapper
  signal event_clk_se  : std_logic;
  --! Reference clock for the EVR GT - single ended
  signal gt0_refclk0   : std_logic;
  --! Clock for driving debug logic
  signal debug_clk     : std_logic;
  attribute keep of debug_clk : signal is "true";

  --------------- Resets ------------------
  -- Record for the reset signals going to the EVR GT
  signal gt0_resets, gt0_resets_t : gt_resets;
  -- Global reset driven from SW - sys_clk domain
  signal gbl_reset, gbl_reset_t   : std_logic := '0';

  ----------- Module parameters -----------
  --! Delay Compensation Enable
  signal dc_mode : std_logic := '1';
  --! Place in the network topology.
  signal topology_addr      : std_logic_vector(31 downto 0);
  --! Target value for the DC module
  signal delay_comp_target  : std_logic_vector(31 downto 0) := x"02100000";

  signal event_link_ok : std_logic;
  signal gt0_status : gt_ctrl_flags;
  signal evr_ctrl : evr_ctrl_reg;
  signal ts_regs  : ts_regs;

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
  signal int_delay_value    : std_logic_vector(31 downto 0);

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
  -- CTRL & status register map - (32-bit reg @ 0x43c00000)
  --         bit
  -- *        0  ->  Global reset
  -- *        1  ->  EVR GT global reset
  -- *        2  ->  EVR GT Tx path reset
  -- *        3  ->  EVR GT Rx path reset
  -- *        4  ->  GT Tx FSM done
  -- *        5  ->  GT Rx FSM done
  -- *        6  ->  GT feedback clock lost
  -- *        7  ->  GT CPLL locked
  -- *        8  ->  GT Link up
  -- *        9  ->  GT Event received
  signal logic_read_data_t       : logic_read_data_t;
  signal logic_return_t_0        : logic_return_t;
  signal logic_return_t          : logic_return_t;

  -- Timestamp external trigger
  signal ext_ts_trig : std_logic;
  signal ext_ts_trig_t : std_logic;

  attribute mark_debug : string;
  attribute mark_debug of event_rxd : signal is "true";
  attribute mark_debug of ext_ts_trig : signal is "true";
  attribute mark_debug of ext_ts_trig_t : signal is "true";
  attribute mark_debug of debug_out : signal is "true";
  attribute mark_debug of gt0_resets : signal is "true";
  attribute mark_debug of gt0_status : signal is "true";

begin

  sys_clk_difbuf_gen:
  if g_CARRIER_VER = "revD" generate
    sys_clk_bufds : IBUFDS
      generic map (
        DIFF_TERM => FALSE,
        IBUF_LOW_PWR => FALSE,
        IOSTANDARD => "LVDS_25")
      port map (
        O   => sys_clk_buf,
        I   => i_ZYNQ_MRCC_LVDS_P,
        IB  => i_ZYNQ_MRCC_LVDS_N);
  end generate;

  sys_clk_buf_gen:
  if g_CARRIER_VER = "revE" generate
    sys_clk_buf <= i_ZYNQ_MRCC1;
  end generate;

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

  dbg_clk_buffer_gen:
  if g_HAS_DEBUG_CLK = true generate
      dbg_clk_buffer : BUFG
         port map (
          O => debug_clk,
          I => i_DEBUG_clk);
  end generate;

  -- Send single-ended clock signal to top-level
  o_GLBL_LOGIC_CLK <= sys_clk;

  i_evr_dc : evr_dc
    generic map (
      RX_POLARITY => '0',
      TX_POLARITY => '0',
      refclksel => '0')
    port map (
      sys_clk => sys_clk,
      refclk_out => refclk,
      event_clk_out => event_clk,

      i_gt0_resets => gt0_resets,
      o_gt0_status => gt0_status,

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

      delay_comp_update => delay_comp_update,
      delay_comp_value => delay_comp_value,
      delay_comp_target => delay_comp_target,
      delay_comp_locked_out => delay_comp_locked,
      int_delay_value => int_delay_value,

      i_mgt_ref0clk  => gt0_refclk0,
      i_mgt_ref1clk  => '0',

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

      reset => gbl_reset);

  dbus_txd <= X"00";
  databuf_txd <= X"00";
  databuf_tx_k <= '0';

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

  -- Get the reset signals into sys_clk time domain
  -- These are sw resets so it is assumed the pulse width will be long enough.
  -- All signals are double-flopped
  reset_reg : process(sys_clk)
    begin
      if rising_edge(sys_clk) then
        -- reset register write (from processor to FPGA)
        gbl_reset   <= gbl_reset_t;
        gbl_reset_t <= logic_read_data_t.ESSControl(0);
        gt0_resets.gbl_async   <= gt0_resets_t.gbl_async;
        gt0_resets_t.gbl_async <= logic_read_data_t.ESSControl(1) or logic_read_data_t.ESSControl(0);
        gt0_resets.tx_async    <= gt0_resets_t.tx_async;
        gt0_resets_t.tx_async  <= logic_read_data_t.ESSControl(2);
        gt0_resets.rx_async    <= gt0_resets_t.rx_async;
        gt0_resets_t.rx_async  <= logic_read_data_t.ESSControl(3);

      end if;
    end process reset_reg;




   -- Synchronously assign relevant signals to the appropriate registers
   reg_assign : process(sys_clk)
     begin
       if rising_edge(sys_clk) then
         -- register read (from FPGA to processor)
         logic_return_t <= logic_return_t_0;

         -- Reset signals
         -- Read back from FPGA
         logic_return_t_0.ESSControl(3 downto 0) <= logic_read_data_t.ESSControl(3 downto 0);
         logic_return_t_0.ESSControl(4) <= gt0_status.tx_fsm_done;
         logic_return_t_0.ESSControl(5) <= gt0_status.rx_fsm_done;
         logic_return_t_0.ESSControl(6) <= gt0_status.fbclk_lost;
         logic_return_t_0.ESSControl(7) <= gt0_status.pll_locked;
         logic_return_t_0.ESSControl(8) <= gt0_status.link_up;
         logic_return_t_0.ESSControl(9) <= gt0_status.event_rcv;
         logic_return_t_0.ESSControl(REGISTER_WIDTH-1 downto 10) <= (others => '0');


         -- Status reg
         logic_return_t_0.Status(5 downto 0) <= "000000";   -- 
         logic_return_t_0.Status(6) <= gt0_status.link_up;  -- LINK
         logic_return_t_0.Status(7) <= i_EVR_MOD_0;         -- SFPMOD
         logic_return_t_0.Status(31 downto 24) <= dbus_rxd; -- DBUS7-DBUS0

         -- Control reg
         -- Assign from processor
         evr_ctrl.evr_en      <= logic_read_data_t.Control(31);
         evr_ctrl.event_fwd   <= logic_read_data_t.Control(30);
         evr_ctrl.tx_loopback <= logic_read_data_t.Control(29);
         evr_ctrl.rx_loopback <= logic_read_data_t.Control(28);
         evr_ctrl.output_en   <= logic_read_data_t.Control(27);
         evr_ctrl.soft_reset  <= logic_read_data_t.Control(26);
         evr_ctrl.dc_enable   <= logic_read_data_t.Control(22);
         evr_ctrl.ts_dbus     <= logic_read_data_t.Control(14);
         evr_ctrl.rst_ts      <= logic_read_data_t.Control(13);
         evr_ctrl.latch_ts    <= logic_read_data_t.Control(10);
         evr_ctrl.map_en      <= logic_read_data_t.Control(9);
         evr_ctrl.map_rs      <= logic_read_data_t.Control(8);
         evr_ctrl.log_rst     <= logic_read_data_t.Control(7);
         evr_ctrl.log_en      <= logic_read_data_t.Control(6);
         evr_ctrl.log_dis     <= logic_read_data_t.Control(5);
         evr_ctrl.log_se      <= logic_read_data_t.Control(4);
         evr_ctrl.rs_fifo     <= logic_read_data_t.Control(3);
         -- Read back
         logic_return_t_0.Control <= logic_read_data_t.Control;

         -- DC registers
         -- From processor
         delay_comp_target <= logic_read_data_t.DCTarget;
         dc_mode           <= evr_ctrl.dc_enable;
         -- From FPGA
         logic_return_t_0.DCTarget   <= delay_comp_target;
         logic_return_t_0.TopologyID <= topology_addr;
         logic_return_t_0.DCStatus   <= delay_comp_rx_status;
         logic_return_t_0.DCRxValue  <= delay_comp_value;
         logic_return_t_0.DCIntValue <= int_delay_value;

         -- Timestamp registers
         -- From FPGA
         logic_return_t_0.SecSR        <= ts_regs.sec_shift_reg;
         logic_return_t_0.SecCounter   <= ts_regs.sec_counter;
         logic_return_t_0.EventCounter <= ts_regs.event_counter;
         logic_return_t_0.SecLatch     <= ts_regs.sec_latch;
         logic_return_t_0.EvCntLatch   <= ts_regs.event_count_latch;
         logic_return_t_0.EvFIFOSec    <= ts_regs.event_fifo_sec;
         logic_return_t_0.EvFIFOEvCnt  <= ts_regs.event_fifo_cnt;
         logic_return_t_0.EvFIFOCode   <= x"0000" & ts_regs.event_fifo_code;

       end if;
     end process reg_assign;

   -- Instantiate timestamp component
   event_timestamp : timestamp
    port map (
      event_clk    => event_clk,
      event_code   => event_rxd,
      reset        => gbl_reset,
      ts_req       => ext_ts_trig,
      ts_data      => o_TS_data,
      ts_valid     => o_TS_valid,
      evr_ctrl     => evr_ctrl,
      ts_regs      => ts_regs,
      MAP14        => '0',
      buffer_pop   => '1',
      buffer_data  => open,
      buffer_valid => open
    );

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

  -- Bring external trigger pulse signal into event_clk time-domain
  process(event_clk)
  begin
    -- Double flip-flop the incoming signals
    if rising_edge(event_clk) then
      ext_ts_trig_t <= i_TS_req;
      ext_ts_trig   <= ext_ts_trig_t;
    end if;
  end process;

  o_EVR_LINK_LED <= gt0_status.link_up;
  o_EVR_EVNT_LED <= gt0_status.event_rcv;

  -- Debug port signal assignment
  o_DEBUG <= event_clk & sys_clk & refclk & rx_link_ok & event_clk;

end rtl;
