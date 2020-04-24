# =============================================================================
# @file   ess_evr.xdc
# @brief  Top constraint file for the ESS openEVR in standalone mode
# -----------------------------------------------------------------------------
# @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
# @company European Spallation Source ERIC
# @date 20200421
# 
# Platform:       picoZED 7030
# Carrier board:  Tallinn picoZED carrier board (aka FPGA-based IOC) rev. B
# Based on the AVNET xdc file for the picozed 7z030 RevC v2
# =============================================================================

# =============================================================================
# Clocks
# =============================================================================

# Clk_sys
set_property PACKAGE_PIN Y19 [get_ports {i_ZYNQ_MRCC_LVDS_N   }];
set_property IOSTANDARD LVDS_25 [get_ports {i_ZYNQ_MRCC_LVDS_N }];
# To the EVR MGT
# From Si5346 Out0 - 88.0525 MHz
set_property PACKAGE_PIN V9   [get_ports {i_ZYNQ_CLKREF0_N   }];
# Secondary SFP port, not used
# From Si5346 Out1 - 88.0525 MHz
#set_property PACKAGE_PIN V5   [get_ports {i_ZYNQ_CLKREF1_N   }];

# =============================================================================
# Si5346
# =============================================================================

# Si5346 Loss of signal alarm on the XA/XB pins 
#set_property PACKAGE_PIN H3   [get_ports {i_SI5346_LOL_XAXB }];  # "H3.JX1_LVDS_0_N"
# Si5346 Output Enable 1
#set_property PACKAGE_PIN E5   [get_ports {o_SI5346_OE1      }];  # "E5.JX1_LVDS_1_N"
# Si5346 Output Enable 0
#set_property PACKAGE_PIN F5   [get_ports {o_SI5346_OE0      }];  # "F5.JX1_LVDS_1_P"
# Si5346 Loss of lock A - H: Locked | L: Out of lock
#set_property PACKAGE_PIN G3   [get_ports {i_SI5346_LOL_A    }];  # "G3.JX1_LVDS_2_P"
# Si5346 Loss of lock B - H: Locked | L: Out of lock
#set_property PACKAGE_PIN G2   [get_ports {i_SI5346_LOL_B    }];  # "G2.JX1_LVDS_2_N"
# Si5346 Device reset (active low)
#set_property PACKAGE_PIN G4   [get_ports {o_SI5346_RST_rn   }];  # "G4.JX1_LVDS_4_P"
# Si5346 Interrupt pin (asserted low)
#set_property PACKAGE_PIN F4   [get_ports {i_SI5346_INT_n    }];  # "F4.JX1_LVDS_4_N"

# =============================================================================
# SY87739
# =============================================================================
# Data In (Microwire interface)
#set_property PACKAGE_PIN AB18 [get_ports {o_SY87730_PROGDI    }];  # "AB18.BANK13_LVDS_5_P"
# Chip select (Microwire interface)         
#set_property PACKAGE_PIN AB19 [get_ports {o_SY87730_PROGCS[0] }];  # "AB19.BANK13_LVDS_5_N"
# Locked signal                             
#set_property PACKAGE_PIN AB21 [get_ports {i_SY87730_LOCKED    }];  # "AB21.BANK13_LVDS_4_P"
# Serial clock (Microwire interface)        
#set_property PACKAGE_PIN AB22 [get_ports {o_SY87730_PROGSK    }];  # "AB22.BANK13_LVDS_4_N"

# =============================================================================
# OpenEVR
# =============================================================================

# EVR enable
#set_property PACKAGE_PIN W16  [get_ports {o_EVR_ENABLE}];      # "W16.BANK13_LVDS_16_N"
# Rx signal from SFP
set_property PACKAGE_PIN AB7  [get_ports {i_EVR_RX_N      }];  # "AB7.MGTRX0_N"
# EVR Link LED
set_property PACKAGE_PIN H5   [get_ports {o_EVR_LINK_LED  }];  # "H5.JX1_SE_1"
set_property IOSTANDARD LVCMOS18   [get_ports {o_EVR_LINK_LED  }];  # "H5.JX1_SE_1"
set_property PACKAGE_PIN H6   [get_ports {o_EVR_EVNT_LED  }];  # "H6.JX1_SE_0"
set_property IOSTANDARD LVCMOS18   [get_ports {o_EVR_EVNT_LED  }];  # "H6.JX1_SE_0"

#set_property PACKAGE_PIN Y13  [get_ports {EVR_RX_RATE     }];  # "Y13.BANK13_LVDS_10_N"
#set_property PACKAGE_PIN Y12  [get_ports {EVR_RX_LOS      }];  # "Y12.BANK13_LVDS_10_P"
#set_property PACKAGE_PIN V13  [get_ports {EVR_MOD_DEF_0   }];  # "V13.BANK13_LVDS_12_P"
set_property PACKAGE_PIN AB3  [get_ports {o_EVR_TX_N        }];  # "AB3.MGTTX0_N"
#set_property PACKAGE_PIN AB11 [get_ports {EVR_TX_DISABLE  }];  # "AB11.BANK13_LVDS_9_N"
#set_property PACKAGE_PIN AA11 [get_ports {EVR_TX_FAULT    }];  # "AA11.BANK13_LVDS_9_P"
#set_property PACKAGE_PIN W11  [get_ports {EVR_MOD_DEF_2   }];  # "W11.BANK13_LVDS_11_N"
#set_property PACKAGE_PIN V11  [get_ports {EVR_MOD_DEF_1   }];  # "V11.BANK13_LVDS_11_P"

create_clock -period 11.2 -name clk_mgt [get_ports i_ZYNQ_CLKREF0_N];
create_clock -period 11.2 -name clk_sys [get_ports i_ZYNQ_MRCC_LVDS_N];