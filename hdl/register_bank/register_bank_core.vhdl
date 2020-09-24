--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_core.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-12
-- Last update : 2018-05-24
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : Collection of the register fields belonging to the register
--               bank.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-05-24  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ESS_openEVR_RegMap;
use ESS_openEVR_RegMap.register_bank_config.all;
use ESS_openEVR_RegMap.register_bank_functions.all;
use ESS_openEVR_RegMap.register_bank_components.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity register_bank_core  is
  port (
    clock_i          : in  std_logic;                                           --! The system clock that is a multiple of the ADC clock
    reset_n_i        : in  std_logic;                                           --! Low active reset signal

    write_en_i       : in  field_write_en_t;                                    --! Record of write enable signals, one for each register
    bus_write_data_i : in  field_data_t;                                        --! Write data from the data bus
    current_data_o   : out field_data_t;                                        --! Output of all the register values that can be read
    logic_to_bus_o   : out field_data_t;

    logic_data_o     : out logic_read_data_t;                                   --! Output values of the registers and register parts towards the logic
    logic_return_i   : in  logic_return_t                                       --! Return values of the registers and register parts from the logic
  );

  attribute dont_touch : string;
  attribute dont_touch of register_bank_core : entity is "true";

end entity register_bank_core;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
architecture rtl of register_bank_core is
begin

    -- Register: Status
    field_Status : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => '0',
      bus_write_data_i => bus_write_data_i.Status,
      field_value_o    => current_data_o.Status,
      logic_to_bus_o   => logic_to_bus_o.Status,
      logic_data_o     => open,
      logic_return_i   => logic_return_i.Status
    );

    -- Register: Control
    field_Control : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Control,
      bus_write_data_i => bus_write_data_i.Control,
      field_value_o    => current_data_o.Control,
      logic_to_bus_o   => logic_to_bus_o.Control,
      logic_data_o     => logic_data_o.Control,
      logic_return_i   => logic_return_i.Control
    );

    -- Register: IrqFlag
    field_IrqFlag : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.IrqFlag,
      bus_write_data_i => bus_write_data_i.IrqFlag,
      field_value_o    => current_data_o.IrqFlag,
      logic_to_bus_o   => logic_to_bus_o.IrqFlag,
      logic_data_o     => logic_data_o.IrqFlag,
      logic_return_i   => logic_return_i.IrqFlag
    );

    -- Register: IrqEnable
    field_IrqEnable : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.IrqEnable,
      bus_write_data_i => bus_write_data_i.IrqEnable,
      field_value_o    => current_data_o.IrqEnable,
      logic_to_bus_o   => logic_to_bus_o.IrqEnable,
      logic_data_o     => logic_data_o.IrqEnable,
      logic_return_i   => logic_return_i.IrqEnable
    );

    -- Register: PulseIrqMap
    field_PulseIrqMap : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PulseIrqMap,
      bus_write_data_i => bus_write_data_i.PulseIrqMap,
      field_value_o    => current_data_o.PulseIrqMap,
      logic_to_bus_o   => logic_to_bus_o.PulseIrqMap,
      logic_data_o     => logic_data_o.PulseIrqMap,
      logic_return_i   => logic_return_i.PulseIrqMap
    );

    -- Register: SWEvent
    field_SWEvent : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.SWEvent,
      bus_write_data_i => bus_write_data_i.SWEvent,
      field_value_o    => current_data_o.SWEvent,
      logic_to_bus_o   => logic_to_bus_o.SWEvent,
      logic_data_o     => logic_data_o.SWEvent,
      logic_return_i   => logic_return_i.SWEvent
    );

    -- Register: DataBufCtrl
    field_DataBufCtrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DataBufCtrl,
      bus_write_data_i => bus_write_data_i.DataBufCtrl,
      field_value_o    => current_data_o.DataBufCtrl,
      logic_to_bus_o   => logic_to_bus_o.DataBufCtrl,
      logic_data_o     => logic_data_o.DataBufCtrl,
      logic_return_i   => logic_return_i.DataBufCtrl
    );

    -- Register: TXDataBufCtrl
    field_TXDataBufCtrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.TXDataBufCtrl,
      bus_write_data_i => bus_write_data_i.TXDataBufCtrl,
      field_value_o    => current_data_o.TXDataBufCtrl,
      logic_to_bus_o   => logic_to_bus_o.TXDataBufCtrl,
      logic_data_o     => logic_data_o.TXDataBufCtrl,
      logic_return_i   => logic_return_i.TXDataBufCtrl
    );

    -- Register: TxSegBufCtrl
    field_TxSegBufCtrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.TxSegBufCtrl,
      bus_write_data_i => bus_write_data_i.TxSegBufCtrl,
      field_value_o    => current_data_o.TxSegBufCtrl,
      logic_to_bus_o   => logic_to_bus_o.TxSegBufCtrl,
      logic_data_o     => logic_data_o.TxSegBufCtrl,
      logic_return_i   => logic_return_i.TxSegBufCtrl
    );

    -- Register: FWVersion
    field_FWVersion : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => '0',
      bus_write_data_i => bus_write_data_i.FWVersion,
      field_value_o    => current_data_o.FWVersion,
      logic_to_bus_o   => logic_to_bus_o.FWVersion,
      logic_data_o     => open,
      logic_return_i   => logic_return_i.FWVersion
    );

    -- Register: EvCntPresc
    field_EvCntPresc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.EvCntPresc,
      bus_write_data_i => bus_write_data_i.EvCntPresc,
      field_value_o    => current_data_o.EvCntPresc,
      logic_to_bus_o   => logic_to_bus_o.EvCntPresc,
      logic_data_o     => logic_data_o.EvCntPresc,
      logic_return_i   => logic_return_i.EvCntPresc
    );

    -- Register: UsecDivider
    field_UsecDivider : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.UsecDivider,
      bus_write_data_i => bus_write_data_i.UsecDivider,
      field_value_o    => current_data_o.UsecDivider,
      logic_to_bus_o   => logic_to_bus_o.UsecDivider,
      logic_data_o     => logic_data_o.UsecDivider,
      logic_return_i   => logic_return_i.UsecDivider
    );

    -- Register: ClockControl
    field_ClockControl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.ClockControl,
      bus_write_data_i => bus_write_data_i.ClockControl,
      field_value_o    => current_data_o.ClockControl,
      logic_to_bus_o   => logic_to_bus_o.ClockControl,
      logic_data_o     => logic_data_o.ClockControl,
      logic_return_i   => logic_return_i.ClockControl
    );

    -- Register: SecSR
    field_SecSR : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.SecSR,
      bus_write_data_i => bus_write_data_i.SecSR,
      field_value_o    => current_data_o.SecSR,
      logic_to_bus_o   => logic_to_bus_o.SecSR,
      logic_data_o     => logic_data_o.SecSR,
      logic_return_i   => logic_return_i.SecSR
    );

    -- Register: SecCounter
    field_SecCounter : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.SecCounter,
      bus_write_data_i => bus_write_data_i.SecCounter,
      field_value_o    => current_data_o.SecCounter,
      logic_to_bus_o   => logic_to_bus_o.SecCounter,
      logic_data_o     => logic_data_o.SecCounter,
      logic_return_i   => logic_return_i.SecCounter
    );

    -- Register: EventCounter
    field_EventCounter : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.EventCounter,
      bus_write_data_i => bus_write_data_i.EventCounter,
      field_value_o    => current_data_o.EventCounter,
      logic_to_bus_o   => logic_to_bus_o.EventCounter,
      logic_data_o     => logic_data_o.EventCounter,
      logic_return_i   => logic_return_i.EventCounter
    );

    -- Register: SecLatch
    field_SecLatch : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.SecLatch,
      bus_write_data_i => bus_write_data_i.SecLatch,
      field_value_o    => current_data_o.SecLatch,
      logic_to_bus_o   => logic_to_bus_o.SecLatch,
      logic_data_o     => logic_data_o.SecLatch,
      logic_return_i   => logic_return_i.SecLatch
    );

    -- Register: EvCntLatch
    field_EvCntLatch : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.EvCntLatch,
      bus_write_data_i => bus_write_data_i.EvCntLatch,
      field_value_o    => current_data_o.EvCntLatch,
      logic_to_bus_o   => logic_to_bus_o.EvCntLatch,
      logic_data_o     => logic_data_o.EvCntLatch,
      logic_return_i   => logic_return_i.EvCntLatch
    );

    -- Register: EvFIFOSec
    field_EvFIFOSec : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.EvFIFOSec,
      bus_write_data_i => bus_write_data_i.EvFIFOSec,
      field_value_o    => current_data_o.EvFIFOSec,
      logic_to_bus_o   => logic_to_bus_o.EvFIFOSec,
      logic_data_o     => logic_data_o.EvFIFOSec,
      logic_return_i   => logic_return_i.EvFIFOSec
    );

    -- Register: EvFIFOEvCnt
    field_EvFIFOEvCnt : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.EvFIFOEvCnt,
      bus_write_data_i => bus_write_data_i.EvFIFOEvCnt,
      field_value_o    => current_data_o.EvFIFOEvCnt,
      logic_to_bus_o   => logic_to_bus_o.EvFIFOEvCnt,
      logic_data_o     => logic_data_o.EvFIFOEvCnt,
      logic_return_i   => logic_return_i.EvFIFOEvCnt
    );

    -- Register: EvFIFOCode
    field_EvFIFOCode : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.EvFIFOCode,
      bus_write_data_i => bus_write_data_i.EvFIFOCode,
      field_value_o    => current_data_o.EvFIFOCode,
      logic_to_bus_o   => logic_to_bus_o.EvFIFOCode,
      logic_data_o     => logic_data_o.EvFIFOCode,
      logic_return_i   => logic_return_i.EvFIFOCode
    );

    -- Register: LogStatus
    field_LogStatus : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => '0',
      bus_write_data_i => bus_write_data_i.LogStatus,
      field_value_o    => current_data_o.LogStatus,
      logic_to_bus_o   => logic_to_bus_o.LogStatus,
      logic_data_o     => open,
      logic_return_i   => logic_return_i.LogStatus
    );

    -- Register: GPIODir
    field_GPIODir : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.GPIODir,
      bus_write_data_i => bus_write_data_i.GPIODir,
      field_value_o    => current_data_o.GPIODir,
      logic_to_bus_o   => logic_to_bus_o.GPIODir,
      logic_data_o     => logic_data_o.GPIODir,
      logic_return_i   => logic_return_i.GPIODir
    );

    -- Register: GPIOIn
    field_GPIOIn : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.GPIOIn,
      bus_write_data_i => bus_write_data_i.GPIOIn,
      field_value_o    => current_data_o.GPIOIn,
      logic_to_bus_o   => logic_to_bus_o.GPIOIn,
      logic_data_o     => logic_data_o.GPIOIn,
      logic_return_i   => logic_return_i.GPIOIn
    );

    -- Register: GPIOOut
    field_GPIOOut : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.GPIOOut,
      bus_write_data_i => bus_write_data_i.GPIOOut,
      field_value_o    => current_data_o.GPIOOut,
      logic_to_bus_o   => logic_to_bus_o.GPIOOut,
      logic_data_o     => logic_data_o.GPIOOut,
      logic_return_i   => logic_return_i.GPIOOut
    );

    -- Register: DCTarget
    field_DCTarget : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#02100000#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DCTarget,
      bus_write_data_i => bus_write_data_i.DCTarget,
      field_value_o    => current_data_o.DCTarget,
      logic_to_bus_o   => logic_to_bus_o.DCTarget,
      logic_data_o     => logic_data_o.DCTarget,
      logic_return_i   => logic_return_i.DCTarget
    );

    -- Register: DCRxValue
    field_DCRxValue : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DCRxValue,
      bus_write_data_i => bus_write_data_i.DCRxValue,
      field_value_o    => current_data_o.DCRxValue,
      logic_to_bus_o   => logic_to_bus_o.DCRxValue,
      logic_data_o     => logic_data_o.DCRxValue,
      logic_return_i   => logic_return_i.DCRxValue
    );

    -- Register: DCIntValue
    field_DCIntValue : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DCIntValue,
      bus_write_data_i => bus_write_data_i.DCIntValue,
      field_value_o    => current_data_o.DCIntValue,
      logic_to_bus_o   => logic_to_bus_o.DCIntValue,
      logic_data_o     => logic_data_o.DCIntValue,
      logic_return_i   => logic_return_i.DCIntValue
    );

    -- Register: DCStatus
    field_DCStatus : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => '0',
      bus_write_data_i => bus_write_data_i.DCStatus,
      field_value_o    => current_data_o.DCStatus,
      logic_to_bus_o   => logic_to_bus_o.DCStatus,
      logic_data_o     => open,
      logic_return_i   => logic_return_i.DCStatus
    );

    -- Register: TopologyID
    field_TopologyID : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.TopologyID,
      bus_write_data_i => bus_write_data_i.TopologyID,
      field_value_o    => current_data_o.TopologyID,
      logic_to_bus_o   => logic_to_bus_o.TopologyID,
      logic_data_o     => logic_data_o.TopologyID,
      logic_return_i   => logic_return_i.TopologyID
    );

    -- Register: SeqRamCtrl
    field_SeqRamCtrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.SeqRamCtrl,
      bus_write_data_i => bus_write_data_i.SeqRamCtrl,
      field_value_o    => current_data_o.SeqRamCtrl,
      logic_to_bus_o   => logic_to_bus_o.SeqRamCtrl,
      logic_data_o     => logic_data_o.SeqRamCtrl,
      logic_return_i   => logic_return_i.SeqRamCtrl
    );

    -- Register: Prescaler0
    field_Prescaler0 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Prescaler0,
      bus_write_data_i => bus_write_data_i.Prescaler0,
      field_value_o    => current_data_o.Prescaler0,
      logic_to_bus_o   => logic_to_bus_o.Prescaler0,
      logic_data_o     => logic_data_o.Prescaler0,
      logic_return_i   => logic_return_i.Prescaler0
    );

    -- Register: Prescaler1
    field_Prescaler1 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Prescaler1,
      bus_write_data_i => bus_write_data_i.Prescaler1,
      field_value_o    => current_data_o.Prescaler1,
      logic_to_bus_o   => logic_to_bus_o.Prescaler1,
      logic_data_o     => logic_data_o.Prescaler1,
      logic_return_i   => logic_return_i.Prescaler1
    );

    -- Register: Prescaler2
    field_Prescaler2 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Prescaler2,
      bus_write_data_i => bus_write_data_i.Prescaler2,
      field_value_o    => current_data_o.Prescaler2,
      logic_to_bus_o   => logic_to_bus_o.Prescaler2,
      logic_data_o     => logic_data_o.Prescaler2,
      logic_return_i   => logic_return_i.Prescaler2
    );

    -- Register: Prescaler3
    field_Prescaler3 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Prescaler3,
      bus_write_data_i => bus_write_data_i.Prescaler3,
      field_value_o    => current_data_o.Prescaler3,
      logic_to_bus_o   => logic_to_bus_o.Prescaler3,
      logic_data_o     => logic_data_o.Prescaler3,
      logic_return_i   => logic_return_i.Prescaler3
    );

    -- Register: Prescaler4
    field_Prescaler4 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Prescaler4,
      bus_write_data_i => bus_write_data_i.Prescaler4,
      field_value_o    => current_data_o.Prescaler4,
      logic_to_bus_o   => logic_to_bus_o.Prescaler4,
      logic_data_o     => logic_data_o.Prescaler4,
      logic_return_i   => logic_return_i.Prescaler4
    );

    -- Register: Prescaler5
    field_Prescaler5 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Prescaler5,
      bus_write_data_i => bus_write_data_i.Prescaler5,
      field_value_o    => current_data_o.Prescaler5,
      logic_to_bus_o   => logic_to_bus_o.Prescaler5,
      logic_data_o     => logic_data_o.Prescaler5,
      logic_return_i   => logic_return_i.Prescaler5
    );

    -- Register: Prescaler6
    field_Prescaler6 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Prescaler6,
      bus_write_data_i => bus_write_data_i.Prescaler6,
      field_value_o    => current_data_o.Prescaler6,
      logic_to_bus_o   => logic_to_bus_o.Prescaler6,
      logic_data_o     => logic_data_o.Prescaler6,
      logic_return_i   => logic_return_i.Prescaler6
    );

    -- Register: Prescaler7
    field_Prescaler7 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Prescaler7,
      bus_write_data_i => bus_write_data_i.Prescaler7,
      field_value_o    => current_data_o.Prescaler7,
      logic_to_bus_o   => logic_to_bus_o.Prescaler7,
      logic_data_o     => logic_data_o.Prescaler7,
      logic_return_i   => logic_return_i.Prescaler7
    );

    -- Register: PrescPhase0
    field_PrescPhase0 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescPhase0,
      bus_write_data_i => bus_write_data_i.PrescPhase0,
      field_value_o    => current_data_o.PrescPhase0,
      logic_to_bus_o   => logic_to_bus_o.PrescPhase0,
      logic_data_o     => logic_data_o.PrescPhase0,
      logic_return_i   => logic_return_i.PrescPhase0
    );

    -- Register: PrescPhase1
    field_PrescPhase1 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescPhase1,
      bus_write_data_i => bus_write_data_i.PrescPhase1,
      field_value_o    => current_data_o.PrescPhase1,
      logic_to_bus_o   => logic_to_bus_o.PrescPhase1,
      logic_data_o     => logic_data_o.PrescPhase1,
      logic_return_i   => logic_return_i.PrescPhase1
    );

    -- Register: PrescPhase2
    field_PrescPhase2 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescPhase2,
      bus_write_data_i => bus_write_data_i.PrescPhase2,
      field_value_o    => current_data_o.PrescPhase2,
      logic_to_bus_o   => logic_to_bus_o.PrescPhase2,
      logic_data_o     => logic_data_o.PrescPhase2,
      logic_return_i   => logic_return_i.PrescPhase2
    );

    -- Register: PrescPhase3
    field_PrescPhase3 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescPhase3,
      bus_write_data_i => bus_write_data_i.PrescPhase3,
      field_value_o    => current_data_o.PrescPhase3,
      logic_to_bus_o   => logic_to_bus_o.PrescPhase3,
      logic_data_o     => logic_data_o.PrescPhase3,
      logic_return_i   => logic_return_i.PrescPhase3
    );

    -- Register: PrescPhase4
    field_PrescPhase4 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescPhase4,
      bus_write_data_i => bus_write_data_i.PrescPhase4,
      field_value_o    => current_data_o.PrescPhase4,
      logic_to_bus_o   => logic_to_bus_o.PrescPhase4,
      logic_data_o     => logic_data_o.PrescPhase4,
      logic_return_i   => logic_return_i.PrescPhase4
    );

    -- Register: PrescPhase5
    field_PrescPhase5 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescPhase5,
      bus_write_data_i => bus_write_data_i.PrescPhase5,
      field_value_o    => current_data_o.PrescPhase5,
      logic_to_bus_o   => logic_to_bus_o.PrescPhase5,
      logic_data_o     => logic_data_o.PrescPhase5,
      logic_return_i   => logic_return_i.PrescPhase5
    );

    -- Register: PrescPhase6
    field_PrescPhase6 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescPhase6,
      bus_write_data_i => bus_write_data_i.PrescPhase6,
      field_value_o    => current_data_o.PrescPhase6,
      logic_to_bus_o   => logic_to_bus_o.PrescPhase6,
      logic_data_o     => logic_data_o.PrescPhase6,
      logic_return_i   => logic_return_i.PrescPhase6
    );

    -- Register: PrescPhase7
    field_PrescPhase7 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescPhase7,
      bus_write_data_i => bus_write_data_i.PrescPhase7,
      field_value_o    => current_data_o.PrescPhase7,
      logic_to_bus_o   => logic_to_bus_o.PrescPhase7,
      logic_data_o     => logic_data_o.PrescPhase7,
      logic_return_i   => logic_return_i.PrescPhase7
    );

    -- Register: PrescTrig0
    field_PrescTrig0 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescTrig0,
      bus_write_data_i => bus_write_data_i.PrescTrig0,
      field_value_o    => current_data_o.PrescTrig0,
      logic_to_bus_o   => logic_to_bus_o.PrescTrig0,
      logic_data_o     => logic_data_o.PrescTrig0,
      logic_return_i   => logic_return_i.PrescTrig0
    );

    -- Register: PrescTrig1
    field_PrescTrig1 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescTrig1,
      bus_write_data_i => bus_write_data_i.PrescTrig1,
      field_value_o    => current_data_o.PrescTrig1,
      logic_to_bus_o   => logic_to_bus_o.PrescTrig1,
      logic_data_o     => logic_data_o.PrescTrig1,
      logic_return_i   => logic_return_i.PrescTrig1
    );

    -- Register: PrescTrig2
    field_PrescTrig2 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescTrig2,
      bus_write_data_i => bus_write_data_i.PrescTrig2,
      field_value_o    => current_data_o.PrescTrig2,
      logic_to_bus_o   => logic_to_bus_o.PrescTrig2,
      logic_data_o     => logic_data_o.PrescTrig2,
      logic_return_i   => logic_return_i.PrescTrig2
    );

    -- Register: PrescTrig3
    field_PrescTrig3 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescTrig3,
      bus_write_data_i => bus_write_data_i.PrescTrig3,
      field_value_o    => current_data_o.PrescTrig3,
      logic_to_bus_o   => logic_to_bus_o.PrescTrig3,
      logic_data_o     => logic_data_o.PrescTrig3,
      logic_return_i   => logic_return_i.PrescTrig3
    );

    -- Register: PrescTrig4
    field_PrescTrig4 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescTrig4,
      bus_write_data_i => bus_write_data_i.PrescTrig4,
      field_value_o    => current_data_o.PrescTrig4,
      logic_to_bus_o   => logic_to_bus_o.PrescTrig4,
      logic_data_o     => logic_data_o.PrescTrig4,
      logic_return_i   => logic_return_i.PrescTrig4
    );

    -- Register: PrescTrig5
    field_PrescTrig5 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescTrig5,
      bus_write_data_i => bus_write_data_i.PrescTrig5,
      field_value_o    => current_data_o.PrescTrig5,
      logic_to_bus_o   => logic_to_bus_o.PrescTrig5,
      logic_data_o     => logic_data_o.PrescTrig5,
      logic_return_i   => logic_return_i.PrescTrig5
    );

    -- Register: PrescTrig6
    field_PrescTrig6 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescTrig6,
      bus_write_data_i => bus_write_data_i.PrescTrig6,
      field_value_o    => current_data_o.PrescTrig6,
      logic_to_bus_o   => logic_to_bus_o.PrescTrig6,
      logic_data_o     => logic_data_o.PrescTrig6,
      logic_return_i   => logic_return_i.PrescTrig6
    );

    -- Register: PrescTrig7
    field_PrescTrig7 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.PrescTrig7,
      bus_write_data_i => bus_write_data_i.PrescTrig7,
      field_value_o    => current_data_o.PrescTrig7,
      logic_to_bus_o   => logic_to_bus_o.PrescTrig7,
      logic_data_o     => logic_data_o.PrescTrig7,
      logic_return_i   => logic_return_i.PrescTrig7
    );

    -- Register: DBusTrig0
    field_DBusTrig0 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DBusTrig0,
      bus_write_data_i => bus_write_data_i.DBusTrig0,
      field_value_o    => current_data_o.DBusTrig0,
      logic_to_bus_o   => logic_to_bus_o.DBusTrig0,
      logic_data_o     => logic_data_o.DBusTrig0,
      logic_return_i   => logic_return_i.DBusTrig0
    );

    -- Register: DBusTrig1
    field_DBusTrig1 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DBusTrig1,
      bus_write_data_i => bus_write_data_i.DBusTrig1,
      field_value_o    => current_data_o.DBusTrig1,
      logic_to_bus_o   => logic_to_bus_o.DBusTrig1,
      logic_data_o     => logic_data_o.DBusTrig1,
      logic_return_i   => logic_return_i.DBusTrig1
    );

    -- Register: DBusTrig2
    field_DBusTrig2 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DBusTrig2,
      bus_write_data_i => bus_write_data_i.DBusTrig2,
      field_value_o    => current_data_o.DBusTrig2,
      logic_to_bus_o   => logic_to_bus_o.DBusTrig2,
      logic_data_o     => logic_data_o.DBusTrig2,
      logic_return_i   => logic_return_i.DBusTrig2
    );

    -- Register: DBusTrig3
    field_DBusTrig3 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DBusTrig3,
      bus_write_data_i => bus_write_data_i.DBusTrig3,
      field_value_o    => current_data_o.DBusTrig3,
      logic_to_bus_o   => logic_to_bus_o.DBusTrig3,
      logic_data_o     => logic_data_o.DBusTrig3,
      logic_return_i   => logic_return_i.DBusTrig3
    );

    -- Register: DBusTrig4
    field_DBusTrig4 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DBusTrig4,
      bus_write_data_i => bus_write_data_i.DBusTrig4,
      field_value_o    => current_data_o.DBusTrig4,
      logic_to_bus_o   => logic_to_bus_o.DBusTrig4,
      logic_data_o     => logic_data_o.DBusTrig4,
      logic_return_i   => logic_return_i.DBusTrig4
    );

    -- Register: DBusTrig5
    field_DBusTrig5 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DBusTrig5,
      bus_write_data_i => bus_write_data_i.DBusTrig5,
      field_value_o    => current_data_o.DBusTrig5,
      logic_to_bus_o   => logic_to_bus_o.DBusTrig5,
      logic_data_o     => logic_data_o.DBusTrig5,
      logic_return_i   => logic_return_i.DBusTrig5
    );

    -- Register: DBusTrig6
    field_DBusTrig6 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DBusTrig6,
      bus_write_data_i => bus_write_data_i.DBusTrig6,
      field_value_o    => current_data_o.DBusTrig6,
      logic_to_bus_o   => logic_to_bus_o.DBusTrig6,
      logic_data_o     => logic_data_o.DBusTrig6,
      logic_return_i   => logic_return_i.DBusTrig6
    );

    -- Register: DBusTrig7
    field_DBusTrig7 : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.DBusTrig7,
      bus_write_data_i => bus_write_data_i.DBusTrig7,
      field_value_o    => current_data_o.DBusTrig7,
      logic_to_bus_o   => logic_to_bus_o.DBusTrig7,
      logic_data_o     => logic_data_o.DBusTrig7,
      logic_return_i   => logic_return_i.DBusTrig7
    );

    -- Register: Pulse0Ctrl
    field_Pulse0Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse0Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse0Ctrl,
      field_value_o    => current_data_o.Pulse0Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse0Ctrl,
      logic_data_o     => logic_data_o.Pulse0Ctrl,
      logic_return_i   => logic_return_i.Pulse0Ctrl
    );

    -- Register: Pulse0Presc
    field_Pulse0Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse0Presc,
      bus_write_data_i => bus_write_data_i.Pulse0Presc,
      field_value_o    => current_data_o.Pulse0Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse0Presc,
      logic_data_o     => logic_data_o.Pulse0Presc,
      logic_return_i   => logic_return_i.Pulse0Presc
    );

    -- Register: Pulse0Delay
    field_Pulse0Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse0Delay,
      bus_write_data_i => bus_write_data_i.Pulse0Delay,
      field_value_o    => current_data_o.Pulse0Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse0Delay,
      logic_data_o     => logic_data_o.Pulse0Delay,
      logic_return_i   => logic_return_i.Pulse0Delay
    );

    -- Register: Pulse0Width
    field_Pulse0Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse0Width,
      bus_write_data_i => bus_write_data_i.Pulse0Width,
      field_value_o    => current_data_o.Pulse0Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse0Width,
      logic_data_o     => logic_data_o.Pulse0Width,
      logic_return_i   => logic_return_i.Pulse0Width
    );

    -- Register: Pulse1Ctrl
    field_Pulse1Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse1Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse1Ctrl,
      field_value_o    => current_data_o.Pulse1Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse1Ctrl,
      logic_data_o     => logic_data_o.Pulse1Ctrl,
      logic_return_i   => logic_return_i.Pulse1Ctrl
    );

    -- Register: Pulse1Presc
    field_Pulse1Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse1Presc,
      bus_write_data_i => bus_write_data_i.Pulse1Presc,
      field_value_o    => current_data_o.Pulse1Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse1Presc,
      logic_data_o     => logic_data_o.Pulse1Presc,
      logic_return_i   => logic_return_i.Pulse1Presc
    );

    -- Register: Pulse1Delay
    field_Pulse1Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse1Delay,
      bus_write_data_i => bus_write_data_i.Pulse1Delay,
      field_value_o    => current_data_o.Pulse1Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse1Delay,
      logic_data_o     => logic_data_o.Pulse1Delay,
      logic_return_i   => logic_return_i.Pulse1Delay
    );

    -- Register: Pulse1Width
    field_Pulse1Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse1Width,
      bus_write_data_i => bus_write_data_i.Pulse1Width,
      field_value_o    => current_data_o.Pulse1Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse1Width,
      logic_data_o     => logic_data_o.Pulse1Width,
      logic_return_i   => logic_return_i.Pulse1Width
    );

    -- Register: Pulse2Ctrl
    field_Pulse2Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse2Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse2Ctrl,
      field_value_o    => current_data_o.Pulse2Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse2Ctrl,
      logic_data_o     => logic_data_o.Pulse2Ctrl,
      logic_return_i   => logic_return_i.Pulse2Ctrl
    );

    -- Register: Pulse2Presc
    field_Pulse2Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse2Presc,
      bus_write_data_i => bus_write_data_i.Pulse2Presc,
      field_value_o    => current_data_o.Pulse2Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse2Presc,
      logic_data_o     => logic_data_o.Pulse2Presc,
      logic_return_i   => logic_return_i.Pulse2Presc
    );

    -- Register: Pulse2Delay
    field_Pulse2Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse2Delay,
      bus_write_data_i => bus_write_data_i.Pulse2Delay,
      field_value_o    => current_data_o.Pulse2Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse2Delay,
      logic_data_o     => logic_data_o.Pulse2Delay,
      logic_return_i   => logic_return_i.Pulse2Delay
    );

    -- Register: Pulse2Width
    field_Pulse2Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse2Width,
      bus_write_data_i => bus_write_data_i.Pulse2Width,
      field_value_o    => current_data_o.Pulse2Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse2Width,
      logic_data_o     => logic_data_o.Pulse2Width,
      logic_return_i   => logic_return_i.Pulse2Width
    );

    -- Register: Pulse3Ctrl
    field_Pulse3Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse3Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse3Ctrl,
      field_value_o    => current_data_o.Pulse3Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse3Ctrl,
      logic_data_o     => logic_data_o.Pulse3Ctrl,
      logic_return_i   => logic_return_i.Pulse3Ctrl
    );

    -- Register: Pulse3Presc
    field_Pulse3Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse3Presc,
      bus_write_data_i => bus_write_data_i.Pulse3Presc,
      field_value_o    => current_data_o.Pulse3Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse3Presc,
      logic_data_o     => logic_data_o.Pulse3Presc,
      logic_return_i   => logic_return_i.Pulse3Presc
    );

    -- Register: Pulse3Delay
    field_Pulse3Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse3Delay,
      bus_write_data_i => bus_write_data_i.Pulse3Delay,
      field_value_o    => current_data_o.Pulse3Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse3Delay,
      logic_data_o     => logic_data_o.Pulse3Delay,
      logic_return_i   => logic_return_i.Pulse3Delay
    );

    -- Register: Pulse3Width
    field_Pulse3Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse3Width,
      bus_write_data_i => bus_write_data_i.Pulse3Width,
      field_value_o    => current_data_o.Pulse3Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse3Width,
      logic_data_o     => logic_data_o.Pulse3Width,
      logic_return_i   => logic_return_i.Pulse3Width
    );

    -- Register: Pulse4Ctrl
    field_Pulse4Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse4Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse4Ctrl,
      field_value_o    => current_data_o.Pulse4Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse4Ctrl,
      logic_data_o     => logic_data_o.Pulse4Ctrl,
      logic_return_i   => logic_return_i.Pulse4Ctrl
    );

    -- Register: Pulse4Presc
    field_Pulse4Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse4Presc,
      bus_write_data_i => bus_write_data_i.Pulse4Presc,
      field_value_o    => current_data_o.Pulse4Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse4Presc,
      logic_data_o     => logic_data_o.Pulse4Presc,
      logic_return_i   => logic_return_i.Pulse4Presc
    );

    -- Register: Pulse4Delay
    field_Pulse4Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse4Delay,
      bus_write_data_i => bus_write_data_i.Pulse4Delay,
      field_value_o    => current_data_o.Pulse4Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse4Delay,
      logic_data_o     => logic_data_o.Pulse4Delay,
      logic_return_i   => logic_return_i.Pulse4Delay
    );

    -- Register: Pulse4Width
    field_Pulse4Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse4Width,
      bus_write_data_i => bus_write_data_i.Pulse4Width,
      field_value_o    => current_data_o.Pulse4Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse4Width,
      logic_data_o     => logic_data_o.Pulse4Width,
      logic_return_i   => logic_return_i.Pulse4Width
    );

    -- Register: Pulse5Ctrl
    field_Pulse5Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse5Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse5Ctrl,
      field_value_o    => current_data_o.Pulse5Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse5Ctrl,
      logic_data_o     => logic_data_o.Pulse5Ctrl,
      logic_return_i   => logic_return_i.Pulse5Ctrl
    );

    -- Register: Pulse5Presc
    field_Pulse5Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse5Presc,
      bus_write_data_i => bus_write_data_i.Pulse5Presc,
      field_value_o    => current_data_o.Pulse5Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse5Presc,
      logic_data_o     => logic_data_o.Pulse5Presc,
      logic_return_i   => logic_return_i.Pulse5Presc
    );

    -- Register: Pulse5Delay
    field_Pulse5Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse5Delay,
      bus_write_data_i => bus_write_data_i.Pulse5Delay,
      field_value_o    => current_data_o.Pulse5Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse5Delay,
      logic_data_o     => logic_data_o.Pulse5Delay,
      logic_return_i   => logic_return_i.Pulse5Delay
    );

    -- Register: Pulse5Width
    field_Pulse5Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse5Width,
      bus_write_data_i => bus_write_data_i.Pulse5Width,
      field_value_o    => current_data_o.Pulse5Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse5Width,
      logic_data_o     => logic_data_o.Pulse5Width,
      logic_return_i   => logic_return_i.Pulse5Width
    );

    -- Register: Pulse6Ctrl
    field_Pulse6Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse6Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse6Ctrl,
      field_value_o    => current_data_o.Pulse6Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse6Ctrl,
      logic_data_o     => logic_data_o.Pulse6Ctrl,
      logic_return_i   => logic_return_i.Pulse6Ctrl
    );

    -- Register: Pulse6Presc
    field_Pulse6Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse6Presc,
      bus_write_data_i => bus_write_data_i.Pulse6Presc,
      field_value_o    => current_data_o.Pulse6Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse6Presc,
      logic_data_o     => logic_data_o.Pulse6Presc,
      logic_return_i   => logic_return_i.Pulse6Presc
    );

    -- Register: Pulse6Delay
    field_Pulse6Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse6Delay,
      bus_write_data_i => bus_write_data_i.Pulse6Delay,
      field_value_o    => current_data_o.Pulse6Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse6Delay,
      logic_data_o     => logic_data_o.Pulse6Delay,
      logic_return_i   => logic_return_i.Pulse6Delay
    );

    -- Register: Pulse6Width
    field_Pulse6Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse6Width,
      bus_write_data_i => bus_write_data_i.Pulse6Width,
      field_value_o    => current_data_o.Pulse6Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse6Width,
      logic_data_o     => logic_data_o.Pulse6Width,
      logic_return_i   => logic_return_i.Pulse6Width
    );

    -- Register: Pulse7Ctrl
    field_Pulse7Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse7Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse7Ctrl,
      field_value_o    => current_data_o.Pulse7Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse7Ctrl,
      logic_data_o     => logic_data_o.Pulse7Ctrl,
      logic_return_i   => logic_return_i.Pulse7Ctrl
    );

    -- Register: Pulse7Presc
    field_Pulse7Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse7Presc,
      bus_write_data_i => bus_write_data_i.Pulse7Presc,
      field_value_o    => current_data_o.Pulse7Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse7Presc,
      logic_data_o     => logic_data_o.Pulse7Presc,
      logic_return_i   => logic_return_i.Pulse7Presc
    );

    -- Register: Pulse7Delay
    field_Pulse7Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse7Delay,
      bus_write_data_i => bus_write_data_i.Pulse7Delay,
      field_value_o    => current_data_o.Pulse7Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse7Delay,
      logic_data_o     => logic_data_o.Pulse7Delay,
      logic_return_i   => logic_return_i.Pulse7Delay
    );

    -- Register: Pulse7Width
    field_Pulse7Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse7Width,
      bus_write_data_i => bus_write_data_i.Pulse7Width,
      field_value_o    => current_data_o.Pulse7Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse7Width,
      logic_data_o     => logic_data_o.Pulse7Width,
      logic_return_i   => logic_return_i.Pulse7Width
    );

    -- Register: Pulse8Ctrl
    field_Pulse8Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse8Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse8Ctrl,
      field_value_o    => current_data_o.Pulse8Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse8Ctrl,
      logic_data_o     => logic_data_o.Pulse8Ctrl,
      logic_return_i   => logic_return_i.Pulse8Ctrl
    );

    -- Register: Pulse8Presc
    field_Pulse8Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse8Presc,
      bus_write_data_i => bus_write_data_i.Pulse8Presc,
      field_value_o    => current_data_o.Pulse8Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse8Presc,
      logic_data_o     => logic_data_o.Pulse8Presc,
      logic_return_i   => logic_return_i.Pulse8Presc
    );

    -- Register: Pulse8Delay
    field_Pulse8Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse8Delay,
      bus_write_data_i => bus_write_data_i.Pulse8Delay,
      field_value_o    => current_data_o.Pulse8Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse8Delay,
      logic_data_o     => logic_data_o.Pulse8Delay,
      logic_return_i   => logic_return_i.Pulse8Delay
    );

    -- Register: Pulse8Width
    field_Pulse8Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse8Width,
      bus_write_data_i => bus_write_data_i.Pulse8Width,
      field_value_o    => current_data_o.Pulse8Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse8Width,
      logic_data_o     => logic_data_o.Pulse8Width,
      logic_return_i   => logic_return_i.Pulse8Width
    );

    -- Register: Pulse9Ctrl
    field_Pulse9Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse9Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse9Ctrl,
      field_value_o    => current_data_o.Pulse9Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse9Ctrl,
      logic_data_o     => logic_data_o.Pulse9Ctrl,
      logic_return_i   => logic_return_i.Pulse9Ctrl
    );

    -- Register: Pulse9Presc
    field_Pulse9Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse9Presc,
      bus_write_data_i => bus_write_data_i.Pulse9Presc,
      field_value_o    => current_data_o.Pulse9Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse9Presc,
      logic_data_o     => logic_data_o.Pulse9Presc,
      logic_return_i   => logic_return_i.Pulse9Presc
    );

    -- Register: Pulse9Delay
    field_Pulse9Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse9Delay,
      bus_write_data_i => bus_write_data_i.Pulse9Delay,
      field_value_o    => current_data_o.Pulse9Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse9Delay,
      logic_data_o     => logic_data_o.Pulse9Delay,
      logic_return_i   => logic_return_i.Pulse9Delay
    );

    -- Register: Pulse9Width
    field_Pulse9Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse9Width,
      bus_write_data_i => bus_write_data_i.Pulse9Width,
      field_value_o    => current_data_o.Pulse9Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse9Width,
      logic_data_o     => logic_data_o.Pulse9Width,
      logic_return_i   => logic_return_i.Pulse9Width
    );

    -- Register: Pulse10Ctrl
    field_Pulse10Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse10Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse10Ctrl,
      field_value_o    => current_data_o.Pulse10Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse10Ctrl,
      logic_data_o     => logic_data_o.Pulse10Ctrl,
      logic_return_i   => logic_return_i.Pulse10Ctrl
    );

    -- Register: Pulse10Presc
    field_Pulse10Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse10Presc,
      bus_write_data_i => bus_write_data_i.Pulse10Presc,
      field_value_o    => current_data_o.Pulse10Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse10Presc,
      logic_data_o     => logic_data_o.Pulse10Presc,
      logic_return_i   => logic_return_i.Pulse10Presc
    );

    -- Register: Pulse10Delay
    field_Pulse10Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse10Delay,
      bus_write_data_i => bus_write_data_i.Pulse10Delay,
      field_value_o    => current_data_o.Pulse10Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse10Delay,
      logic_data_o     => logic_data_o.Pulse10Delay,
      logic_return_i   => logic_return_i.Pulse10Delay
    );

    -- Register: Pulse10Width
    field_Pulse10Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse10Width,
      bus_write_data_i => bus_write_data_i.Pulse10Width,
      field_value_o    => current_data_o.Pulse10Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse10Width,
      logic_data_o     => logic_data_o.Pulse10Width,
      logic_return_i   => logic_return_i.Pulse10Width
    );

    -- Register: Pulse11Ctrl
    field_Pulse11Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse11Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse11Ctrl,
      field_value_o    => current_data_o.Pulse11Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse11Ctrl,
      logic_data_o     => logic_data_o.Pulse11Ctrl,
      logic_return_i   => logic_return_i.Pulse11Ctrl
    );

    -- Register: Pulse11Presc
    field_Pulse11Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse11Presc,
      bus_write_data_i => bus_write_data_i.Pulse11Presc,
      field_value_o    => current_data_o.Pulse11Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse11Presc,
      logic_data_o     => logic_data_o.Pulse11Presc,
      logic_return_i   => logic_return_i.Pulse11Presc
    );

    -- Register: Pulse11Delay
    field_Pulse11Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse11Delay,
      bus_write_data_i => bus_write_data_i.Pulse11Delay,
      field_value_o    => current_data_o.Pulse11Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse11Delay,
      logic_data_o     => logic_data_o.Pulse11Delay,
      logic_return_i   => logic_return_i.Pulse11Delay
    );

    -- Register: Pulse11Width
    field_Pulse11Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse11Width,
      bus_write_data_i => bus_write_data_i.Pulse11Width,
      field_value_o    => current_data_o.Pulse11Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse11Width,
      logic_data_o     => logic_data_o.Pulse11Width,
      logic_return_i   => logic_return_i.Pulse11Width
    );

    -- Register: Pulse12Ctrl
    field_Pulse12Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse12Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse12Ctrl,
      field_value_o    => current_data_o.Pulse12Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse12Ctrl,
      logic_data_o     => logic_data_o.Pulse12Ctrl,
      logic_return_i   => logic_return_i.Pulse12Ctrl
    );

    -- Register: Pulse12Presc
    field_Pulse12Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse12Presc,
      bus_write_data_i => bus_write_data_i.Pulse12Presc,
      field_value_o    => current_data_o.Pulse12Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse12Presc,
      logic_data_o     => logic_data_o.Pulse12Presc,
      logic_return_i   => logic_return_i.Pulse12Presc
    );

    -- Register: Pulse12Delay
    field_Pulse12Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse12Delay,
      bus_write_data_i => bus_write_data_i.Pulse12Delay,
      field_value_o    => current_data_o.Pulse12Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse12Delay,
      logic_data_o     => logic_data_o.Pulse12Delay,
      logic_return_i   => logic_return_i.Pulse12Delay
    );

    -- Register: Pulse12Width
    field_Pulse12Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse12Width,
      bus_write_data_i => bus_write_data_i.Pulse12Width,
      field_value_o    => current_data_o.Pulse12Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse12Width,
      logic_data_o     => logic_data_o.Pulse12Width,
      logic_return_i   => logic_return_i.Pulse12Width
    );

    -- Register: Pulse13Ctrl
    field_Pulse13Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse13Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse13Ctrl,
      field_value_o    => current_data_o.Pulse13Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse13Ctrl,
      logic_data_o     => logic_data_o.Pulse13Ctrl,
      logic_return_i   => logic_return_i.Pulse13Ctrl
    );

    -- Register: Pulse13Presc
    field_Pulse13Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse13Presc,
      bus_write_data_i => bus_write_data_i.Pulse13Presc,
      field_value_o    => current_data_o.Pulse13Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse13Presc,
      logic_data_o     => logic_data_o.Pulse13Presc,
      logic_return_i   => logic_return_i.Pulse13Presc
    );

    -- Register: Pulse13Delay
    field_Pulse13Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse13Delay,
      bus_write_data_i => bus_write_data_i.Pulse13Delay,
      field_value_o    => current_data_o.Pulse13Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse13Delay,
      logic_data_o     => logic_data_o.Pulse13Delay,
      logic_return_i   => logic_return_i.Pulse13Delay
    );

    -- Register: Pulse13Width
    field_Pulse13Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse13Width,
      bus_write_data_i => bus_write_data_i.Pulse13Width,
      field_value_o    => current_data_o.Pulse13Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse13Width,
      logic_data_o     => logic_data_o.Pulse13Width,
      logic_return_i   => logic_return_i.Pulse13Width
    );

    -- Register: Pulse14Ctrl
    field_Pulse14Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse14Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse14Ctrl,
      field_value_o    => current_data_o.Pulse14Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse14Ctrl,
      logic_data_o     => logic_data_o.Pulse14Ctrl,
      logic_return_i   => logic_return_i.Pulse14Ctrl
    );

    -- Register: Pulse14Presc
    field_Pulse14Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse14Presc,
      bus_write_data_i => bus_write_data_i.Pulse14Presc,
      field_value_o    => current_data_o.Pulse14Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse14Presc,
      logic_data_o     => logic_data_o.Pulse14Presc,
      logic_return_i   => logic_return_i.Pulse14Presc
    );

    -- Register: Pulse14Delay
    field_Pulse14Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse14Delay,
      bus_write_data_i => bus_write_data_i.Pulse14Delay,
      field_value_o    => current_data_o.Pulse14Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse14Delay,
      logic_data_o     => logic_data_o.Pulse14Delay,
      logic_return_i   => logic_return_i.Pulse14Delay
    );

    -- Register: Pulse14Width
    field_Pulse14Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse14Width,
      bus_write_data_i => bus_write_data_i.Pulse14Width,
      field_value_o    => current_data_o.Pulse14Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse14Width,
      logic_data_o     => logic_data_o.Pulse14Width,
      logic_return_i   => logic_return_i.Pulse14Width
    );

    -- Register: Pulse15Ctrl
    field_Pulse15Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse15Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse15Ctrl,
      field_value_o    => current_data_o.Pulse15Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse15Ctrl,
      logic_data_o     => logic_data_o.Pulse15Ctrl,
      logic_return_i   => logic_return_i.Pulse15Ctrl
    );

    -- Register: Pulse15Presc
    field_Pulse15Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse15Presc,
      bus_write_data_i => bus_write_data_i.Pulse15Presc,
      field_value_o    => current_data_o.Pulse15Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse15Presc,
      logic_data_o     => logic_data_o.Pulse15Presc,
      logic_return_i   => logic_return_i.Pulse15Presc
    );

    -- Register: Pulse15Delay
    field_Pulse15Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse15Delay,
      bus_write_data_i => bus_write_data_i.Pulse15Delay,
      field_value_o    => current_data_o.Pulse15Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse15Delay,
      logic_data_o     => logic_data_o.Pulse15Delay,
      logic_return_i   => logic_return_i.Pulse15Delay
    );

    -- Register: Pulse15Width
    field_Pulse15Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse15Width,
      bus_write_data_i => bus_write_data_i.Pulse15Width,
      field_value_o    => current_data_o.Pulse15Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse15Width,
      logic_data_o     => logic_data_o.Pulse15Width,
      logic_return_i   => logic_return_i.Pulse15Width
    );

    -- Register: Pulse16Ctrl
    field_Pulse16Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse16Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse16Ctrl,
      field_value_o    => current_data_o.Pulse16Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse16Ctrl,
      logic_data_o     => logic_data_o.Pulse16Ctrl,
      logic_return_i   => logic_return_i.Pulse16Ctrl
    );

    -- Register: Pulse16Presc
    field_Pulse16Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse16Presc,
      bus_write_data_i => bus_write_data_i.Pulse16Presc,
      field_value_o    => current_data_o.Pulse16Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse16Presc,
      logic_data_o     => logic_data_o.Pulse16Presc,
      logic_return_i   => logic_return_i.Pulse16Presc
    );

    -- Register: Pulse16Delay
    field_Pulse16Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse16Delay,
      bus_write_data_i => bus_write_data_i.Pulse16Delay,
      field_value_o    => current_data_o.Pulse16Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse16Delay,
      logic_data_o     => logic_data_o.Pulse16Delay,
      logic_return_i   => logic_return_i.Pulse16Delay
    );

    -- Register: Pulse16Width
    field_Pulse16Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse16Width,
      bus_write_data_i => bus_write_data_i.Pulse16Width,
      field_value_o    => current_data_o.Pulse16Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse16Width,
      logic_data_o     => logic_data_o.Pulse16Width,
      logic_return_i   => logic_return_i.Pulse16Width
    );

    -- Register: Pulse17Ctrl
    field_Pulse17Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse17Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse17Ctrl,
      field_value_o    => current_data_o.Pulse17Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse17Ctrl,
      logic_data_o     => logic_data_o.Pulse17Ctrl,
      logic_return_i   => logic_return_i.Pulse17Ctrl
    );

    -- Register: Pulse17Presc
    field_Pulse17Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse17Presc,
      bus_write_data_i => bus_write_data_i.Pulse17Presc,
      field_value_o    => current_data_o.Pulse17Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse17Presc,
      logic_data_o     => logic_data_o.Pulse17Presc,
      logic_return_i   => logic_return_i.Pulse17Presc
    );

    -- Register: Pulse17Delay
    field_Pulse17Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse17Delay,
      bus_write_data_i => bus_write_data_i.Pulse17Delay,
      field_value_o    => current_data_o.Pulse17Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse17Delay,
      logic_data_o     => logic_data_o.Pulse17Delay,
      logic_return_i   => logic_return_i.Pulse17Delay
    );

    -- Register: Pulse17Width
    field_Pulse17Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse17Width,
      bus_write_data_i => bus_write_data_i.Pulse17Width,
      field_value_o    => current_data_o.Pulse17Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse17Width,
      logic_data_o     => logic_data_o.Pulse17Width,
      logic_return_i   => logic_return_i.Pulse17Width
    );

    -- Register: Pulse18Ctrl
    field_Pulse18Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse18Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse18Ctrl,
      field_value_o    => current_data_o.Pulse18Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse18Ctrl,
      logic_data_o     => logic_data_o.Pulse18Ctrl,
      logic_return_i   => logic_return_i.Pulse18Ctrl
    );

    -- Register: Pulse18Presc
    field_Pulse18Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse18Presc,
      bus_write_data_i => bus_write_data_i.Pulse18Presc,
      field_value_o    => current_data_o.Pulse18Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse18Presc,
      logic_data_o     => logic_data_o.Pulse18Presc,
      logic_return_i   => logic_return_i.Pulse18Presc
    );

    -- Register: Pulse18Delay
    field_Pulse18Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse18Delay,
      bus_write_data_i => bus_write_data_i.Pulse18Delay,
      field_value_o    => current_data_o.Pulse18Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse18Delay,
      logic_data_o     => logic_data_o.Pulse18Delay,
      logic_return_i   => logic_return_i.Pulse18Delay
    );

    -- Register: Pulse18Width
    field_Pulse18Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse18Width,
      bus_write_data_i => bus_write_data_i.Pulse18Width,
      field_value_o    => current_data_o.Pulse18Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse18Width,
      logic_data_o     => logic_data_o.Pulse18Width,
      logic_return_i   => logic_return_i.Pulse18Width
    );

    -- Register: Pulse19Ctrl
    field_Pulse19Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse19Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse19Ctrl,
      field_value_o    => current_data_o.Pulse19Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse19Ctrl,
      logic_data_o     => logic_data_o.Pulse19Ctrl,
      logic_return_i   => logic_return_i.Pulse19Ctrl
    );

    -- Register: Pulse19Presc
    field_Pulse19Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse19Presc,
      bus_write_data_i => bus_write_data_i.Pulse19Presc,
      field_value_o    => current_data_o.Pulse19Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse19Presc,
      logic_data_o     => logic_data_o.Pulse19Presc,
      logic_return_i   => logic_return_i.Pulse19Presc
    );

    -- Register: Pulse19Delay
    field_Pulse19Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse19Delay,
      bus_write_data_i => bus_write_data_i.Pulse19Delay,
      field_value_o    => current_data_o.Pulse19Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse19Delay,
      logic_data_o     => logic_data_o.Pulse19Delay,
      logic_return_i   => logic_return_i.Pulse19Delay
    );

    -- Register: Pulse19Width
    field_Pulse19Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse19Width,
      bus_write_data_i => bus_write_data_i.Pulse19Width,
      field_value_o    => current_data_o.Pulse19Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse19Width,
      logic_data_o     => logic_data_o.Pulse19Width,
      logic_return_i   => logic_return_i.Pulse19Width
    );

    -- Register: Pulse20Ctrl
    field_Pulse20Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse20Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse20Ctrl,
      field_value_o    => current_data_o.Pulse20Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse20Ctrl,
      logic_data_o     => logic_data_o.Pulse20Ctrl,
      logic_return_i   => logic_return_i.Pulse20Ctrl
    );

    -- Register: Pulse20Presc
    field_Pulse20Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse20Presc,
      bus_write_data_i => bus_write_data_i.Pulse20Presc,
      field_value_o    => current_data_o.Pulse20Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse20Presc,
      logic_data_o     => logic_data_o.Pulse20Presc,
      logic_return_i   => logic_return_i.Pulse20Presc
    );

    -- Register: Pulse20Delay
    field_Pulse20Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse20Delay,
      bus_write_data_i => bus_write_data_i.Pulse20Delay,
      field_value_o    => current_data_o.Pulse20Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse20Delay,
      logic_data_o     => logic_data_o.Pulse20Delay,
      logic_return_i   => logic_return_i.Pulse20Delay
    );

    -- Register: Pulse20Width
    field_Pulse20Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse20Width,
      bus_write_data_i => bus_write_data_i.Pulse20Width,
      field_value_o    => current_data_o.Pulse20Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse20Width,
      logic_data_o     => logic_data_o.Pulse20Width,
      logic_return_i   => logic_return_i.Pulse20Width
    );

    -- Register: Pulse21Ctrl
    field_Pulse21Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse21Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse21Ctrl,
      field_value_o    => current_data_o.Pulse21Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse21Ctrl,
      logic_data_o     => logic_data_o.Pulse21Ctrl,
      logic_return_i   => logic_return_i.Pulse21Ctrl
    );

    -- Register: Pulse21Presc
    field_Pulse21Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse21Presc,
      bus_write_data_i => bus_write_data_i.Pulse21Presc,
      field_value_o    => current_data_o.Pulse21Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse21Presc,
      logic_data_o     => logic_data_o.Pulse21Presc,
      logic_return_i   => logic_return_i.Pulse21Presc
    );

    -- Register: Pulse21Delay
    field_Pulse21Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse21Delay,
      bus_write_data_i => bus_write_data_i.Pulse21Delay,
      field_value_o    => current_data_o.Pulse21Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse21Delay,
      logic_data_o     => logic_data_o.Pulse21Delay,
      logic_return_i   => logic_return_i.Pulse21Delay
    );

    -- Register: Pulse21Width
    field_Pulse21Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse21Width,
      bus_write_data_i => bus_write_data_i.Pulse21Width,
      field_value_o    => current_data_o.Pulse21Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse21Width,
      logic_data_o     => logic_data_o.Pulse21Width,
      logic_return_i   => logic_return_i.Pulse21Width
    );

    -- Register: Pulse22Ctrl
    field_Pulse22Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse22Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse22Ctrl,
      field_value_o    => current_data_o.Pulse22Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse22Ctrl,
      logic_data_o     => logic_data_o.Pulse22Ctrl,
      logic_return_i   => logic_return_i.Pulse22Ctrl
    );

    -- Register: Pulse22Presc
    field_Pulse22Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse22Presc,
      bus_write_data_i => bus_write_data_i.Pulse22Presc,
      field_value_o    => current_data_o.Pulse22Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse22Presc,
      logic_data_o     => logic_data_o.Pulse22Presc,
      logic_return_i   => logic_return_i.Pulse22Presc
    );

    -- Register: Pulse22Delay
    field_Pulse22Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse22Delay,
      bus_write_data_i => bus_write_data_i.Pulse22Delay,
      field_value_o    => current_data_o.Pulse22Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse22Delay,
      logic_data_o     => logic_data_o.Pulse22Delay,
      logic_return_i   => logic_return_i.Pulse22Delay
    );

    -- Register: Pulse22Width
    field_Pulse22Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse22Width,
      bus_write_data_i => bus_write_data_i.Pulse22Width,
      field_value_o    => current_data_o.Pulse22Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse22Width,
      logic_data_o     => logic_data_o.Pulse22Width,
      logic_return_i   => logic_return_i.Pulse22Width
    );

    -- Register: Pulse23Ctrl
    field_Pulse23Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse23Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse23Ctrl,
      field_value_o    => current_data_o.Pulse23Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse23Ctrl,
      logic_data_o     => logic_data_o.Pulse23Ctrl,
      logic_return_i   => logic_return_i.Pulse23Ctrl
    );

    -- Register: Pulse23Presc
    field_Pulse23Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse23Presc,
      bus_write_data_i => bus_write_data_i.Pulse23Presc,
      field_value_o    => current_data_o.Pulse23Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse23Presc,
      logic_data_o     => logic_data_o.Pulse23Presc,
      logic_return_i   => logic_return_i.Pulse23Presc
    );

    -- Register: Pulse23Delay
    field_Pulse23Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse23Delay,
      bus_write_data_i => bus_write_data_i.Pulse23Delay,
      field_value_o    => current_data_o.Pulse23Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse23Delay,
      logic_data_o     => logic_data_o.Pulse23Delay,
      logic_return_i   => logic_return_i.Pulse23Delay
    );

    -- Register: Pulse23Width
    field_Pulse23Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse23Width,
      bus_write_data_i => bus_write_data_i.Pulse23Width,
      field_value_o    => current_data_o.Pulse23Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse23Width,
      logic_data_o     => logic_data_o.Pulse23Width,
      logic_return_i   => logic_return_i.Pulse23Width
    );

    -- Register: Pulse24Ctrl
    field_Pulse24Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse24Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse24Ctrl,
      field_value_o    => current_data_o.Pulse24Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse24Ctrl,
      logic_data_o     => logic_data_o.Pulse24Ctrl,
      logic_return_i   => logic_return_i.Pulse24Ctrl
    );

    -- Register: Pulse24Presc
    field_Pulse24Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse24Presc,
      bus_write_data_i => bus_write_data_i.Pulse24Presc,
      field_value_o    => current_data_o.Pulse24Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse24Presc,
      logic_data_o     => logic_data_o.Pulse24Presc,
      logic_return_i   => logic_return_i.Pulse24Presc
    );

    -- Register: Pulse24Delay
    field_Pulse24Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse24Delay,
      bus_write_data_i => bus_write_data_i.Pulse24Delay,
      field_value_o    => current_data_o.Pulse24Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse24Delay,
      logic_data_o     => logic_data_o.Pulse24Delay,
      logic_return_i   => logic_return_i.Pulse24Delay
    );

    -- Register: Pulse24Width
    field_Pulse24Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse24Width,
      bus_write_data_i => bus_write_data_i.Pulse24Width,
      field_value_o    => current_data_o.Pulse24Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse24Width,
      logic_data_o     => logic_data_o.Pulse24Width,
      logic_return_i   => logic_return_i.Pulse24Width
    );

    -- Register: Pulse25Ctrl
    field_Pulse25Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse25Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse25Ctrl,
      field_value_o    => current_data_o.Pulse25Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse25Ctrl,
      logic_data_o     => logic_data_o.Pulse25Ctrl,
      logic_return_i   => logic_return_i.Pulse25Ctrl
    );

    -- Register: Pulse25Presc
    field_Pulse25Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse25Presc,
      bus_write_data_i => bus_write_data_i.Pulse25Presc,
      field_value_o    => current_data_o.Pulse25Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse25Presc,
      logic_data_o     => logic_data_o.Pulse25Presc,
      logic_return_i   => logic_return_i.Pulse25Presc
    );

    -- Register: Pulse25Delay
    field_Pulse25Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse25Delay,
      bus_write_data_i => bus_write_data_i.Pulse25Delay,
      field_value_o    => current_data_o.Pulse25Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse25Delay,
      logic_data_o     => logic_data_o.Pulse25Delay,
      logic_return_i   => logic_return_i.Pulse25Delay
    );

    -- Register: Pulse25Width
    field_Pulse25Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse25Width,
      bus_write_data_i => bus_write_data_i.Pulse25Width,
      field_value_o    => current_data_o.Pulse25Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse25Width,
      logic_data_o     => logic_data_o.Pulse25Width,
      logic_return_i   => logic_return_i.Pulse25Width
    );

    -- Register: Pulse26Ctrl
    field_Pulse26Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse26Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse26Ctrl,
      field_value_o    => current_data_o.Pulse26Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse26Ctrl,
      logic_data_o     => logic_data_o.Pulse26Ctrl,
      logic_return_i   => logic_return_i.Pulse26Ctrl
    );

    -- Register: Pulse26Presc
    field_Pulse26Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse26Presc,
      bus_write_data_i => bus_write_data_i.Pulse26Presc,
      field_value_o    => current_data_o.Pulse26Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse26Presc,
      logic_data_o     => logic_data_o.Pulse26Presc,
      logic_return_i   => logic_return_i.Pulse26Presc
    );

    -- Register: Pulse26Delay
    field_Pulse26Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse26Delay,
      bus_write_data_i => bus_write_data_i.Pulse26Delay,
      field_value_o    => current_data_o.Pulse26Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse26Delay,
      logic_data_o     => logic_data_o.Pulse26Delay,
      logic_return_i   => logic_return_i.Pulse26Delay
    );

    -- Register: Pulse26Width
    field_Pulse26Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse26Width,
      bus_write_data_i => bus_write_data_i.Pulse26Width,
      field_value_o    => current_data_o.Pulse26Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse26Width,
      logic_data_o     => logic_data_o.Pulse26Width,
      logic_return_i   => logic_return_i.Pulse26Width
    );

    -- Register: Pulse27Ctrl
    field_Pulse27Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse27Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse27Ctrl,
      field_value_o    => current_data_o.Pulse27Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse27Ctrl,
      logic_data_o     => logic_data_o.Pulse27Ctrl,
      logic_return_i   => logic_return_i.Pulse27Ctrl
    );

    -- Register: Pulse27Presc
    field_Pulse27Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse27Presc,
      bus_write_data_i => bus_write_data_i.Pulse27Presc,
      field_value_o    => current_data_o.Pulse27Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse27Presc,
      logic_data_o     => logic_data_o.Pulse27Presc,
      logic_return_i   => logic_return_i.Pulse27Presc
    );

    -- Register: Pulse27Delay
    field_Pulse27Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse27Delay,
      bus_write_data_i => bus_write_data_i.Pulse27Delay,
      field_value_o    => current_data_o.Pulse27Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse27Delay,
      logic_data_o     => logic_data_o.Pulse27Delay,
      logic_return_i   => logic_return_i.Pulse27Delay
    );

    -- Register: Pulse27Width
    field_Pulse27Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse27Width,
      bus_write_data_i => bus_write_data_i.Pulse27Width,
      field_value_o    => current_data_o.Pulse27Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse27Width,
      logic_data_o     => logic_data_o.Pulse27Width,
      logic_return_i   => logic_return_i.Pulse27Width
    );

    -- Register: Pulse28Ctrl
    field_Pulse28Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse28Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse28Ctrl,
      field_value_o    => current_data_o.Pulse28Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse28Ctrl,
      logic_data_o     => logic_data_o.Pulse28Ctrl,
      logic_return_i   => logic_return_i.Pulse28Ctrl
    );

    -- Register: Pulse28Presc
    field_Pulse28Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse28Presc,
      bus_write_data_i => bus_write_data_i.Pulse28Presc,
      field_value_o    => current_data_o.Pulse28Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse28Presc,
      logic_data_o     => logic_data_o.Pulse28Presc,
      logic_return_i   => logic_return_i.Pulse28Presc
    );

    -- Register: Pulse28Delay
    field_Pulse28Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse28Delay,
      bus_write_data_i => bus_write_data_i.Pulse28Delay,
      field_value_o    => current_data_o.Pulse28Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse28Delay,
      logic_data_o     => logic_data_o.Pulse28Delay,
      logic_return_i   => logic_return_i.Pulse28Delay
    );

    -- Register: Pulse28Width
    field_Pulse28Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse28Width,
      bus_write_data_i => bus_write_data_i.Pulse28Width,
      field_value_o    => current_data_o.Pulse28Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse28Width,
      logic_data_o     => logic_data_o.Pulse28Width,
      logic_return_i   => logic_return_i.Pulse28Width
    );

    -- Register: Pulse29Ctrl
    field_Pulse29Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse29Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse29Ctrl,
      field_value_o    => current_data_o.Pulse29Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse29Ctrl,
      logic_data_o     => logic_data_o.Pulse29Ctrl,
      logic_return_i   => logic_return_i.Pulse29Ctrl
    );

    -- Register: Pulse29Presc
    field_Pulse29Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse29Presc,
      bus_write_data_i => bus_write_data_i.Pulse29Presc,
      field_value_o    => current_data_o.Pulse29Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse29Presc,
      logic_data_o     => logic_data_o.Pulse29Presc,
      logic_return_i   => logic_return_i.Pulse29Presc
    );

    -- Register: Pulse29Delay
    field_Pulse29Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse29Delay,
      bus_write_data_i => bus_write_data_i.Pulse29Delay,
      field_value_o    => current_data_o.Pulse29Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse29Delay,
      logic_data_o     => logic_data_o.Pulse29Delay,
      logic_return_i   => logic_return_i.Pulse29Delay
    );

    -- Register: Pulse29Width
    field_Pulse29Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse29Width,
      bus_write_data_i => bus_write_data_i.Pulse29Width,
      field_value_o    => current_data_o.Pulse29Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse29Width,
      logic_data_o     => logic_data_o.Pulse29Width,
      logic_return_i   => logic_return_i.Pulse29Width
    );

    -- Register: Pulse30Ctrl
    field_Pulse30Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse30Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse30Ctrl,
      field_value_o    => current_data_o.Pulse30Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse30Ctrl,
      logic_data_o     => logic_data_o.Pulse30Ctrl,
      logic_return_i   => logic_return_i.Pulse30Ctrl
    );

    -- Register: Pulse30Presc
    field_Pulse30Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse30Presc,
      bus_write_data_i => bus_write_data_i.Pulse30Presc,
      field_value_o    => current_data_o.Pulse30Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse30Presc,
      logic_data_o     => logic_data_o.Pulse30Presc,
      logic_return_i   => logic_return_i.Pulse30Presc
    );

    -- Register: Pulse30Delay
    field_Pulse30Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse30Delay,
      bus_write_data_i => bus_write_data_i.Pulse30Delay,
      field_value_o    => current_data_o.Pulse30Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse30Delay,
      logic_data_o     => logic_data_o.Pulse30Delay,
      logic_return_i   => logic_return_i.Pulse30Delay
    );

    -- Register: Pulse30Width
    field_Pulse30Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse30Width,
      bus_write_data_i => bus_write_data_i.Pulse30Width,
      field_value_o    => current_data_o.Pulse30Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse30Width,
      logic_data_o     => logic_data_o.Pulse30Width,
      logic_return_i   => logic_return_i.Pulse30Width
    );

    -- Register: Pulse31Ctrl
    field_Pulse31Ctrl : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse31Ctrl,
      bus_write_data_i => bus_write_data_i.Pulse31Ctrl,
      field_value_o    => current_data_o.Pulse31Ctrl,
      logic_to_bus_o   => logic_to_bus_o.Pulse31Ctrl,
      logic_data_o     => logic_data_o.Pulse31Ctrl,
      logic_return_i   => logic_return_i.Pulse31Ctrl
    );

    -- Register: Pulse31Presc
    field_Pulse31Presc : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse31Presc,
      bus_write_data_i => bus_write_data_i.Pulse31Presc,
      field_value_o    => current_data_o.Pulse31Presc,
      logic_to_bus_o   => logic_to_bus_o.Pulse31Presc,
      logic_data_o     => logic_data_o.Pulse31Presc,
      logic_return_i   => logic_return_i.Pulse31Presc
    );

    -- Register: Pulse31Delay
    field_Pulse31Delay : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse31Delay,
      bus_write_data_i => bus_write_data_i.Pulse31Delay,
      field_value_o    => current_data_o.Pulse31Delay,
      logic_to_bus_o   => logic_to_bus_o.Pulse31Delay,
      logic_data_o     => logic_data_o.Pulse31Delay,
      logic_return_i   => logic_return_i.Pulse31Delay
    );

    -- Register: Pulse31Width
    field_Pulse31Width : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.Pulse31Width,
      bus_write_data_i => bus_write_data_i.Pulse31Width,
      field_value_o    => current_data_o.Pulse31Width,
      logic_to_bus_o   => logic_to_bus_o.Pulse31Width,
      logic_data_o     => logic_data_o.Pulse31Width,
      logic_return_i   => logic_return_i.Pulse31Width
    );

    -- Register: master_reset
    field_master_reset : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.master_reset,
      bus_write_data_i => bus_write_data_i.master_reset,
      field_value_o    => current_data_o.master_reset,
      logic_to_bus_o   => logic_to_bus_o.master_reset,
      logic_data_o     => logic_data_o.master_reset,
      logic_return_i   => logic_return_i.master_reset
    );

    -- Register: rxpath_reset
    field_rxpath_reset : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.rxpath_reset,
      bus_write_data_i => bus_write_data_i.rxpath_reset,
      field_value_o    => current_data_o.rxpath_reset,
      logic_to_bus_o   => logic_to_bus_o.rxpath_reset,
      logic_data_o     => logic_data_o.rxpath_reset,
      logic_return_i   => logic_return_i.rxpath_reset
    );

    -- Register: txpath_reset
    field_txpath_reset : field_core
    generic map (
      RESET_VALUE => std_logic_vector(to_unsigned(16#0#, 32)),
      WIDTH => 32
    )
    port map (
      clock_i          => clock_i,
      reset_n_i        => reset_n_i,
      write_en_i       => write_en_i.txpath_reset,
      bus_write_data_i => bus_write_data_i.txpath_reset,
      field_value_o    => current_data_o.txpath_reset,
      logic_to_bus_o   => logic_to_bus_o.txpath_reset,
      logic_data_o     => logic_data_o.txpath_reset,
      logic_return_i   => logic_return_i.txpath_reset
    );



end architecture rtl;
