-- =============================================================================
--! @file   transceiver_dc_z7.vhd
--! @brief  z7 GTX wrapper for the openEVR
--!
--! @details
--!
--! Vaguely based in the GT wrapper available in the MRF's openEVR project.
--!
--! @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
--! @author Ross Elliot <ross.elliot@ess.eu>
--!
--! @date 20200728
--!
--! \b Company   European Spallation Source ERIC \n
--! \b Platform: picoZED 7030 \n
--! \b Carrier board: Tallinn picoZED carrier board rev. B \n
--!
--! @copyright
--!
--! Copyright (C) 2019 - 2020 European Spallation Source ERIC \n
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
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.evr_pkg.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity transceiver_dc_z7 is
  port (
    i_sys_clk       : in std_logic;   -- system bus clock
    i_gtref0_clk    : in std_logic;   -- MGTREFCLK0
    i_gtref1_clk    : in std_logic;   -- MGTREFCLK1
    REFCLK_OUT      : out std_logic;  -- reference clock output
    recclk_out      : out std_logic;  -- Recovered clock, locked to EVG
    event_clk       : in std_logic;   -- event clock input (phase shifted by DCM)

    i_gt_resets     : in gt_resets;      -- Transceiver resets
    o_gt_status     : out gt_ctrl_flags; -- Transceiver flags

    -- Receiver side connections
    event_rxd       : out std_logic_vector(7 downto 0); -- RX event code output
    dbus_rxd        : out std_logic_vector(7 downto 0); -- RX distributed bus bits
    databuf_rxd     : out std_logic_vector(7 downto 0); -- RX data buffer data
    databuf_rx_k    : out std_logic; -- RX data buffer K-character
    databuf_rx_ena  : out std_logic; -- RX data buffer data enable
    databuf_rx_mode : in std_logic;  -- RX data buffer mode, must be '1'
                                     -- enabled for delay compensation mode
    dc_mode         : in std_logic;  -- delay compensation mode enable when '1'

    rx_link_ok      : out   std_logic; -- RX link OK
    rx_violation    : out   std_logic; -- RX violation detected
    rx_clear_viol   : in    std_logic; -- Clear RX violation
    rx_beacon       : out   std_logic; -- Received DC beacon
    tx_beacon       : out   std_logic; -- Transmitted DC beacon
    rx_int_beacon   : out   std_logic; -- Received DC beacon after DC FIFO

    delay_inc       : in    std_logic; -- Insert extra event in FIFO
    delay_dec       : in    std_logic; -- Drop event from FIFO
                                       -- These two control signals are used
                                       -- only during the initial phase of
                                       -- delay compensation adjustment

    -- Transmitter side connections
    event_txd       : in  std_logic_vector(7 downto 0); -- TX event code
    tx_event_ena    : out std_logic; -- 1 when event is sent out
                                     -- With backward events the beacon event
                                     -- has highest priority
    dbus_txd        : in  std_logic_vector(7 downto 0); -- TX distributed bus data
    databuf_txd     : in  std_logic_vector(7 downto 0); -- TX data buffer data
    databuf_tx_k    : in  std_logic; -- TX data buffer K-character
    databuf_tx_ena  : out std_logic; -- TX data buffer data enable
    databuf_tx_mode : in  std_logic; -- TX data buffer mode enabled when '1'

    RXN             : in    std_logic;
    RXP             : in    std_logic;

    TXN             : out   std_logic;
    TXP             : out   std_logic;
    EVENT_CLK_o     : out   std_logic
    );
end transceiver_dc_z7;

architecture structure of transceiver_dc_z7 is

  -- Attributes
  attribute mark_debug : string;

  -- Useful constant values
  signal c_vcc : std_logic := '1';
  signal c_gnd : std_logic := '0';
  signal c_gnd_vec : std_logic_vector(63 downto 0) := (others => '0');

  signal tx_outclk     : std_logic;
  signal tx_refclk     : std_logic;
  signal refclk        : std_logic;

  signal rx_charisk    : std_logic_vector(1 downto 0);
  signal rx_rundisp    : std_logic_vector(1 downto 0);
  signal rx_commadet   : std_logic;
  signal rx_data       : std_logic_vector(15 downto 0);
  signal rx_disperr    : std_logic_vector(1 downto 0);
  signal rx_notintable : std_logic_vector(1 downto 0);
  signal rx_realign    : std_logic;
  signal rx_beacon_i   : std_logic;
  signal rxusrclk      : std_logic;
  signal txusrclk      : std_logic;
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
  signal rxchariscomma_float_i            :   std_logic_vector(5 downto 0);
  signal rxcharisk_float_i                :   std_logic_vector(5 downto 0);
  signal rxdisperr_float_i                :   std_logic_vector(5 downto 0);
  signal rxnotintable_float_i             :   std_logic_vector(5 downto 0);
  signal rxrundisp_float_i                :   std_logic_vector(5 downto 0);

  -- TX Datapath signals
  signal txdata_i                         :   std_logic_vector(63 downto 0);
  signal txkerr_float_i                   :   std_logic_vector(5 downto 0);
  signal txrundisp_float_i                :   std_logic_vector(5 downto 0);
  signal txbufstatus_i                    :   std_logic_vector(1 downto 0);

  signal CPLLLOCK_out : std_logic;
  signal CPLLFBCLKLOST_out : std_logic;
  signal CPLLRESET_in : std_logic;
  signal RXUSERRDY_in : std_logic;
  signal RXOUTCLK_out : std_logic;
  signal GTRXRESET_in : std_logic;
  signal RXPMARESET_in : std_logic;
  signal RXPOLARITY_in : std_logic;
  signal RXRESETDONE_out : std_logic;
  signal GTTXRESET_in : std_logic;
  signal TXUSERRDY_in : std_logic;
  signal TXDLYSRESET_in : std_logic;
  signal TXOUTCLKFABRIC_out : std_logic;
  signal TXOUTCLKPCS_out : std_logic;
  signal TXRESETDONE_out : std_logic;
  signal TXPOLARITY_in : std_logic;

  -- RX Datapath signals
  signal rxdata0_i                        :   std_logic_vector(31 downto 0);
  signal rxcharisk0_float_i               :   std_logic_vector(1 downto 0);
  signal rxdisperr0_float_i               :   std_logic_vector(1 downto 0);
  signal rxnotintable0_float_i            :   std_logic_vector(1 downto 0);
  signal rxrundisp0_float_i               :   std_logic_vector(1 downto 0);

  -- TX Datapath signals
  signal txdata0_i                        :   std_logic_vector(31 downto 0);
  signal txkerr0_float_i                  :   std_logic_vector(1 downto 0);
  signal txrundisp0_float_i               :   std_logic_vector(1 downto 0);
  -- States for the Tx path state machine:
  type timing_event is (s_EVENT_BEACON,   -- Send a beacon event for DC mode
                        s_EVENT_USER,     -- Send a regular user event
                        s_EVENT_CONTROL,  -- Send the K28.5 control character
                        s_EVENT_EMPTY);   -- Send empty data
  signal tx_path_state                    : timing_event;
  -- A Tx beacon is generated every 2 K28.5
  signal tx_beacon_gen                    : std_logic := '0';
  signal beacon_cnt : std_logic_vector(3 downto 0) := "0000";
  signal fifo_pend  : std_logic := '0';

  signal gtx_rxreset : std_logic := '0';

  -- RX Datapath signals
  signal rxdata1_i                        :   std_logic_vector(31 downto 0);
  signal rxcharisk1_float_i               :   std_logic_vector(1 downto 0);
  signal rxdisperr1_float_i               :   std_logic_vector(1 downto 0);
  signal rxnotintable1_float_i            :   std_logic_vector(1 downto 0);
  signal rxrundisp1_float_i               :   std_logic_vector(1 downto 0);


  -- TX Datapath signals
  signal txdata1_i                        :   std_logic_vector(31 downto 0);
  signal txkerr1_float_i                  :   std_logic_vector(1 downto 0);
  signal txrundisp1_float_i               :   std_logic_vector(1 downto 0);

  signal phase_acc    : std_logic_vector(6 downto 0);
  signal phase_acc_en : std_logic;
  signal drpclk  : std_logic;
  signal drpaddr : std_logic_vector(8 downto 0) := (others => '0');
  signal drpdi   : std_logic_vector(15 downto 0) := (others => '0');
  signal drpdo   : std_logic_vector(15 downto 0);
  signal drpen   : std_logic;
  signal drpwe   : std_logic;
  signal drprdy  : std_logic;

  signal rxpath_common_rst : std_logic := '0';

  signal event_rxd_i : std_logic_vector(7 downto 0);

  attribute mark_debug of rx_data : signal is "true";
  attribute mark_debug of rx_charisk : signal is "true";
  attribute mark_debug of rx_disperr : signal is "true";
  attribute mark_debug of rx_notintable : signal is "true";
  attribute mark_debug of link_ok : signal is "true";
  attribute mark_debug of CPLLRESET_in : signal is "true";
  attribute mark_debug of GTTXRESET_in : signal is "true";
  attribute mark_debug of TXUSERRDY_in : signal is "true";
  attribute mark_debug of GTRXRESET_in : signal is "true";
  attribute mark_debug of RXUSERRDY_in : signal is "true";
  attribute mark_debug of tx_data : signal is "true";
  attribute mark_debug of tx_charisk : signal is "true";
  attribute mark_debug of rx_error : signal is "true";
  attribute mark_debug of rxcdrreset : signal is "true";
  attribute mark_debug of align_error : signal is "true";
  attribute mark_debug of databuf_rxd_i : signal is "true";
  attribute mark_debug of databuf_rx_k_i : signal is "true";
  attribute mark_debug of RXPMARESET_in : signal is "true";
  attribute mark_debug of RXRESETDONE_out : signal is "true";
  attribute mark_debug of databuf_tx_mode : signal is "true";
  attribute mark_debug of databuf_tx_k : signal is "true";
  attribute mark_debug of databuf_txd : signal is "true";
  attribute mark_debug of tx_event_ena_i : signal is "true";
  attribute mark_debug of fifo_di : signal is "true";
  attribute mark_debug of fifo_do : signal is "true";

begin

  i_bufg0: BUFG
    port map (
      O => rxusrclk,
      I => RXOUTCLK_out);

  i_bufg1: BUFG
    port map (
      O => txusrclk,
      I => tx_outclk);

  --! @brief Reset generator for the Rx path of the GT
  --! @details This component will generate a 500 ns width reset signal for
  --!          the Transceiver at startup or when any of the input signals are
  --!          asserted.
  --!          The Rx paht is reset either by the internal signal rxcdrreset or
  --!          by an external async. reset signal (from sw).
  gtrx_reset_gen : z7_gtx_evr_common_reset
    generic map
    (
      STABLE_CLOCK_PERIOD => 11
    )
    port map
    (
      STABLE_CLOCK        => refclk,
      SOFT_RESET          => gtx_rxreset,
      COMMON_RESET        => rxpath_common_rst
    );

  gtx_rxreset <= rxcdrreset or i_gt_resets.rx_async;

  --! @brief Reset generator for the Tx path of the GT
  --! @details This component will generate a 500 ns width reset signal for
  --!          the Transceiver at startup.
  --!          The Tx paht is also reset by the global sw reset.
  cpll_reset_gen : z7_gtx_evr_common_reset
    generic map
    (
      STABLE_CLOCK_PERIOD => 11
    )
    port map
    (
      STABLE_CLOCK        => refclk,
      SOFT_RESET          => i_gt_resets.gbl_async,
      COMMON_RESET        => CPLLRESET_in
    );

  GTTXRESET_in <= not CPLLLOCK_out;
  TXUSERRDY_in <= CPLLLOCK_out;

  RXUSERRDY_in <= not rxpath_common_rst;
  GTRXRESET_in <= rxpath_common_rst;

  --!@brief Wrapper for the GTX channel primitive
  gt0_x0y0 : z7_gtx_evr
    port map (
      SYSCLK_IN                   => i_sys_clk,
      SOFT_RESET_TX_IN            => CPLLRESET_in,
      SOFT_RESET_RX_IN            => rxpath_common_rst,
      DONT_RESET_ON_DATA_ERROR_IN => c_vcc,
      GT0_TX_FSM_RESET_DONE_OUT   => open,
      GT0_RX_FSM_RESET_DONE_OUT   => open,
      GT0_DATA_VALID_IN           => c_vcc,
      gt0_cpllfbclklost_out       => CPLLFBCLKLOST_out,
      gt0_cplllock_out            => CPLLLOCK_out,
      gt0_cplllockdetclk_in       => i_sys_clk,
      gt0_cpllreset_in            => CPLLRESET_in,
      gt0_gtrefclk0_in            => i_gtref0_clk,
      gt0_gtrefclk1_in            => i_gtref1_clk,
      gt0_drpaddr_in              => c_gnd_vec(8 downto 0),
      gt0_drpclk_in               => txusrclk,
      gt0_drpdi_in                => c_gnd_vec(15 downto 0),
      gt0_drpdo_out               => open,
      gt0_drpen_in                => c_gnd,
      gt0_drprdy_out              => open,
      gt0_drpwe_in                => c_gnd,
      gt0_dmonitorout_out         => open,
      gt0_eyescanreset_in         => c_gnd,
      -- See p. 72 [1]
      gt0_rxuserrdy_in            => RXUSERRDY_in,
      gt0_eyescandataerror_out    => open,
      gt0_eyescantrigger_in       => c_gnd,
      gt0_rxusrclk_in             => rxusrclk,
      gt0_rxusrclk2_in            => rxusrclk,
      gt0_rxdata_out              => rxdata_i(15 downto 0),
      gt0_rxdisperr_out           => rx_disperr,
      gt0_rxnotintable_out        => rx_notintable,
      gt0_gtxrxp_in               => RXP,
      gt0_gtxrxn_in               => RXN,
      gt0_rxphmonitor_out         => open,
      gt0_rxphslipmonitor_out     => open,
      gt0_rxdfelpmreset_in        => i_gt_resets.gbl_async,
      gt0_rxmonitorout_out        => open,
      gt0_rxmonitorsel_in         => c_gnd_vec(1 downto 0),
      gt0_rxoutclk_out            => RXOUTCLK_out,
      gt0_rxoutclkfabric_out      => open,
      gt0_gtrxreset_in            => GTRXRESET_in,
      gt0_rxpmareset_in           => RXPMARESET_in,
      gt0_rxslide_in              => c_gnd,
      gt0_rxcharisk_out           => rx_charisk,
      gt0_rxresetdone_out         => RXRESETDONE_out,
      gt0_gttxreset_in            => GTTXRESET_in,
      gt0_txuserrdy_in            => TXUSERRDY_in,
      gt0_txusrclk_in             => txusrclk,
      gt0_txusrclk2_in            => txusrclk,
      gt0_txdata_in               => txdata_i(15 downto 0),
      gt0_gtxtxn_out              => TXN,
      gt0_gtxtxp_out              => TXP,
      gt0_txoutclk_out            => tx_outclk,
      gt0_txoutclkfabric_out      => TXOUTCLKFABRIC_out,
      gt0_txoutclkpcs_out         => TXOUTCLKPCS_out,
      gt0_txcharisk_in            => tx_charisk,
      gt0_txresetdone_out         => TXRESETDONE_out,
      GT0_QPLLOUTCLK_IN           => c_gnd,
      GT0_QPLLOUTREFCLK_IN        => c_gnd);

      EVENT_CLK_o <= i_gtref0_clk; -- Assign output of clock buf back to top

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
      RDCLK => event_clk,
      RDEN => fifo_rden,
      REGCE => c_vcc,
      RST => fifo_rst,
      RSTREG => c_gnd,
      WRCLK => rxusrclk,
      WREN => fifo_wren,
      DI => fifo_di,
      DIP => fifo_dip,
      INJECTDBITERR => c_gnd,
      INJECTSBITERR => c_gnd);

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
      RDCLK => txusrclk,
      RDEN => tx_fifo_rden,
      REGCE => c_vcc,
      RST => tx_fifo_rst,
      RSTREG => c_gnd,
      WRCLK => refclk,
      WREN => tx_fifo_wren,
      DI => tx_fifo_di,
      DIP => tx_fifo_dip);

  RXPMARESET_in <= i_gt_resets.gbl_async;
  TXDLYSRESET_in <= i_gt_resets.gbl_async;

  recclk_out <= rxusrclk;
  REFCLK_OUT <= refclk;
  refclk <= txusrclk;

  fifo_di(63 downto 16) <= (others => '0');
  fifo_di(15 downto 0) <= rx_data;
  fifo_dip(7 downto 4) <= (others => '0');
  fifo_dip(2) <= '0';
  fifo_dip(1 downto 0) <= rx_charisk;

  rx_beacon <= rx_beacon_i;
  rx_int_beacon <= rx_int_beacon_i;
  rx_int_beacon_i <= fifo_dop(3);
  fifo_dip(3) <= rx_beacon_i;

  rx_error_detect: process (rxusrclk)
  begin
    if rising_edge(rxusrclk) then
      if (rx_charisk(0) = '1' and rx_data(7) = '1')
         or rx_disperr /= "00" or rx_notintable /= "00" then
        rx_error <= '1';
      else
        rx_error <= '0';
      end if;
    end if;
  end process;

  rx_error_clk_cross : process (refclk)
    variable rx_error_sync_d : std_logic;
  begin
    if rising_edge(refclk) then
      rx_error_i <= rx_error_sync_d;
      rx_error_sync_d := rx_error;
    end if;
  end process;

  beacon_detect : process (rxusrclk, rx_data, rx_charisk,
    rx_disperr, rx_notintable)
    variable beacon_cnt : std_logic_vector(2 downto 0) := "000";
    variable cnt : std_logic_vector(12 downto 0);
  begin
    if rising_edge(rxusrclk) then
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

  link_ok_detection : process (refclk, link_ok, i_gt_resets.gbl_async, rx_error_i, rx_link_ok_i)
    variable link_ok_delay : std_logic_vector(19 downto 0) := (others => '0');
  begin
    rx_link_ok <= rx_link_ok_i;
    rx_link_ok_i <= link_ok_delay(link_ok_delay'high);
    if rising_edge(refclk) then
      if link_ok_delay(link_ok_delay'high) = '0' then
        link_ok_delay := link_ok_delay + 1;
      end if;
      if i_gt_resets.gbl_async = '1' or link_ok = '0' or rx_error_i = '1' then
        link_ok_delay := (others => '0');
      end if;
    end if;
  end process;

  link_status_testing : process (refclk, i_gt_resets.gbl_async, rx_charisk, link_ok,
                                 rx_disperr, CPLLLOCK_out)
    variable prescaler : std_logic_vector(14 downto 0);
    variable count : std_logic_vector(3 downto 0);
    variable rx_error_sync : std_logic;
    variable rx_error_sync_1 : std_logic;
    variable loss_lock : std_logic;
    variable rx_error_count : std_logic_vector(5 downto 0);
    variable reset_sync : std_logic_vector(1 downto 0);
  begin
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
      if i_gt_resets.gbl_async = '1' or CPLLLOCK_out = '0' then
        reset_sync(1) := '1';
      end if;
    end if;
  end process;

  reg_dbus_data : process (event_clk, rx_link_ok_i, rx_data, databuf_rxd_i, databuf_rx_k_i)
    variable even : std_logic;
  begin
    databuf_rxd <= databuf_rxd_i;
    databuf_rx_k <= databuf_rx_k_i;
    if rising_edge(event_clk) then
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
      event_rxd_i <= fifo_do(15 downto 8);
      if rx_link_ok_i = '0' or fifo_dop(1) = '1' or i_gt_resets.gbl_async = '1' then
        event_rxd_i <= (others => '0');
        even := '0';
      end if;
    end if;
  end process;

  event_rxd <= event_rxd_i;

  rx_data_align_detect : process (rxusrclk, i_gt_resets.gbl_async, rx_charisk, rx_data,
                                  rx_clear_viol)
  begin
    if i_gt_resets.gbl_async = '1' or rx_clear_viol = '1' then
      align_error <= '0';
    elsif rising_edge(rxusrclk) then
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

  violation_detect : process (rxusrclk, rx_clear_viol,
                              rx_disperr, rx_notintable, link_ok)
    variable clrvio : std_logic;
  begin
    if rising_edge(rxusrclk) then
      if rx_disperr /= "00" or rx_notintable /= "00" then
        rx_vio_usrclk <= '1';
      elsif clrvio = '1' then
        rx_vio_usrclk <= '0';
      end if;

      clrvio := rx_clear_viol;
    end if;
  end process;

  rx_data <= rxdata_i(15 downto 0);
  txdata_i <= (c_gnd_vec(47 downto 0) & tx_data);

  -- Priority encoder for the Tx path FSM state transition
  tx_path_fsm_ctrl : process (txusrclk)
    variable control_event_gen : std_logic_vector(1 downto 0) := "00";
  begin
    if rising_edge(txusrclk) then
      if i_gt_resets.gbl_async = '1' then
        tx_path_state <= s_EVENT_EMPTY;
        control_event_gen := "00";
      elsif beacon_cnt(1 downto 0) = "10" and dc_mode = '1' then
        tx_path_state <= s_EVENT_BEACON;
      elsif tx_fifo_rderr = '0' then
        tx_path_state <= s_EVENT_USER;
      elsif control_event_gen = "00" then
        tx_path_state <= s_EVENT_CONTROL;
        tx_beacon_gen <= not tx_beacon_gen;
      elsif tx_beacon_gen = '1' then
        tx_path_state <= s_EVENT_EMPTY;
      else
        tx_path_state <= s_EVENT_EMPTY;
      end if;

      control_event_gen := control_event_gen + 1;
    end if;
  end process;

  transmit_data : process (txusrclk,beacon_cnt,dc_mode,tx_path_state)
    variable cur_state : timing_event;
  begin
    if beacon_cnt(1 downto 0) = "10" and dc_mode = '1' then
      if tx_fifo_empty = '0' then
        tx_fifo_rden <= '0';
      else
        tx_fifo_rden <= '1';
      end if;
    else
      tx_fifo_rden <= '1';
    end if;

    cur_state := tx_path_state;

    case cur_state is
      when s_EVENT_BEACON =>
        tx_data(15 downto 8) <= C_EVENT_BEACON; -- 7E
      when s_EVENT_CONTROL =>
        tx_charisk <= "10";
        tx_data(15 downto 8) <= X"BC"; -- K28.5 character
      when s_EVENT_USER =>
        tx_data(15 downto 8) <= tx_fifo_do(7 downto 0);
        fifo_pend <= '0';
      when s_EVENT_EMPTY =>
        tx_charisk <= "00";
        tx_data(15 downto 8) <= (others => '0');
        tx_beacon <= beacon_cnt(1);
      when others =>
        tx_charisk <= "00";
        tx_data(15 downto 8) <= (others => '0');
    end case;

    if rising_edge(txusrclk) then
      if tx_fifo_empty = '0' then
        fifo_pend <= '1';
      end if;

      tx_data(7 downto 0) <= dbus_txd;
      if tx_beacon_gen = '0' and databuf_tx_mode = '1' then
        tx_data(7 downto 0) <= databuf_txd;
        tx_charisk(0) <= databuf_tx_k;
      end if;
      databuf_tx_ena <= tx_beacon_gen;
      beacon_cnt <= rx_beacon_i & beacon_cnt(beacon_cnt'high downto 1);
      if i_gt_resets.gbl_async = '1' then
        fifo_pend <= '0';
      end if;
    end if;
  end process;

  -- Read and write enables are used to adjust the coarse delay
  -- These can cause data packet corruption and missing events -
  -- thus this method is used only during link training

  fifo_read_enable : process (event_clk, delay_inc)
    variable sr_delay_trig : std_logic_vector(2 downto 0) := "000";
  begin
    if rising_edge(event_clk) then
      fifo_rden <= '1';
      if sr_delay_trig(1 downto 0) = "10" then
        fifo_rden <= '0';
      end if;
      sr_delay_trig := delay_inc & sr_delay_trig(2 downto 1);
    end if;
  end process;

  fifo_write_enable : process (rxusrclk, delay_dec)
    variable sr_delay_trig : std_logic_vector(2 downto 0) := "000";
  begin
    if rising_edge(rxusrclk) then
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
  tx_fifo_rst <= i_gt_resets.gbl_async;

  drpclk <= txusrclk;

  process (drpclk, i_gt_resets.gbl_async, txbufstatus_i, TXUSERRDY_in)
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
            if i_gt_resets.gbl_async = '0' then
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
      if i_gt_resets.gbl_async = '1' or TXUSERRDY_in = '0' then
        ph_state := init;
        phase := (others => '0');
        cnt := (others => '0');
      end if;
    end if;
  end process;

  o_gt_status.tx_fsm_done <= TXRESETDONE_out;
  o_gt_status.rx_fsm_done <= RXRESETDONE_out;
  o_gt_status.pll_locked <= CPLLLOCK_out;
  o_gt_status.fbclk_lost <= CPLLFBCLKLOST_out;
  o_gt_status.rx_data_valid <= not rx_error_i;
  o_gt_status.link_up <= rx_link_ok_i;
  o_gt_status.event_rcv <= '1' when event_rxd_i /= "00" else '0';

end structure;
