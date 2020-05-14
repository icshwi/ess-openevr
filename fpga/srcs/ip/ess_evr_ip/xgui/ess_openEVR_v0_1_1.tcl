# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  set g_DEBUG_WIDTH [ipgui::add_param $IPINST -name "g_DEBUG_WIDTH"]
  set_property tooltip {Width of the debug port} ${g_DEBUG_WIDTH}

}

proc update_PARAM_VALUE.g_DEBUG_WIDTH { PARAM_VALUE.g_DEBUG_WIDTH } {
	# Procedure called to update g_DEBUG_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_DEBUG_WIDTH { PARAM_VALUE.g_DEBUG_WIDTH } {
	# Procedure called to validate g_DEBUG_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.g_DEBUG_WIDTH { MODELPARAM_VALUE.g_DEBUG_WIDTH PARAM_VALUE.g_DEBUG_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_DEBUG_WIDTH}] ${MODELPARAM_VALUE.g_DEBUG_WIDTH}
}

