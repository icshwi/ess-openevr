
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/ess_openEVR_v0_1.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  set g_HAS_DEBUG_CLK [ipgui::add_param $IPINST -name "g_HAS_DEBUG_CLK"]
  set_property tooltip {Useful to drive ILAs and debug logic} ${g_HAS_DEBUG_CLK}
  set g_CARRIER_VER [ipgui::add_param $IPINST -name "g_CARRIER_VER" -widget comboBox]
  set_property tooltip {revE or revD (old)} ${g_CARRIER_VER}
  set FP_OUT_CHANNELS [ipgui::add_param $IPINST -name "FP_OUT_CHANNELS"]
  set_property tooltip {Number of Output Channels for the openEVR Core} ${FP_OUT_CHANNELS}
  set FP_IN_CHANNELS [ipgui::add_param $IPINST -name "FP_IN_CHANNELS"]
  set_property tooltip {Front Panel Input Channels} ${FP_IN_CHANNELS}

}

proc update_PARAM_VALUE.g_HAS_DEBUG_CLK { PARAM_VALUE.g_HAS_DEBUG_CLK PARAM_VALUE.g_HAS_DEBUG_CLK } {
	# Procedure called to update g_HAS_DEBUG_CLK when any of the dependent parameters in the arguments change

	set g_HAS_DEBUG_CLK ${PARAM_VALUE.g_HAS_DEBUG_CLK}
	set values(g_HAS_DEBUG_CLK) [get_property value $g_HAS_DEBUG_CLK]
	if { [gen_USERPARAMETER_g_HAS_DEBUG_CLK_ENABLEMENT $values(g_HAS_DEBUG_CLK)] } {
		set_property enabled true $g_HAS_DEBUG_CLK
	} else {
		set_property enabled false $g_HAS_DEBUG_CLK
		set_property value [gen_USERPARAMETER_g_HAS_DEBUG_CLK_VALUE $values(g_HAS_DEBUG_CLK)] $g_HAS_DEBUG_CLK
	}
}

proc validate_PARAM_VALUE.g_HAS_DEBUG_CLK { PARAM_VALUE.g_HAS_DEBUG_CLK } {
	# Procedure called to validate g_HAS_DEBUG_CLK
	return true
}

proc update_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to update AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to validate AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to update AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to validate AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_WSTRB_WIDTH { PARAM_VALUE.AXI_WSTRB_WIDTH } {
	# Procedure called to update AXI_WSTRB_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_WSTRB_WIDTH { PARAM_VALUE.AXI_WSTRB_WIDTH } {
	# Procedure called to validate AXI_WSTRB_WIDTH
	return true
}

proc update_PARAM_VALUE.FP_IN_CHANNELS { PARAM_VALUE.FP_IN_CHANNELS } {
	# Procedure called to update FP_IN_CHANNELS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FP_IN_CHANNELS { PARAM_VALUE.FP_IN_CHANNELS } {
	# Procedure called to validate FP_IN_CHANNELS
	return true
}

proc update_PARAM_VALUE.FP_OUT_CHANNELS { PARAM_VALUE.FP_OUT_CHANNELS } {
	# Procedure called to update FP_OUT_CHANNELS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FP_OUT_CHANNELS { PARAM_VALUE.FP_OUT_CHANNELS } {
	# Procedure called to validate FP_OUT_CHANNELS
	return true
}

proc update_PARAM_VALUE.REGISTER_WIDTH { PARAM_VALUE.REGISTER_WIDTH } {
	# Procedure called to update REGISTER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REGISTER_WIDTH { PARAM_VALUE.REGISTER_WIDTH } {
	# Procedure called to validate REGISTER_WIDTH
	return true
}

proc update_PARAM_VALUE.REG_ADDR_WIDTH { PARAM_VALUE.REG_ADDR_WIDTH } {
	# Procedure called to update REG_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REG_ADDR_WIDTH { PARAM_VALUE.REG_ADDR_WIDTH } {
	# Procedure called to validate REG_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.g_CARRIER_VER { PARAM_VALUE.g_CARRIER_VER } {
	# Procedure called to update g_CARRIER_VER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_CARRIER_VER { PARAM_VALUE.g_CARRIER_VER } {
	# Procedure called to validate g_CARRIER_VER
	return true
}


proc update_MODELPARAM_VALUE.AXI_ADDR_WIDTH { MODELPARAM_VALUE.AXI_ADDR_WIDTH PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.REG_ADDR_WIDTH { MODELPARAM_VALUE.REG_ADDR_WIDTH PARAM_VALUE.REG_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REG_ADDR_WIDTH}] ${MODELPARAM_VALUE.REG_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_WSTRB_WIDTH { MODELPARAM_VALUE.AXI_WSTRB_WIDTH PARAM_VALUE.AXI_WSTRB_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_WSTRB_WIDTH}] ${MODELPARAM_VALUE.AXI_WSTRB_WIDTH}
}

proc update_MODELPARAM_VALUE.REGISTER_WIDTH { MODELPARAM_VALUE.REGISTER_WIDTH PARAM_VALUE.REGISTER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REGISTER_WIDTH}] ${MODELPARAM_VALUE.REGISTER_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_DATA_WIDTH { MODELPARAM_VALUE.AXI_DATA_WIDTH PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.g_HAS_DEBUG_CLK { MODELPARAM_VALUE.g_HAS_DEBUG_CLK PARAM_VALUE.g_HAS_DEBUG_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_HAS_DEBUG_CLK}] ${MODELPARAM_VALUE.g_HAS_DEBUG_CLK}
}

proc update_MODELPARAM_VALUE.g_CARRIER_VER { MODELPARAM_VALUE.g_CARRIER_VER PARAM_VALUE.g_CARRIER_VER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_CARRIER_VER}] ${MODELPARAM_VALUE.g_CARRIER_VER}
}

proc update_MODELPARAM_VALUE.FP_IN_CHANNELS { MODELPARAM_VALUE.FP_IN_CHANNELS PARAM_VALUE.FP_IN_CHANNELS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FP_IN_CHANNELS}] ${MODELPARAM_VALUE.FP_IN_CHANNELS}
}

proc update_MODELPARAM_VALUE.FP_OUT_CHANNELS { MODELPARAM_VALUE.FP_OUT_CHANNELS PARAM_VALUE.FP_OUT_CHANNELS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FP_OUT_CHANNELS}] ${MODELPARAM_VALUE.FP_OUT_CHANNELS}
}
