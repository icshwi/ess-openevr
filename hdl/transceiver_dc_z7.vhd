-- =============================================================================
--! @file   transceiver_dc_k7.vhd
--! @brief  MGT wrapper for the openEVR
-- -----------------------------------------------------------------------------
--! @author Ross Elliot <ross.elliot@ess.eu>
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--! @company European Spallation Source ERIC
--! @date 20200515
--! @version 0.1
--
-- Platform: picoZED 7030
-- Carrier board:  Tallinn picoZED carrier board (aka FPGA-based IOC) rev. B
-- Based on the AVNET xdc file for the picozed 7z030 RevC v2
-- -----------------------------------------------------------------------------
--! @details
--     Vaguely based in the GT wrapper available in the MRF's openEVR project.
--
--------------------------------------------------------------------------------
--! @references
--  -# [1]: 7 Series FFPGAS GTX/GTH Transceivers User Gude (UG476)
--------------------------------------------------------------------------------
--! @copyright
--      Copyright (C) 2019- 2020 European Spallation Source ERIC
--
--      This program is free software: you can redistribute it and/or modify
--      it under the terms of the GNU General Public License as published by
--      the Free Software Foundation, either version 3 of the License, or
--      (at your option) any later version.
--
--      This program is distributed in the hope that it will be useful,
--      but WITHOUT ANY WARRANTY; without even the implied warranty of
--      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--      GNU General Public License for more details.
--
--      You should have received a copy of the GNU General Public License
--      along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- =============================================================================

-- TODO: Change to NUMERIC_STD
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.evr_pkg.all;

library unisim;
use unisim.vcomponents.ALL;

entity evr_gtx_phy_z7 is
  generic
  (
    g_SIM_GTRESET_SPEEDUP : string  := "TRUE";
    g_STABLE_CLOCK_PERIOD : integer := 10;
    g_EVENT_CODE_WIDTH    : integer := 8;
    g_DBUS_WORD_WIDTH     : integer := 8;
    g_DATABUF_WORD_WIDTH  : integer := 8
  );
  port (
    --!@name GT Clocks
    --!@{

    --! System clock - 100 MHz (From PLL Si5346 Out2)
    i_sys_clk       : in std_logic;
    --! Reference clock for the GTX (single ended) - 88.0525 MHz
    i_ref0_clk      : in std_logic;
    --! Reference clock for the GTX (single ended)
    i_ref1_clk      : in std_logic;
    --! Tx clock for the synchronous transmission logic
    o_refclock      : out std_logic;
    --! Rx clock - recovered from upstream node in the network
    o_rxclock       : out std_logic;
    --! Event clock - phase shifted by DCM
    i_evntclk_delay : in std_logic;
    --!@}

    --! Transceiver reset
    reset           : in    std_logic;

    --!@name Receiver side connections
    --!@{

    --! RX event code output
    event_rxd       : out std_logic_vector(g_EVENT_CODE_WIDTH-1 downto 0);
    --! RX distributed bus bits
    dbus_rxd        : out std_logic_vector(g_DBUS_WORD_WIDTH-1 downto 0);
    --! RX data buffer data
    databuf_rxd     : out std_logic_vector(g_DATABUF_WORD_WIDTH-1 downto 0);
    --! RX data buffer K-character flag
    databuf_rx_k    : out std_logic;
    --! RX data buffer data enable
    databuf_rx_ena  : out std_logic;
    --! RX data buffer mode, must be '1' - enabled for delay compensation mode
    databuf_rx_mode : in std_logic;
    --! RX link OK
    rx_link_ok      : out   std_logic;
    --! RX violation detected
    rx_violation    : out   std_logic;
    --! Clear RX violation
    rx_clear_viol   : in    std_logic;
    --! Received DC beacon after DC FIFO
    rx_int_beacon   : out   std_logic;
    --!@}

    --!@name Delay compensation
    --!{@

    --! Delay Compensation mode enabled when '1'
    dc_mode         : in std_logic;
    --! Insert extra event in FIFO
    delay_inc       : in    std_logic;
    --! Drop event from FIFO
    delay_dec       : in    std_logic;
    --!@}

    --! Transmitter side connections
    --! TX event code
    event_txd       : in  std_logic_vector(7 downto 0);
    tx_event_ena    : out std_logic; -- 1 when event is sent out
                                     -- With backward events the beacon event
                                     -- has highest priority
    dbus_txd        : in  std_logic_vector(7 downto 0); -- TX distributed bus data
    databuf_txd     : in  std_logic_vector(7 downto 0); -- TX data buffer data
    databuf_tx_k    : in  std_logic; -- TX data buffer K-character
    databuf_tx_ena  : out std_logic; -- TX data buffer data enable
    databuf_tx_mode : in  std_logic; -- TX data buffer mode enabled when '1'
    --! Transmitted DC beacon
    tx_beacon       : out   std_logic;

    --!@name SFP lines
    --@{
    i_rx_n          : in    std_logic;
    i_rx_p          : in    std_logic;
    o_tx_n          : out   std_logic;
    o_tx_p          : out   std_logic
    --!@}
    );
end evr_gtx_phy_z7;

architecture structure of evr_gtx_phy_z7 is

  -- Common constant values
  constant vcc       : std_logic := '1';
  constant gnd       : std_logic := '0';
  constant gnd_32b   : std_logic_vector(31 downto 0) := (others => '0');
  constant c_gnd_64b : std_logic_vector(63 downto 0) := (others => '0');

  -- GT0 related signals
  -- Clocks
  signal refclk        : std_logic;
  signal gt0_rxoutclk  : std_logic;
  signal gt0_txoutclk  : std_logic;

  -- Resets
  signal i_gt0_tx_async_rst : std_logic;
  signal i_gt0_rx_async_rst : std_logic;

  signal rx_charisk    : std_logic_vector(1 downto 0);
  signal rx_data       : std_logic_vector(15 downto 0);
  signal rx_disperr    : std_logic_vector(1 downto 0);
  signal rx_notintable : std_logic_vector(1 downto 0);
  signal rx_beacon_i   : std_logic;
  signal rx_beacon     : std_logic;
  signal gt0_rxclk      : std_logic;
  signal gt0_txclk      : std_logic;
  signal rxcdrreset    : std_logic;

  signal link_ok         : std_logic;
  signal align_error     : std_logic;
  signal rx_error        : std_logic;
  signal rx_int_beacon_i : std_logic;
  signal rx_vio_usrclk   : std_logic;

  signal rx_link_ok_i    : std_logic;
  signal rx_error_i      : std_logic;

  signal tx_charisk    : std_logic_vector(1 downto 0);
  signal tx_data       : std_logic_vector(15 downto 0);

  signal databuf_rxd_i : std_logic_vector(7 downto 0);
  signal databuf_rx_k_i    : std_logic;

  signal fifo_do       : std_logic_vector(63 downto 0);
  signal fifo_dop      : std_logic_vector(7 downto 0);
  signal fifo_rden     : std_logic;
  signal fifo_rst      : std_logic;
  signal fifo_wren     : std_logic;
  signal fifo_di       : std_logic_vector(63 downto 0);
  signal fifo_dip      : std_logic_vector(7 downto 0);

  signal tx_fifo_do    : std_logic_vector(31 downto 0);
  signal tx_fifo_dop   : std_logic_vector(3 downto 0);
  signal tx_fifo_rden  : std_logic;
  signal tx_fifo_rderr : std_logic;
  signal tx_fifo_empty : std_logic;
  signal tx_fifo_rst   : std_logic;
  signal tx_fifo_wren  : std_logic;
  signal tx_fifo_di    : std_logic_vector(31 downto 0);
  signal tx_fifo_dip   : std_logic_vector(3 downto 0);

  signal tx_event_ena_i : std_logic;

  -- RX Datapath signals
  signal rxdata_i                         :   std_logic_vector(63 downto 0);
  signal rxcharisk_float_i                :   std_logic_vector(5 downto 0);
  signal rxdisperr_float_i                :   std_logic_vector(7 downto 0);
  signal rxnotintable_float_i             :   std_logic_vector(5 downto 0);

  -- TX Datapath signals
  signal txdata_i                         :   std_logic_vector(63 downto 0);
  signal txbufstatus_i                    :   std_logic_vector(1 downto 0);

  signal gt0_pll_locked : std_logic;
  signal gt0_cpll_reset : std_logic;
  signal RXUSERRDY_in : std_logic;
  signal RXDLYEN_in : std_logic;
  signal RXDLYSRESET_in : std_logic;
  signal RXPHALIGN_in : std_logic;
  signal RXPHALIGNEN_in : std_logic;
  signal RXPHDLYRESET_in : std_logic;
  signal RXPHMONITOR_out : std_logic_vector(4 downto 0);
  signal RXPHSLIPMONITOR_out : std_logic_vector(4 downto 0);
  signal RXDFELPMRESET_in : std_logic;
  signal RXOUTCLK_out : std_logic;
  signal GTRXRESET_in : std_logic;
  signal RXPCSRESET_in : std_logic;
  signal RXPMARESET_in : std_logic;
  signal RXSLIDE_in : std_logic;
  signal RXRESETDONE_out : std_logic;
  signal GTTXRESET_in : std_logic;
  signal TXUSERRDY_in : std_logic;
  signal TXDLYEN_in : std_logic;
  signal TXDLYSRESET_in : std_logic;
  signal TXPHALIGN_in : std_logic;
  signal TXPHALIGNEN_in : std_logic;
  signal TXPHDLYRESET_in : std_logic;
  signal TXPHINIT_in : std_logic;
  signal TXOUTCLKFABRIC_out : std_logic;
  signal TXOUTCLKPCS_out : std_logic;
  signal TXPCSRESET_in : std_logic;
  signal TXPMARESET_in : std_logic;
  signal TXRESETDONE_out : std_logic;

  signal phase_acc    : std_logic_vector(6 downto 0);
  signal phase_acc_en : std_logic;
  signal drpclk  : std_logic;
  signal drpaddr : std_logic_vector(8 downto 0);
  signal drpdi   : std_logic_vector(15 downto 0);
  signal drpdo   : std_logic_vector(15 downto 0);
  signal drpen   : std_logic;
  signal drpwe   : std_logic;
  signal drprdy  : std_logic;

begin

  gt0_recovered_clk_buf : BUFG
    port map (
      O => gt0_rxclk,
      I => gt0_rxoutclk);

  gt0_txoutclk_buf: BUFG
    port map (
      O => gt0_txclk,
      I => gt0_txoutclk);

  gt0_x0y0 : z7_gtx_evr
    port map (
      --! System clock - 100 MHz (From PLL Si5346 Out2)
      SYSCLK_IN                   => i_sys_clk,
      --! Soft reset for the GT Tx FSM
      SOFT_RESET_TX_IN            => i_gt0_tx_async_rst,
      --! Soft reset for the Rx FSM
      SOFT_RESET_RX_IN            => i_gt0_rx_async_rst,
      DONT_RESET_ON_DATA_ERROR_IN => gnd,
      --! Indicates Tx Initialization complete. Use it to reset a frame generator
      GT0_TX_FSM_RESET_DONE_OUT   => open,
      GT0_RX_FSM_RESET_DONE_OUT   => open,
      --! Indicates that data is valid on the Rx side - RXUSRCLK2 domain
      GT0_DATA_VALID_IN           => gnd,
      --_________________________________________________________________________
      --GT0  (X0Y0)
      --____________________________CHANNEL PORTS________________________________
      --------------------------------- CPLL Ports -------------------------------
      --! A High on this signal indicates the feedback clock from the CPLL
      --! feedback divider to the phase frequency detector of the CPLL is lost.
      gt0_cpllfbclklost_out           =>      open,
      --! PLL freq. locked. Transceiver and clock outs reliable when this is 1.
      gt0_cplllock_out                =>      gt0_pll_locked,
      --! Stable reference clock for the detection of the feedback and
      --! reference clock signals to the CPLL.
      --! NOT USE a clock generated by the CPLL nor the reference clock for it!
      gt0_cplllockdetclk_in           =>      i_sys_clk,
      gt0_cpllreset_in                =>      gt0_cpll_reset,
      -------------------------- Channel - Clocking Ports ----------------------
      gt0_gtrefclk0_in                =>      i_ref0_clk,
      gt0_gtrefclk1_in                =>      gnd,
      ---------------------------- Channel - DRP Ports  ------------------------
      --! Dynamic Reconfiguration Port not used by the moment
      --! TODO: do we need this?
      gt0_drpaddr_in                  =>      gnd_32b(8 downto 0),
      --! Use the Tx clock
      gt0_drpclk_in                   =>      gt0_txclk,
      gt0_drpdi_in                    =>      gnd_32b(15 downto 0),
      gt0_drpdo_out                   =>      open,
      gt0_drpen_in                    =>      gnd,
      gt0_drprdy_out                  =>      open,
      gt0_drpwe_in                    =>      gnd,
      --------------------------- Digital Monitor Ports ------------------------
      gt0_dmonitorout_out             =>      open,
      --------------------- RX Initialization and Reset Ports ------------------
      gt0_eyescanreset_in             =>      gnd,
      gt0_rxuserrdy_in                =>      RXUSERRDY_in,
      -------------------------- RX Margin Analysis Ports ----------------------
      gt0_eyescandataerror_out        =>      open,
      gt0_eyescantrigger_in           =>      gnd,
      ------------------ Receive Ports - FPGA RX Interface Ports ---------------
      --! Generated from RxOutCLK
      gt0_rxusrclk_in                 =>      gt0_rxclk,
      gt0_rxusrclk2_in                =>      gt0_rxclk,
      ------------------ Receive Ports - FPGA RX interface Ports ---------------
      gt0_rxdata_out                  =>      rxdata_i(15 downto 0),
      ------------------ Receive Ports - RX 8B/10B Decoder Ports ---------------
      gt0_rxdisperr_out               =>     rx_disperr,
      gt0_rxnotintable_out            =>     rx_notintable,
      --------------------------- Receive Ports - RX AFE -----------------------
      gt0_gtxrxp_in                   =>      i_rx_p,
      ------------------------ Receive Ports - RX AFE Ports --------------------
      gt0_gtxrxn_in                   =>      i_rx_n,
      ------------------- Receive Ports - RX Buffer Bypass Ports ---------------
      --! Rx phase alignment monitor
      gt0_rxphmonitor_out             =>      RXPHMONITOR_out,
      --! Rx phase slip monitor
      gt0_rxphslipmonitor_out         =>      RXPHSLIPMONITOR_out,
      --------------------- Receive Ports - RX Equalizer Ports -----------------
      gt0_rxdfelpmreset_in            =>      gnd,
      gt0_rxmonitorout_out            =>      open,
      gt0_rxmonitorsel_in             =>      gnd_32b(1 downto 0),
      --------------- Receive Ports - RX Fabric Output Control Ports -----------
      --! Recovered clock for the FPGA logic
      gt0_rxoutclk_out                =>      gt0_rxoutclk,
      --! RXoutCLK * 2 and without Delay alignment - see p.210 [1]
      gt0_rxoutclkfabric_out          =>      open,
      ------------- Receive Ports - RX Initialization and Reset Ports ----------
      gt0_gtrxreset_in                =>      GTRXRESET_in,
      gt0_rxpmareset_in               =>      RXPMARESET_in,
      ---------------------- Receive Ports - RX gearbox ports ------------------
      gt0_rxslide_in                  =>      RXSLIDE_in,
      ------------------- Receive Ports - RX8B/10B Decoder Ports ---------------
      gt0_rxcharisk_out               =>      rx_charisk,
      -------------- Receive Ports -RX Initialization and Reset Ports ----------
      gt0_rxresetdone_out             =>      RXRESETDONE_out,
      --------------------- TX Initialization and Reset Ports ------------------
      gt0_gttxreset_in                =>      GTTXRESET_in,
      gt0_txuserrdy_in                =>      TXUSERRDY_in,
      ------------------ Transmit Ports - FPGA TX Interface Ports --------------
      gt0_txusrclk_in                 =>      gt0_txclk,
      gt0_txusrclk2_in                =>      gt0_txclk,
      ------------------ Transmit Ports - TX Data Path interface ---------------
      gt0_txdata_in                   =>      txdata_i(15 DOWNTO 0),
      ---------------- Transmit Ports - TX Driver and OOB signaling ------------
      gt0_gtxtxn_out                  =>      o_tx_n,
      gt0_gtxtxp_out                  =>      o_tx_p,
      ----------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
      gt0_txoutclk_out                =>      gt0_txoutclk,
      gt0_txoutclkfabric_out          =>      TXOUTCLKFABRIC_out,
      gt0_txoutclkpcs_out             =>      TXOUTCLKPCS_out,
      --------------------- Transmit Ports - TX Gearbox Ports --------------------
      gt0_txcharisk_in                =>      tx_charisk,
      ------------- Transmit Ports - TX Initialization and Reset Ports -----------
      gt0_txresetdone_out             =>      TXRESETDONE_out,

      --____________________________COMMON PORTS________________________________
      GT0_QPLLOUTCLK_IN               => gnd,
      GT0_QPLLOUTREFCLK_IN            => gnd);

  --! @brief EVR Rx FIFO
  i_dc_fifo : FIFO36E1
    generic map (
      ALMOST_EMPTY_OFFSET => X"0080",
      ALMOST_FULL_OFFSET => X"0080",
      DATA_WIDTH => 36,
      DO_REG => 1,
      EN_SYN => FALSE,
      FIFO_MODE => "FIFO36",
      FIRST_WORD_FALL_THROUGH => FALSE,
      INIT => X"000000000",
      SIM_DEVICE => "7SERIES",
      SRVAL => X"000000000")
    port map (
      DO => fifo_do,
      DOP => fifo_dop,
      ECCPARITY => open,
      ALMOSTEMPTY => open,
      ALMOSTFULL => open,
      DBITERR => open,
      SBITERR => open,
      EMPTY => open,
      FULL => open,
      RDCOUNT => open,
      RDERR => open,
      WRCOUNT => open,
      WRERR => open,
      RDCLK => i_evntclk_delay,
      RDEN => fifo_rden,
      REGCE => vcc,
      RST => fifo_rst,
      RSTREG => gnd,
      WRCLK => gt0_rxclk,
      WREN => fifo_wren,
      DI => fifo_di,
      DIP => fifo_dip,
      INJECTDBITERR => gnd,
      INJECTSBITERR => gnd);

  --! @brief EVR Tx FIFO
  i_txfifo : FIFO18E1
    generic map (
      ALMOST_EMPTY_OFFSET => X"0080",
      ALMOST_FULL_OFFSET => X"0080",
      DATA_WIDTH => 9,
      DO_REG => 1,
      EN_SYN => FALSE,
      FIFO_MODE => "FIFO18",
      FIRST_WORD_FALL_THROUGH => FALSE,
      INIT => X"000000000",
      SIM_DEVICE => "7SERIES",
      SRVAL => X"000000000")
    port map (
      DO => tx_fifo_do,
      DOP => tx_fifo_dop,
      ALMOSTEMPTY => open,
      ALMOSTFULL => open,
      EMPTY => tx_fifo_empty,
      FULL => open,
      RDCOUNT => open,
      RDERR => tx_fifo_rderr,
      WRCOUNT => open,
      WRERR => open,
      RDCLK => gt0_txclk,
      RDEN => tx_fifo_rden,
      REGCE => vcc,
      RST => tx_fifo_rst,
      RSTREG => gnd,
      WRCLK => refclk,
      WREN => tx_fifo_wren,
      DI => tx_fifo_di,
      DIP => tx_fifo_dip);

  RXDFELPMRESET_in <= reset;
  RXDLYEN_in <= '0';
  RXDLYSRESET_in <= reset;
  RXPCSRESET_in <= reset;
  RXPHALIGN_in <= '0';
  RXPHALIGNEN_in <= '0';
  RXPHDLYRESET_in <= reset;
  RXPMARESET_in <= reset;
  RXSLIDE_in <= '0';
  TXDLYEN_in <= '0';
  TXDLYSRESET_in <= reset;
  TXPCSRESET_in <= '0';
  TXPHALIGN_in <= '0';
  TXPHALIGNEN_in <= '0';
  TXPHDLYRESET_in <= '0';
  TXPHINIT_in <= '0';
  TXPMARESET_in <= '0';

  refclk <= gt0_txclk;
  o_rxclock <= gt0_rxclk;
  o_refclock <= gt0_txclk;

  fifo_di(63 downto 16) <= (others => '0');
  fifo_di(15 downto 0) <= rx_data;
  fifo_dip(7 downto 4) <= (others => '0');
  fifo_dip(2) <= '0';
  fifo_dip(1 downto 0) <= rx_charisk;

  rx_beacon <= rx_beacon_i;
  rx_int_beacon <= rx_int_beacon_i;
  rx_int_beacon_i <= fifo_dop(3);
  fifo_dip(3) <= rx_beacon_i;

  receive_error_detect : process (gt0_rxclk, rx_data, rx_charisk,
    rx_disperr, rx_notintable)
    variable beacon_cnt : std_logic_vector(2 downto 0) := "000";
    variable cnt : std_logic_vector(12 downto 0);
  begin
    if rising_edge(gt0_rxclk) then
      rx_error <= '0';
      if (rx_charisk(0) = '1' and rx_data(7) = '1') or
        rx_disperr /= "00" or rx_notintable /= "00" then
        rx_error <= '1';
      end if;
      if beacon_cnt(beacon_cnt'high) = '1' then
        beacon_cnt := beacon_cnt - 1;
      end if;
      if link_ok = '1' and rx_charisk(1) = '0' and rx_data(15 downto 8) = C_EVENT_BEACON then
        beacon_cnt := "111";
      end if;
      rx_beacon_i <= beacon_cnt(beacon_cnt'high);
      if dc_mode = '0' then
        rx_beacon_i <= cnt(cnt'high);
      end if;
      if cnt(cnt'high) = '1' then
        cnt(cnt'high) := '0';
      end if;
      cnt := cnt + 1;
    end if;
  end process;

  link_ok_detection : process (refclk, link_ok, reset, rx_error_i, rx_link_ok_i)
    variable link_ok_delay : std_logic_vector(19 downto 0) := (others => '0');
  begin
    rx_link_ok <= rx_link_ok_i;
    rx_link_ok_i <= link_ok_delay(link_ok_delay'high);
    if rising_edge(refclk) then
      if link_ok_delay(link_ok_delay'high) = '0' then
        link_ok_delay := link_ok_delay + 1;
      end if;
      if reset = '1' or link_ok = '0' or rx_error_i = '1' then
        link_ok_delay := (others => '0');
      end if;
    end if;
  end process;

  link_status_testing : process (refclk, reset, rx_charisk, link_ok,
                                 rx_disperr, gt0_pll_locked)
    variable prescaler : std_logic_vector(14 downto 0);
    variable count : std_logic_vector(3 downto 0);
    variable rx_error_sync : std_logic;
    variable rx_error_sync_1 : std_logic;
    variable loss_lock : std_logic;
    variable rx_error_count : std_logic_vector(5 downto 0);
    variable reset_sync : std_logic_vector(1 downto 0);
  begin
--    TRIG0(58 downto 53) <= rx_error_count;
--    TRIG0(59) <= loss_lock;
--    TRIG0(60) <= rx_error_sync;
--    TRIG0(75 downto 61) <= prescaler;
--    TRIG0(79 downto 76) <= count;

    if rising_edge(refclk) then
      rxcdrreset <= '0';
      if GTRXRESET_in = '0' then
        if prescaler(prescaler'high) = '1' then
          link_ok <= '0';
          if count = "0000" then
            link_ok <= '1';
          end if;

          if count = "1111" then
            rxcdrreset <= '1';
          end if;

          if count(count'high) = '1' then
            rx_error_count := "011111";
          end if;

          if count /= "0000" then
            count := count - 1;
          end if;
        end if;

        if count = "0000" then
          if loss_lock = '1' then
            count := "1111";
          end if;
        end if;

        loss_lock := rx_error_count(5);

        if rx_error_sync = '1' then
          if rx_error_count(5) = '0' then
            rx_error_count := rx_error_count - 1;
          end if;
        else
          if prescaler(prescaler'high) = '1' and
            (rx_error_count(5) = '1' or rx_error_count(4) = '0') then
            rx_error_count := rx_error_count + 1;
          end if;
        end if;

        if prescaler(prescaler'high) = '1' then
          prescaler := "011111111111111";
        else
          prescaler := prescaler - 1;
        end if;
      end if;

      rx_error_i <= rx_error_sync_1;
      rx_error_sync := rx_error_sync_1;
      rx_error_sync_1 := rx_error;

      if reset_sync(0) = '1' then
        count := "1111";
      end if;

      -- Synchronize asynchronous resets
      reset_sync(0) := reset_sync(1);
      reset_sync(1) := '0';
      if reset = '1' or gt0_pll_locked = '0' then
        reset_sync(1) := '1';
      end if;
    end if;
  end process;

  reg_dbus_data : process (i_evntclk_delay, rx_link_ok_i, rx_data, databuf_rxd_i, databuf_rx_k_i)
    variable even : std_logic;
  begin
    databuf_rxd <= databuf_rxd_i;
    databuf_rx_k <= databuf_rx_k_i;
    if rising_edge(i_evntclk_delay) then
      if databuf_rx_mode = '0' or even = '0' then
        dbus_rxd <= fifo_do(7 downto 0);
      end if;

      if databuf_rx_mode = '1' then
        if even = '1' then
          databuf_rxd_i <= fifo_do(7 downto 0);
          databuf_rx_k_i <= fifo_dop(0);
        end if;
      else
        databuf_rxd_i <= (others => '0');
        databuf_rx_k_i <= '0';
      end if;

      databuf_rx_ena <= even;

      if rx_link_ok_i = '0' then
        databuf_rxd_i <= (others => '0');
        databuf_rx_k_i <= '0';
        dbus_rxd <= (others => '0');
      end if;

      even := not even;
      event_rxd <= fifo_do(15 downto 8);
      if rx_link_ok_i = '0' or fifo_dop(1) = '1' or reset = '1' then
        event_rxd <= (others => '0');
        even := '0';
      end if;
    end if;
  end process;

  rx_data_align_detect : process (gt0_rxclk, reset, rx_charisk, rx_data,
                                  rx_clear_viol)
  begin
    if reset = '1' or rx_clear_viol = '1' then
      align_error <= '0';
    elsif rising_edge(gt0_rxclk) then
      align_error <= '0';
      if rx_charisk(0) = '1' and rx_data(7) = '1' then
        align_error <= '1';
      end if;
    end if;
  end process;

  violation_flag : process (i_sys_clk, rx_clear_viol, rx_link_ok_i, rx_vio_usrclk)
    variable vio : std_logic;
  begin
    if rising_edge(i_sys_clk) then
      if rx_clear_viol = '1' then
        rx_violation <= '0';
      end if;
      if vio = '1' or rx_link_ok_i = '0' then
        rx_violation <= '1';
      end if;
      vio := rx_vio_usrclk;
    end if;
  end process;

  violation_detect : process (gt0_rxclk, rx_clear_viol,
                              rx_disperr, rx_notintable, link_ok)
    variable clrvio : std_logic;
  begin
    if rising_edge(gt0_rxclk) then
      if rx_disperr /= "00" or rx_notintable /= "00" then
        rx_vio_usrclk <= '1';
      elsif clrvio = '1' then
        rx_vio_usrclk <= '0';
      end if;

      clrvio := rx_clear_viol;
    end if;
  end process;

--  TRIG0(15 downto 0) <= rx_data;
--  TRIG0(17 downto 16) <= rx_charisk;
--  TRIG0(19 downto 18) <= rx_disperr;
--  TRIG0(21 downto 20) <= "00";
--  TRIG0(23 downto 22) <= rx_notintable;
--  TRIG0(24) <= link_ok;
--  TRIG0(25) <= gt0_cpll_reset;
--  TRIG0(26) <= GTTXRESET_in;
--  TRIG0(27) <= TXUSERRDY_in;
--  TRIG0(28) <= GTRXRESET_in;
--  TRIG0(29) <= RXUSERRDY_in;
--  TRIG0(30) <= '0';
--  TRIG0(31) <= '0';
--  TRIG0(47 downto 32) <= tx_data;
--  TRIG0(49 downto 48) <= tx_charisk;
--  TRIG0(50) <= rx_error;
--  TRIG0(51) <= rxcdrreset;
--  TRIG0(52) <= align_error;
--  TRIG0(87 downto 80) <= databuf_rxd_i;
--  TRIG0(88) <= databuf_rx_k_i;
--  TRIG0(90) <= RXPCSRESET_in;
--  TRIG0(91) <= RXPMARESET_in;
--  TRIG0(92) <= RXRESETDONE_out;
--  TRIG0(116 downto 93) <= (others => '0');
--  TRIG0(117) <= databuf_tx_mode;
--  TRIG0(119) <= databuf_tx_k;
--  TRIG0(127 downto 120) <= databuf_txd;
--  TRIG0(143 downto 128) <= fifo_do(15 downto 0);
--  TRIG0(147 downto 144) <= fifo_dop(3 downto 0);
--  TRIG0(148) <= fifo_rden;
--  TRIG0(156 downto 149) <= tx_fifo_do(7 downto 0);
--  TRIG0(164 downto 157) <= tx_fifo_di(7 downto 0);
--  TRIG0(165) <= tx_fifo_wren;
--  TRIG0(166) <= tx_fifo_rden;
--  TRIG0(167) <= tx_fifo_empty;
--  TRIG0(168) <= tx_event_ena_i;
--  TRIG0(250 downto 170) <= (others => '0');

--  process (gt0_rxclk)
--    variable toggle : std_logic := '0';
--  begin
--    TRIG0(169) <= toggle;
--    if rising_edge(gt0_rxclk) then
--      toggle := not toggle;
--    end if;
--  end process;

  rx_data <= rxdata_i(15 downto 0);
  txdata_i <= (c_gnd_64b(47 downto 0) & tx_data);

  -- Scalers for clocks for debugging purposes to see which clocks
  -- are running using the ILA core

--  process (refclk, reset)
--    variable cnt : std_logic_vector(2 downto 0);
--  begin
--    TRIG0(255) <= cnt(cnt'high);
--    if rising_edge(refclk) then
--      cnt := cnt + 1;
--      if reset = '1' then
--        cnt := (others => '0');
--      end if;
--    end if;
--  end process;

--  process (i_sys_clk, reset)
--    variable cnt : std_logic_vector(2 downto 0);
--  begin
--    TRIG0(254) <= cnt(cnt'high);
--    if rising_edge(i_sys_clk) then
--      cnt := cnt + 1;
--      if reset = '1' then
--        cnt := (others => '0');
--      end if;
--    end if;
--  end process;

--  process (i_evntclk_delay, reset)
--    variable cnt : std_logic_vector(2 downto 0);
--  begin
--    TRIG0(253) <= cnt(cnt'high);
--    if rising_edge(i_evntclk_delay) then
--      cnt := cnt + 1;
--      if reset = '1' then
--        cnt := (others => '0');
--      end if;
--    end if;
--  end process;

--  process (gt0_rxclk, reset)
--    variable cnt : std_logic_vector(2 downto 0);
--  begin
--    TRIG0(252) <= cnt(cnt'high);
--    if rising_edge(gt0_rxclk) then
--      cnt := cnt + 1;
--      if reset = '1' then
--        cnt := (others => '0');
--      end if;
--    end if;
--  end process;

--  process (gt0_txclk, reset)
--    variable cnt : std_logic_vector(2 downto 0);
--  begin
--    TRIG0(251) <= cnt(cnt'high);
--    if rising_edge(gt0_txclk) then
--      cnt := cnt + 1;
--      if reset = '1' then
--        cnt := (others => '0');
--      end if;
--    end if;
--  end process;

  cpll_reset: process (i_sys_clk, reset)
    variable cnt : std_logic_vector(25 downto 0) := (others => '1');
  begin
    if rising_edge(i_sys_clk) then
      gt0_cpll_reset <= cnt(cnt'high);
      if cnt(cnt'high) = '1' then
        cnt := cnt - 1;
        GTTXRESET_in <= '1';
        TXUSERRDY_in <= '0';
      end if;
      if reset = '1' then
        cnt := (others => '1');
      end if;
      if gt0_pll_locked = '1' then
        GTTXRESET_in <= '0';
        TXUSERRDY_in <= '1';
      end if;
    end if;
  end process;

  rx_resetting: process (refclk, rxcdrreset)
    variable cnt : std_logic_vector(25 downto 0) := (others => '1');
  begin
    if rising_edge(refclk) then
      GTRXRESET_in <= cnt(cnt'high);
      RXUSERRDY_in <= not cnt(cnt'high);
      if cnt(cnt'high) = '1' then
        cnt := cnt - 1;
      end if;
      if rxcdrreset = '1' then
        cnt := (others => '1');
      end if;
    end if;
  end process;

  transmit_data : process (gt0_txclk, tx_fifo_do, tx_fifo_empty, dbus_txd,
                           databuf_txd, databuf_tx_k, databuf_tx_mode, dc_mode,
                           reset,tx_event_ena_i)
    variable even       : std_logic_vector(1 downto 0) := "00";
    variable beacon_cnt : std_logic_vector(3 downto 0) := "0000";
    variable fifo_pend  : std_logic;
  begin
    tx_event_ena <= tx_event_ena_i;
    tx_event_ena_i <= '1';
    tx_fifo_rden <= '1';
    if beacon_cnt(1 downto 0) = "10" and dc_mode = '1' then
      tx_event_ena_i <= '0';
      if tx_fifo_empty = '0' then
        tx_fifo_rden <= '0';
      end if;
    end if;
    if rising_edge(gt0_txclk) then
      tx_charisk <= "00";
      tx_data(15 downto 8) <= (others => '0');
      tx_beacon <= beacon_cnt(1);
      if beacon_cnt(1 downto 0) = "10" and dc_mode = '1' then
        tx_data(15 downto 8) <= C_EVENT_BEACON; -- Beacon event
      elsif tx_fifo_rderr = '0' then
        tx_data(15 downto 8) <= tx_fifo_do(7 downto 0);
        fifo_pend := '0';
      elsif even = "00" then
        tx_charisk <= "10";
        tx_data(15 downto 8) <= X"BC"; -- K28.5 character
      end if;

      if tx_fifo_empty = '0' then
        fifo_pend := '1';
      end if;

      tx_data(7 downto 0) <= dbus_txd;
      if even(0) = '0' and databuf_tx_mode = '1' then
        tx_data(7 downto 0) <= databuf_txd;
        tx_charisk(0) <= databuf_tx_k;
      end if;
      databuf_tx_ena <= even(0);
--      TRIG0(118) <= even(0);
      even := even + 1;
      beacon_cnt := rx_beacon_i & beacon_cnt(beacon_cnt'high downto 1);
      if reset = '1' then
        fifo_pend := '0';
      end if;
    end if;
  end process;

  -- Read and write enables are used to adjust the coarse delay
  -- These can cause data packet corruption and missing events -
  -- thus this method is used only during link training

  fifo_read_enable : process (i_evntclk_delay, delay_inc)
    variable sr_delay_trig : std_logic_vector(2 downto 0) := "000";
  begin
    if rising_edge(i_evntclk_delay) then
      fifo_rden <= '1';
      if sr_delay_trig(1 downto 0) = "10" then
        fifo_rden <= '0';
      end if;
      sr_delay_trig := delay_inc & sr_delay_trig(2 downto 1);
    end if;
  end process;

  fifo_write_enable : process (gt0_rxclk, delay_dec)
    variable sr_delay_trig : std_logic_vector(2 downto 0) := "000";
  begin
    if rising_edge(gt0_rxclk) then
      fifo_wren <= '1';
      if sr_delay_trig(1 downto 0) = "10" then
        fifo_wren <= '0';
      end if;
      sr_delay_trig := delay_dec & sr_delay_trig(2 downto 1);
    end if;
  end process;

  fifo_rst <= not link_ok;

  tx_fifo_writing : process (refclk, event_txd)
  begin
    tx_fifo_di <= (others => '0');
    tx_fifo_di(7 downto 0) <= event_txd;
    tx_fifo_wren <= '0';
    if event_txd /= X"00" then
      tx_fifo_wren <= '1';
    end if;
  end process;

  tx_fifo_dip <= (others => '0');
  tx_fifo_rst <= reset;

  drpclk <= gt0_txclk;

  process (drpclk, reset, txbufstatus_i, TXUSERRDY_in)
    type state is (init, init_delay, acq_bufstate, deldec, delinc, locked);
    variable ph_state : state;
    variable phase       : std_logic_vector(6 downto 0);
    variable cnt      : std_logic_vector(19 downto 0);
    variable halffull : std_logic;
  begin
    if rising_edge(drpclk) then
      if (ph_state = acq_bufstate) or
        (ph_state = delinc) or
        (ph_state = deldec) then
        if txbufstatus_i(0) = '1' then
          halffull := '1';
        end if;
      end if;

      phase_acc_en <= '0';
      if cnt(cnt'high) = '1' then
        case ph_state is
          when init =>
            if reset = '0' then
              ph_state := init_delay;
            end if;
          when init_delay =>
            halffull := '0';
            ph_state := acq_bufstate;
          when acq_bufstate =>
            if halffull = '0' then
              ph_state := delinc;
            else
              ph_state := deldec;
            end if;
            halffull := '0';
          when deldec =>
            if halffull = '1' then
              phase := phase - 1;
            else
              ph_state := delinc;
            end if;
            halffull := '0';
            phase_acc_en <= '1';
          when delinc =>
            if halffull = '0' then
              phase := phase + 1;
            else
              ph_state := locked;
            end if;
            halffull := '0';
            phase_acc_en <= '1';
          when others =>
        end case;
        phase_acc <= phase;
        cnt := (others => '0');
      else
        cnt := cnt + 1;
      end if;
      if reset = '1' or TXUSERRDY_in = '0' then
        ph_state := init;
        phase := (others => '0');
        cnt := (others => '0');
      end if;
    end if;
  end process;

  process (drpclk, phase_acc, phase_acc_en, reset)
    type state is (idle, a64_0, a64_1, a64_2, a9f_0, a9f_1, a9f_2, a9f_3, a9f_4, a9f_5);
    variable drp_state, next_state : state;
    variable rdy_wait : std_logic;
  begin
    if rising_edge(drpclk) then
      rdy_wait := '0';
      case drp_state is
        when a64_0 =>
          drpaddr <= '0' & X"64";
          drpdi <= X"00" & '0' & phase_acc;
          drpen <= '0';
          drpwe <= '0';
          next_state := a64_1;
        when a64_1 =>
          drpaddr <= '0' & X"64";
          drpdi <= X"00" & '0' & phase_acc;
          drpen <= '1';
          drpwe <= '1';
          next_state := a64_2;
        when a64_2 =>
          drpaddr <= '0' & X"64";
          drpdi <= X"00" & '0' & phase_acc;
          drpen <= '0';
          drpwe <= '0';
          next_state := a9f_0;
          rdy_wait := '1';
        when a9f_0 =>
          drpaddr <= '0' & X"9F";
          drpdi <= X"0035";
          drpen <= '0';
          drpwe <= '0';
          next_state := a9f_1;
        when a9f_1 =>
          drpaddr <= '0' & X"9F";
          drpdi <= X"0035";
          drpen <= '1';
          drpwe <= '1';
          next_state := a9f_2;
        when a9f_2 =>
          drpaddr <= '0' & X"9F";
          drpdi <= X"0035";
          drpen <= '0';
          drpwe <= '0';
          rdy_wait := '1';
          next_state := a9f_3;
        when a9f_3 =>
          drpaddr <= '0' & X"9F";
          drpdi <= X"0034";
          drpen <= '0';
          drpwe <= '0';
          next_state := a9f_4;
        when a9f_4 =>
          drpaddr <= '0' & X"9F";
          drpdi <= X"0034";
          drpen <= '1';
          drpwe <= '1';
          next_state := a9f_5;
        when a9f_5 =>
          drpaddr <= '0' & X"9F";
          drpdi <= X"0034";
          drpen <= '0';
          drpwe <= '0';
          rdy_wait := '1';
          next_state := idle;
        when others =>
          drpaddr <= '0' & X"64";
          drpdi <= X"00" & '0' & phase_acc;
          drpen <= '0';
          drpwe <= '0';
          next_state := idle;
          rdy_wait := '0';
      end case;
      if rdy_wait = '0' or drprdy = '1' then
        if drp_state = idle and phase_acc_en = '1' then
          next_state := a64_0;
        end if;
        drp_state := next_state;
      end if;
      if reset = '1' then
        drp_state := idle;
        rdy_wait := '0';
      end if;
    end if;
  end process;

end structure;
