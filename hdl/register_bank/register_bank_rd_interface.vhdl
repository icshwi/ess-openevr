--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_rd_interface.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-05-21
-- Last update : 2018-05-31
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
-- 0.1 : 2018-05-31  Christian Amstutz
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
entity register_bank_rd_interface is
  port (
    field_value_i      : in  field_data_t;
    logic_value_i      : in  field_data_t;

    register_data_o    : out register_bus_read_t
  );
end entity register_bank_rd_interface;

--------------------------------------------------------------------------------
--! @brief
--------------------------------------------------------------------------------
architecture rtl of register_bank_rd_interface is
begin

  read_interface_cores : process (field_value_i, logic_value_i)
  begin

    -- Make all undefined registers/fields read as UNDEFINED_FIELD_VALUE
    register_data_o <= (others => (others => UNDEFINED_FIELD_VALUE));

    read_interface_logic(32, 0, field_value_i.Status, logic_value_i.Status, register_data_o.Status);
    read_interface_logic(32, 0, field_value_i.Control, logic_value_i.Control, register_data_o.Control);
    read_interface_logic(32, 0, field_value_i.IrqFlag, logic_value_i.IrqFlag, register_data_o.IrqFlag);
    read_interface_logic(32, 0, field_value_i.IrqEnable, logic_value_i.IrqEnable, register_data_o.IrqEnable);
    read_interface_logic(32, 0, field_value_i.PulseIrqMap, logic_value_i.PulseIrqMap, register_data_o.PulseIrqMap);
    read_interface_logic(32, 0, field_value_i.SWEvent, logic_value_i.SWEvent, register_data_o.SWEvent);
    read_interface_logic(32, 0, field_value_i.DataBufCtrl, logic_value_i.DataBufCtrl, register_data_o.DataBufCtrl);
    read_interface_logic(32, 0, field_value_i.TXDataBufCtrl, logic_value_i.TXDataBufCtrl, register_data_o.TXDataBufCtrl);
    read_interface_logic(32, 0, field_value_i.TxSegBufCtrl, logic_value_i.TxSegBufCtrl, register_data_o.TxSegBufCtrl);
    read_interface_logic(32, 0, field_value_i.FWVersion, logic_value_i.FWVersion, register_data_o.FWVersion);
    read_interface_logic(32, 0, field_value_i.EvCntPresc, logic_value_i.EvCntPresc, register_data_o.EvCntPresc);
    read_interface_logic(32, 0, field_value_i.UsecDivider, logic_value_i.UsecDivider, register_data_o.UsecDivider);
    read_interface_logic(32, 0, field_value_i.ClockControl, logic_value_i.ClockControl, register_data_o.ClockControl);
    read_interface_logic(32, 0, field_value_i.SecSR, logic_value_i.SecSR, register_data_o.SecSR);
    read_interface_logic(32, 0, field_value_i.SecCounter, logic_value_i.SecCounter, register_data_o.SecCounter);
    read_interface_logic(32, 0, field_value_i.EventCounter, logic_value_i.EventCounter, register_data_o.EventCounter);
    read_interface_logic(32, 0, field_value_i.SecLatch, logic_value_i.SecLatch, register_data_o.SecLatch);
    read_interface_logic(32, 0, field_value_i.EvCntLatch, logic_value_i.EvCntLatch, register_data_o.EvCntLatch);
    read_interface_logic(32, 0, field_value_i.EvFIFOSec, logic_value_i.EvFIFOSec, register_data_o.EvFIFOSec);
    read_interface_logic(32, 0, field_value_i.EvFIFOEvCnt, logic_value_i.EvFIFOEvCnt, register_data_o.EvFIFOEvCnt);
    read_interface_logic(32, 0, field_value_i.EvFIFOCode, logic_value_i.EvFIFOCode, register_data_o.EvFIFOCode);
    read_interface_logic(32, 0, field_value_i.LogStatus, logic_value_i.LogStatus, register_data_o.LogStatus);
    read_interface_logic(32, 0, field_value_i.GPIODir, logic_value_i.GPIODir, register_data_o.GPIODir);
    read_interface_logic(32, 0, field_value_i.GPIOIn, logic_value_i.GPIOIn, register_data_o.GPIOIn);
    read_interface_logic(32, 0, field_value_i.GPIOOut, logic_value_i.GPIOOut, register_data_o.GPIOOut);
    read_interface_logic(32, 0, field_value_i.DCTarget, logic_value_i.DCTarget, register_data_o.DCTarget);
    read_interface_logic(32, 0, field_value_i.DCRxValue, logic_value_i.DCRxValue, register_data_o.DCRxValue);
    read_interface_logic(32, 0, field_value_i.DCIntValue, logic_value_i.DCIntValue, register_data_o.DCIntValue);
    read_interface_logic(32, 0, field_value_i.DCStatus, logic_value_i.DCStatus, register_data_o.DCStatus);
    read_interface_logic(32, 0, field_value_i.TopologyID, logic_value_i.TopologyID, register_data_o.TopologyID);
    read_interface_logic(32, 0, field_value_i.SeqRamCtrl, logic_value_i.SeqRamCtrl, register_data_o.SeqRamCtrl);
    read_interface_logic(32, 0, field_value_i.Prescaler0, logic_value_i.Prescaler0, register_data_o.Prescaler0);
    read_interface_logic(32, 0, field_value_i.Prescaler1, logic_value_i.Prescaler1, register_data_o.Prescaler1);
    read_interface_logic(32, 0, field_value_i.Prescaler2, logic_value_i.Prescaler2, register_data_o.Prescaler2);
    read_interface_logic(32, 0, field_value_i.Prescaler3, logic_value_i.Prescaler3, register_data_o.Prescaler3);
    read_interface_logic(32, 0, field_value_i.Prescaler4, logic_value_i.Prescaler4, register_data_o.Prescaler4);
    read_interface_logic(32, 0, field_value_i.Prescaler5, logic_value_i.Prescaler5, register_data_o.Prescaler5);
    read_interface_logic(32, 0, field_value_i.Prescaler6, logic_value_i.Prescaler6, register_data_o.Prescaler6);
    read_interface_logic(32, 0, field_value_i.Prescaler7, logic_value_i.Prescaler7, register_data_o.Prescaler7);
    read_interface_logic(32, 0, field_value_i.PrescPhase0, logic_value_i.PrescPhase0, register_data_o.PrescPhase0);
    read_interface_logic(32, 0, field_value_i.PrescPhase1, logic_value_i.PrescPhase1, register_data_o.PrescPhase1);
    read_interface_logic(32, 0, field_value_i.PrescPhase2, logic_value_i.PrescPhase2, register_data_o.PrescPhase2);
    read_interface_logic(32, 0, field_value_i.PrescPhase3, logic_value_i.PrescPhase3, register_data_o.PrescPhase3);
    read_interface_logic(32, 0, field_value_i.PrescPhase4, logic_value_i.PrescPhase4, register_data_o.PrescPhase4);
    read_interface_logic(32, 0, field_value_i.PrescPhase5, logic_value_i.PrescPhase5, register_data_o.PrescPhase5);
    read_interface_logic(32, 0, field_value_i.PrescPhase6, logic_value_i.PrescPhase6, register_data_o.PrescPhase6);
    read_interface_logic(32, 0, field_value_i.PrescPhase7, logic_value_i.PrescPhase7, register_data_o.PrescPhase7);
    read_interface_logic(32, 0, field_value_i.PrescTrig0, logic_value_i.PrescTrig0, register_data_o.PrescTrig0);
    read_interface_logic(32, 0, field_value_i.PrescTrig1, logic_value_i.PrescTrig1, register_data_o.PrescTrig1);
    read_interface_logic(32, 0, field_value_i.PrescTrig2, logic_value_i.PrescTrig2, register_data_o.PrescTrig2);
    read_interface_logic(32, 0, field_value_i.PrescTrig3, logic_value_i.PrescTrig3, register_data_o.PrescTrig3);
    read_interface_logic(32, 0, field_value_i.PrescTrig4, logic_value_i.PrescTrig4, register_data_o.PrescTrig4);
    read_interface_logic(32, 0, field_value_i.PrescTrig5, logic_value_i.PrescTrig5, register_data_o.PrescTrig5);
    read_interface_logic(32, 0, field_value_i.PrescTrig6, logic_value_i.PrescTrig6, register_data_o.PrescTrig6);
    read_interface_logic(32, 0, field_value_i.PrescTrig7, logic_value_i.PrescTrig7, register_data_o.PrescTrig7);
    read_interface_logic(32, 0, field_value_i.DBusTrig0, logic_value_i.DBusTrig0, register_data_o.DBusTrig0);
    read_interface_logic(32, 0, field_value_i.DBusTrig1, logic_value_i.DBusTrig1, register_data_o.DBusTrig1);
    read_interface_logic(32, 0, field_value_i.DBusTrig2, logic_value_i.DBusTrig2, register_data_o.DBusTrig2);
    read_interface_logic(32, 0, field_value_i.DBusTrig3, logic_value_i.DBusTrig3, register_data_o.DBusTrig3);
    read_interface_logic(32, 0, field_value_i.DBusTrig4, logic_value_i.DBusTrig4, register_data_o.DBusTrig4);
    read_interface_logic(32, 0, field_value_i.DBusTrig5, logic_value_i.DBusTrig5, register_data_o.DBusTrig5);
    read_interface_logic(32, 0, field_value_i.DBusTrig6, logic_value_i.DBusTrig6, register_data_o.DBusTrig6);
    read_interface_logic(32, 0, field_value_i.DBusTrig7, logic_value_i.DBusTrig7, register_data_o.DBusTrig7);
    read_interface_logic(32, 0, field_value_i.Pulse0Ctrl, logic_value_i.Pulse0Ctrl, register_data_o.Pulse0Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse0Presc, logic_value_i.Pulse0Presc, register_data_o.Pulse0Presc);
    read_interface_logic(32, 0, field_value_i.Pulse0Delay, logic_value_i.Pulse0Delay, register_data_o.Pulse0Delay);
    read_interface_logic(32, 0, field_value_i.Pulse0Width, logic_value_i.Pulse0Width, register_data_o.Pulse0Width);
    read_interface_logic(32, 0, field_value_i.Pulse1Ctrl, logic_value_i.Pulse1Ctrl, register_data_o.Pulse1Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse1Presc, logic_value_i.Pulse1Presc, register_data_o.Pulse1Presc);
    read_interface_logic(32, 0, field_value_i.Pulse1Delay, logic_value_i.Pulse1Delay, register_data_o.Pulse1Delay);
    read_interface_logic(32, 0, field_value_i.Pulse1Width, logic_value_i.Pulse1Width, register_data_o.Pulse1Width);
    read_interface_logic(32, 0, field_value_i.Pulse2Ctrl, logic_value_i.Pulse2Ctrl, register_data_o.Pulse2Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse2Presc, logic_value_i.Pulse2Presc, register_data_o.Pulse2Presc);
    read_interface_logic(32, 0, field_value_i.Pulse2Delay, logic_value_i.Pulse2Delay, register_data_o.Pulse2Delay);
    read_interface_logic(32, 0, field_value_i.Pulse2Width, logic_value_i.Pulse2Width, register_data_o.Pulse2Width);
    read_interface_logic(32, 0, field_value_i.Pulse3Ctrl, logic_value_i.Pulse3Ctrl, register_data_o.Pulse3Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse3Presc, logic_value_i.Pulse3Presc, register_data_o.Pulse3Presc);
    read_interface_logic(32, 0, field_value_i.Pulse3Delay, logic_value_i.Pulse3Delay, register_data_o.Pulse3Delay);
    read_interface_logic(32, 0, field_value_i.Pulse3Width, logic_value_i.Pulse3Width, register_data_o.Pulse3Width);
    read_interface_logic(32, 0, field_value_i.Pulse4Ctrl, logic_value_i.Pulse4Ctrl, register_data_o.Pulse4Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse4Presc, logic_value_i.Pulse4Presc, register_data_o.Pulse4Presc);
    read_interface_logic(32, 0, field_value_i.Pulse4Delay, logic_value_i.Pulse4Delay, register_data_o.Pulse4Delay);
    read_interface_logic(32, 0, field_value_i.Pulse4Width, logic_value_i.Pulse4Width, register_data_o.Pulse4Width);
    read_interface_logic(32, 0, field_value_i.Pulse5Ctrl, logic_value_i.Pulse5Ctrl, register_data_o.Pulse5Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse5Presc, logic_value_i.Pulse5Presc, register_data_o.Pulse5Presc);
    read_interface_logic(32, 0, field_value_i.Pulse5Delay, logic_value_i.Pulse5Delay, register_data_o.Pulse5Delay);
    read_interface_logic(32, 0, field_value_i.Pulse5Width, logic_value_i.Pulse5Width, register_data_o.Pulse5Width);
    read_interface_logic(32, 0, field_value_i.Pulse6Ctrl, logic_value_i.Pulse6Ctrl, register_data_o.Pulse6Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse6Presc, logic_value_i.Pulse6Presc, register_data_o.Pulse6Presc);
    read_interface_logic(32, 0, field_value_i.Pulse6Delay, logic_value_i.Pulse6Delay, register_data_o.Pulse6Delay);
    read_interface_logic(32, 0, field_value_i.Pulse6Width, logic_value_i.Pulse6Width, register_data_o.Pulse6Width);
    read_interface_logic(32, 0, field_value_i.Pulse7Ctrl, logic_value_i.Pulse7Ctrl, register_data_o.Pulse7Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse7Presc, logic_value_i.Pulse7Presc, register_data_o.Pulse7Presc);
    read_interface_logic(32, 0, field_value_i.Pulse7Delay, logic_value_i.Pulse7Delay, register_data_o.Pulse7Delay);
    read_interface_logic(32, 0, field_value_i.Pulse7Width, logic_value_i.Pulse7Width, register_data_o.Pulse7Width);
    read_interface_logic(32, 0, field_value_i.Pulse8Ctrl, logic_value_i.Pulse8Ctrl, register_data_o.Pulse8Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse8Presc, logic_value_i.Pulse8Presc, register_data_o.Pulse8Presc);
    read_interface_logic(32, 0, field_value_i.Pulse8Delay, logic_value_i.Pulse8Delay, register_data_o.Pulse8Delay);
    read_interface_logic(32, 0, field_value_i.Pulse8Width, logic_value_i.Pulse8Width, register_data_o.Pulse8Width);
    read_interface_logic(32, 0, field_value_i.Pulse9Ctrl, logic_value_i.Pulse9Ctrl, register_data_o.Pulse9Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse9Presc, logic_value_i.Pulse9Presc, register_data_o.Pulse9Presc);
    read_interface_logic(32, 0, field_value_i.Pulse9Delay, logic_value_i.Pulse9Delay, register_data_o.Pulse9Delay);
    read_interface_logic(32, 0, field_value_i.Pulse9Width, logic_value_i.Pulse9Width, register_data_o.Pulse9Width);
    read_interface_logic(32, 0, field_value_i.Pulse10Ctrl, logic_value_i.Pulse10Ctrl, register_data_o.Pulse10Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse10Presc, logic_value_i.Pulse10Presc, register_data_o.Pulse10Presc);
    read_interface_logic(32, 0, field_value_i.Pulse10Delay, logic_value_i.Pulse10Delay, register_data_o.Pulse10Delay);
    read_interface_logic(32, 0, field_value_i.Pulse10Width, logic_value_i.Pulse10Width, register_data_o.Pulse10Width);
    read_interface_logic(32, 0, field_value_i.Pulse11Ctrl, logic_value_i.Pulse11Ctrl, register_data_o.Pulse11Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse11Presc, logic_value_i.Pulse11Presc, register_data_o.Pulse11Presc);
    read_interface_logic(32, 0, field_value_i.Pulse11Delay, logic_value_i.Pulse11Delay, register_data_o.Pulse11Delay);
    read_interface_logic(32, 0, field_value_i.Pulse11Width, logic_value_i.Pulse11Width, register_data_o.Pulse11Width);
    read_interface_logic(32, 0, field_value_i.Pulse12Ctrl, logic_value_i.Pulse12Ctrl, register_data_o.Pulse12Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse12Presc, logic_value_i.Pulse12Presc, register_data_o.Pulse12Presc);
    read_interface_logic(32, 0, field_value_i.Pulse12Delay, logic_value_i.Pulse12Delay, register_data_o.Pulse12Delay);
    read_interface_logic(32, 0, field_value_i.Pulse12Width, logic_value_i.Pulse12Width, register_data_o.Pulse12Width);
    read_interface_logic(32, 0, field_value_i.Pulse13Ctrl, logic_value_i.Pulse13Ctrl, register_data_o.Pulse13Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse13Presc, logic_value_i.Pulse13Presc, register_data_o.Pulse13Presc);
    read_interface_logic(32, 0, field_value_i.Pulse13Delay, logic_value_i.Pulse13Delay, register_data_o.Pulse13Delay);
    read_interface_logic(32, 0, field_value_i.Pulse13Width, logic_value_i.Pulse13Width, register_data_o.Pulse13Width);
    read_interface_logic(32, 0, field_value_i.Pulse14Ctrl, logic_value_i.Pulse14Ctrl, register_data_o.Pulse14Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse14Presc, logic_value_i.Pulse14Presc, register_data_o.Pulse14Presc);
    read_interface_logic(32, 0, field_value_i.Pulse14Delay, logic_value_i.Pulse14Delay, register_data_o.Pulse14Delay);
    read_interface_logic(32, 0, field_value_i.Pulse14Width, logic_value_i.Pulse14Width, register_data_o.Pulse14Width);
    read_interface_logic(32, 0, field_value_i.Pulse15Ctrl, logic_value_i.Pulse15Ctrl, register_data_o.Pulse15Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse15Presc, logic_value_i.Pulse15Presc, register_data_o.Pulse15Presc);
    read_interface_logic(32, 0, field_value_i.Pulse15Delay, logic_value_i.Pulse15Delay, register_data_o.Pulse15Delay);
    read_interface_logic(32, 0, field_value_i.Pulse15Width, logic_value_i.Pulse15Width, register_data_o.Pulse15Width);
    read_interface_logic(32, 0, field_value_i.Pulse16Ctrl, logic_value_i.Pulse16Ctrl, register_data_o.Pulse16Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse16Presc, logic_value_i.Pulse16Presc, register_data_o.Pulse16Presc);
    read_interface_logic(32, 0, field_value_i.Pulse16Delay, logic_value_i.Pulse16Delay, register_data_o.Pulse16Delay);
    read_interface_logic(32, 0, field_value_i.Pulse16Width, logic_value_i.Pulse16Width, register_data_o.Pulse16Width);
    read_interface_logic(32, 0, field_value_i.Pulse17Ctrl, logic_value_i.Pulse17Ctrl, register_data_o.Pulse17Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse17Presc, logic_value_i.Pulse17Presc, register_data_o.Pulse17Presc);
    read_interface_logic(32, 0, field_value_i.Pulse17Delay, logic_value_i.Pulse17Delay, register_data_o.Pulse17Delay);
    read_interface_logic(32, 0, field_value_i.Pulse17Width, logic_value_i.Pulse17Width, register_data_o.Pulse17Width);
    read_interface_logic(32, 0, field_value_i.Pulse18Ctrl, logic_value_i.Pulse18Ctrl, register_data_o.Pulse18Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse18Presc, logic_value_i.Pulse18Presc, register_data_o.Pulse18Presc);
    read_interface_logic(32, 0, field_value_i.Pulse18Delay, logic_value_i.Pulse18Delay, register_data_o.Pulse18Delay);
    read_interface_logic(32, 0, field_value_i.Pulse18Width, logic_value_i.Pulse18Width, register_data_o.Pulse18Width);
    read_interface_logic(32, 0, field_value_i.Pulse19Ctrl, logic_value_i.Pulse19Ctrl, register_data_o.Pulse19Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse19Presc, logic_value_i.Pulse19Presc, register_data_o.Pulse19Presc);
    read_interface_logic(32, 0, field_value_i.Pulse19Delay, logic_value_i.Pulse19Delay, register_data_o.Pulse19Delay);
    read_interface_logic(32, 0, field_value_i.Pulse19Width, logic_value_i.Pulse19Width, register_data_o.Pulse19Width);
    read_interface_logic(32, 0, field_value_i.Pulse20Ctrl, logic_value_i.Pulse20Ctrl, register_data_o.Pulse20Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse20Presc, logic_value_i.Pulse20Presc, register_data_o.Pulse20Presc);
    read_interface_logic(32, 0, field_value_i.Pulse20Delay, logic_value_i.Pulse20Delay, register_data_o.Pulse20Delay);
    read_interface_logic(32, 0, field_value_i.Pulse20Width, logic_value_i.Pulse20Width, register_data_o.Pulse20Width);
    read_interface_logic(32, 0, field_value_i.Pulse21Ctrl, logic_value_i.Pulse21Ctrl, register_data_o.Pulse21Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse21Presc, logic_value_i.Pulse21Presc, register_data_o.Pulse21Presc);
    read_interface_logic(32, 0, field_value_i.Pulse21Delay, logic_value_i.Pulse21Delay, register_data_o.Pulse21Delay);
    read_interface_logic(32, 0, field_value_i.Pulse21Width, logic_value_i.Pulse21Width, register_data_o.Pulse21Width);
    read_interface_logic(32, 0, field_value_i.Pulse22Ctrl, logic_value_i.Pulse22Ctrl, register_data_o.Pulse22Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse22Presc, logic_value_i.Pulse22Presc, register_data_o.Pulse22Presc);
    read_interface_logic(32, 0, field_value_i.Pulse22Delay, logic_value_i.Pulse22Delay, register_data_o.Pulse22Delay);
    read_interface_logic(32, 0, field_value_i.Pulse22Width, logic_value_i.Pulse22Width, register_data_o.Pulse22Width);
    read_interface_logic(32, 0, field_value_i.Pulse23Ctrl, logic_value_i.Pulse23Ctrl, register_data_o.Pulse23Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse23Presc, logic_value_i.Pulse23Presc, register_data_o.Pulse23Presc);
    read_interface_logic(32, 0, field_value_i.Pulse23Delay, logic_value_i.Pulse23Delay, register_data_o.Pulse23Delay);
    read_interface_logic(32, 0, field_value_i.Pulse23Width, logic_value_i.Pulse23Width, register_data_o.Pulse23Width);
    read_interface_logic(32, 0, field_value_i.Pulse24Ctrl, logic_value_i.Pulse24Ctrl, register_data_o.Pulse24Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse24Presc, logic_value_i.Pulse24Presc, register_data_o.Pulse24Presc);
    read_interface_logic(32, 0, field_value_i.Pulse24Delay, logic_value_i.Pulse24Delay, register_data_o.Pulse24Delay);
    read_interface_logic(32, 0, field_value_i.Pulse24Width, logic_value_i.Pulse24Width, register_data_o.Pulse24Width);
    read_interface_logic(32, 0, field_value_i.Pulse25Ctrl, logic_value_i.Pulse25Ctrl, register_data_o.Pulse25Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse25Presc, logic_value_i.Pulse25Presc, register_data_o.Pulse25Presc);
    read_interface_logic(32, 0, field_value_i.Pulse25Delay, logic_value_i.Pulse25Delay, register_data_o.Pulse25Delay);
    read_interface_logic(32, 0, field_value_i.Pulse25Width, logic_value_i.Pulse25Width, register_data_o.Pulse25Width);
    read_interface_logic(32, 0, field_value_i.Pulse26Ctrl, logic_value_i.Pulse26Ctrl, register_data_o.Pulse26Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse26Presc, logic_value_i.Pulse26Presc, register_data_o.Pulse26Presc);
    read_interface_logic(32, 0, field_value_i.Pulse26Delay, logic_value_i.Pulse26Delay, register_data_o.Pulse26Delay);
    read_interface_logic(32, 0, field_value_i.Pulse26Width, logic_value_i.Pulse26Width, register_data_o.Pulse26Width);
    read_interface_logic(32, 0, field_value_i.Pulse27Ctrl, logic_value_i.Pulse27Ctrl, register_data_o.Pulse27Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse27Presc, logic_value_i.Pulse27Presc, register_data_o.Pulse27Presc);
    read_interface_logic(32, 0, field_value_i.Pulse27Delay, logic_value_i.Pulse27Delay, register_data_o.Pulse27Delay);
    read_interface_logic(32, 0, field_value_i.Pulse27Width, logic_value_i.Pulse27Width, register_data_o.Pulse27Width);
    read_interface_logic(32, 0, field_value_i.Pulse28Ctrl, logic_value_i.Pulse28Ctrl, register_data_o.Pulse28Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse28Presc, logic_value_i.Pulse28Presc, register_data_o.Pulse28Presc);
    read_interface_logic(32, 0, field_value_i.Pulse28Delay, logic_value_i.Pulse28Delay, register_data_o.Pulse28Delay);
    read_interface_logic(32, 0, field_value_i.Pulse28Width, logic_value_i.Pulse28Width, register_data_o.Pulse28Width);
    read_interface_logic(32, 0, field_value_i.Pulse29Ctrl, logic_value_i.Pulse29Ctrl, register_data_o.Pulse29Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse29Presc, logic_value_i.Pulse29Presc, register_data_o.Pulse29Presc);
    read_interface_logic(32, 0, field_value_i.Pulse29Delay, logic_value_i.Pulse29Delay, register_data_o.Pulse29Delay);
    read_interface_logic(32, 0, field_value_i.Pulse29Width, logic_value_i.Pulse29Width, register_data_o.Pulse29Width);
    read_interface_logic(32, 0, field_value_i.Pulse30Ctrl, logic_value_i.Pulse30Ctrl, register_data_o.Pulse30Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse30Presc, logic_value_i.Pulse30Presc, register_data_o.Pulse30Presc);
    read_interface_logic(32, 0, field_value_i.Pulse30Delay, logic_value_i.Pulse30Delay, register_data_o.Pulse30Delay);
    read_interface_logic(32, 0, field_value_i.Pulse30Width, logic_value_i.Pulse30Width, register_data_o.Pulse30Width);
    read_interface_logic(32, 0, field_value_i.Pulse31Ctrl, logic_value_i.Pulse31Ctrl, register_data_o.Pulse31Ctrl);
    read_interface_logic(32, 0, field_value_i.Pulse31Presc, logic_value_i.Pulse31Presc, register_data_o.Pulse31Presc);
    read_interface_logic(32, 0, field_value_i.Pulse31Delay, logic_value_i.Pulse31Delay, register_data_o.Pulse31Delay);
    read_interface_logic(32, 0, field_value_i.Pulse31Width, logic_value_i.Pulse31Width, register_data_o.Pulse31Width);
    read_interface_logic(32, 0, field_value_i.master_reset, logic_value_i.master_reset, register_data_o.master_reset);
    read_interface_logic(32, 0, field_value_i.rxpath_reset, logic_value_i.rxpath_reset, register_data_o.rxpath_reset);
    read_interface_logic(32, 0, field_value_i.txpath_reset, logic_value_i.txpath_reset, register_data_o.txpath_reset);


  end process read_interface_cores;

end architecture rtl;
