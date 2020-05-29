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

address_width  = 12
register_width = 32

bank = essffw.RegisterBank("test_bank", address_width, register_width)
bank.base_address = 0x0

bank.add_register("master_reset", address=0, reset_value=0x0, modes="RW")
bank["master_reset"].data_width = 1

bank.add_register("rxpath_reset")
bank["rxpath_reset"].reset_value = 0x0
bank["rxpath_reset"].modes = "RW"
bank["rxpath_reset"].data_width = 1

bank.add_register("txpath_reset")
bank["txpath_reset"].reset_value = 0x0
bank["txpath_reset"].modes = "RW"
bank["txpath_reset"].data_width = 1

print()
print(str(bank))
print()

bank.generate_code("../../../output/test_openevr")
