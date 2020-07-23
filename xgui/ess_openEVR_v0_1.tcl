# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  set g_DEBUG_WIDTH [ipgui::add_param $IPINST -name "g_DEBUG_WIDTH"]
  set_property tooltip {Width of the debug port} ${g_DEBUG_WIDTH}
  set g_HAS_DEBUG_CLK [ipgui::add_param $IPINST -name "g_HAS_DEBUG_CLK"]
  set_property tooltip {Useful to drive ILAs and debug logic} ${g_HAS_DEBUG_CLK}

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

proc update_PARAM_VALUE.g_DEBUG_WIDTH { PARAM_VALUE.g_DEBUG_WIDTH } {
	# Procedure called to update g_DEBUG_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_DEBUG_WIDTH { PARAM_VALUE.g_DEBUG_WIDTH } {
	# Procedure called to validate g_DEBUG_WIDTH
	return true
}

proc update_PARAM_VALUE.g_HAS_DEBUG_CLK { PARAM_VALUE.g_HAS_DEBUG_CLK } {
	# Procedure called to update g_HAS_DEBUG_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_HAS_DEBUG_CLK { PARAM_VALUE.g_HAS_DEBUG_CLK } {
	# Procedure called to validate g_HAS_DEBUG_CLK
	return true
}


proc update_MODELPARAM_VALUE.g_DEBUG_WIDTH { MODELPARAM_VALUE.g_DEBUG_WIDTH PARAM_VALUE.g_DEBUG_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_DEBUG_WIDTH}] ${MODELPARAM_VALUE.g_DEBUG_WIDTH}
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

