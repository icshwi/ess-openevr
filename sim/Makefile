################################################################################
#
# Makefile for Vivado simulation projects
# -------------------------------- 
#
################################################################################

# Directories
TOP    := $(PWD)
OUTDIR := $(TOP)/output

tb ?= bram_controller_tb

# Variables
project_dir  := $(OUTDIR)/$(tb)
project_file := $(project_dir)/$(tb).xpr
project_srcs := $(TOP)/$(tb)
project_tcl  := $(project_srcs)/$(tb).tcl
sim_dir      := $(OUTDIR)/$(tb)_sim
vhdl_prj     := $(project_srcs)/$(tb)_vhdl.prj
compile_log  := $(sim_dir)/compile.log
elab_log     := $(sim_dir)/elaborate.log
sim_log      := $(sim_dir)/simulation.log
wave_db      := $(sim_dir)/$(tb).wbd
wave_cfg     := $(project_srcs)/srcs/$(tb)_behav.wcfg
tcl_sim_cmd  := $(TOP)/scripts/sim.tcl

project:	$(project_file)
compile:    $(compile_log)
elab   :    $(elab_log)
sim    :    $(sim_log)

.PHONY: clean wave
.DEFAULT_GOAL := sim

$(compile_log): 
	@echo -e "\033[1;92mCompiling simulation: $@\033[0m"
	@mkdir -p $(sim_dir)
	@xvhdl --relax -prj $(vhdl_prj) --work aaa 2>&1 | tee $(compile_log)
    
$(elab_log) : $(compile_log)
	@echo -e "\033[1;92mElaborating simulation: $@\033[0m"
	@xelab --relax --debug typical --mt auto -L xil_defaultlib -L work -L secureip -L xpm --snapshot $(tb) work.$(tb) -log $(elab_log)

$(sim_log): $(elab_log)
	@echo -e "\033[1;92mRunning simulation: $@\033[0m"
	@xsim $(tb) -key {Behavioral:sim_1:Functional:$(tb)} --runall --wdb $(wave_db) --log $(sim_log)
    
wave: $(elab_log)
	@echo -e "\033[1;92mRunning graphical simulation: $@\033[0m"
	@xsim $(tb) -key {Behavioral:sim_1:Functional:$(tb)} --tclbatch $(tcl_sim_cmd) --wdb $(wave_db) --gui --view $(wave_cfg) --onfinish stop --log $(sim_log)

$(project_file): $(project_tcl)
	@echo -e "\033[1;92mCreating simulation project: $@\033[0m"
	@mkdir -p $(project_dir)
	@vivado -mode batch -m64 -source $(project_tcl) -tclarg --origin_dir $(project_srcs) --output_dir $(OUTDIR)

clean:
	@echo -e "\033[1;92mDeleting all generated files from $(project_dir)\033[0m"
	@rm -rf $(sim_dir)
	@rm -rf $(project_dir)
	@rm -rf $(TOP)/*.log 
	@rm -rf $(TOP)/*.jou
	@rm -rf xsim.dir
	@rm -rf *.pb
