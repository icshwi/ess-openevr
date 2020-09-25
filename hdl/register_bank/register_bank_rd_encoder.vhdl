--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_rd_encoder.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-12
-- Last update : 2018-05-21
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description :
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-05-21  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ESS_openEVR_RegMap;
use ESS_openEVR_RegMap.register_bank_config.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity register_bank_rd_encoder  is
  port (
    clock_i           : in  std_logic;                                    --! The output data is registered according to this clock
    reset_n_i         : in  std_logic;                                    --! Asynchronous low-active reset

    decode_error_o    : out std_logic;                                    --! Read access to address which does not allow read
    read_en_i         : in  std_logic;                                    --! Read enable
    address_i         : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);   --! Register address

    register_data_i   : in  register_bus_read_t;                          --! Record of values stored in the registers

    bus_data_o        : out std_logic_vector(REGISTER_WIDTH-1 downto 0)   --! Value of selected register (registered)
  );
end entity register_bank_rd_encoder;

--------------------------------------------------------------------------------
--! @brief
--------------------------------------------------------------------------------
architecture rtl of register_bank_rd_encoder is
  signal address_int : integer;                                           --! Integer representation of the register address
begin

  address_int <= to_integer(unsigned(address_i));

  output_select : process (clock_i)
  begin
    if rising_edge(clock_i) then
      if (reset_n_i = '0') then
        decode_error_o <= '0';
        bus_data_o <= (others => '0');
      else
        if (read_en_i = '1') then
          decode_error_o <= '0';
          case address_int is

            when 16#0# =>
              bus_data_o <= register_data_i.Status;
            when 16#4# =>
              bus_data_o <= register_data_i.Control;
            when 16#8# =>
              bus_data_o <= register_data_i.IrqFlag;
            when 16#C# =>
              bus_data_o <= register_data_i.IrqEnable;
            when 16#10# =>
              bus_data_o <= register_data_i.PulseIrqMap;
            when 16#18# =>
              bus_data_o <= register_data_i.SWEvent;
            when 16#20# =>
              bus_data_o <= register_data_i.DataBufCtrl;
            when 16#24# =>
              bus_data_o <= register_data_i.TXDataBufCtrl;
            when 16#28# =>
              bus_data_o <= register_data_i.TxSegBufCtrl;
            when 16#2C# =>
              bus_data_o <= register_data_i.FWVersion;
            when 16#40# =>
              bus_data_o <= register_data_i.EvCntPresc;
            when 16#4C# =>
              bus_data_o <= register_data_i.UsecDivider;
            when 16#50# =>
              bus_data_o <= register_data_i.ClockControl;
            when 16#5C# =>
              bus_data_o <= register_data_i.SecSR;
            when 16#60# =>
              bus_data_o <= register_data_i.SecCounter;
            when 16#64# =>
              bus_data_o <= register_data_i.EventCounter;
            when 16#68# =>
              bus_data_o <= register_data_i.SecLatch;
            when 16#6C# =>
              bus_data_o <= register_data_i.EvCntLatch;
            when 16#70# =>
              bus_data_o <= register_data_i.EvFIFOSec;
            when 16#74# =>
              bus_data_o <= register_data_i.EvFIFOEvCnt;
            when 16#78# =>
              bus_data_o <= register_data_i.EvFIFOCode;
            when 16#7C# =>
              bus_data_o <= register_data_i.LogStatus;
            when 16#90# =>
              bus_data_o <= register_data_i.GPIODir;
            when 16#94# =>
              bus_data_o <= register_data_i.GPIOIn;
            when 16#98# =>
              bus_data_o <= register_data_i.GPIOOut;
            when 16#B0# =>
              bus_data_o <= register_data_i.DCTarget;
            when 16#B4# =>
              bus_data_o <= register_data_i.DCRxValue;
            when 16#B8# =>
              bus_data_o <= register_data_i.DCIntValue;
            when 16#BC# =>
              bus_data_o <= register_data_i.DCStatus;
            when 16#C0# =>
              bus_data_o <= register_data_i.TopologyID;
            when 16#E0# =>
              bus_data_o <= register_data_i.SeqRamCtrl;
            when 16#100# =>
              bus_data_o <= register_data_i.Prescaler0;
            when 16#104# =>
              bus_data_o <= register_data_i.Prescaler1;
            when 16#108# =>
              bus_data_o <= register_data_i.Prescaler2;
            when 16#10C# =>
              bus_data_o <= register_data_i.Prescaler3;
            when 16#110# =>
              bus_data_o <= register_data_i.Prescaler4;
            when 16#114# =>
              bus_data_o <= register_data_i.Prescaler5;
            when 16#118# =>
              bus_data_o <= register_data_i.Prescaler6;
            when 16#11C# =>
              bus_data_o <= register_data_i.Prescaler7;
            when 16#120# =>
              bus_data_o <= register_data_i.PrescPhase0;
            when 16#124# =>
              bus_data_o <= register_data_i.PrescPhase1;
            when 16#128# =>
              bus_data_o <= register_data_i.PrescPhase2;
            when 16#12C# =>
              bus_data_o <= register_data_i.PrescPhase3;
            when 16#130# =>
              bus_data_o <= register_data_i.PrescPhase4;
            when 16#134# =>
              bus_data_o <= register_data_i.PrescPhase5;
            when 16#138# =>
              bus_data_o <= register_data_i.PrescPhase6;
            when 16#13C# =>
              bus_data_o <= register_data_i.PrescPhase7;
            when 16#140# =>
              bus_data_o <= register_data_i.PrescTrig0;
            when 16#144# =>
              bus_data_o <= register_data_i.PrescTrig1;
            when 16#148# =>
              bus_data_o <= register_data_i.PrescTrig2;
            when 16#14C# =>
              bus_data_o <= register_data_i.PrescTrig3;
            when 16#150# =>
              bus_data_o <= register_data_i.PrescTrig4;
            when 16#154# =>
              bus_data_o <= register_data_i.PrescTrig5;
            when 16#158# =>
              bus_data_o <= register_data_i.PrescTrig6;
            when 16#15C# =>
              bus_data_o <= register_data_i.PrescTrig7;
            when 16#180# =>
              bus_data_o <= register_data_i.DBusTrig0;
            when 16#184# =>
              bus_data_o <= register_data_i.DBusTrig1;
            when 16#188# =>
              bus_data_o <= register_data_i.DBusTrig2;
            when 16#18C# =>
              bus_data_o <= register_data_i.DBusTrig3;
            when 16#190# =>
              bus_data_o <= register_data_i.DBusTrig4;
            when 16#194# =>
              bus_data_o <= register_data_i.DBusTrig5;
            when 16#198# =>
              bus_data_o <= register_data_i.DBusTrig6;
            when 16#19C# =>
              bus_data_o <= register_data_i.DBusTrig7;
            when 16#200# =>
              bus_data_o <= register_data_i.Pulse0Ctrl;
            when 16#204# =>
              bus_data_o <= register_data_i.Pulse0Presc;
            when 16#208# =>
              bus_data_o <= register_data_i.Pulse0Delay;
            when 16#20C# =>
              bus_data_o <= register_data_i.Pulse0Width;
            when 16#210# =>
              bus_data_o <= register_data_i.Pulse1Ctrl;
            when 16#214# =>
              bus_data_o <= register_data_i.Pulse1Presc;
            when 16#218# =>
              bus_data_o <= register_data_i.Pulse1Delay;
            when 16#21C# =>
              bus_data_o <= register_data_i.Pulse1Width;
            when 16#220# =>
              bus_data_o <= register_data_i.Pulse2Ctrl;
            when 16#224# =>
              bus_data_o <= register_data_i.Pulse2Presc;
            when 16#228# =>
              bus_data_o <= register_data_i.Pulse2Delay;
            when 16#22C# =>
              bus_data_o <= register_data_i.Pulse2Width;
            when 16#230# =>
              bus_data_o <= register_data_i.Pulse3Ctrl;
            when 16#234# =>
              bus_data_o <= register_data_i.Pulse3Presc;
            when 16#238# =>
              bus_data_o <= register_data_i.Pulse3Delay;
            when 16#23C# =>
              bus_data_o <= register_data_i.Pulse3Width;
            when 16#240# =>
              bus_data_o <= register_data_i.Pulse4Ctrl;
            when 16#244# =>
              bus_data_o <= register_data_i.Pulse4Presc;
            when 16#248# =>
              bus_data_o <= register_data_i.Pulse4Delay;
            when 16#24C# =>
              bus_data_o <= register_data_i.Pulse4Width;
            when 16#250# =>
              bus_data_o <= register_data_i.Pulse5Ctrl;
            when 16#254# =>
              bus_data_o <= register_data_i.Pulse5Presc;
            when 16#258# =>
              bus_data_o <= register_data_i.Pulse5Delay;
            when 16#25C# =>
              bus_data_o <= register_data_i.Pulse5Width;
            when 16#260# =>
              bus_data_o <= register_data_i.Pulse6Ctrl;
            when 16#264# =>
              bus_data_o <= register_data_i.Pulse6Presc;
            when 16#268# =>
              bus_data_o <= register_data_i.Pulse6Delay;
            when 16#26C# =>
              bus_data_o <= register_data_i.Pulse6Width;
            when 16#270# =>
              bus_data_o <= register_data_i.Pulse7Ctrl;
            when 16#274# =>
              bus_data_o <= register_data_i.Pulse7Presc;
            when 16#278# =>
              bus_data_o <= register_data_i.Pulse7Delay;
            when 16#27C# =>
              bus_data_o <= register_data_i.Pulse7Width;
            when 16#280# =>
              bus_data_o <= register_data_i.Pulse8Ctrl;
            when 16#284# =>
              bus_data_o <= register_data_i.Pulse8Presc;
            when 16#288# =>
              bus_data_o <= register_data_i.Pulse8Delay;
            when 16#28C# =>
              bus_data_o <= register_data_i.Pulse8Width;
            when 16#290# =>
              bus_data_o <= register_data_i.Pulse9Ctrl;
            when 16#294# =>
              bus_data_o <= register_data_i.Pulse9Presc;
            when 16#298# =>
              bus_data_o <= register_data_i.Pulse9Delay;
            when 16#29C# =>
              bus_data_o <= register_data_i.Pulse9Width;
            when 16#2A0# =>
              bus_data_o <= register_data_i.Pulse10Ctrl;
            when 16#2A4# =>
              bus_data_o <= register_data_i.Pulse10Presc;
            when 16#2A8# =>
              bus_data_o <= register_data_i.Pulse10Delay;
            when 16#2AC# =>
              bus_data_o <= register_data_i.Pulse10Width;
            when 16#2B0# =>
              bus_data_o <= register_data_i.Pulse11Ctrl;
            when 16#2B4# =>
              bus_data_o <= register_data_i.Pulse11Presc;
            when 16#2B8# =>
              bus_data_o <= register_data_i.Pulse11Delay;
            when 16#2BC# =>
              bus_data_o <= register_data_i.Pulse11Width;
            when 16#2C0# =>
              bus_data_o <= register_data_i.Pulse12Ctrl;
            when 16#2C4# =>
              bus_data_o <= register_data_i.Pulse12Presc;
            when 16#2C8# =>
              bus_data_o <= register_data_i.Pulse12Delay;
            when 16#2CC# =>
              bus_data_o <= register_data_i.Pulse12Width;
            when 16#2D0# =>
              bus_data_o <= register_data_i.Pulse13Ctrl;
            when 16#2D4# =>
              bus_data_o <= register_data_i.Pulse13Presc;
            when 16#2D8# =>
              bus_data_o <= register_data_i.Pulse13Delay;
            when 16#2DC# =>
              bus_data_o <= register_data_i.Pulse13Width;
            when 16#2E0# =>
              bus_data_o <= register_data_i.Pulse14Ctrl;
            when 16#2E4# =>
              bus_data_o <= register_data_i.Pulse14Presc;
            when 16#2E8# =>
              bus_data_o <= register_data_i.Pulse14Delay;
            when 16#2EC# =>
              bus_data_o <= register_data_i.Pulse14Width;
            when 16#2F0# =>
              bus_data_o <= register_data_i.Pulse15Ctrl;
            when 16#2F4# =>
              bus_data_o <= register_data_i.Pulse15Presc;
            when 16#2F8# =>
              bus_data_o <= register_data_i.Pulse15Delay;
            when 16#2FC# =>
              bus_data_o <= register_data_i.Pulse15Width;
            when 16#300# =>
              bus_data_o <= register_data_i.Pulse16Ctrl;
            when 16#304# =>
              bus_data_o <= register_data_i.Pulse16Presc;
            when 16#308# =>
              bus_data_o <= register_data_i.Pulse16Delay;
            when 16#30C# =>
              bus_data_o <= register_data_i.Pulse16Width;
            when 16#310# =>
              bus_data_o <= register_data_i.Pulse17Ctrl;
            when 16#314# =>
              bus_data_o <= register_data_i.Pulse17Presc;
            when 16#318# =>
              bus_data_o <= register_data_i.Pulse17Delay;
            when 16#31C# =>
              bus_data_o <= register_data_i.Pulse17Width;
            when 16#320# =>
              bus_data_o <= register_data_i.Pulse18Ctrl;
            when 16#324# =>
              bus_data_o <= register_data_i.Pulse18Presc;
            when 16#328# =>
              bus_data_o <= register_data_i.Pulse18Delay;
            when 16#32C# =>
              bus_data_o <= register_data_i.Pulse18Width;
            when 16#330# =>
              bus_data_o <= register_data_i.Pulse19Ctrl;
            when 16#334# =>
              bus_data_o <= register_data_i.Pulse19Presc;
            when 16#338# =>
              bus_data_o <= register_data_i.Pulse19Delay;
            when 16#33C# =>
              bus_data_o <= register_data_i.Pulse19Width;
            when 16#340# =>
              bus_data_o <= register_data_i.Pulse20Ctrl;
            when 16#344# =>
              bus_data_o <= register_data_i.Pulse20Presc;
            when 16#348# =>
              bus_data_o <= register_data_i.Pulse20Delay;
            when 16#34C# =>
              bus_data_o <= register_data_i.Pulse20Width;
            when 16#350# =>
              bus_data_o <= register_data_i.Pulse21Ctrl;
            when 16#354# =>
              bus_data_o <= register_data_i.Pulse21Presc;
            when 16#358# =>
              bus_data_o <= register_data_i.Pulse21Delay;
            when 16#35C# =>
              bus_data_o <= register_data_i.Pulse21Width;
            when 16#360# =>
              bus_data_o <= register_data_i.Pulse22Ctrl;
            when 16#364# =>
              bus_data_o <= register_data_i.Pulse22Presc;
            when 16#368# =>
              bus_data_o <= register_data_i.Pulse22Delay;
            when 16#36C# =>
              bus_data_o <= register_data_i.Pulse22Width;
            when 16#370# =>
              bus_data_o <= register_data_i.Pulse23Ctrl;
            when 16#374# =>
              bus_data_o <= register_data_i.Pulse23Presc;
            when 16#378# =>
              bus_data_o <= register_data_i.Pulse23Delay;
            when 16#37C# =>
              bus_data_o <= register_data_i.Pulse23Width;
            when 16#380# =>
              bus_data_o <= register_data_i.Pulse24Ctrl;
            when 16#384# =>
              bus_data_o <= register_data_i.Pulse24Presc;
            when 16#388# =>
              bus_data_o <= register_data_i.Pulse24Delay;
            when 16#38C# =>
              bus_data_o <= register_data_i.Pulse24Width;
            when 16#390# =>
              bus_data_o <= register_data_i.Pulse25Ctrl;
            when 16#394# =>
              bus_data_o <= register_data_i.Pulse25Presc;
            when 16#398# =>
              bus_data_o <= register_data_i.Pulse25Delay;
            when 16#39C# =>
              bus_data_o <= register_data_i.Pulse25Width;
            when 16#3A0# =>
              bus_data_o <= register_data_i.Pulse26Ctrl;
            when 16#3A4# =>
              bus_data_o <= register_data_i.Pulse26Presc;
            when 16#3A8# =>
              bus_data_o <= register_data_i.Pulse26Delay;
            when 16#3AC# =>
              bus_data_o <= register_data_i.Pulse26Width;
            when 16#3B0# =>
              bus_data_o <= register_data_i.Pulse27Ctrl;
            when 16#3B4# =>
              bus_data_o <= register_data_i.Pulse27Presc;
            when 16#3B8# =>
              bus_data_o <= register_data_i.Pulse27Delay;
            when 16#3BC# =>
              bus_data_o <= register_data_i.Pulse27Width;
            when 16#3C0# =>
              bus_data_o <= register_data_i.Pulse28Ctrl;
            when 16#3C4# =>
              bus_data_o <= register_data_i.Pulse28Presc;
            when 16#3C8# =>
              bus_data_o <= register_data_i.Pulse28Delay;
            when 16#3CC# =>
              bus_data_o <= register_data_i.Pulse28Width;
            when 16#3D0# =>
              bus_data_o <= register_data_i.Pulse29Ctrl;
            when 16#3D4# =>
              bus_data_o <= register_data_i.Pulse29Presc;
            when 16#3D8# =>
              bus_data_o <= register_data_i.Pulse29Delay;
            when 16#3DC# =>
              bus_data_o <= register_data_i.Pulse29Width;
            when 16#3E0# =>
              bus_data_o <= register_data_i.Pulse30Ctrl;
            when 16#3E4# =>
              bus_data_o <= register_data_i.Pulse30Presc;
            when 16#3E8# =>
              bus_data_o <= register_data_i.Pulse30Delay;
            when 16#3EC# =>
              bus_data_o <= register_data_i.Pulse30Width;
            when 16#3F0# =>
              bus_data_o <= register_data_i.Pulse31Ctrl;
            when 16#3F4# =>
              bus_data_o <= register_data_i.Pulse31Presc;
            when 16#3F8# =>
              bus_data_o <= register_data_i.Pulse31Delay;
            when 16#3FC# =>
              bus_data_o <= register_data_i.Pulse31Width;
            when 16#FFF0# =>
              bus_data_o <= register_data_i.ESSStatus;
            when 16#FFF4# =>
              bus_data_o <= register_data_i.ESSControl;


            when others =>
              decode_error_o <= '1';
          end case;
        end if;
      end if;
    end if;
  end process output_select;

end architecture rtl;
