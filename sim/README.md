# Vivado Simulation Projects

This subdirectory contains the sources and infrastructure to create and run HDL simulations, when the simulation relies on Xilinx IP and simulation libraries, i.e., simulating the Block Memory Controller IP (BRAM).

The Makefile has the following targets:

 * **compile** - Compile (analyse) the source VHDL files to check for syntax and semantical errors
 * **elab**    - Elaborate in preparation for simulation. Depends on the *compile* target
 * **sim**     - Run the simulation. Depends on the *elab* target
 * **wave**    - Run the simulation and display the resulting waveform. Depends on the *elab* target
 * **project** - Generate a Vivado simulation project for a given testbench - useful when making changes to a testbench file.  
 The generated project will be located at *output/\<test_bench_name\>/\<test_bench_name\>.xpr*  

To run any of the targets you must provide a testbench name, i.e. *bram_controller_tb*:
    
    $ make <target> tb=<component_testbench_name>

For example, to run the simulation target for the bram_controller_tb testbench, you would call:

    $ make sim tb=bram_controller_tb

The defaults for the Makefile are currently:

 * **target** := sim
 * **tb** := bram_controller_tb

