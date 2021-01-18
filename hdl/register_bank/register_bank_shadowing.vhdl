--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_shadowing.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-05-28
-- Last update : 2018-05-28
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
-- 0.1 : 2018-05-28  Christian Amstutz
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
entity register_bank_shadowing is
  port (
    clock_i                 : in  std_logic;
    reset_n_i               : in  std_logic;

    transfer_shadow_group_i : in  transfer_shadow_group_t;

    logic_data_i            : in  logic_read_data_t;
    logic_data_o            : out logic_read_data_t
  );
end entity register_bank_shadowing;

--------------------------------------------------------------------------------
--! @brief
--------------------------------------------------------------------------------
architecture rtl of register_bank_shadowing is
begin



  logic_data_o.Control <= logic_data_i.Control;
  logic_data_o.IrqFlag <= logic_data_i.IrqFlag;
  logic_data_o.IrqEnable <= logic_data_i.IrqEnable;
  logic_data_o.PulseIrqMap <= logic_data_i.PulseIrqMap;
  logic_data_o.SWEvent <= logic_data_i.SWEvent;
  logic_data_o.DataBufCtrl <= logic_data_i.DataBufCtrl;
  logic_data_o.TXDataBufCtrl <= logic_data_i.TXDataBufCtrl;
  logic_data_o.TxSegBufCtrl <= logic_data_i.TxSegBufCtrl;
  logic_data_o.EvCntPresc <= logic_data_i.EvCntPresc;
  logic_data_o.UsecDivider <= logic_data_i.UsecDivider;
  logic_data_o.ClockControl <= logic_data_i.ClockControl;
  logic_data_o.GPIODir <= logic_data_i.GPIODir;
  logic_data_o.GPIOIn <= logic_data_i.GPIOIn;
  logic_data_o.GPIOOut <= logic_data_i.GPIOOut;
  logic_data_o.DCTarget <= logic_data_i.DCTarget;
  logic_data_o.SeqRamCtrl <= logic_data_i.SeqRamCtrl;
  logic_data_o.Prescaler0 <= logic_data_i.Prescaler0;
  logic_data_o.Prescaler1 <= logic_data_i.Prescaler1;
  logic_data_o.Prescaler2 <= logic_data_i.Prescaler2;
  logic_data_o.Prescaler3 <= logic_data_i.Prescaler3;
  logic_data_o.Prescaler4 <= logic_data_i.Prescaler4;
  logic_data_o.Prescaler5 <= logic_data_i.Prescaler5;
  logic_data_o.Prescaler6 <= logic_data_i.Prescaler6;
  logic_data_o.Prescaler7 <= logic_data_i.Prescaler7;
  logic_data_o.PrescPhase0 <= logic_data_i.PrescPhase0;
  logic_data_o.PrescPhase1 <= logic_data_i.PrescPhase1;
  logic_data_o.PrescPhase2 <= logic_data_i.PrescPhase2;
  logic_data_o.PrescPhase3 <= logic_data_i.PrescPhase3;
  logic_data_o.PrescPhase4 <= logic_data_i.PrescPhase4;
  logic_data_o.PrescPhase5 <= logic_data_i.PrescPhase5;
  logic_data_o.PrescPhase6 <= logic_data_i.PrescPhase6;
  logic_data_o.PrescPhase7 <= logic_data_i.PrescPhase7;
  logic_data_o.PrescTrig0 <= logic_data_i.PrescTrig0;
  logic_data_o.PrescTrig1 <= logic_data_i.PrescTrig1;
  logic_data_o.PrescTrig2 <= logic_data_i.PrescTrig2;
  logic_data_o.PrescTrig3 <= logic_data_i.PrescTrig3;
  logic_data_o.PrescTrig4 <= logic_data_i.PrescTrig4;
  logic_data_o.PrescTrig5 <= logic_data_i.PrescTrig5;
  logic_data_o.PrescTrig6 <= logic_data_i.PrescTrig6;
  logic_data_o.PrescTrig7 <= logic_data_i.PrescTrig7;
  logic_data_o.DBusTrig0 <= logic_data_i.DBusTrig0;
  logic_data_o.DBusTrig1 <= logic_data_i.DBusTrig1;
  logic_data_o.DBusTrig2 <= logic_data_i.DBusTrig2;
  logic_data_o.DBusTrig3 <= logic_data_i.DBusTrig3;
  logic_data_o.DBusTrig4 <= logic_data_i.DBusTrig4;
  logic_data_o.DBusTrig5 <= logic_data_i.DBusTrig5;
  logic_data_o.DBusTrig6 <= logic_data_i.DBusTrig6;
  logic_data_o.DBusTrig7 <= logic_data_i.DBusTrig7;
  logic_data_o.Pulse0Ctrl <= logic_data_i.Pulse0Ctrl;
  logic_data_o.Pulse0Presc <= logic_data_i.Pulse0Presc;
  logic_data_o.Pulse0Delay <= logic_data_i.Pulse0Delay;
  logic_data_o.Pulse0Width <= logic_data_i.Pulse0Width;
  logic_data_o.Pulse1Ctrl <= logic_data_i.Pulse1Ctrl;
  logic_data_o.Pulse1Presc <= logic_data_i.Pulse1Presc;
  logic_data_o.Pulse1Delay <= logic_data_i.Pulse1Delay;
  logic_data_o.Pulse1Width <= logic_data_i.Pulse1Width;
  logic_data_o.Pulse2Ctrl <= logic_data_i.Pulse2Ctrl;
  logic_data_o.Pulse2Presc <= logic_data_i.Pulse2Presc;
  logic_data_o.Pulse2Delay <= logic_data_i.Pulse2Delay;
  logic_data_o.Pulse2Width <= logic_data_i.Pulse2Width;
  logic_data_o.Pulse3Ctrl <= logic_data_i.Pulse3Ctrl;
  logic_data_o.Pulse3Presc <= logic_data_i.Pulse3Presc;
  logic_data_o.Pulse3Delay <= logic_data_i.Pulse3Delay;
  logic_data_o.Pulse3Width <= logic_data_i.Pulse3Width;
  logic_data_o.Pulse4Ctrl <= logic_data_i.Pulse4Ctrl;
  logic_data_o.Pulse4Presc <= logic_data_i.Pulse4Presc;
  logic_data_o.Pulse4Delay <= logic_data_i.Pulse4Delay;
  logic_data_o.Pulse4Width <= logic_data_i.Pulse4Width;
  logic_data_o.Pulse5Ctrl <= logic_data_i.Pulse5Ctrl;
  logic_data_o.Pulse5Presc <= logic_data_i.Pulse5Presc;
  logic_data_o.Pulse5Delay <= logic_data_i.Pulse5Delay;
  logic_data_o.Pulse5Width <= logic_data_i.Pulse5Width;
  logic_data_o.Pulse6Ctrl <= logic_data_i.Pulse6Ctrl;
  logic_data_o.Pulse6Presc <= logic_data_i.Pulse6Presc;
  logic_data_o.Pulse6Delay <= logic_data_i.Pulse6Delay;
  logic_data_o.Pulse6Width <= logic_data_i.Pulse6Width;
  logic_data_o.Pulse7Ctrl <= logic_data_i.Pulse7Ctrl;
  logic_data_o.Pulse7Presc <= logic_data_i.Pulse7Presc;
  logic_data_o.Pulse7Delay <= logic_data_i.Pulse7Delay;
  logic_data_o.Pulse7Width <= logic_data_i.Pulse7Width;
  logic_data_o.Pulse8Ctrl <= logic_data_i.Pulse8Ctrl;
  logic_data_o.Pulse8Presc <= logic_data_i.Pulse8Presc;
  logic_data_o.Pulse8Delay <= logic_data_i.Pulse8Delay;
  logic_data_o.Pulse8Width <= logic_data_i.Pulse8Width;
  logic_data_o.Pulse9Ctrl <= logic_data_i.Pulse9Ctrl;
  logic_data_o.Pulse9Presc <= logic_data_i.Pulse9Presc;
  logic_data_o.Pulse9Delay <= logic_data_i.Pulse9Delay;
  logic_data_o.Pulse9Width <= logic_data_i.Pulse9Width;
  logic_data_o.Pulse10Ctrl <= logic_data_i.Pulse10Ctrl;
  logic_data_o.Pulse10Presc <= logic_data_i.Pulse10Presc;
  logic_data_o.Pulse10Delay <= logic_data_i.Pulse10Delay;
  logic_data_o.Pulse10Width <= logic_data_i.Pulse10Width;
  logic_data_o.Pulse11Ctrl <= logic_data_i.Pulse11Ctrl;
  logic_data_o.Pulse11Presc <= logic_data_i.Pulse11Presc;
  logic_data_o.Pulse11Delay <= logic_data_i.Pulse11Delay;
  logic_data_o.Pulse11Width <= logic_data_i.Pulse11Width;
  logic_data_o.Pulse12Ctrl <= logic_data_i.Pulse12Ctrl;
  logic_data_o.Pulse12Presc <= logic_data_i.Pulse12Presc;
  logic_data_o.Pulse12Delay <= logic_data_i.Pulse12Delay;
  logic_data_o.Pulse12Width <= logic_data_i.Pulse12Width;
  logic_data_o.Pulse13Ctrl <= logic_data_i.Pulse13Ctrl;
  logic_data_o.Pulse13Presc <= logic_data_i.Pulse13Presc;
  logic_data_o.Pulse13Delay <= logic_data_i.Pulse13Delay;
  logic_data_o.Pulse13Width <= logic_data_i.Pulse13Width;
  logic_data_o.Pulse14Ctrl <= logic_data_i.Pulse14Ctrl;
  logic_data_o.Pulse14Presc <= logic_data_i.Pulse14Presc;
  logic_data_o.Pulse14Delay <= logic_data_i.Pulse14Delay;
  logic_data_o.Pulse14Width <= logic_data_i.Pulse14Width;
  logic_data_o.Pulse15Ctrl <= logic_data_i.Pulse15Ctrl;
  logic_data_o.Pulse15Presc <= logic_data_i.Pulse15Presc;
  logic_data_o.Pulse15Delay <= logic_data_i.Pulse15Delay;
  logic_data_o.Pulse15Width <= logic_data_i.Pulse15Width;
  logic_data_o.Pulse16Ctrl <= logic_data_i.Pulse16Ctrl;
  logic_data_o.Pulse16Presc <= logic_data_i.Pulse16Presc;
  logic_data_o.Pulse16Delay <= logic_data_i.Pulse16Delay;
  logic_data_o.Pulse16Width <= logic_data_i.Pulse16Width;
  logic_data_o.Pulse17Ctrl <= logic_data_i.Pulse17Ctrl;
  logic_data_o.Pulse17Presc <= logic_data_i.Pulse17Presc;
  logic_data_o.Pulse17Delay <= logic_data_i.Pulse17Delay;
  logic_data_o.Pulse17Width <= logic_data_i.Pulse17Width;
  logic_data_o.Pulse18Ctrl <= logic_data_i.Pulse18Ctrl;
  logic_data_o.Pulse18Presc <= logic_data_i.Pulse18Presc;
  logic_data_o.Pulse18Delay <= logic_data_i.Pulse18Delay;
  logic_data_o.Pulse18Width <= logic_data_i.Pulse18Width;
  logic_data_o.Pulse19Ctrl <= logic_data_i.Pulse19Ctrl;
  logic_data_o.Pulse19Presc <= logic_data_i.Pulse19Presc;
  logic_data_o.Pulse19Delay <= logic_data_i.Pulse19Delay;
  logic_data_o.Pulse19Width <= logic_data_i.Pulse19Width;
  logic_data_o.Pulse20Ctrl <= logic_data_i.Pulse20Ctrl;
  logic_data_o.Pulse20Presc <= logic_data_i.Pulse20Presc;
  logic_data_o.Pulse20Delay <= logic_data_i.Pulse20Delay;
  logic_data_o.Pulse20Width <= logic_data_i.Pulse20Width;
  logic_data_o.Pulse21Ctrl <= logic_data_i.Pulse21Ctrl;
  logic_data_o.Pulse21Presc <= logic_data_i.Pulse21Presc;
  logic_data_o.Pulse21Delay <= logic_data_i.Pulse21Delay;
  logic_data_o.Pulse21Width <= logic_data_i.Pulse21Width;
  logic_data_o.Pulse22Ctrl <= logic_data_i.Pulse22Ctrl;
  logic_data_o.Pulse22Presc <= logic_data_i.Pulse22Presc;
  logic_data_o.Pulse22Delay <= logic_data_i.Pulse22Delay;
  logic_data_o.Pulse22Width <= logic_data_i.Pulse22Width;
  logic_data_o.Pulse23Ctrl <= logic_data_i.Pulse23Ctrl;
  logic_data_o.Pulse23Presc <= logic_data_i.Pulse23Presc;
  logic_data_o.Pulse23Delay <= logic_data_i.Pulse23Delay;
  logic_data_o.Pulse23Width <= logic_data_i.Pulse23Width;
  logic_data_o.Pulse24Ctrl <= logic_data_i.Pulse24Ctrl;
  logic_data_o.Pulse24Presc <= logic_data_i.Pulse24Presc;
  logic_data_o.Pulse24Delay <= logic_data_i.Pulse24Delay;
  logic_data_o.Pulse24Width <= logic_data_i.Pulse24Width;
  logic_data_o.Pulse25Ctrl <= logic_data_i.Pulse25Ctrl;
  logic_data_o.Pulse25Presc <= logic_data_i.Pulse25Presc;
  logic_data_o.Pulse25Delay <= logic_data_i.Pulse25Delay;
  logic_data_o.Pulse25Width <= logic_data_i.Pulse25Width;
  logic_data_o.Pulse26Ctrl <= logic_data_i.Pulse26Ctrl;
  logic_data_o.Pulse26Presc <= logic_data_i.Pulse26Presc;
  logic_data_o.Pulse26Delay <= logic_data_i.Pulse26Delay;
  logic_data_o.Pulse26Width <= logic_data_i.Pulse26Width;
  logic_data_o.Pulse27Ctrl <= logic_data_i.Pulse27Ctrl;
  logic_data_o.Pulse27Presc <= logic_data_i.Pulse27Presc;
  logic_data_o.Pulse27Delay <= logic_data_i.Pulse27Delay;
  logic_data_o.Pulse27Width <= logic_data_i.Pulse27Width;
  logic_data_o.Pulse28Ctrl <= logic_data_i.Pulse28Ctrl;
  logic_data_o.Pulse28Presc <= logic_data_i.Pulse28Presc;
  logic_data_o.Pulse28Delay <= logic_data_i.Pulse28Delay;
  logic_data_o.Pulse28Width <= logic_data_i.Pulse28Width;
  logic_data_o.Pulse29Ctrl <= logic_data_i.Pulse29Ctrl;
  logic_data_o.Pulse29Presc <= logic_data_i.Pulse29Presc;
  logic_data_o.Pulse29Delay <= logic_data_i.Pulse29Delay;
  logic_data_o.Pulse29Width <= logic_data_i.Pulse29Width;
  logic_data_o.Pulse30Ctrl <= logic_data_i.Pulse30Ctrl;
  logic_data_o.Pulse30Presc <= logic_data_i.Pulse30Presc;
  logic_data_o.Pulse30Delay <= logic_data_i.Pulse30Delay;
  logic_data_o.Pulse30Width <= logic_data_i.Pulse30Width;
  logic_data_o.Pulse31Ctrl <= logic_data_i.Pulse31Ctrl;
  logic_data_o.Pulse31Presc <= logic_data_i.Pulse31Presc;
  logic_data_o.Pulse31Delay <= logic_data_i.Pulse31Delay;
  logic_data_o.Pulse31Width <= logic_data_i.Pulse31Width;
  logic_data_o.FPOutMap0_1 <= logic_data_i.FPOutMap0_1;
  logic_data_o.UnivOUTMap0_1 <= logic_data_i.UnivOUTMap0_1;
  logic_data_o.ESSControl <= logic_data_i.ESSControl;


end architecture rtl;
