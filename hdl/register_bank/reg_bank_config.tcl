set libname "reg_bank"
set pkg_dir "../packages"

set_property target_language VHDL [current_project]
add_files -norecurse -scan_for_includes {
register_bank_axi.vhdl 
field_core.vhdl 
axi_write_ctrl.vhdl 
register_bank_shadowing.vhdl 
register_bank_core.vhdl 
register_bank_rd_encoder.vhdl 
axi_read_ctrl.vhdl 
register_bank_address_decoder.vhdl 
register_bank_rd_interface.vhdl 
register_bank_wr_interface.vhdl 
register_bank.vhdl
../packages/register_bank_config_pkg.vhdl 
../packages/register_bank_components_pkg.vhdl 
../packages/register_bank_functions_pkg.vhdl 
}
set_property file_type {VHDL 2008} [get_files  {axi_write_ctrl.vhdl axi_read_ctrl.vhdl}]

set_property library $libname [get_files { "../packages/register_bank_functions_pkg.vhdl" "../packagaes/register_bank_components_pkg.vhdl" "../packages/register_bank_config_pkg.vhdl" }]

add_files -norecurse { "../packages/axi4_pkg.vhdl" }
set_property library essffw [get_files { "../packages/axi4_pkg.vhdl" } ]

update_compile_order -fileset sources_1

