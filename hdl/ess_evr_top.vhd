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
--! @version 0.6
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
use work.sizing.all;

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
    g_HAS_DEBUG_CLK : boolean := true;             --! Enable an input for a free running clock to drive ILA cores
    AXI_ADDR_WIDTH  : integer := ADDRESS_WIDTH+2;
    REG_ADDR_WIDTH  : integer := ADDRESS_WIDTH;    --! Width of the address signals
    AXI_WSTRB_WIDTH : integer := 4;                --! Width of the AXI wstrb signal, may be determined by ADDRESS_WIDTH
    REGISTER_WIDTH  : integer := REGISTER_WIDTH;   --! Width of the registers
    AXI_DATA_WIDTH  : integer := AXI4L_DATA_WIDTH; --! Width of the AXI data signals
    FP_IN_CHANNELS  : integer := 2;                --! Front Panel Input channels
    FP_OUT_CHANNELS : integer := 2                 --! Front Panel Output channels
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

    --!@name Event mapping RAM interface
    --!@brief Signals for the control of 2 external BRAM blocks used as event mapping RAMs
    --!@desc Only one BRAM block is active at a time, thus most of the lines can be
    --!       shared to save some resources. Only the enable lines are specific to a BRAM block.
    --!@{
    --! Address port (shared)
    o_evnt_map_addr    : out std_logic_vector(c_EVNT_MAP_ADDR_WIDTH-1 downto 0);
    --! Data out port (shared)
    o_evnt_map_data    : out std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0);
    --! Data in port (shared)
    i_evnt_map_data    : in  std_logic_vector(c_EVNT_MAP_DATA_WIDTH-1 downto 0);
    --! Write enable port (shared)
    o_evnt_map_wren    : out std_logic;
    --! Enable line for the Block RAM 0
    o_evnt_map0_en     : out std_logic;
    --! Enable line for the Block RAM 1
    o_evnt_map1_en     : out std_logic;
    --!@}


    --! Global logic clock, differential input from Si5346 Out2
    i_ZYNQ_MRCC_LVDS_P : in std_logic;
    i_ZYNQ_MRCC_LVDS_N : in std_logic;

    --! Global logic clock, LVCMOS input from Si5332 Out2
    i_ZYNQ_MRCC1 : in std_logic;

    --! MGT reference clock 0, differential input from Si5346 Out0
    i_ZYNQ_CLKREF0_P : in std_logic;
    i_ZYNQ_CLKREF0_N : in std_logic;

    -- OpenEVR SFP interface --------------------------------------------------

    --! SFP Tx&Rx lines
    o_EVR_TX_P        : out std_logic;
    o_EVR_TX_N        : out std_logic;
    i_EVR_RX_P        : in std_logic;
    i_EVR_RX_N        : in std_logic;

    --! SFP Link LED
    o_EVR_LINK_LED    : out std_logic;
    --! SFP Event LED
    o_EVR_EVNT_LED    : out std_logic;

    --! Tx disable
    o_EVR_TX_DISABLE  : out std_logic;
    --! Tx fault flag
    i_EVR_TX_FAULT    : in std_logic;
    --! Rx signal lost
    i_EVR_RX_LOS      : in std_logic;
    --! SFP MOD 0 line (module detected, active-low)
    i_EVR_MOD_0       : in std_logic;

    -- MRF Universal Module interface -----------------------------------------
    o_MRF_UNIVMOD_OUT0 : out std_logic;
    o_MRF_UNIVMOD_OUT1 : out std_logic;
    i_MRF_UNIVMOD_IN0  : in std_logic;
    i_MRF_UNIVMOD_IN1  : in std_logic;

    -- Front Panel I/O --------------------------------------------------------
    o_FP_OUT  : out std_logic_vector(FP_OUT_CHANNELS-1 downto 0);
    i_FP_IN   : in std_logic_vector(FP_IN_CHANNELS-1 downto 0);

    --! External timestamp request
    i_TS_req   : in  std_logic;
    o_TS_data  : out std_logic_vector(63 downto 0);
    o_TS_valid : out std_logic;

    --! EVR event single-ended clock output - 88.0525 MHz
    o_EVR_EVENT_CLK  : out std_logic;

    --! Optional input clock to drive the ILA logic
    i_DEBUG_clk      : in std_logic);
end ess_evr_top;

architecture rtl of ess_evr_top is
  --attribute keep : string;
  attribute mark_debug : string;

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

  --------------- Resets ------------------
  -- Record for the reset signals going to the EVR GT
  signal gt0_resets, gt0_resets_t : gt_resets;
  -- Global reset driven from SW for all the EVR logic
  signal gbl_evr_rst, gbl_reset_0, gbl_reset_t   : std_logic := '0';

  ----------- Module parameters -----------
  --! Delay Compensation Enable
  signal dc_mode, dc_mode_r, dc_mode_0 : std_logic := '1';
  --! Place in the network topology.
  signal topology_addr      : std_logic_vector(31 downto 0);
  --! Target value for the DC module
  signal delay_comp_target  : std_logic_vector(31 downto 0) := x"02100000";

  --! Target event for the heartbeat monitor
  --! TODO: assign from the mapping RAM
  signal hb_mon_target : event_code := x"7A";

  --------  IRQ related signals -----------

  --! Interrupt line coming from the Hearbeat monitor
  signal heartbeat_mon_int : std_logic;
  attribute mark_debug of heartbeat_mon_int : signal is "true";
  signal hb_mon_cnt : unsigned(c_HEARTBEAT_CNT_SIZE-1 downto 0);
  attribute mark_debug of hb_mon_cnt : signal is "true";

  ------------ Pulse generators -----------
  --! Array to hold the control register of each instance of pulse generator
  signal pulse_gen_ctrl_reg : pgen_ctrl_regs;
  signal pulse_gen_map_reg  : pgen_map_reg;
  signal pulse_gen_pxout    : std_logic_vector(c_PULSE_GENS_CNT-1 downto 0);

  signal event_link_ok : std_logic;
  signal gt0_status : gt_ctrl_flags;
  signal evr_ctrl : evr_ctrl_reg;
  signal ts_regs  : ts_regs;

  signal event_rxd       : std_logic_vector(7 downto 0);
  attribute mark_debug of event_rxd : signal is "true";
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

  signal ext_trig_ts_data    : std_logic_vector(63 downto 0);
  signal ext_trig_ts_valid   : std_logic;

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

  -- OpenEVR SFP signals

  -- Front Panel I/O ----------------------------------------------------------
  type fp_map is array (0 to FP_OUT_CHANNELS-1) of std_logic_vector(15 downto 0);
  signal fp_out_map : fp_map := (others => x"003F"); -- Default to Low
  attribute mark_debug of fp_out_map : signal is "true";
  signal evr_tx_dis : std_logic := '0';

  -- MRF Universal Module interface signals -----------------------------------
  signal univ_out : std_logic_vector (1 downto 0) := "00";
  -- Only one UNIV I/O socket, which supports up to 2 channels
  type fp_univ_map is array (0 to 1) of std_logic_vector(15 downto 0);
  signal fp_univ_out_map : fp_univ_map := (others => x"003F"); -- Default to Low
  attribute mark_debug of fp_univ_out_map : signal is "true";
  signal mrfunivmod_in0 : std_logic := '0';
  signal mrfunivmod_in1 : std_logic := '0';
  -- attribute mark_debug of mrfunivmod_in0 : signal is "true";
  -- attribute mark_debug of mrfunivmod_in1 : signal is "true";
  --
  -- attribute mark_debug of event_rxd : signal is "true";
  -- attribute mark_debug of ext_ts_trig : signal is "true";
  -- attribute mark_debug of ext_ts_trig_t : signal is "true";


  component standalone is
    generic (
        g_PRESCALER_SIZE : natural := bit_size(c_EVENT_RATE)
    );
    port (
        i_gt_refclk : in std_logic;

        o_event_tx  : out std_logic_vector(7 downto 0)
    );
  end component;

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

  -- Driven low - no foreseen use-case to dynamically change this line
  o_EVR_TX_DISABLE <= evr_tx_dis;

  systoeventclk : process(event_clk)
    begin
      if rising_edge(event_clk) then
        dc_mode_0     <= dc_mode_r;
        ext_ts_trig_t <= i_TS_req;
        gbl_reset_0   <= not gt0_status.link_up;

        dc_mode       <= dc_mode_0;
        ext_ts_trig   <= ext_ts_trig_t;
        gbl_evr_rst   <= gbl_reset_0;

      end if;
    end process systoeventclk;

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

  i_standalone : standalone
    port map (
      i_gt_refclk   => refclk,
      o_event_tx    => event_txd
    );

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

      reset => gbl_evr_rst);

  dbus_txd <= X"00";
  databuf_txd <= X"00";
  databuf_tx_k <= '0';

  i_heartbeat_mon : heartbeat_mon
    generic map (
      g_PRESCALER_SIZE => bit_size(c_HEARTBEAT_TIMEOUT)
    )
    port map (
      i_ref_clk           => refclk,
      i_reset             => gt0_resets.gbl_async,
      i_event_rxd         => event_rxd,
      i_target_evnt       => hb_mon_target,
      o_heartbeat_ov      => heartbeat_mon_int,
      o_heartbeat_ov_cnt  => hb_mon_cnt
    );
 
  -- TODO (ROSS) : connect this line
  -- <hb irq line> <= heartbeat_mon_int and evr_irqen.iehb and evr_irqen.irqen;

  i_pulse_gen_controller : pulse_gen_controller
    generic map (
      g_PULSE_GEN_CNT => c_PULSE_GENS_CNT
    )
    port map (
      i_event_clk     => i_event_clk,         -- The event_clock is down when no link is present, is this a problem?
      i_pgen_ctrl_reg => pulse_gen_ctrl_reg,
      i_pgen_map_reg  => pulse_gen_map_reg,
      o_pgen_pxout    => pulse_gen_pxout
    );

  -- AXI register interface for the picoEVR ----------------------------------

  axi_reg_bank : register_bank_axi
    generic map (
      AXI_ADDR_WIDTH => ADDRESS_WIDTH+2,
      REG_ADDR_WIDTH	=> ADDRESS_WIDTH,    --! Width of the address signals
      AXI_WSTRB_WIDTH => 4,                --! Width of the AXI wstrb signal, may be determined by ADDRESS_WIDTH
      REGISTER_WIDTH  => REGISTER_WIDTH,   --! Width of the registers
      AXI_DATA_WIDTH  => AXI4L_DATA_WIDTH) --! Width of the AXI data signals
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

  -- Synchronously assign relevant signals to the appropriate registers
  reg_assign : process(sys_clk)
    begin
      if rising_edge(sys_clk) then
        -- ESS-Control register 0xB004
        -- from processor to FPGA
        -- gbl_evr_rst              <= gbl_reset_t;
        -- -- FROM bit 0 to 30 - check if the net improves
        -- gbl_reset_t            <= logic_read_data_t.ESSControl(30);
        gt0_resets.gbl_async   <= gt0_resets_t.gbl_async;
        gt0_resets_t.gbl_async <= logic_read_data_t.ESSControl(1) or logic_read_data_t.ESSControl(0);
        gt0_resets.tx_async    <= gt0_resets_t.tx_async;
        gt0_resets_t.tx_async  <= logic_read_data_t.ESSControl(2);
        gt0_resets.rx_async    <= gt0_resets_t.rx_async;
        gt0_resets_t.rx_async  <= logic_read_data_t.ESSControl(3);
        -- Read back from FPGA
        logic_return_t_0.ESSControl(3 downto 0) <= logic_read_data_t.ESSControl(3 downto 0);
        logic_return_t_0.ESSControl(REGISTER_WIDTH-1 downto 4) <= (others => '0');
        -- Temporally assigned here
        logic_return_t_0.ESSControl(31) <= logic_read_data_t.ESSControl(31);

        -- ESS-Status register - 0xB000
        logic_return_t_0.ESSStatus(0)  <= gt0_status.tx_fsm_done;
        logic_return_t_0.ESSStatus(1)  <= gt0_status.rx_fsm_done;
        logic_return_t_0.ESSStatus(2)  <= gt0_status.fbclk_lost;
        logic_return_t_0.ESSStatus(3)  <= gt0_status.pll_locked;
        logic_return_t_0.ESSStatus(4)  <= i_EVR_TX_FAULT;
        logic_return_t_0.ESSStatus(5)  <= gt0_status.link_up;
        logic_return_t_0.ESSStatus(6)  <= i_EVR_RX_LOS;
        logic_return_t_0.ESSStatus(7)  <= gt0_status.event_rcv;
        logic_return_t_0.ESSStatus(30) <= mrfunivmod_in0;
        logic_return_t_0.ESSStatus(31) <= mrfunivmod_in1;

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
        dc_mode_r         <= evr_ctrl.dc_enable;
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

        -- External trigger timestamp
        -- From FPGA
        logic_return_t_0.ESSExtSecCounter   <= ext_trig_ts_data(63 downto 32);
        logic_return_t_0.ESSExtEventCounter <= ext_trig_ts_data(31 downto 0);

        -- Pulse generators -- 16 by now
        -- From processor
        pulse_gen_ctrl_reg(0).control(6 downto 0)  <= logic_read_data_t.Pulse0Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(0).delay    <= logic_read_data_t.Pulse0Delay;
        pulse_gen_ctrl_reg(0).width    <= logic_read_data_t.Pulse0Width;
        pulse_gen_ctrl_reg(1).control(6 downto 0)  <= logic_read_data_t.Pulse1Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(1).delay    <= logic_read_data_t.Pulse1Delay;
        pulse_gen_ctrl_reg(1).width    <= logic_read_data_t.Pulse1Width;
        pulse_gen_ctrl_reg(2).control(6 downto 0)  <= logic_read_data_t.Pulse2Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(2).delay    <= logic_read_data_t.Pulse2Delay;
        pulse_gen_ctrl_reg(2).width    <= logic_read_data_t.Pulse2Width;
        pulse_gen_ctrl_reg(3).control(6 downto 0)  <= logic_read_data_t.Pulse3Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(3).delay    <= logic_read_data_t.Pulse3Delay;
        pulse_gen_ctrl_reg(3).width    <= logic_read_data_t.Pulse3Width;

        pulse_gen_ctrl_reg(4).control(6 downto 0)  <= logic_read_data_t.Pulse4Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(4).delay    <= logic_read_data_t.Pulse4Delay;
        pulse_gen_ctrl_reg(4).width    <= logic_read_data_t.Pulse4Width;
        pulse_gen_ctrl_reg(5).control(6 downto 0)  <= logic_read_data_t.Pulse5Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(5).delay    <= logic_read_data_t.Pulse5Delay;
        pulse_gen_ctrl_reg(5).width    <= logic_read_data_t.Pulse5Width;
        pulse_gen_ctrl_reg(6).control(6 downto 0)  <= logic_read_data_t.Pulse6Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(6).delay    <= logic_read_data_t.Pulse6Delay;
        pulse_gen_ctrl_reg(6).width    <= logic_read_data_t.Pulse6Width;
        pulse_gen_ctrl_reg(7).control(6 downto 0)  <= logic_read_data_t.Pulse7Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(7).delay    <= logic_read_data_t.Pulse7Delay;
        pulse_gen_ctrl_reg(7).width    <= logic_read_data_t.Pulse7Width;

        pulse_gen_ctrl_reg(8).control(6 downto 0)  <= logic_read_data_t.Pulse8Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(8).delay    <= logic_read_data_t.Pulse8Delay;
        pulse_gen_ctrl_reg(8).width    <= logic_read_data_t.Pulse8Width;
        pulse_gen_ctrl_reg(9).control(6 downto 0)  <= logic_read_data_t.Pulse9Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(9).delay    <= logic_read_data_t.Pulse9Delay;
        pulse_gen_ctrl_reg(9).width    <= logic_read_data_t.Pulse9Width;
        pulse_gen_ctrl_reg(10).control(6 downto 0) <= logic_read_data_t.Pulse10Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(10).delay   <= logic_read_data_t.Pulse10Delay;
        pulse_gen_ctrl_reg(10).width   <= logic_read_data_t.Pulse10Width;
        pulse_gen_ctrl_reg(11).control(6 downto 0) <= logic_read_data_t.Pulse11Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(11).delay   <= logic_read_data_t.Pulse11Delay;
        pulse_gen_ctrl_reg(11).width   <= logic_read_data_t.Pulse11Width;

        pulse_gen_ctrl_reg(12).control(6 downto 0) <= logic_read_data_t.Pulse12Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(12).delay   <= logic_read_data_t.Pulse12Delay;
        pulse_gen_ctrl_reg(12).width   <= logic_read_data_t.Pulse132Width;
        pulse_gen_ctrl_reg(13).control(6 downto 0) <= logic_read_data_t.Pulse13Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(13).delay   <= logic_read_data_t.Pulse13Delay;
        pulse_gen_ctrl_reg(13).width   <= logic_read_data_t.Pulse14Width;
        pulse_gen_ctrl_reg(14).control(6 downto 0) <= logic_read_data_t.Pulse14Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(14).delay   <= logic_read_data_t.Pulse14Delay;
        pulse_gen_ctrl_reg(14).width   <= logic_read_data_t.Pulse1Width;
        pulse_gen_ctrl_reg(15).control(6 downto 0) <= logic_read_data_t.Pulse15Ctrl(6 downto 0);
        pulse_gen_ctrl_reg(15).delay   <= logic_read_data_t.Pulse15Delay;
        pulse_gen_ctrl_reg(15).width   <= logic_read_data_t.Pulse15Width;

        -- Read back
        logic_return_t_0.Pulse0Ctrl   <= x"0000" & pgen_pxout(0) & logic_read_data_t.Pulse0Ctrl(6 downto 0);
        logic_return_t_0.Pulse0Delay  <= logic_read_data_t.Pulse0Delay;
        logic_return_t_0.Pulse0Width  <= logic_read_data_t.Pulse0Width;
        logic_return_t_0.Pulse1Ctrl   <= x"0000" & pgen_pxout(1) & logic_read_data_t.Pulse1Ctrl(6 downto 0);
        logic_return_t_0.Pulse1Delay  <= logic_read_data_t.Pulse1Delay;
        logic_return_t_0.Pulse1Width  <= logic_read_data_t.Pulse1Width;
        logic_return_t_0.Pulse2Ctrl   <= x"0000" & pgen_pxout(2) & logic_read_data_t.Pulse2Ctrl(6 downto 0);
        logic_return_t_0.Pulse2Delay  <= logic_read_data_t.Pulse2Delay;
        logic_return_t_0.Pulse2Width  <= logic_read_data_t.Pulse2Width;
        logic_return_t_0.Pulse3Ctrl   <= x"0000" & pgen_pxout(3) & logic_read_data_t.Pulse3Ctrl(6 downto 0);
        logic_return_t_0.Pulse3Delay  <= logic_read_data_t.Pulse3Delay;
        logic_return_t_0.Pulse3Width  <= logic_read_data_t.Pulse3Width;

        logic_return_t_0.Pulse4Ctrl   <= x"0000" & pgen_pxout(4) & logic_read_data_t.Pulse4Ctrl(6 downto 0);
        logic_return_t_0.Pulse4Delay  <= logic_read_data_t.Pulse4Delay;
        logic_return_t_0.Pulse4Width  <= logic_read_data_t.Pulse4Width;
        logic_return_t_0.Pulse5Ctrl   <= x"0000" & pgen_pxout(5) & logic_read_data_t.Pulse5Ctrl(6 downto 0);
        logic_return_t_0.Pulse5Delay  <= logic_read_data_t.Pulse5Delay;
        logic_return_t_0.Pulse5Width  <= logic_read_data_t.Pulse5Width;
        logic_return_t_0.Pulse6Ctrl   <= x"0000" & pgen_pxout(6) & logic_read_data_t.Pulse6Ctrl(6 downto 0);
        logic_return_t_0.Pulse6Delay  <= logic_read_data_t.Pulse6Delay;
        logic_return_t_0.Pulse6Width  <= logic_read_data_t.Pulse6Width;
        logic_return_t_0.Pulse7Ctrl   <= x"0000" & pgen_pxout(7) & logic_read_data_t.Pulse7Ctrl(6 downto 0);
        logic_return_t_0.Pulse7Delay  <= logic_read_data_t.Pulse7Delay;
        logic_return_t_0.Pulse7Width  <= logic_read_data_t.Pulse7Width;

        logic_return_t_0.Pulse8Ctrl   <= x"0000" & pgen_pxout(8) & logic_read_data_t.Pulse8Ctrl(6 downto 0);
        logic_return_t_0.Pulse8Delay  <= logic_read_data_t.Pulse8Delay;
        logic_return_t_0.Pulse8Width  <= logic_read_data_t.Pulse8Width;
        logic_return_t_0.Pulse9Ctrl   <= x"0000" & pgen_pxout(9) & logic_read_data_t.Pulse9Ctrl(6 downto 0);
        logic_return_t_0.Pulse9Delay  <= logic_read_data_t.Pulse9Delay;
        logic_return_t_0.Pulse9Width  <= logic_read_data_t.Pulse9Width;
        logic_return_t_0.Pulse10Ctrl   <= x"0000" & pgen_pxout(10) & logic_read_data_t.Pulse10Ctrl(6 downto 0);
        logic_return_t_0.Pulse10Delay <= logic_read_data_t.Pulse10Delay;
        logic_return_t_0.Pulse10Width <= logic_read_data_t.Pulse10Width;
        logic_return_t_0.Pulse11Ctrl   <= x"0000" & pgen_pxout(11) & logic_read_data_t.Pulse11Ctrl(6 downto 0);
        logic_return_t_0.Pulse11Delay <= logic_read_data_t.Pulse11Delay;
        logic_return_t_0.Pulse11Width <= logic_read_data_t.Pulse11Width;

        logic_return_t_0.Pulse12Ctrl   <= x"0000" & pgen_pxout(12) & logic_read_data_t.Pulse12Ctrl(6 downto 0);
        logic_return_t_0.Pulse12Delay <= logic_read_data_t.Pulse12Delay;
        logic_return_t_0.Pulse12Width <= logic_read_data_t.Pulse12Width;
        logic_return_t_0.Pulse13Ctrl   <= x"0000" & pgen_pxout(13) & logic_read_data_t.Pulse13Ctrl(6 downto 0);
        logic_return_t_0.Pulse13Delay <= logic_read_data_t.Pulse13Delay;
        logic_return_t_0.Pulse13Width <= logic_read_data_t.Pulse13Width;
        logic_return_t_0.Pulse14Ctrl   <= x"0000" & pgen_pxout(14) & logic_read_data_t.Pulse14Ctrl(6 downto 0);
        logic_return_t_0.Pulse14Delay <= logic_read_data_t.Pulse14Delay;
        logic_return_t_0.Pulse14Width <= logic_read_data_t.Pulse14Width;
        logic_return_t_0.Pulse15Ctrl   <= x"0000" & pgen_pxout(15) & logic_read_data_t.Pulse15Ctrl(6 downto 0);
        logic_return_t_0.Pulse15Delay <= logic_read_data_t.Pulse15Delay;
        logic_return_t_0.Pulse15Width <= logic_read_data_t.Pulse15Width;

        -- Front Panel registers
        -- From processor
        fp_out_map(0) <= logic_read_data_t.FPOutMap0_1(15 downto 0);
        fp_out_map(1) <= logic_read_data_t.FPOutMap0_1(31 downto 16);

        fp_univ_out_map(0) <= logic_read_data_t.UnivOUTMap0_1(15 downto 0);
        fp_univ_out_map(1) <= logic_read_data_t.UnivOUTMap0_1(31 downto 16);

        -- Read back
        logic_return_t_0.FPOutMap0_1 <= logic_read_data_t.FPOutMap0_1;
        logic_return_t_0.UnivOUTMap0_1 <= logic_read_data_t.UnivOUTMap0_1;

        -- register read (from FPGA to processor)
        logic_return_t <= logic_return_t_0;
      end if;
    end process reg_assign;

   -- Instantiate timestamp component
   event_timestamp : timestamp
    port map (
      event_clk    => event_clk,
      event_code   => event_rxd,
      reset        => gbl_evr_rst,
      ts_req       => ext_ts_trig,
      ts_data      => ext_trig_ts_data,
      ts_valid     => ext_trig_ts_valid,
      evr_ctrl     => evr_ctrl,
      ts_regs      => ts_regs,
      MAP14        => '0',
      buffer_pop   => '1',
      buffer_data  => open,
      buffer_valid => open
    );

  o_TS_data  <= ext_trig_ts_data;
  o_TS_valid <= ext_trig_ts_valid;

  -- Generate slow signals for the status LEDs --------------------------------
  evr_event_led : process(event_clk)
    variable counter : natural range 0 to 32 := 0;
    variable counting : std_logic := '0';
    begin
      if rising_edge(event_clk) then
        -- A new event was received
        if counting = '0' and gt0_status.event_rcv = '1' then
          counting := '1';
        -- ~150 ns should be enough to see the LED
        elsif counting = '1' and counter = 15 then
          counting := '0';
          counter  := 0;
        elsif counting = '1' then
          counter := counter + 1;
        end if;

        o_EVR_EVNT_LED <= counting;
      end if;
    end process evr_event_led;

  -- HIGH when the EVR link is up and no errors were detected
  o_EVR_LINK_LED <= gt0_status.link_up;


  -- MRF Universal Module interface -------------------------------------------

  -- There're different lines for inputs and outputs but it isn't clear if the
  -- output lines are allowed to drive signals in case an input module is
  -- installed. To avoid electrical issues, these lines are safely hold in
  -- high Z when the installed module is a MRF Universal Input module.

  -- Only one UNIV Module socket - up to 2 channels
  univ_omapping : for I in 0 to 1 generate
    with fp_univ_out_map(I) select
    univ_out(I) <=  pulse_gen_pxout(0)    when x"0000", -- Up to 16 pulse generators in the default configuration of the picoEVR
                    pulse_gen_pxout(1)    when x"0001",
                    pulse_gen_pxout(2)    when x"0002",
                    pulse_gen_pxout(3)    when x"0003",
                    pulse_gen_pxout(4)    when x"0004",
                    pulse_gen_pxout(5)    when x"0005",
                    pulse_gen_pxout(6)    when x"0006",
                    pulse_gen_pxout(7)    when x"0007",
                    pulse_gen_pxout(8)    when x"0008",
                    pulse_gen_pxout(9)    when x"0009",
                    pulse_gen_pxout(10)   when x"000A",
                    pulse_gen_pxout(11)   when x"000B",
                    pulse_gen_pxout(12)   when x"000C",
                    pulse_gen_pxout(13)   when x"000D",
                    pulse_gen_pxout(14)   when x"000E",
                    pulse_gen_pxout(15)   when x"000F",
                    pulse_gen_pxout(16)   when x"0010",
                    event_clk             when x"003B",
                   '1'                    when x"003E",
                   '0'                    when x"003F",
                   '0'                    when others;
  end generate;

  o_MRF_UNIVMOD_OUT0 <= univ_out(0);
  o_MRF_UNIVMOD_OUT1 <= univ_out(1);

  mrfunivmod_in0 <= i_MRF_UNIVMOD_IN0;
  mrfunivmod_in1 <= i_MRF_UNIVMOD_IN1;

  -- Fron Panel I/O -----------------------------------------------------------

 -- Mapping of internal resources to FP Output channels
  -- Mapping is available at MRF's Event System with Delay Compensation
  -- Technical Reference (p. 62)
  fp_omapping : for I in 0 to FP_OUT_CHANNELS-1 generate
    with fp_out_map(I) select
    o_FP_OUT(I) <= event_clk          when x"003B",
                   '1'                when x"003E",
                   '0'                when x"003F",
                   '0'                when others;
  end generate;


end rtl;
