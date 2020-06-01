# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set AXI-Lite_Parameters [ipgui::add_group $IPINST -name "AXI-Lite Parameters" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "AXI_ADDR_WIDTH" -parent ${AXI-Lite_Parameters}
  ipgui::add_param $IPINST -name "AXI_WSTRB_WIDTH" -parent ${AXI-Lite_Parameters}
  ipgui::add_param $IPINST -name "REGISTER_WIDTH" -parent ${AXI-Lite_Parameters}
  ipgui::add_param $IPINST -name "AXI_DATA_WIDTH" -parent ${AXI-Lite_Parameters}
  ipgui::add_param $IPINST -name "REG_ADDR_WIDTH" -parent ${AXI-Lite_Parameters}

  #Adding Group
  set Debug_Parameters [ipgui::add_group $IPINST -name "Debug Parameters" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "g_DEBUG_WIDTH" -parent ${Debug_Parameters}
  ipgui::add_param $IPINST -name "g_HAS_DEBUG_CLK" -parent ${Debug_Parameters}



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

