--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_wr_interface.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-05-21
-- Last update : 2018-05-23
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description :
--               Combinatorial block.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-05-23  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library ESS_openEVR_RegMap;
use ESS_openEVR_RegMap.register_bank_config.all;
use ESS_openEVR_RegMap.register_bank_functions.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity register_bank_wr_interface  is
  port (
    register_write_en_i   : in  register_write_en_t;
    data_bus_i            : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);

    current_field_value_i : in  field_data_t;

    field_write_en_o      : out field_write_en_t;
    field_data_o          : out field_data_t
  );
end entity register_bank_wr_interface;

--------------------------------------------------------------------------------
--! @brief
--------------------------------------------------------------------------------
architecture rtl of register_bank_wr_interface is

    signal Status_write_en : std_logic_vector(0 downto 0);
    signal Control_write_en : std_logic_vector(0 downto 0);
    signal IrqFlag_write_en : std_logic_vector(0 downto 0);
    signal IrqEnable_write_en : std_logic_vector(0 downto 0);
    signal PulseIrqMap_write_en : std_logic_vector(0 downto 0);
    signal SWEvent_write_en : std_logic_vector(0 downto 0);
    signal DataBufCtrl_write_en : std_logic_vector(0 downto 0);
    signal TXDataBufCtrl_write_en : std_logic_vector(0 downto 0);
    signal TxSegBufCtrl_write_en : std_logic_vector(0 downto 0);
    signal FWVersion_write_en : std_logic_vector(0 downto 0);
    signal EvCntPresc_write_en : std_logic_vector(0 downto 0);
    signal UsecDivider_write_en : std_logic_vector(0 downto 0);
    signal ClockControl_write_en : std_logic_vector(0 downto 0);
    signal SecSR_write_en : std_logic_vector(0 downto 0);
    signal SecCounter_write_en : std_logic_vector(0 downto 0);
    signal EventCounter_write_en : std_logic_vector(0 downto 0);
    signal SecLatch_write_en : std_logic_vector(0 downto 0);
    signal EvCntLatch_write_en : std_logic_vector(0 downto 0);
    signal EvFIFOSec_write_en : std_logic_vector(0 downto 0);
    signal EvFIFOEvCnt_write_en : std_logic_vector(0 downto 0);
    signal EvFIFOCode_write_en : std_logic_vector(0 downto 0);
    signal LogStatus_write_en : std_logic_vector(0 downto 0);
    signal GPIODir_write_en : std_logic_vector(0 downto 0);
    signal GPIOIn_write_en : std_logic_vector(0 downto 0);
    signal GPIOOut_write_en : std_logic_vector(0 downto 0);
    signal DCTarget_write_en : std_logic_vector(0 downto 0);
    signal DCRxValue_write_en : std_logic_vector(0 downto 0);
    signal DCIntValue_write_en : std_logic_vector(0 downto 0);
    signal DCStatus_write_en : std_logic_vector(0 downto 0);
    signal TopologyID_write_en : std_logic_vector(0 downto 0);
    signal SeqRamCtrl_write_en : std_logic_vector(0 downto 0);
    signal Prescaler0_write_en : std_logic_vector(0 downto 0);
    signal Prescaler1_write_en : std_logic_vector(0 downto 0);
    signal Prescaler2_write_en : std_logic_vector(0 downto 0);
    signal Prescaler3_write_en : std_logic_vector(0 downto 0);
    signal Prescaler4_write_en : std_logic_vector(0 downto 0);
    signal Prescaler5_write_en : std_logic_vector(0 downto 0);
    signal Prescaler6_write_en : std_logic_vector(0 downto 0);
    signal Prescaler7_write_en : std_logic_vector(0 downto 0);
    signal PrescPhase0_write_en : std_logic_vector(0 downto 0);
    signal PrescPhase1_write_en : std_logic_vector(0 downto 0);
    signal PrescPhase2_write_en : std_logic_vector(0 downto 0);
    signal PrescPhase3_write_en : std_logic_vector(0 downto 0);
    signal PrescPhase4_write_en : std_logic_vector(0 downto 0);
    signal PrescPhase5_write_en : std_logic_vector(0 downto 0);
    signal PrescPhase6_write_en : std_logic_vector(0 downto 0);
    signal PrescPhase7_write_en : std_logic_vector(0 downto 0);
    signal PrescTrig0_write_en : std_logic_vector(0 downto 0);
    signal PrescTrig1_write_en : std_logic_vector(0 downto 0);
    signal PrescTrig2_write_en : std_logic_vector(0 downto 0);
    signal PrescTrig3_write_en : std_logic_vector(0 downto 0);
    signal PrescTrig4_write_en : std_logic_vector(0 downto 0);
    signal PrescTrig5_write_en : std_logic_vector(0 downto 0);
    signal PrescTrig6_write_en : std_logic_vector(0 downto 0);
    signal PrescTrig7_write_en : std_logic_vector(0 downto 0);
    signal DBusTrig0_write_en : std_logic_vector(0 downto 0);
    signal DBusTrig1_write_en : std_logic_vector(0 downto 0);
    signal DBusTrig2_write_en : std_logic_vector(0 downto 0);
    signal DBusTrig3_write_en : std_logic_vector(0 downto 0);
    signal DBusTrig4_write_en : std_logic_vector(0 downto 0);
    signal DBusTrig5_write_en : std_logic_vector(0 downto 0);
    signal DBusTrig6_write_en : std_logic_vector(0 downto 0);
    signal DBusTrig7_write_en : std_logic_vector(0 downto 0);
    signal Pulse0Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse0Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse0Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse0Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse1Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse1Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse1Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse1Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse2Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse2Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse2Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse2Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse3Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse3Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse3Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse3Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse4Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse4Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse4Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse4Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse5Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse5Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse5Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse5Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse6Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse6Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse6Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse6Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse7Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse7Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse7Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse7Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse8Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse8Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse8Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse8Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse9Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse9Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse9Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse9Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse10Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse10Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse10Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse10Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse11Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse11Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse11Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse11Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse12Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse12Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse12Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse12Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse13Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse13Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse13Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse13Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse14Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse14Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse14Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse14Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse15Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse15Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse15Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse15Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse16Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse16Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse16Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse16Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse17Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse17Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse17Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse17Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse18Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse18Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse18Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse18Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse19Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse19Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse19Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse19Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse20Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse20Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse20Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse20Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse21Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse21Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse21Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse21Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse22Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse22Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse22Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse22Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse23Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse23Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse23Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse23Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse24Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse24Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse24Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse24Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse25Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse25Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse25Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse25Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse26Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse26Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse26Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse26Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse27Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse27Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse27Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse27Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse28Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse28Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse28Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse28Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse29Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse29Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse29Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse29Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse30Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse30Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse30Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse30Width_write_en : std_logic_vector(0 downto 0);
    signal Pulse31Ctrl_write_en : std_logic_vector(0 downto 0);
    signal Pulse31Presc_write_en : std_logic_vector(0 downto 0);
    signal Pulse31Delay_write_en : std_logic_vector(0 downto 0);
    signal Pulse31Width_write_en : std_logic_vector(0 downto 0);
    signal ESSStatus_write_en : std_logic_vector(0 downto 0);
    signal ESSControl_write_en : std_logic_vector(0 downto 0);
    signal ESSExtSecCounter_write_en : std_logic_vector(0 downto 0);
    signal ESSExtEventCounter_write_en : std_logic_vector(0 downto 0);


begin

  write_interface_cores : process (register_write_en_i, data_bus_i, current_field_value_i)
  begin

    Control_write_en(0) <= register_write_en_i.Control;
    write_interface_core((0 => 0), (0 => WRITE), Control_write_en, data_bus_i, field_write_en_o.Control, field_data_o.Control, current_field_value_i.Control);

    IrqFlag_write_en(0) <= register_write_en_i.IrqFlag;
    write_interface_core((0 => 0), (0 => WRITE), IrqFlag_write_en, data_bus_i, field_write_en_o.IrqFlag, field_data_o.IrqFlag, current_field_value_i.IrqFlag);

    IrqEnable_write_en(0) <= register_write_en_i.IrqEnable;
    write_interface_core((0 => 0), (0 => WRITE), IrqEnable_write_en, data_bus_i, field_write_en_o.IrqEnable, field_data_o.IrqEnable, current_field_value_i.IrqEnable);

    PulseIrqMap_write_en(0) <= register_write_en_i.PulseIrqMap;
    write_interface_core((0 => 0), (0 => WRITE), PulseIrqMap_write_en, data_bus_i, field_write_en_o.PulseIrqMap, field_data_o.PulseIrqMap, current_field_value_i.PulseIrqMap);

    SWEvent_write_en(0) <= register_write_en_i.SWEvent;
    write_interface_core((0 => 0), (0 => WRITE), SWEvent_write_en, data_bus_i, field_write_en_o.SWEvent, field_data_o.SWEvent, current_field_value_i.SWEvent);

    DataBufCtrl_write_en(0) <= register_write_en_i.DataBufCtrl;
    write_interface_core((0 => 0), (0 => WRITE), DataBufCtrl_write_en, data_bus_i, field_write_en_o.DataBufCtrl, field_data_o.DataBufCtrl, current_field_value_i.DataBufCtrl);

    TXDataBufCtrl_write_en(0) <= register_write_en_i.TXDataBufCtrl;
    write_interface_core((0 => 0), (0 => WRITE), TXDataBufCtrl_write_en, data_bus_i, field_write_en_o.TXDataBufCtrl, field_data_o.TXDataBufCtrl, current_field_value_i.TXDataBufCtrl);

    TxSegBufCtrl_write_en(0) <= register_write_en_i.TxSegBufCtrl;
    write_interface_core((0 => 0), (0 => WRITE), TxSegBufCtrl_write_en, data_bus_i, field_write_en_o.TxSegBufCtrl, field_data_o.TxSegBufCtrl, current_field_value_i.TxSegBufCtrl);

    EvCntPresc_write_en(0) <= register_write_en_i.EvCntPresc;
    write_interface_core((0 => 0), (0 => WRITE), EvCntPresc_write_en, data_bus_i, field_write_en_o.EvCntPresc, field_data_o.EvCntPresc, current_field_value_i.EvCntPresc);

    UsecDivider_write_en(0) <= register_write_en_i.UsecDivider;
    write_interface_core((0 => 0), (0 => WRITE), UsecDivider_write_en, data_bus_i, field_write_en_o.UsecDivider, field_data_o.UsecDivider, current_field_value_i.UsecDivider);

    ClockControl_write_en(0) <= register_write_en_i.ClockControl;
    write_interface_core((0 => 0), (0 => WRITE), ClockControl_write_en, data_bus_i, field_write_en_o.ClockControl, field_data_o.ClockControl, current_field_value_i.ClockControl);

    GPIODir_write_en(0) <= register_write_en_i.GPIODir;
    write_interface_core((0 => 0), (0 => WRITE), GPIODir_write_en, data_bus_i, field_write_en_o.GPIODir, field_data_o.GPIODir, current_field_value_i.GPIODir);

    GPIOIn_write_en(0) <= register_write_en_i.GPIOIn;
    write_interface_core((0 => 0), (0 => WRITE), GPIOIn_write_en, data_bus_i, field_write_en_o.GPIOIn, field_data_o.GPIOIn, current_field_value_i.GPIOIn);

    GPIOOut_write_en(0) <= register_write_en_i.GPIOOut;
    write_interface_core((0 => 0), (0 => WRITE), GPIOOut_write_en, data_bus_i, field_write_en_o.GPIOOut, field_data_o.GPIOOut, current_field_value_i.GPIOOut);

    DCTarget_write_en(0) <= register_write_en_i.DCTarget;
    write_interface_core((0 => 0), (0 => WRITE), DCTarget_write_en, data_bus_i, field_write_en_o.DCTarget, field_data_o.DCTarget, current_field_value_i.DCTarget);

    SeqRamCtrl_write_en(0) <= register_write_en_i.SeqRamCtrl;
    write_interface_core((0 => 0), (0 => WRITE), SeqRamCtrl_write_en, data_bus_i, field_write_en_o.SeqRamCtrl, field_data_o.SeqRamCtrl, current_field_value_i.SeqRamCtrl);

    Prescaler0_write_en(0) <= register_write_en_i.Prescaler0;
    write_interface_core((0 => 0), (0 => WRITE), Prescaler0_write_en, data_bus_i, field_write_en_o.Prescaler0, field_data_o.Prescaler0, current_field_value_i.Prescaler0);

    Prescaler1_write_en(0) <= register_write_en_i.Prescaler1;
    write_interface_core((0 => 0), (0 => WRITE), Prescaler1_write_en, data_bus_i, field_write_en_o.Prescaler1, field_data_o.Prescaler1, current_field_value_i.Prescaler1);

    Prescaler2_write_en(0) <= register_write_en_i.Prescaler2;
    write_interface_core((0 => 0), (0 => WRITE), Prescaler2_write_en, data_bus_i, field_write_en_o.Prescaler2, field_data_o.Prescaler2, current_field_value_i.Prescaler2);

    Prescaler3_write_en(0) <= register_write_en_i.Prescaler3;
    write_interface_core((0 => 0), (0 => WRITE), Prescaler3_write_en, data_bus_i, field_write_en_o.Prescaler3, field_data_o.Prescaler3, current_field_value_i.Prescaler3);

    Prescaler4_write_en(0) <= register_write_en_i.Prescaler4;
    write_interface_core((0 => 0), (0 => WRITE), Prescaler4_write_en, data_bus_i, field_write_en_o.Prescaler4, field_data_o.Prescaler4, current_field_value_i.Prescaler4);

    Prescaler5_write_en(0) <= register_write_en_i.Prescaler5;
    write_interface_core((0 => 0), (0 => WRITE), Prescaler5_write_en, data_bus_i, field_write_en_o.Prescaler5, field_data_o.Prescaler5, current_field_value_i.Prescaler5);

    Prescaler6_write_en(0) <= register_write_en_i.Prescaler6;
    write_interface_core((0 => 0), (0 => WRITE), Prescaler6_write_en, data_bus_i, field_write_en_o.Prescaler6, field_data_o.Prescaler6, current_field_value_i.Prescaler6);

    Prescaler7_write_en(0) <= register_write_en_i.Prescaler7;
    write_interface_core((0 => 0), (0 => WRITE), Prescaler7_write_en, data_bus_i, field_write_en_o.Prescaler7, field_data_o.Prescaler7, current_field_value_i.Prescaler7);

    PrescPhase0_write_en(0) <= register_write_en_i.PrescPhase0;
    write_interface_core((0 => 0), (0 => WRITE), PrescPhase0_write_en, data_bus_i, field_write_en_o.PrescPhase0, field_data_o.PrescPhase0, current_field_value_i.PrescPhase0);

    PrescPhase1_write_en(0) <= register_write_en_i.PrescPhase1;
    write_interface_core((0 => 0), (0 => WRITE), PrescPhase1_write_en, data_bus_i, field_write_en_o.PrescPhase1, field_data_o.PrescPhase1, current_field_value_i.PrescPhase1);

    PrescPhase2_write_en(0) <= register_write_en_i.PrescPhase2;
    write_interface_core((0 => 0), (0 => WRITE), PrescPhase2_write_en, data_bus_i, field_write_en_o.PrescPhase2, field_data_o.PrescPhase2, current_field_value_i.PrescPhase2);

    PrescPhase3_write_en(0) <= register_write_en_i.PrescPhase3;
    write_interface_core((0 => 0), (0 => WRITE), PrescPhase3_write_en, data_bus_i, field_write_en_o.PrescPhase3, field_data_o.PrescPhase3, current_field_value_i.PrescPhase3);

    PrescPhase4_write_en(0) <= register_write_en_i.PrescPhase4;
    write_interface_core((0 => 0), (0 => WRITE), PrescPhase4_write_en, data_bus_i, field_write_en_o.PrescPhase4, field_data_o.PrescPhase4, current_field_value_i.PrescPhase4);

    PrescPhase5_write_en(0) <= register_write_en_i.PrescPhase5;
    write_interface_core((0 => 0), (0 => WRITE), PrescPhase5_write_en, data_bus_i, field_write_en_o.PrescPhase5, field_data_o.PrescPhase5, current_field_value_i.PrescPhase5);

    PrescPhase6_write_en(0) <= register_write_en_i.PrescPhase6;
    write_interface_core((0 => 0), (0 => WRITE), PrescPhase6_write_en, data_bus_i, field_write_en_o.PrescPhase6, field_data_o.PrescPhase6, current_field_value_i.PrescPhase6);

    PrescPhase7_write_en(0) <= register_write_en_i.PrescPhase7;
    write_interface_core((0 => 0), (0 => WRITE), PrescPhase7_write_en, data_bus_i, field_write_en_o.PrescPhase7, field_data_o.PrescPhase7, current_field_value_i.PrescPhase7);

    PrescTrig0_write_en(0) <= register_write_en_i.PrescTrig0;
    write_interface_core((0 => 0), (0 => WRITE), PrescTrig0_write_en, data_bus_i, field_write_en_o.PrescTrig0, field_data_o.PrescTrig0, current_field_value_i.PrescTrig0);

    PrescTrig1_write_en(0) <= register_write_en_i.PrescTrig1;
    write_interface_core((0 => 0), (0 => WRITE), PrescTrig1_write_en, data_bus_i, field_write_en_o.PrescTrig1, field_data_o.PrescTrig1, current_field_value_i.PrescTrig1);

    PrescTrig2_write_en(0) <= register_write_en_i.PrescTrig2;
    write_interface_core((0 => 0), (0 => WRITE), PrescTrig2_write_en, data_bus_i, field_write_en_o.PrescTrig2, field_data_o.PrescTrig2, current_field_value_i.PrescTrig2);

    PrescTrig3_write_en(0) <= register_write_en_i.PrescTrig3;
    write_interface_core((0 => 0), (0 => WRITE), PrescTrig3_write_en, data_bus_i, field_write_en_o.PrescTrig3, field_data_o.PrescTrig3, current_field_value_i.PrescTrig3);

    PrescTrig4_write_en(0) <= register_write_en_i.PrescTrig4;
    write_interface_core((0 => 0), (0 => WRITE), PrescTrig4_write_en, data_bus_i, field_write_en_o.PrescTrig4, field_data_o.PrescTrig4, current_field_value_i.PrescTrig4);

    PrescTrig5_write_en(0) <= register_write_en_i.PrescTrig5;
    write_interface_core((0 => 0), (0 => WRITE), PrescTrig5_write_en, data_bus_i, field_write_en_o.PrescTrig5, field_data_o.PrescTrig5, current_field_value_i.PrescTrig5);

    PrescTrig6_write_en(0) <= register_write_en_i.PrescTrig6;
    write_interface_core((0 => 0), (0 => WRITE), PrescTrig6_write_en, data_bus_i, field_write_en_o.PrescTrig6, field_data_o.PrescTrig6, current_field_value_i.PrescTrig6);

    PrescTrig7_write_en(0) <= register_write_en_i.PrescTrig7;
    write_interface_core((0 => 0), (0 => WRITE), PrescTrig7_write_en, data_bus_i, field_write_en_o.PrescTrig7, field_data_o.PrescTrig7, current_field_value_i.PrescTrig7);

    DBusTrig0_write_en(0) <= register_write_en_i.DBusTrig0;
    write_interface_core((0 => 0), (0 => WRITE), DBusTrig0_write_en, data_bus_i, field_write_en_o.DBusTrig0, field_data_o.DBusTrig0, current_field_value_i.DBusTrig0);

    DBusTrig1_write_en(0) <= register_write_en_i.DBusTrig1;
    write_interface_core((0 => 0), (0 => WRITE), DBusTrig1_write_en, data_bus_i, field_write_en_o.DBusTrig1, field_data_o.DBusTrig1, current_field_value_i.DBusTrig1);

    DBusTrig2_write_en(0) <= register_write_en_i.DBusTrig2;
    write_interface_core((0 => 0), (0 => WRITE), DBusTrig2_write_en, data_bus_i, field_write_en_o.DBusTrig2, field_data_o.DBusTrig2, current_field_value_i.DBusTrig2);

    DBusTrig3_write_en(0) <= register_write_en_i.DBusTrig3;
    write_interface_core((0 => 0), (0 => WRITE), DBusTrig3_write_en, data_bus_i, field_write_en_o.DBusTrig3, field_data_o.DBusTrig3, current_field_value_i.DBusTrig3);

    DBusTrig4_write_en(0) <= register_write_en_i.DBusTrig4;
    write_interface_core((0 => 0), (0 => WRITE), DBusTrig4_write_en, data_bus_i, field_write_en_o.DBusTrig4, field_data_o.DBusTrig4, current_field_value_i.DBusTrig4);

    DBusTrig5_write_en(0) <= register_write_en_i.DBusTrig5;
    write_interface_core((0 => 0), (0 => WRITE), DBusTrig5_write_en, data_bus_i, field_write_en_o.DBusTrig5, field_data_o.DBusTrig5, current_field_value_i.DBusTrig5);

    DBusTrig6_write_en(0) <= register_write_en_i.DBusTrig6;
    write_interface_core((0 => 0), (0 => WRITE), DBusTrig6_write_en, data_bus_i, field_write_en_o.DBusTrig6, field_data_o.DBusTrig6, current_field_value_i.DBusTrig6);

    DBusTrig7_write_en(0) <= register_write_en_i.DBusTrig7;
    write_interface_core((0 => 0), (0 => WRITE), DBusTrig7_write_en, data_bus_i, field_write_en_o.DBusTrig7, field_data_o.DBusTrig7, current_field_value_i.DBusTrig7);

    Pulse0Ctrl_write_en(0) <= register_write_en_i.Pulse0Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse0Ctrl_write_en, data_bus_i, field_write_en_o.Pulse0Ctrl, field_data_o.Pulse0Ctrl, current_field_value_i.Pulse0Ctrl);

    Pulse0Presc_write_en(0) <= register_write_en_i.Pulse0Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse0Presc_write_en, data_bus_i, field_write_en_o.Pulse0Presc, field_data_o.Pulse0Presc, current_field_value_i.Pulse0Presc);

    Pulse0Delay_write_en(0) <= register_write_en_i.Pulse0Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse0Delay_write_en, data_bus_i, field_write_en_o.Pulse0Delay, field_data_o.Pulse0Delay, current_field_value_i.Pulse0Delay);

    Pulse0Width_write_en(0) <= register_write_en_i.Pulse0Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse0Width_write_en, data_bus_i, field_write_en_o.Pulse0Width, field_data_o.Pulse0Width, current_field_value_i.Pulse0Width);

    Pulse1Ctrl_write_en(0) <= register_write_en_i.Pulse1Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse1Ctrl_write_en, data_bus_i, field_write_en_o.Pulse1Ctrl, field_data_o.Pulse1Ctrl, current_field_value_i.Pulse1Ctrl);

    Pulse1Presc_write_en(0) <= register_write_en_i.Pulse1Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse1Presc_write_en, data_bus_i, field_write_en_o.Pulse1Presc, field_data_o.Pulse1Presc, current_field_value_i.Pulse1Presc);

    Pulse1Delay_write_en(0) <= register_write_en_i.Pulse1Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse1Delay_write_en, data_bus_i, field_write_en_o.Pulse1Delay, field_data_o.Pulse1Delay, current_field_value_i.Pulse1Delay);

    Pulse1Width_write_en(0) <= register_write_en_i.Pulse1Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse1Width_write_en, data_bus_i, field_write_en_o.Pulse1Width, field_data_o.Pulse1Width, current_field_value_i.Pulse1Width);

    Pulse2Ctrl_write_en(0) <= register_write_en_i.Pulse2Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse2Ctrl_write_en, data_bus_i, field_write_en_o.Pulse2Ctrl, field_data_o.Pulse2Ctrl, current_field_value_i.Pulse2Ctrl);

    Pulse2Presc_write_en(0) <= register_write_en_i.Pulse2Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse2Presc_write_en, data_bus_i, field_write_en_o.Pulse2Presc, field_data_o.Pulse2Presc, current_field_value_i.Pulse2Presc);

    Pulse2Delay_write_en(0) <= register_write_en_i.Pulse2Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse2Delay_write_en, data_bus_i, field_write_en_o.Pulse2Delay, field_data_o.Pulse2Delay, current_field_value_i.Pulse2Delay);

    Pulse2Width_write_en(0) <= register_write_en_i.Pulse2Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse2Width_write_en, data_bus_i, field_write_en_o.Pulse2Width, field_data_o.Pulse2Width, current_field_value_i.Pulse2Width);

    Pulse3Ctrl_write_en(0) <= register_write_en_i.Pulse3Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse3Ctrl_write_en, data_bus_i, field_write_en_o.Pulse3Ctrl, field_data_o.Pulse3Ctrl, current_field_value_i.Pulse3Ctrl);

    Pulse3Presc_write_en(0) <= register_write_en_i.Pulse3Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse3Presc_write_en, data_bus_i, field_write_en_o.Pulse3Presc, field_data_o.Pulse3Presc, current_field_value_i.Pulse3Presc);

    Pulse3Delay_write_en(0) <= register_write_en_i.Pulse3Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse3Delay_write_en, data_bus_i, field_write_en_o.Pulse3Delay, field_data_o.Pulse3Delay, current_field_value_i.Pulse3Delay);

    Pulse3Width_write_en(0) <= register_write_en_i.Pulse3Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse3Width_write_en, data_bus_i, field_write_en_o.Pulse3Width, field_data_o.Pulse3Width, current_field_value_i.Pulse3Width);

    Pulse4Ctrl_write_en(0) <= register_write_en_i.Pulse4Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse4Ctrl_write_en, data_bus_i, field_write_en_o.Pulse4Ctrl, field_data_o.Pulse4Ctrl, current_field_value_i.Pulse4Ctrl);

    Pulse4Presc_write_en(0) <= register_write_en_i.Pulse4Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse4Presc_write_en, data_bus_i, field_write_en_o.Pulse4Presc, field_data_o.Pulse4Presc, current_field_value_i.Pulse4Presc);

    Pulse4Delay_write_en(0) <= register_write_en_i.Pulse4Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse4Delay_write_en, data_bus_i, field_write_en_o.Pulse4Delay, field_data_o.Pulse4Delay, current_field_value_i.Pulse4Delay);

    Pulse4Width_write_en(0) <= register_write_en_i.Pulse4Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse4Width_write_en, data_bus_i, field_write_en_o.Pulse4Width, field_data_o.Pulse4Width, current_field_value_i.Pulse4Width);

    Pulse5Ctrl_write_en(0) <= register_write_en_i.Pulse5Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse5Ctrl_write_en, data_bus_i, field_write_en_o.Pulse5Ctrl, field_data_o.Pulse5Ctrl, current_field_value_i.Pulse5Ctrl);

    Pulse5Presc_write_en(0) <= register_write_en_i.Pulse5Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse5Presc_write_en, data_bus_i, field_write_en_o.Pulse5Presc, field_data_o.Pulse5Presc, current_field_value_i.Pulse5Presc);

    Pulse5Delay_write_en(0) <= register_write_en_i.Pulse5Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse5Delay_write_en, data_bus_i, field_write_en_o.Pulse5Delay, field_data_o.Pulse5Delay, current_field_value_i.Pulse5Delay);

    Pulse5Width_write_en(0) <= register_write_en_i.Pulse5Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse5Width_write_en, data_bus_i, field_write_en_o.Pulse5Width, field_data_o.Pulse5Width, current_field_value_i.Pulse5Width);

    Pulse6Ctrl_write_en(0) <= register_write_en_i.Pulse6Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse6Ctrl_write_en, data_bus_i, field_write_en_o.Pulse6Ctrl, field_data_o.Pulse6Ctrl, current_field_value_i.Pulse6Ctrl);

    Pulse6Presc_write_en(0) <= register_write_en_i.Pulse6Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse6Presc_write_en, data_bus_i, field_write_en_o.Pulse6Presc, field_data_o.Pulse6Presc, current_field_value_i.Pulse6Presc);

    Pulse6Delay_write_en(0) <= register_write_en_i.Pulse6Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse6Delay_write_en, data_bus_i, field_write_en_o.Pulse6Delay, field_data_o.Pulse6Delay, current_field_value_i.Pulse6Delay);

    Pulse6Width_write_en(0) <= register_write_en_i.Pulse6Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse6Width_write_en, data_bus_i, field_write_en_o.Pulse6Width, field_data_o.Pulse6Width, current_field_value_i.Pulse6Width);

    Pulse7Ctrl_write_en(0) <= register_write_en_i.Pulse7Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse7Ctrl_write_en, data_bus_i, field_write_en_o.Pulse7Ctrl, field_data_o.Pulse7Ctrl, current_field_value_i.Pulse7Ctrl);

    Pulse7Presc_write_en(0) <= register_write_en_i.Pulse7Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse7Presc_write_en, data_bus_i, field_write_en_o.Pulse7Presc, field_data_o.Pulse7Presc, current_field_value_i.Pulse7Presc);

    Pulse7Delay_write_en(0) <= register_write_en_i.Pulse7Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse7Delay_write_en, data_bus_i, field_write_en_o.Pulse7Delay, field_data_o.Pulse7Delay, current_field_value_i.Pulse7Delay);

    Pulse7Width_write_en(0) <= register_write_en_i.Pulse7Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse7Width_write_en, data_bus_i, field_write_en_o.Pulse7Width, field_data_o.Pulse7Width, current_field_value_i.Pulse7Width);

    Pulse8Ctrl_write_en(0) <= register_write_en_i.Pulse8Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse8Ctrl_write_en, data_bus_i, field_write_en_o.Pulse8Ctrl, field_data_o.Pulse8Ctrl, current_field_value_i.Pulse8Ctrl);

    Pulse8Presc_write_en(0) <= register_write_en_i.Pulse8Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse8Presc_write_en, data_bus_i, field_write_en_o.Pulse8Presc, field_data_o.Pulse8Presc, current_field_value_i.Pulse8Presc);

    Pulse8Delay_write_en(0) <= register_write_en_i.Pulse8Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse8Delay_write_en, data_bus_i, field_write_en_o.Pulse8Delay, field_data_o.Pulse8Delay, current_field_value_i.Pulse8Delay);

    Pulse8Width_write_en(0) <= register_write_en_i.Pulse8Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse8Width_write_en, data_bus_i, field_write_en_o.Pulse8Width, field_data_o.Pulse8Width, current_field_value_i.Pulse8Width);

    Pulse9Ctrl_write_en(0) <= register_write_en_i.Pulse9Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse9Ctrl_write_en, data_bus_i, field_write_en_o.Pulse9Ctrl, field_data_o.Pulse9Ctrl, current_field_value_i.Pulse9Ctrl);

    Pulse9Presc_write_en(0) <= register_write_en_i.Pulse9Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse9Presc_write_en, data_bus_i, field_write_en_o.Pulse9Presc, field_data_o.Pulse9Presc, current_field_value_i.Pulse9Presc);

    Pulse9Delay_write_en(0) <= register_write_en_i.Pulse9Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse9Delay_write_en, data_bus_i, field_write_en_o.Pulse9Delay, field_data_o.Pulse9Delay, current_field_value_i.Pulse9Delay);

    Pulse9Width_write_en(0) <= register_write_en_i.Pulse9Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse9Width_write_en, data_bus_i, field_write_en_o.Pulse9Width, field_data_o.Pulse9Width, current_field_value_i.Pulse9Width);

    Pulse10Ctrl_write_en(0) <= register_write_en_i.Pulse10Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse10Ctrl_write_en, data_bus_i, field_write_en_o.Pulse10Ctrl, field_data_o.Pulse10Ctrl, current_field_value_i.Pulse10Ctrl);

    Pulse10Presc_write_en(0) <= register_write_en_i.Pulse10Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse10Presc_write_en, data_bus_i, field_write_en_o.Pulse10Presc, field_data_o.Pulse10Presc, current_field_value_i.Pulse10Presc);

    Pulse10Delay_write_en(0) <= register_write_en_i.Pulse10Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse10Delay_write_en, data_bus_i, field_write_en_o.Pulse10Delay, field_data_o.Pulse10Delay, current_field_value_i.Pulse10Delay);

    Pulse10Width_write_en(0) <= register_write_en_i.Pulse10Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse10Width_write_en, data_bus_i, field_write_en_o.Pulse10Width, field_data_o.Pulse10Width, current_field_value_i.Pulse10Width);

    Pulse11Ctrl_write_en(0) <= register_write_en_i.Pulse11Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse11Ctrl_write_en, data_bus_i, field_write_en_o.Pulse11Ctrl, field_data_o.Pulse11Ctrl, current_field_value_i.Pulse11Ctrl);

    Pulse11Presc_write_en(0) <= register_write_en_i.Pulse11Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse11Presc_write_en, data_bus_i, field_write_en_o.Pulse11Presc, field_data_o.Pulse11Presc, current_field_value_i.Pulse11Presc);

    Pulse11Delay_write_en(0) <= register_write_en_i.Pulse11Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse11Delay_write_en, data_bus_i, field_write_en_o.Pulse11Delay, field_data_o.Pulse11Delay, current_field_value_i.Pulse11Delay);

    Pulse11Width_write_en(0) <= register_write_en_i.Pulse11Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse11Width_write_en, data_bus_i, field_write_en_o.Pulse11Width, field_data_o.Pulse11Width, current_field_value_i.Pulse11Width);

    Pulse12Ctrl_write_en(0) <= register_write_en_i.Pulse12Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse12Ctrl_write_en, data_bus_i, field_write_en_o.Pulse12Ctrl, field_data_o.Pulse12Ctrl, current_field_value_i.Pulse12Ctrl);

    Pulse12Presc_write_en(0) <= register_write_en_i.Pulse12Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse12Presc_write_en, data_bus_i, field_write_en_o.Pulse12Presc, field_data_o.Pulse12Presc, current_field_value_i.Pulse12Presc);

    Pulse12Delay_write_en(0) <= register_write_en_i.Pulse12Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse12Delay_write_en, data_bus_i, field_write_en_o.Pulse12Delay, field_data_o.Pulse12Delay, current_field_value_i.Pulse12Delay);

    Pulse12Width_write_en(0) <= register_write_en_i.Pulse12Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse12Width_write_en, data_bus_i, field_write_en_o.Pulse12Width, field_data_o.Pulse12Width, current_field_value_i.Pulse12Width);

    Pulse13Ctrl_write_en(0) <= register_write_en_i.Pulse13Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse13Ctrl_write_en, data_bus_i, field_write_en_o.Pulse13Ctrl, field_data_o.Pulse13Ctrl, current_field_value_i.Pulse13Ctrl);

    Pulse13Presc_write_en(0) <= register_write_en_i.Pulse13Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse13Presc_write_en, data_bus_i, field_write_en_o.Pulse13Presc, field_data_o.Pulse13Presc, current_field_value_i.Pulse13Presc);

    Pulse13Delay_write_en(0) <= register_write_en_i.Pulse13Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse13Delay_write_en, data_bus_i, field_write_en_o.Pulse13Delay, field_data_o.Pulse13Delay, current_field_value_i.Pulse13Delay);

    Pulse13Width_write_en(0) <= register_write_en_i.Pulse13Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse13Width_write_en, data_bus_i, field_write_en_o.Pulse13Width, field_data_o.Pulse13Width, current_field_value_i.Pulse13Width);

    Pulse14Ctrl_write_en(0) <= register_write_en_i.Pulse14Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse14Ctrl_write_en, data_bus_i, field_write_en_o.Pulse14Ctrl, field_data_o.Pulse14Ctrl, current_field_value_i.Pulse14Ctrl);

    Pulse14Presc_write_en(0) <= register_write_en_i.Pulse14Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse14Presc_write_en, data_bus_i, field_write_en_o.Pulse14Presc, field_data_o.Pulse14Presc, current_field_value_i.Pulse14Presc);

    Pulse14Delay_write_en(0) <= register_write_en_i.Pulse14Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse14Delay_write_en, data_bus_i, field_write_en_o.Pulse14Delay, field_data_o.Pulse14Delay, current_field_value_i.Pulse14Delay);

    Pulse14Width_write_en(0) <= register_write_en_i.Pulse14Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse14Width_write_en, data_bus_i, field_write_en_o.Pulse14Width, field_data_o.Pulse14Width, current_field_value_i.Pulse14Width);

    Pulse15Ctrl_write_en(0) <= register_write_en_i.Pulse15Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse15Ctrl_write_en, data_bus_i, field_write_en_o.Pulse15Ctrl, field_data_o.Pulse15Ctrl, current_field_value_i.Pulse15Ctrl);

    Pulse15Presc_write_en(0) <= register_write_en_i.Pulse15Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse15Presc_write_en, data_bus_i, field_write_en_o.Pulse15Presc, field_data_o.Pulse15Presc, current_field_value_i.Pulse15Presc);

    Pulse15Delay_write_en(0) <= register_write_en_i.Pulse15Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse15Delay_write_en, data_bus_i, field_write_en_o.Pulse15Delay, field_data_o.Pulse15Delay, current_field_value_i.Pulse15Delay);

    Pulse15Width_write_en(0) <= register_write_en_i.Pulse15Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse15Width_write_en, data_bus_i, field_write_en_o.Pulse15Width, field_data_o.Pulse15Width, current_field_value_i.Pulse15Width);

    Pulse16Ctrl_write_en(0) <= register_write_en_i.Pulse16Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse16Ctrl_write_en, data_bus_i, field_write_en_o.Pulse16Ctrl, field_data_o.Pulse16Ctrl, current_field_value_i.Pulse16Ctrl);

    Pulse16Presc_write_en(0) <= register_write_en_i.Pulse16Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse16Presc_write_en, data_bus_i, field_write_en_o.Pulse16Presc, field_data_o.Pulse16Presc, current_field_value_i.Pulse16Presc);

    Pulse16Delay_write_en(0) <= register_write_en_i.Pulse16Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse16Delay_write_en, data_bus_i, field_write_en_o.Pulse16Delay, field_data_o.Pulse16Delay, current_field_value_i.Pulse16Delay);

    Pulse16Width_write_en(0) <= register_write_en_i.Pulse16Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse16Width_write_en, data_bus_i, field_write_en_o.Pulse16Width, field_data_o.Pulse16Width, current_field_value_i.Pulse16Width);

    Pulse17Ctrl_write_en(0) <= register_write_en_i.Pulse17Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse17Ctrl_write_en, data_bus_i, field_write_en_o.Pulse17Ctrl, field_data_o.Pulse17Ctrl, current_field_value_i.Pulse17Ctrl);

    Pulse17Presc_write_en(0) <= register_write_en_i.Pulse17Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse17Presc_write_en, data_bus_i, field_write_en_o.Pulse17Presc, field_data_o.Pulse17Presc, current_field_value_i.Pulse17Presc);

    Pulse17Delay_write_en(0) <= register_write_en_i.Pulse17Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse17Delay_write_en, data_bus_i, field_write_en_o.Pulse17Delay, field_data_o.Pulse17Delay, current_field_value_i.Pulse17Delay);

    Pulse17Width_write_en(0) <= register_write_en_i.Pulse17Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse17Width_write_en, data_bus_i, field_write_en_o.Pulse17Width, field_data_o.Pulse17Width, current_field_value_i.Pulse17Width);

    Pulse18Ctrl_write_en(0) <= register_write_en_i.Pulse18Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse18Ctrl_write_en, data_bus_i, field_write_en_o.Pulse18Ctrl, field_data_o.Pulse18Ctrl, current_field_value_i.Pulse18Ctrl);

    Pulse18Presc_write_en(0) <= register_write_en_i.Pulse18Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse18Presc_write_en, data_bus_i, field_write_en_o.Pulse18Presc, field_data_o.Pulse18Presc, current_field_value_i.Pulse18Presc);

    Pulse18Delay_write_en(0) <= register_write_en_i.Pulse18Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse18Delay_write_en, data_bus_i, field_write_en_o.Pulse18Delay, field_data_o.Pulse18Delay, current_field_value_i.Pulse18Delay);

    Pulse18Width_write_en(0) <= register_write_en_i.Pulse18Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse18Width_write_en, data_bus_i, field_write_en_o.Pulse18Width, field_data_o.Pulse18Width, current_field_value_i.Pulse18Width);

    Pulse19Ctrl_write_en(0) <= register_write_en_i.Pulse19Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse19Ctrl_write_en, data_bus_i, field_write_en_o.Pulse19Ctrl, field_data_o.Pulse19Ctrl, current_field_value_i.Pulse19Ctrl);

    Pulse19Presc_write_en(0) <= register_write_en_i.Pulse19Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse19Presc_write_en, data_bus_i, field_write_en_o.Pulse19Presc, field_data_o.Pulse19Presc, current_field_value_i.Pulse19Presc);

    Pulse19Delay_write_en(0) <= register_write_en_i.Pulse19Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse19Delay_write_en, data_bus_i, field_write_en_o.Pulse19Delay, field_data_o.Pulse19Delay, current_field_value_i.Pulse19Delay);

    Pulse19Width_write_en(0) <= register_write_en_i.Pulse19Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse19Width_write_en, data_bus_i, field_write_en_o.Pulse19Width, field_data_o.Pulse19Width, current_field_value_i.Pulse19Width);

    Pulse20Ctrl_write_en(0) <= register_write_en_i.Pulse20Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse20Ctrl_write_en, data_bus_i, field_write_en_o.Pulse20Ctrl, field_data_o.Pulse20Ctrl, current_field_value_i.Pulse20Ctrl);

    Pulse20Presc_write_en(0) <= register_write_en_i.Pulse20Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse20Presc_write_en, data_bus_i, field_write_en_o.Pulse20Presc, field_data_o.Pulse20Presc, current_field_value_i.Pulse20Presc);

    Pulse20Delay_write_en(0) <= register_write_en_i.Pulse20Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse20Delay_write_en, data_bus_i, field_write_en_o.Pulse20Delay, field_data_o.Pulse20Delay, current_field_value_i.Pulse20Delay);

    Pulse20Width_write_en(0) <= register_write_en_i.Pulse20Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse20Width_write_en, data_bus_i, field_write_en_o.Pulse20Width, field_data_o.Pulse20Width, current_field_value_i.Pulse20Width);

    Pulse21Ctrl_write_en(0) <= register_write_en_i.Pulse21Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse21Ctrl_write_en, data_bus_i, field_write_en_o.Pulse21Ctrl, field_data_o.Pulse21Ctrl, current_field_value_i.Pulse21Ctrl);

    Pulse21Presc_write_en(0) <= register_write_en_i.Pulse21Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse21Presc_write_en, data_bus_i, field_write_en_o.Pulse21Presc, field_data_o.Pulse21Presc, current_field_value_i.Pulse21Presc);

    Pulse21Delay_write_en(0) <= register_write_en_i.Pulse21Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse21Delay_write_en, data_bus_i, field_write_en_o.Pulse21Delay, field_data_o.Pulse21Delay, current_field_value_i.Pulse21Delay);

    Pulse21Width_write_en(0) <= register_write_en_i.Pulse21Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse21Width_write_en, data_bus_i, field_write_en_o.Pulse21Width, field_data_o.Pulse21Width, current_field_value_i.Pulse21Width);

    Pulse22Ctrl_write_en(0) <= register_write_en_i.Pulse22Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse22Ctrl_write_en, data_bus_i, field_write_en_o.Pulse22Ctrl, field_data_o.Pulse22Ctrl, current_field_value_i.Pulse22Ctrl);

    Pulse22Presc_write_en(0) <= register_write_en_i.Pulse22Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse22Presc_write_en, data_bus_i, field_write_en_o.Pulse22Presc, field_data_o.Pulse22Presc, current_field_value_i.Pulse22Presc);

    Pulse22Delay_write_en(0) <= register_write_en_i.Pulse22Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse22Delay_write_en, data_bus_i, field_write_en_o.Pulse22Delay, field_data_o.Pulse22Delay, current_field_value_i.Pulse22Delay);

    Pulse22Width_write_en(0) <= register_write_en_i.Pulse22Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse22Width_write_en, data_bus_i, field_write_en_o.Pulse22Width, field_data_o.Pulse22Width, current_field_value_i.Pulse22Width);

    Pulse23Ctrl_write_en(0) <= register_write_en_i.Pulse23Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse23Ctrl_write_en, data_bus_i, field_write_en_o.Pulse23Ctrl, field_data_o.Pulse23Ctrl, current_field_value_i.Pulse23Ctrl);

    Pulse23Presc_write_en(0) <= register_write_en_i.Pulse23Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse23Presc_write_en, data_bus_i, field_write_en_o.Pulse23Presc, field_data_o.Pulse23Presc, current_field_value_i.Pulse23Presc);

    Pulse23Delay_write_en(0) <= register_write_en_i.Pulse23Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse23Delay_write_en, data_bus_i, field_write_en_o.Pulse23Delay, field_data_o.Pulse23Delay, current_field_value_i.Pulse23Delay);

    Pulse23Width_write_en(0) <= register_write_en_i.Pulse23Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse23Width_write_en, data_bus_i, field_write_en_o.Pulse23Width, field_data_o.Pulse23Width, current_field_value_i.Pulse23Width);

    Pulse24Ctrl_write_en(0) <= register_write_en_i.Pulse24Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse24Ctrl_write_en, data_bus_i, field_write_en_o.Pulse24Ctrl, field_data_o.Pulse24Ctrl, current_field_value_i.Pulse24Ctrl);

    Pulse24Presc_write_en(0) <= register_write_en_i.Pulse24Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse24Presc_write_en, data_bus_i, field_write_en_o.Pulse24Presc, field_data_o.Pulse24Presc, current_field_value_i.Pulse24Presc);

    Pulse24Delay_write_en(0) <= register_write_en_i.Pulse24Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse24Delay_write_en, data_bus_i, field_write_en_o.Pulse24Delay, field_data_o.Pulse24Delay, current_field_value_i.Pulse24Delay);

    Pulse24Width_write_en(0) <= register_write_en_i.Pulse24Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse24Width_write_en, data_bus_i, field_write_en_o.Pulse24Width, field_data_o.Pulse24Width, current_field_value_i.Pulse24Width);

    Pulse25Ctrl_write_en(0) <= register_write_en_i.Pulse25Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse25Ctrl_write_en, data_bus_i, field_write_en_o.Pulse25Ctrl, field_data_o.Pulse25Ctrl, current_field_value_i.Pulse25Ctrl);

    Pulse25Presc_write_en(0) <= register_write_en_i.Pulse25Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse25Presc_write_en, data_bus_i, field_write_en_o.Pulse25Presc, field_data_o.Pulse25Presc, current_field_value_i.Pulse25Presc);

    Pulse25Delay_write_en(0) <= register_write_en_i.Pulse25Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse25Delay_write_en, data_bus_i, field_write_en_o.Pulse25Delay, field_data_o.Pulse25Delay, current_field_value_i.Pulse25Delay);

    Pulse25Width_write_en(0) <= register_write_en_i.Pulse25Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse25Width_write_en, data_bus_i, field_write_en_o.Pulse25Width, field_data_o.Pulse25Width, current_field_value_i.Pulse25Width);

    Pulse26Ctrl_write_en(0) <= register_write_en_i.Pulse26Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse26Ctrl_write_en, data_bus_i, field_write_en_o.Pulse26Ctrl, field_data_o.Pulse26Ctrl, current_field_value_i.Pulse26Ctrl);

    Pulse26Presc_write_en(0) <= register_write_en_i.Pulse26Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse26Presc_write_en, data_bus_i, field_write_en_o.Pulse26Presc, field_data_o.Pulse26Presc, current_field_value_i.Pulse26Presc);

    Pulse26Delay_write_en(0) <= register_write_en_i.Pulse26Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse26Delay_write_en, data_bus_i, field_write_en_o.Pulse26Delay, field_data_o.Pulse26Delay, current_field_value_i.Pulse26Delay);

    Pulse26Width_write_en(0) <= register_write_en_i.Pulse26Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse26Width_write_en, data_bus_i, field_write_en_o.Pulse26Width, field_data_o.Pulse26Width, current_field_value_i.Pulse26Width);

    Pulse27Ctrl_write_en(0) <= register_write_en_i.Pulse27Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse27Ctrl_write_en, data_bus_i, field_write_en_o.Pulse27Ctrl, field_data_o.Pulse27Ctrl, current_field_value_i.Pulse27Ctrl);

    Pulse27Presc_write_en(0) <= register_write_en_i.Pulse27Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse27Presc_write_en, data_bus_i, field_write_en_o.Pulse27Presc, field_data_o.Pulse27Presc, current_field_value_i.Pulse27Presc);

    Pulse27Delay_write_en(0) <= register_write_en_i.Pulse27Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse27Delay_write_en, data_bus_i, field_write_en_o.Pulse27Delay, field_data_o.Pulse27Delay, current_field_value_i.Pulse27Delay);

    Pulse27Width_write_en(0) <= register_write_en_i.Pulse27Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse27Width_write_en, data_bus_i, field_write_en_o.Pulse27Width, field_data_o.Pulse27Width, current_field_value_i.Pulse27Width);

    Pulse28Ctrl_write_en(0) <= register_write_en_i.Pulse28Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse28Ctrl_write_en, data_bus_i, field_write_en_o.Pulse28Ctrl, field_data_o.Pulse28Ctrl, current_field_value_i.Pulse28Ctrl);

    Pulse28Presc_write_en(0) <= register_write_en_i.Pulse28Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse28Presc_write_en, data_bus_i, field_write_en_o.Pulse28Presc, field_data_o.Pulse28Presc, current_field_value_i.Pulse28Presc);

    Pulse28Delay_write_en(0) <= register_write_en_i.Pulse28Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse28Delay_write_en, data_bus_i, field_write_en_o.Pulse28Delay, field_data_o.Pulse28Delay, current_field_value_i.Pulse28Delay);

    Pulse28Width_write_en(0) <= register_write_en_i.Pulse28Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse28Width_write_en, data_bus_i, field_write_en_o.Pulse28Width, field_data_o.Pulse28Width, current_field_value_i.Pulse28Width);

    Pulse29Ctrl_write_en(0) <= register_write_en_i.Pulse29Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse29Ctrl_write_en, data_bus_i, field_write_en_o.Pulse29Ctrl, field_data_o.Pulse29Ctrl, current_field_value_i.Pulse29Ctrl);

    Pulse29Presc_write_en(0) <= register_write_en_i.Pulse29Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse29Presc_write_en, data_bus_i, field_write_en_o.Pulse29Presc, field_data_o.Pulse29Presc, current_field_value_i.Pulse29Presc);

    Pulse29Delay_write_en(0) <= register_write_en_i.Pulse29Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse29Delay_write_en, data_bus_i, field_write_en_o.Pulse29Delay, field_data_o.Pulse29Delay, current_field_value_i.Pulse29Delay);

    Pulse29Width_write_en(0) <= register_write_en_i.Pulse29Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse29Width_write_en, data_bus_i, field_write_en_o.Pulse29Width, field_data_o.Pulse29Width, current_field_value_i.Pulse29Width);

    Pulse30Ctrl_write_en(0) <= register_write_en_i.Pulse30Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse30Ctrl_write_en, data_bus_i, field_write_en_o.Pulse30Ctrl, field_data_o.Pulse30Ctrl, current_field_value_i.Pulse30Ctrl);

    Pulse30Presc_write_en(0) <= register_write_en_i.Pulse30Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse30Presc_write_en, data_bus_i, field_write_en_o.Pulse30Presc, field_data_o.Pulse30Presc, current_field_value_i.Pulse30Presc);

    Pulse30Delay_write_en(0) <= register_write_en_i.Pulse30Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse30Delay_write_en, data_bus_i, field_write_en_o.Pulse30Delay, field_data_o.Pulse30Delay, current_field_value_i.Pulse30Delay);

    Pulse30Width_write_en(0) <= register_write_en_i.Pulse30Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse30Width_write_en, data_bus_i, field_write_en_o.Pulse30Width, field_data_o.Pulse30Width, current_field_value_i.Pulse30Width);

    Pulse31Ctrl_write_en(0) <= register_write_en_i.Pulse31Ctrl;
    write_interface_core((0 => 0), (0 => WRITE), Pulse31Ctrl_write_en, data_bus_i, field_write_en_o.Pulse31Ctrl, field_data_o.Pulse31Ctrl, current_field_value_i.Pulse31Ctrl);

    Pulse31Presc_write_en(0) <= register_write_en_i.Pulse31Presc;
    write_interface_core((0 => 0), (0 => WRITE), Pulse31Presc_write_en, data_bus_i, field_write_en_o.Pulse31Presc, field_data_o.Pulse31Presc, current_field_value_i.Pulse31Presc);

    Pulse31Delay_write_en(0) <= register_write_en_i.Pulse31Delay;
    write_interface_core((0 => 0), (0 => WRITE), Pulse31Delay_write_en, data_bus_i, field_write_en_o.Pulse31Delay, field_data_o.Pulse31Delay, current_field_value_i.Pulse31Delay);

    Pulse31Width_write_en(0) <= register_write_en_i.Pulse31Width;
    write_interface_core((0 => 0), (0 => WRITE), Pulse31Width_write_en, data_bus_i, field_write_en_o.Pulse31Width, field_data_o.Pulse31Width, current_field_value_i.Pulse31Width);

    ESSControl_write_en(0) <= register_write_en_i.ESSControl;
    write_interface_core((0 => 0), (0 => WRITE), ESSControl_write_en, data_bus_i, field_write_en_o.ESSControl, field_data_o.ESSControl, current_field_value_i.ESSControl);



  end process write_interface_cores;

end architecture rtl;
