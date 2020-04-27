proc build {project_name project_path} {

  set project_src "${project_path}/${project_name}.xpr"
  
  if { ! [ file exists "${project_src}" ] } {
    error "Vivado project (${project_src}) not found."
  }

  open_project "${project_path}/${project_name}.xpr"

  # Run synthesis
  reset_run "synth_1"
  launch_runs "synth_1" -jobs 4
  wait_on_run "synth_1"
  launch_runs "impl_1" -jobs 4 -to_step write_bitstream
  wait_on_run "impl_1"
  puts "OpenEVR bitstream generated!"
}

if { $::argc < 2 } {
    puts "$::argv0: <project_name> <project_path>"
    exit -1
}

set project_name [lindex $::argv 0]
set project_path [lindex $::argv 1]

build ${project_name} ${project_path}

