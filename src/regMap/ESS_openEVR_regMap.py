# =============================================================================
# @file   openevr_regbank_gen.py
# @brief  Python script to generate the register interface for the openEVR core
#
# @details
# Generates an AXI4-Lite compatible register bank for the openEVR IP core.
# Provides writeable registers for providing configuration and control signals
# to the logic, and also readback registers for providing status and
# diagnostic information
#
# @author Ross Elliot <ross.elliot@ess.eu>
# @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
#
# @date 20200525
# @version 0.1
#
# Company: European Spallation Source ERIC \n
#
# @copyright
#
# Copyright (C) 2019- 2020 European Spallation Source ERIC \n
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version. \n
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details. \n
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# =============================================================================

# Load modules in other folders
import os
import sys
import inspect
import_folder = ".."
import_folder_abs = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile(inspect.currentframe() ))[0], import_folder)))
if import_folder_abs not in sys.path:
    sys.path.insert(0, import_folder_abs)

import essffw

address_width  = 16
register_width = 32

bank = essffw.RegisterBank("ESS_openEVR_RegMap", address_width, register_width)
bank.base_address = 0x0

# EVR registers (see mTCA-ERV300U-DCManual, Sec. 3.8 Register Map)
bank.add_register("Status",        address=0x000,    modes="R")  # Status Register
bank.add_register("Control",       address=0x004,    modes="RW") # Control Register
bank.add_register("IrqFlag",       address=0x008,    modes="RW") # Interrupt Flag Register
bank.add_register("IrqEnable",     address=0x00C,    modes="RW") # Interrupt Enable Register

bank.add_register("PulseIrqMap",   address=0x010,    modes="RW") # Mapping register for pulse interrupt
bank.add_register("SWEvent",       address=0x018,    modes="RW") # Software event register

bank.add_register("DataBufCtrl",   address=0x020,    modes="RW") # Data Buffer Control and Status Register
bank.add_register("TXDataBufCtrl", address=0x024,    modes="RW") # TX Data Buffer Control and Status Register
bank.add_register("TxSegBufCtrl",  address=0x028,    modes="RW") # TX Segmented Data Buffer Control and Status Register
bank.add_register("FWVersion",     address=0x02C,    modes="R")  # Firmware Version Register

bank.add_register("EvCntPresc",    address=0x040,    modes="RW") # Event Counter Prescaler
bank.add_register("UsecDivider",   address=0x04C,    modes="RW") # Divider to get from Event Clock to 1 MHz
bank.add_register("ClockControl",  address=0x050,    modes="RW") # Event Clock Control Register
bank.add_register("SecSR",         address=0x05C,    modes="R")  # Seconds Shift Register
bank.add_register("SecCounter",    address=0x060,    modes="R")  # Timestamp Seconds Counter
bank.add_register("EventCounter",  address=0x064,    modes="R")  # Timestamp Event Counter
bank.add_register("SecLatch",      address=0x068,    modes="R")  # Timestamp Seconds Counter Latch
bank.add_register("EvCntLatch",    address=0x06C,    modes="R")  # Timestamp Event Counter Latch
bank.add_register("EvFIFOSec",     address=0x070,    modes="R")  # Event FIFO Seconds Register
bank.add_register("EvFIFOEvCnt",   address=0x074,    modes="R")  # Event FIFO Event Counter Register
bank.add_register("EvFIFOCode",    address=0x078,    modes="R")  # Event FIFO Event Code Register
bank.add_register("LogStatus",     address=0x07C,    modes="R")  # Event Log Status Register

bank.add_register("GPIODir",       address=0x090,    modes="RW") # Front Panel UnivIO GPIO signal direction
bank.add_register("GPIOIn",        address=0x094,    modes="RW") # Front Panel UnivIO GPIO input register
bank.add_register("GPIOOut",       address=0x098,    modes="RW") # Front Panel UnivIO GPIO output register

bank.add_register("DCTarget",      address=0x0B0,    modes="RW",  reset_value=0x037084FC) # Delay compensation target value
bank.add_register("DCRxValue",     address=0x0B4,    modes="R")  # Delay compensation transmission path delay value

bank.add_register("DCIntValue",    address=0x0B8,    modes="R")  # Delay Compensation Internal Delay Value
bank.add_register("DCStatus",      address=0x0BC,    modes="R")  # Delay Compensation Status Register

bank.add_register("TopologyID",    address=0x0C0,    modes="R")  # Timing Node Topology ID

bank.add_register("SeqRamCtrl",    address=0x0E0,    modes="RW") # Sequence RAM Control Register

bank.add_register("Prescaler0",    address=0x100,    modes="RW") # Prescaler 0 Divider
bank.add_register("Prescaler1",    address=0x104,    modes="RW") # Prescaler 1 Divider
bank.add_register("Prescaler2",    address=0x108,    modes="RW") # Prescaler 2 Divider
bank.add_register("Prescaler3",    address=0x10C,    modes="RW") # Prescaler 3 Divider
bank.add_register("Prescaler4",    address=0x110,    modes="RW") # Prescaler 4 Divider
bank.add_register("Prescaler5",    address=0x114,    modes="RW") # Prescaler 5 Divider
bank.add_register("Prescaler6",    address=0x118,    modes="RW") # Prescaler 6 Divider
bank.add_register("Prescaler7",    address=0x11C,    modes="RW") # Prescaler 7 Divider

bank.add_register("PrescPhase0",   address=0x120,    modes="RW") # Prescaler 0 Phase Offset Register
bank.add_register("PrescPhase1",   address=0x124,    modes="RW") # Prescaler 1 Phase Offset Register
bank.add_register("PrescPhase2",   address=0x128,    modes="RW") # Prescaler 2 Phase Offset Register
bank.add_register("PrescPhase3",   address=0x12C,    modes="RW") # Prescaler 3 Phase Offset Register
bank.add_register("PrescPhase4",   address=0x130,    modes="RW") # Prescaler 4 Phase Offset Register
bank.add_register("PrescPhase5",   address=0x134,    modes="RW") # Prescaler 5 Phase Offset Register
bank.add_register("PrescPhase6",   address=0x138,    modes="RW") # Prescaler 6 Phase Offset Register
bank.add_register("PrescPhase7",   address=0x13C,    modes="RW") # Prescaler 7 Phase Offset Register

bank.add_register("PrescTrig0",    address=0x140,    modes="RW") # Prescaler 0 Pulse Generator Trigger Register
bank.add_register("PrescTrig1",    address=0x144,    modes="RW") # Prescaler 1 Pulse Generator Trigger Register
bank.add_register("PrescTrig2",    address=0x148,    modes="RW") # Prescaler 2 Pulse Generator Trigger Register
bank.add_register("PrescTrig3",    address=0x14C,    modes="RW") # Prescaler 3 Pulse Generator Trigger Register
bank.add_register("PrescTrig4",    address=0x150,    modes="RW") # Prescaler 4 Pulse Generator Trigger Register
bank.add_register("PrescTrig5",    address=0x154,    modes="RW") # Prescaler 5 Pulse Generator Trigger Register
bank.add_register("PrescTrig6",    address=0x158,    modes="RW") # Prescaler 6 Pulse Generator Trigger Register
bank.add_register("PrescTrig7",    address=0x15C,    modes="RW") # Prescaler 7 Pulse Generator Trigger Register

bank.add_register("DBusTrig0",     address=0x180,    modes="RW") # DBus bit 0 Pulse Generator Trigger Register
bank.add_register("DBusTrig1",     address=0x184,    modes="RW") # DBus bit 1 Pulse Generator Trigger Register
bank.add_register("DBusTrig2",     address=0x188,    modes="RW") # DBus bit 2 Pulse Generator Trigger Register
bank.add_register("DBusTrig3",     address=0x18C,    modes="RW") # DBus bit 3 Pulse Generator Trigger Register
bank.add_register("DBusTrig4",     address=0x190,    modes="RW") # DBus bit 4 Pulse Generator Trigger Register
bank.add_register("DBusTrig5",     address=0x194,    modes="RW") # DBus bit 5 Pulse Generator Trigger Register
bank.add_register("DBusTrig6",     address=0x198,    modes="RW") # DBus bit 6 Pulse Generator Trigger Register
bank.add_register("DBusTrig7",     address=0x19C,    modes="RW") # DBus bit 7 Pulse Generator Trigger Register

bank.add_register("Pulse0Ctrl",    address=0x200,    modes="RW") # Pulse 0 Control Register
bank.add_register("Pulse0Presc",   address=0x204,    modes="RW") # Pulse 0 Prescaler Register
bank.add_register("Pulse0Delay",   address=0x208,    modes="RW") # Pulse 0 Delay Register
bank.add_register("Pulse0Width",   address=0x20C,    modes="RW") # Pulse 0 Width Register
bank.add_register("Pulse1Ctrl",    address=0x210,    modes="RW") # Pulse 1 Control Register
bank.add_register("Pulse1Presc",   address=0x214,    modes="RW") # Pulse 1 Prescaler Register
bank.add_register("Pulse1Delay",   address=0x218,    modes="RW") # Pulse 1 Delay Register
bank.add_register("Pulse1Width",   address=0x21C,    modes="RW") # Pulse 1 Width Register
bank.add_register("Pulse2Ctrl",    address=0x220,    modes="RW") # Pulse 2 Control Register
bank.add_register("Pulse2Presc",   address=0x224,    modes="RW") # Pulse 2 Prescaler Register
bank.add_register("Pulse2Delay",   address=0x228,    modes="RW") # Pulse 2 Delay Register
bank.add_register("Pulse2Width",   address=0x22C,    modes="RW") # Pulse 2 Width Register
bank.add_register("Pulse3Ctrl",    address=0x230,    modes="RW") # Pulse 3 Control Register
bank.add_register("Pulse3Presc",   address=0x234,    modes="RW") # Pulse 3 Prescaler Register
bank.add_register("Pulse3Delay",   address=0x238,    modes="RW") # Pulse 3 Delay Register
bank.add_register("Pulse3Width",   address=0x23C,    modes="RW") # Pulse 3 Width Register
bank.add_register("Pulse4Ctrl",    address=0x240,    modes="RW") # Pulse 4 Control Register
bank.add_register("Pulse4Presc",   address=0x244,    modes="RW") # Pulse 4 Prescaler Register
bank.add_register("Pulse4Delay",   address=0x248,    modes="RW") # Pulse 4 Delay Register
bank.add_register("Pulse4Width",   address=0x24C,    modes="RW") # Pulse 4 Width Register
bank.add_register("Pulse5Ctrl",    address=0x250,    modes="RW") # Pulse 5 Control Register
bank.add_register("Pulse5Presc",   address=0x254,    modes="RW") # Pulse 5 Prescaler Register
bank.add_register("Pulse5Delay",   address=0x258,    modes="RW") # Pulse 5 Delay Register
bank.add_register("Pulse5Width",   address=0x25C,    modes="RW") # Pulse 5 Width Register
bank.add_register("Pulse6Ctrl",    address=0x260,    modes="RW") # Pulse 6 Control Register
bank.add_register("Pulse6Presc",   address=0x264,    modes="RW") # Pulse 6 Prescaler Register
bank.add_register("Pulse6Delay",   address=0x268,    modes="RW") # Pulse 6 Delay Register
bank.add_register("Pulse6Width",   address=0x26C,    modes="RW") # Pulse 6 Width Register
bank.add_register("Pulse7Ctrl",    address=0x270,    modes="RW") # Pulse 7 Control Register
bank.add_register("Pulse7Presc",   address=0x274,    modes="RW") # Pulse 7 Prescaler Register
bank.add_register("Pulse7Delay",   address=0x278,    modes="RW") # Pulse 7 Delay Register
bank.add_register("Pulse7Width",   address=0x27C,    modes="RW") # Pulse 7 Width Register
bank.add_register("Pulse8Ctrl",    address=0x280,    modes="RW") # Pulse 8 Control Register
bank.add_register("Pulse8Presc",   address=0x284,    modes="RW") # Pulse 8 Prescaler Register
bank.add_register("Pulse8Delay",   address=0x288,    modes="RW") # Pulse 8 Delay Register
bank.add_register("Pulse8Width",   address=0x28C,    modes="RW") # Pulse 8 Width Register
bank.add_register("Pulse9Ctrl",    address=0x290,    modes="RW") # Pulse 9 Control Register
bank.add_register("Pulse9Presc",   address=0x294,    modes="RW") # Pulse 9 Prescaler Register
bank.add_register("Pulse9Delay",   address=0x298,    modes="RW") # Pulse 9 Delay Register
bank.add_register("Pulse9Width",   address=0x29C,    modes="RW") # Pulse 9 Width Register

bank.add_register("Pulse10Ctrl",   address=0x2A0,    modes="RW") # Pulse 10 Control Register
bank.add_register("Pulse10Presc",  address=0x2A4,    modes="RW") # Pulse 10 Prescaler Register
bank.add_register("Pulse10Delay",  address=0x2A8,    modes="RW") # Pulse 10 Delay Register
bank.add_register("Pulse10Width",  address=0x2AC,    modes="RW") # Pulse 10 Width Register
bank.add_register("Pulse11Ctrl",   address=0x2B0,    modes="RW") # Pulse 11 Control Register
bank.add_register("Pulse11Presc",  address=0x2B4,    modes="RW") # Pulse 11 Prescaler Register
bank.add_register("Pulse11Delay",  address=0x2B8,    modes="RW") # Pulse 11 Delay Register
bank.add_register("Pulse11Width",  address=0x2BC,    modes="RW") # Pulse 11 Width Register
bank.add_register("Pulse12Ctrl",   address=0x2C0,    modes="RW") # Pulse 12 Control Register
bank.add_register("Pulse12Presc",  address=0x2C4,    modes="RW") # Pulse 12 Prescaler Register
bank.add_register("Pulse12Delay",  address=0x2C8,    modes="RW") # Pulse 12 Delay Register
bank.add_register("Pulse12Width",  address=0x2CC,    modes="RW") # Pulse 12 Width Register
bank.add_register("Pulse13Ctrl",   address=0x2D0,    modes="RW") # Pulse 13 Control Register
bank.add_register("Pulse13Presc",  address=0x2D4,    modes="RW") # Pulse 13 Prescaler Register
bank.add_register("Pulse13Delay",  address=0x2D8,    modes="RW") # Pulse 13 Delay Register
bank.add_register("Pulse13Width",  address=0x2DC,    modes="RW") # Pulse 13 Width Register
bank.add_register("Pulse14Ctrl",   address=0x2E0,    modes="RW") # Pulse 14 Control Register
bank.add_register("Pulse14Presc",  address=0x2E4,    modes="RW") # Pulse 14 Prescaler Register
bank.add_register("Pulse14Delay",  address=0x2E8,    modes="RW") # Pulse 14 Delay Register
bank.add_register("Pulse14Width",  address=0x2EC,    modes="RW") # Pulse 14 Width Register
bank.add_register("Pulse15Ctrl",   address=0x2F0,    modes="RW") # Pulse 15 Control Register
bank.add_register("Pulse15Presc",  address=0x2F4,    modes="RW") # Pulse 15 Prescaler Register
bank.add_register("Pulse15Delay",  address=0x2F8,    modes="RW") # Pulse 15 Delay Register
bank.add_register("Pulse15Width",  address=0x2FC,    modes="RW") # Pulse 15 Width Register
bank.add_register("Pulse16Ctrl",   address=0x300,    modes="RW") # Pulse 16 Control Register
bank.add_register("Pulse16Presc",  address=0x304,    modes="RW") # Pulse 16 Prescaler Register
bank.add_register("Pulse16Delay",  address=0x308,    modes="RW") # Pulse 16 Delay Register
bank.add_register("Pulse16Width",  address=0x30C,    modes="RW") # Pulse 16 Width Register
bank.add_register("Pulse17Ctrl",   address=0x310,    modes="RW") # Pulse 17 Control Register
bank.add_register("Pulse17Presc",  address=0x314,    modes="RW") # Pulse 17 Prescaler Register
bank.add_register("Pulse17Delay",  address=0x318,    modes="RW") # Pulse 17 Delay Register
bank.add_register("Pulse17Width",  address=0x31C,    modes="RW") # Pulse 17 Width Register
bank.add_register("Pulse18Ctrl",   address=0x320,    modes="RW") # Pulse 18 Control Register
bank.add_register("Pulse18Presc",  address=0x324,    modes="RW") # Pulse 18 Prescaler Register
bank.add_register("Pulse18Delay",  address=0x328,    modes="RW") # Pulse 18 Delay Register
bank.add_register("Pulse18Width",  address=0x32C,    modes="RW") # Pulse 18 Width Register
bank.add_register("Pulse19Ctrl",   address=0x330,    modes="RW") # Pulse 19 Control Register
bank.add_register("Pulse19Presc",  address=0x334,    modes="RW") # Pulse 19 Prescaler Register
bank.add_register("Pulse19Delay",  address=0x338,    modes="RW") # Pulse 19 Delay Register
bank.add_register("Pulse19Width",  address=0x33C,    modes="RW") # Pulse 19 Width Register

bank.add_register("Pulse20Ctrl",   address=0x340,    modes="RW") # Pulse 20 Control Register
bank.add_register("Pulse20Presc",  address=0x344,    modes="RW") # Pulse 20 Prescaler Register
bank.add_register("Pulse20Delay",  address=0x348,    modes="RW") # Pulse 20 Delay Register
bank.add_register("Pulse20Width",  address=0x34C,    modes="RW") # Pulse 20 Width Register
bank.add_register("Pulse21Ctrl",   address=0x350,    modes="RW") # Pulse 21 Control Register
bank.add_register("Pulse21Presc",  address=0x354,    modes="RW") # Pulse 21 Prescaler Register
bank.add_register("Pulse21Delay",  address=0x358,    modes="RW") # Pulse 21 Delay Register
bank.add_register("Pulse21Width",  address=0x35C,    modes="RW") # Pulse 21 Width Register
bank.add_register("Pulse22Ctrl",   address=0x360,    modes="RW") # Pulse 22 Control Register
bank.add_register("Pulse22Presc",  address=0x364,    modes="RW") # Pulse 22 Prescaler Register
bank.add_register("Pulse22Delay",  address=0x368,    modes="RW") # Pulse 22 Delay Register
bank.add_register("Pulse22Width",  address=0x36C,    modes="RW") # Pulse 22 Width Register
bank.add_register("Pulse23Ctrl",   address=0x370,    modes="RW") # Pulse 23 Control Register
bank.add_register("Pulse23Presc",  address=0x374,    modes="RW") # Pulse 23 Prescaler Register
bank.add_register("Pulse23Delay",  address=0x378,    modes="RW") # Pulse 23 Delay Register
bank.add_register("Pulse23Width",  address=0x37C,    modes="RW") # Pulse 23 Width Register
bank.add_register("Pulse24Ctrl",   address=0x380,    modes="RW") # Pulse 24 Control Register
bank.add_register("Pulse24Presc",  address=0x384,    modes="RW") # Pulse 24 Prescaler Register
bank.add_register("Pulse24Delay",  address=0x388,    modes="RW") # Pulse 24 Delay Register
bank.add_register("Pulse24Width",  address=0x38C,    modes="RW") # Pulse 24 Width Register
bank.add_register("Pulse25Ctrl",   address=0x390,    modes="RW") # Pulse 25 Control Register
bank.add_register("Pulse25Presc",  address=0x394,    modes="RW") # Pulse 25 Prescaler Register
bank.add_register("Pulse25Delay",  address=0x398,    modes="RW") # Pulse 25 Delay Register
bank.add_register("Pulse25Width",  address=0x39C,    modes="RW") # Pulse 25 Width Register
bank.add_register("Pulse26Ctrl",   address=0x3A0,    modes="RW") # Pulse 26 Control Register
bank.add_register("Pulse26Presc",  address=0x3A4,    modes="RW") # Pulse 26 Prescaler Register
bank.add_register("Pulse26Delay",  address=0x3A8,    modes="RW") # Pulse 26 Delay Register
bank.add_register("Pulse26Width",  address=0x3AC,    modes="RW") # Pulse 26 Width Register
bank.add_register("Pulse27Ctrl",   address=0x3B0,    modes="RW") # Pulse 27 Control Register
bank.add_register("Pulse27Presc",  address=0x3B4,    modes="RW") # Pulse 27 Prescaler Register
bank.add_register("Pulse27Delay",  address=0x3B8,    modes="RW") # Pulse 27 Delay Register
bank.add_register("Pulse27Width",  address=0x3BC,    modes="RW") # Pulse 27 Width Register
bank.add_register("Pulse28Ctrl",   address=0x3C0,    modes="RW") # Pulse 28 Control Register
bank.add_register("Pulse28Presc",  address=0x3C4,    modes="RW") # Pulse 28 Prescaler Register
bank.add_register("Pulse28Delay",  address=0x3C8,    modes="RW") # Pulse 28 Delay Register
bank.add_register("Pulse28Width",  address=0x3CC,    modes="RW") # Pulse 28 Width Register
bank.add_register("Pulse29Ctrl",   address=0x3D0,    modes="RW") # Pulse 29 Control Register
bank.add_register("Pulse29Presc",  address=0x3D4,    modes="RW") # Pulse 29 Prescaler Register
bank.add_register("Pulse29Delay",  address=0x3D8,    modes="RW") # Pulse 29 Delay Register
bank.add_register("Pulse29Width",  address=0x3DC,    modes="RW") # Pulse 29 Width Register

bank.add_register("Pulse30Ctrl",   address=0x3E0,    modes="RW") # Pulse 30 Control Register
bank.add_register("Pulse30Presc",  address=0x3E4,    modes="RW") # Pulse 30 Prescaler Register
bank.add_register("Pulse30Delay",  address=0x3E8,    modes="RW") # Pulse 30 Delay Register
bank.add_register("Pulse30Width",  address=0x3EC,    modes="RW") # Pulse 30 Width Register
bank.add_register("Pulse31Ctrl",   address=0x3F0,    modes="RW") # Pulse 31 Control Register
bank.add_register("Pulse31Presc",  address=0x3F4,    modes="RW") # Pulse 31 Prescaler Register
bank.add_register("Pulse31Delay",  address=0x3F8,    modes="RW") # Pulse 31 Delay Register
bank.add_register("Pulse31Width",  address=0x3FC,    modes="RW") # Pulse 31 Width Register

# ESS OpenEVR specific registers
bank.add_register("ESSStatus",          address=0xB000, reset_value=0x0, modes="R")
bank.add_register("ESSControl",         address=0xB004, reset_value=0x0, modes="RW")
bank.add_register("ESSExtSecCounter",   address=0xB060, reset_value=0x0, modes="R")
bank.add_register("ESSExtEventCounter", address=0xB064, reset_value=0x0, modes="R")

print()
print(str(bank))
print()

bank.generate_code("../../../output/ESS_openEVR_regMap_hdl")
