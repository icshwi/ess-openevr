--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : register_bank_address_decoder.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-03-12
-- Last update : 2018-05-23
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : Template for the address decoder of the AXI-4 register bank
--               generator. Generates the according write enables for the
--               different registers.
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
use ieee.numeric_std.all;

library ESS_openEVR_RegMap;
use ESS_openEVR_RegMap.register_bank_config.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity register_bank_address_decoder  is
  port (
    clock_i             : in  std_logic;
    reset_n_i           : in  std_logic;

    decode_error_o      : out std_logic;                                         --! Status signal that indicates that a non-existing address should be accessed

    write_en_i          : in  std_logic;                                         --! Global write enable signal
    address_i           : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);        --! Address of the register
    bus_data_i          : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);       --! Data coming from the bus

    register_write_en_o : out register_write_en_t;                               --! Record with an enable signal for each register
    register_data_o     : out std_logic_vector(REGISTER_WIDTH-1 downto 0)        --! Output data to the registers
  );
end entity register_bank_address_decoder;

--------------------------------------------------------------------------------
--! @brief RTL description of the register bank write controller.
--------------------------------------------------------------------------------
architecture rtl of register_bank_address_decoder is

  signal address_int  : integer;                                                 --! Integer representation of the register address
  signal decode_error : std_logic;

begin

  address_int <= to_integer(unsigned(address_i));

  write_select : process(clock_i)
  begin
    if rising_edge(clock_i) then
      -- Put '0' on all outputs per default
      register_write_en_o <= (others => '0');

      if (write_en_i = '1') then
        decode_error_o <= '0';
        case address_int is

          when 16#4# =>
            register_write_en_o.Control              <= '1';
          when 16#8# =>
            register_write_en_o.IrqFlag              <= '1';
          when 16#C# =>
            register_write_en_o.IrqEnable            <= '1';
          when 16#10# =>
            register_write_en_o.PulseIrqMap          <= '1';
          when 16#18# =>
            register_write_en_o.SWEvent              <= '1';
          when 16#20# =>
            register_write_en_o.DataBufCtrl          <= '1';
          when 16#24# =>
            register_write_en_o.TXDataBufCtrl        <= '1';
          when 16#28# =>
            register_write_en_o.TxSegBufCtrl         <= '1';
          when 16#40# =>
            register_write_en_o.EvCntPresc           <= '1';
          when 16#4C# =>
            register_write_en_o.UsecDivider          <= '1';
          when 16#50# =>
            register_write_en_o.ClockControl         <= '1';
          when 16#90# =>
            register_write_en_o.GPIODir              <= '1';
          when 16#94# =>
            register_write_en_o.GPIOIn               <= '1';
          when 16#98# =>
            register_write_en_o.GPIOOut              <= '1';
          when 16#B0# =>
            register_write_en_o.DCTarget             <= '1';
          when 16#E0# =>
            register_write_en_o.SeqRamCtrl           <= '1';
          when 16#100# =>
            register_write_en_o.Prescaler0           <= '1';
          when 16#104# =>
            register_write_en_o.Prescaler1           <= '1';
          when 16#108# =>
            register_write_en_o.Prescaler2           <= '1';
          when 16#10C# =>
            register_write_en_o.Prescaler3           <= '1';
          when 16#110# =>
            register_write_en_o.Prescaler4           <= '1';
          when 16#114# =>
            register_write_en_o.Prescaler5           <= '1';
          when 16#118# =>
            register_write_en_o.Prescaler6           <= '1';
          when 16#11C# =>
            register_write_en_o.Prescaler7           <= '1';
          when 16#120# =>
            register_write_en_o.PrescPhase0          <= '1';
          when 16#124# =>
            register_write_en_o.PrescPhase1          <= '1';
          when 16#128# =>
            register_write_en_o.PrescPhase2          <= '1';
          when 16#12C# =>
            register_write_en_o.PrescPhase3          <= '1';
          when 16#130# =>
            register_write_en_o.PrescPhase4          <= '1';
          when 16#134# =>
            register_write_en_o.PrescPhase5          <= '1';
          when 16#138# =>
            register_write_en_o.PrescPhase6          <= '1';
          when 16#13C# =>
            register_write_en_o.PrescPhase7          <= '1';
          when 16#140# =>
            register_write_en_o.PrescTrig0           <= '1';
          when 16#144# =>
            register_write_en_o.PrescTrig1           <= '1';
          when 16#148# =>
            register_write_en_o.PrescTrig2           <= '1';
          when 16#14C# =>
            register_write_en_o.PrescTrig3           <= '1';
          when 16#150# =>
            register_write_en_o.PrescTrig4           <= '1';
          when 16#154# =>
            register_write_en_o.PrescTrig5           <= '1';
          when 16#158# =>
            register_write_en_o.PrescTrig6           <= '1';
          when 16#15C# =>
            register_write_en_o.PrescTrig7           <= '1';
          when 16#180# =>
            register_write_en_o.DBusTrig0            <= '1';
          when 16#184# =>
            register_write_en_o.DBusTrig1            <= '1';
          when 16#188# =>
            register_write_en_o.DBusTrig2            <= '1';
          when 16#18C# =>
            register_write_en_o.DBusTrig3            <= '1';
          when 16#190# =>
            register_write_en_o.DBusTrig4            <= '1';
          when 16#194# =>
            register_write_en_o.DBusTrig5            <= '1';
          when 16#198# =>
            register_write_en_o.DBusTrig6            <= '1';
          when 16#19C# =>
            register_write_en_o.DBusTrig7            <= '1';
          when 16#200# =>
            register_write_en_o.Pulse0Ctrl           <= '1';
          when 16#204# =>
            register_write_en_o.Pulse0Presc          <= '1';
          when 16#208# =>
            register_write_en_o.Pulse0Delay          <= '1';
          when 16#20C# =>
            register_write_en_o.Pulse0Width          <= '1';
          when 16#210# =>
            register_write_en_o.Pulse1Ctrl           <= '1';
          when 16#214# =>
            register_write_en_o.Pulse1Presc          <= '1';
          when 16#218# =>
            register_write_en_o.Pulse1Delay          <= '1';
          when 16#21C# =>
            register_write_en_o.Pulse1Width          <= '1';
          when 16#220# =>
            register_write_en_o.Pulse2Ctrl           <= '1';
          when 16#224# =>
            register_write_en_o.Pulse2Presc          <= '1';
          when 16#228# =>
            register_write_en_o.Pulse2Delay          <= '1';
          when 16#22C# =>
            register_write_en_o.Pulse2Width          <= '1';
          when 16#230# =>
            register_write_en_o.Pulse3Ctrl           <= '1';
          when 16#234# =>
            register_write_en_o.Pulse3Presc          <= '1';
          when 16#238# =>
            register_write_en_o.Pulse3Delay          <= '1';
          when 16#23C# =>
            register_write_en_o.Pulse3Width          <= '1';
          when 16#240# =>
            register_write_en_o.Pulse4Ctrl           <= '1';
          when 16#244# =>
            register_write_en_o.Pulse4Presc          <= '1';
          when 16#248# =>
            register_write_en_o.Pulse4Delay          <= '1';
          when 16#24C# =>
            register_write_en_o.Pulse4Width          <= '1';
          when 16#250# =>
            register_write_en_o.Pulse5Ctrl           <= '1';
          when 16#254# =>
            register_write_en_o.Pulse5Presc          <= '1';
          when 16#258# =>
            register_write_en_o.Pulse5Delay          <= '1';
          when 16#25C# =>
            register_write_en_o.Pulse5Width          <= '1';
          when 16#260# =>
            register_write_en_o.Pulse6Ctrl           <= '1';
          when 16#264# =>
            register_write_en_o.Pulse6Presc          <= '1';
          when 16#268# =>
            register_write_en_o.Pulse6Delay          <= '1';
          when 16#26C# =>
            register_write_en_o.Pulse6Width          <= '1';
          when 16#270# =>
            register_write_en_o.Pulse7Ctrl           <= '1';
          when 16#274# =>
            register_write_en_o.Pulse7Presc          <= '1';
          when 16#278# =>
            register_write_en_o.Pulse7Delay          <= '1';
          when 16#27C# =>
            register_write_en_o.Pulse7Width          <= '1';
          when 16#280# =>
            register_write_en_o.Pulse8Ctrl           <= '1';
          when 16#284# =>
            register_write_en_o.Pulse8Presc          <= '1';
          when 16#288# =>
            register_write_en_o.Pulse8Delay          <= '1';
          when 16#28C# =>
            register_write_en_o.Pulse8Width          <= '1';
          when 16#290# =>
            register_write_en_o.Pulse9Ctrl           <= '1';
          when 16#294# =>
            register_write_en_o.Pulse9Presc          <= '1';
          when 16#298# =>
            register_write_en_o.Pulse9Delay          <= '1';
          when 16#29C# =>
            register_write_en_o.Pulse9Width          <= '1';
          when 16#2A0# =>
            register_write_en_o.Pulse10Ctrl          <= '1';
          when 16#2A4# =>
            register_write_en_o.Pulse10Presc         <= '1';
          when 16#2A8# =>
            register_write_en_o.Pulse10Delay         <= '1';
          when 16#2AC# =>
            register_write_en_o.Pulse10Width         <= '1';
          when 16#2B0# =>
            register_write_en_o.Pulse11Ctrl          <= '1';
          when 16#2B4# =>
            register_write_en_o.Pulse11Presc         <= '1';
          when 16#2B8# =>
            register_write_en_o.Pulse11Delay         <= '1';
          when 16#2BC# =>
            register_write_en_o.Pulse11Width         <= '1';
          when 16#2C0# =>
            register_write_en_o.Pulse12Ctrl          <= '1';
          when 16#2C4# =>
            register_write_en_o.Pulse12Presc         <= '1';
          when 16#2C8# =>
            register_write_en_o.Pulse12Delay         <= '1';
          when 16#2CC# =>
            register_write_en_o.Pulse12Width         <= '1';
          when 16#2D0# =>
            register_write_en_o.Pulse13Ctrl          <= '1';
          when 16#2D4# =>
            register_write_en_o.Pulse13Presc         <= '1';
          when 16#2D8# =>
            register_write_en_o.Pulse13Delay         <= '1';
          when 16#2DC# =>
            register_write_en_o.Pulse13Width         <= '1';
          when 16#2E0# =>
            register_write_en_o.Pulse14Ctrl          <= '1';
          when 16#2E4# =>
            register_write_en_o.Pulse14Presc         <= '1';
          when 16#2E8# =>
            register_write_en_o.Pulse14Delay         <= '1';
          when 16#2EC# =>
            register_write_en_o.Pulse14Width         <= '1';
          when 16#2F0# =>
            register_write_en_o.Pulse15Ctrl          <= '1';
          when 16#2F4# =>
            register_write_en_o.Pulse15Presc         <= '1';
          when 16#2F8# =>
            register_write_en_o.Pulse15Delay         <= '1';
          when 16#2FC# =>
            register_write_en_o.Pulse15Width         <= '1';
          when 16#300# =>
            register_write_en_o.Pulse16Ctrl          <= '1';
          when 16#304# =>
            register_write_en_o.Pulse16Presc         <= '1';
          when 16#308# =>
            register_write_en_o.Pulse16Delay         <= '1';
          when 16#30C# =>
            register_write_en_o.Pulse16Width         <= '1';
          when 16#310# =>
            register_write_en_o.Pulse17Ctrl          <= '1';
          when 16#314# =>
            register_write_en_o.Pulse17Presc         <= '1';
          when 16#318# =>
            register_write_en_o.Pulse17Delay         <= '1';
          when 16#31C# =>
            register_write_en_o.Pulse17Width         <= '1';
          when 16#320# =>
            register_write_en_o.Pulse18Ctrl          <= '1';
          when 16#324# =>
            register_write_en_o.Pulse18Presc         <= '1';
          when 16#328# =>
            register_write_en_o.Pulse18Delay         <= '1';
          when 16#32C# =>
            register_write_en_o.Pulse18Width         <= '1';
          when 16#330# =>
            register_write_en_o.Pulse19Ctrl          <= '1';
          when 16#334# =>
            register_write_en_o.Pulse19Presc         <= '1';
          when 16#338# =>
            register_write_en_o.Pulse19Delay         <= '1';
          when 16#33C# =>
            register_write_en_o.Pulse19Width         <= '1';
          when 16#340# =>
            register_write_en_o.Pulse20Ctrl          <= '1';
          when 16#344# =>
            register_write_en_o.Pulse20Presc         <= '1';
          when 16#348# =>
            register_write_en_o.Pulse20Delay         <= '1';
          when 16#34C# =>
            register_write_en_o.Pulse20Width         <= '1';
          when 16#350# =>
            register_write_en_o.Pulse21Ctrl          <= '1';
          when 16#354# =>
            register_write_en_o.Pulse21Presc         <= '1';
          when 16#358# =>
            register_write_en_o.Pulse21Delay         <= '1';
          when 16#35C# =>
            register_write_en_o.Pulse21Width         <= '1';
          when 16#360# =>
            register_write_en_o.Pulse22Ctrl          <= '1';
          when 16#364# =>
            register_write_en_o.Pulse22Presc         <= '1';
          when 16#368# =>
            register_write_en_o.Pulse22Delay         <= '1';
          when 16#36C# =>
            register_write_en_o.Pulse22Width         <= '1';
          when 16#370# =>
            register_write_en_o.Pulse23Ctrl          <= '1';
          when 16#374# =>
            register_write_en_o.Pulse23Presc         <= '1';
          when 16#378# =>
            register_write_en_o.Pulse23Delay         <= '1';
          when 16#37C# =>
            register_write_en_o.Pulse23Width         <= '1';
          when 16#380# =>
            register_write_en_o.Pulse24Ctrl          <= '1';
          when 16#384# =>
            register_write_en_o.Pulse24Presc         <= '1';
          when 16#388# =>
            register_write_en_o.Pulse24Delay         <= '1';
          when 16#38C# =>
            register_write_en_o.Pulse24Width         <= '1';
          when 16#390# =>
            register_write_en_o.Pulse25Ctrl          <= '1';
          when 16#394# =>
            register_write_en_o.Pulse25Presc         <= '1';
          when 16#398# =>
            register_write_en_o.Pulse25Delay         <= '1';
          when 16#39C# =>
            register_write_en_o.Pulse25Width         <= '1';
          when 16#3A0# =>
            register_write_en_o.Pulse26Ctrl          <= '1';
          when 16#3A4# =>
            register_write_en_o.Pulse26Presc         <= '1';
          when 16#3A8# =>
            register_write_en_o.Pulse26Delay         <= '1';
          when 16#3AC# =>
            register_write_en_o.Pulse26Width         <= '1';
          when 16#3B0# =>
            register_write_en_o.Pulse27Ctrl          <= '1';
          when 16#3B4# =>
            register_write_en_o.Pulse27Presc         <= '1';
          when 16#3B8# =>
            register_write_en_o.Pulse27Delay         <= '1';
          when 16#3BC# =>
            register_write_en_o.Pulse27Width         <= '1';
          when 16#3C0# =>
            register_write_en_o.Pulse28Ctrl          <= '1';
          when 16#3C4# =>
            register_write_en_o.Pulse28Presc         <= '1';
          when 16#3C8# =>
            register_write_en_o.Pulse28Delay         <= '1';
          when 16#3CC# =>
            register_write_en_o.Pulse28Width         <= '1';
          when 16#3D0# =>
            register_write_en_o.Pulse29Ctrl          <= '1';
          when 16#3D4# =>
            register_write_en_o.Pulse29Presc         <= '1';
          when 16#3D8# =>
            register_write_en_o.Pulse29Delay         <= '1';
          when 16#3DC# =>
            register_write_en_o.Pulse29Width         <= '1';
          when 16#3E0# =>
            register_write_en_o.Pulse30Ctrl          <= '1';
          when 16#3E4# =>
            register_write_en_o.Pulse30Presc         <= '1';
          when 16#3E8# =>
            register_write_en_o.Pulse30Delay         <= '1';
          when 16#3EC# =>
            register_write_en_o.Pulse30Width         <= '1';
          when 16#3F0# =>
            register_write_en_o.Pulse31Ctrl          <= '1';
          when 16#3F4# =>
            register_write_en_o.Pulse31Presc         <= '1';
          when 16#3F8# =>
            register_write_en_o.Pulse31Delay         <= '1';
          when 16#3FC# =>
            register_write_en_o.Pulse31Width         <= '1';
          when 16#400# =>
            register_write_en_o.FPOutMap0_1          <= '1';
          when 16#440# =>
            register_write_en_o.UnivOUTMap0_1        <= '1';
          when 16#B004# =>
            register_write_en_o.ESSControl           <= '1';


          when others =>
            decode_error_o <= '1';
        end case;
      end if;
    end if;

    -- Forward bus data to the registers
    register_data_o <= bus_data_i;

  end process write_select;

end architecture rtl;
