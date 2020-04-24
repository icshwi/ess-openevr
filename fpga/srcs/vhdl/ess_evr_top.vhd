 -- =============================================================================
 -- @file   ess_evr_top.vhd
 -- @brief  OpenEVR Top entity supporting the picoZED carrier by Tallinn
 -- -----------------------------------------------------------------------------
 -- @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
 -- @company European Spallation Source ERIC
 -- @date 20200421
 -- @version 0.1
 --
 -- Platform: picoZED 7030
 -- Carrier board:  Tallinn picoZED carrier board (aka FPGA-based IOC) rev. B
 -- Based on the AVNET xdc file for the picozed 7z030 RevC v2
 -- =============================================================================


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.evr_pkg.ALL;

entity ess_evr_top is
  Port (
    -- Global logic clock
    i_ZYNQ_MRCC_LVDS_P : in std_logic;
    i_ZYNQ_MRCC_LVDS_N : in std_logic;

    -- MGT reference clock 0
    i_ZYNQ_CLKREF0_P : in std_logic;
    i_ZYNQ_CLKREF0_N : in std_logic;

    -- SFP Tx&Rx lines
    o_EVR_TX_P     : out std_logic;
    o_EVR_TX_N     : out std_logic;
    i_EVR_RX_P     : in std_logic;
    i_EVR_RX_N     : in std_logic;

    -- SFP LEDs
    o_EVR_LINK_LED : out std_logic;
    o_EVR_EVNT_LED : out std_logic
    );
end ess_evr_top;

architecture rtl of ess_evr_top is

  signal gnd     : std_logic := '0';
  signal vcc     : std_logic := '1';

  signal clk_sys : std_logic;
  signal clk_sys_buff : std_logic;
  signal sys_reset : std_logic;

  signal refclk  : std_logic;
  signal event_clk : std_logic;

  signal dc_mode : std_logic := '1';

  signal tx_reset : std_logic;

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
  signal delay_comp_target  : std_logic_vector(31 downto 0) := x"02100000";

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

  signal topology_addr       : std_logic_vector(31 downto 0);

  signal local_clk           : std_logic := '0';
  signal transceiver_reset   : std_logic := '0';

begin

  clk_sys_bufds : IBUFDS
    generic map (
      DIFF_TERM => FALSE,
      IBUF_LOW_PWR => FALSE,
      IOSTANDARD => "LVDS_25")
    port map (
      O => clk_sys_buff,
      I => i_ZYNQ_MRCC_LVDS_P,
      IB => i_ZYNQ_MRCC_LVDS_N);

  clk_sys_buf : BUFG
    port map (
      O => clk_sys,
      I => clk_sys_buff);

  evr_mtp_wrapper : evr_dc
    generic map (
      RX_POLARITY => '0',
      TX_POLARITY => '0',
      refclksel => '1')
    port map (
      sys_clk => clk_sys,
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

      MGTREFCLK0_P => gnd,
      MGTREFCLK0_N => gnd,
      MGTREFCLK1_P => i_ZYNQ_CLKREF0_P,
      MGTREFCLK1_N => i_ZYNQ_CLKREF0_N,

      MGTRX2_N => i_EVR_RX_N,
      MGTRX2_P => i_EVR_RX_P,

      MGTTX2_N => o_EVR_TX_N,
      MGTTX2_P => o_EVR_TX_P);

  databuf_dc : databuf_rx_dc
    port map (
      data_out => databuf_dc_data_out,
      size_data_out => databuf_dc_size_out,
      addr_in(10 downto 2) => databuf_dc_addr,
      clk => clk_sys,

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

  dbus_txd <= X"00";
  databuf_txd <= X"00";
  databuf_tx_k <= '0';

  -- Reset signal for the Transceiver ---------------

  -- Generate a low speed clock from the sys clock
  -- clk_sys = 11 ns * 8 = 88 ns period / 50% duty cycle
  local_clk_scaler : process (clk_sys)
    variable scaler : unsigned(2 downto 0) := "000";
  begin
    if rising_edge(clk_sys) then
      if scaler < "100" then
        local_clk <= '1';
      else
        local_clk <= '0';
      end if;

      scaler := scaler + "001";
    end if;
  end process local_clk_scaler;

  -- Wait for 6 cycles of the local_clk after GSR, then
  -- assert the reset signal for 1 period
  gtx_reset : process (local_clk)
    variable count : unsigned(2 downto 0) := "000";
  begin
    if rising_edge(local_clk) then
      if count <= "101" then
        transceiver_reset <= '0';
        count := count + "001";
      elsif count <= "110" then
        transceiver_reset <= '1';
        count := count + "001";
      else
        transceiver_reset <= '0';
      end if;
    end if;
  end process gtx_reset;


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

  --TODO: chose a good source to drive the reset signals
  sys_reset <= '0';

  --TODO: drive the LEDs from a meaningful source
  o_EVR_LINK_LED <= '0';
  o_EVR_EVNT_LED <= '0';



  -- process (clk_sys)
  --   variable count : std_logic_vector(31 downto 0) := X"FFFFFFFF";
  -- begin
  --   if rising_edge(clk_sys) then
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
