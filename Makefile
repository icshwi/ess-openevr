################################################################################
#
# Makefile for the ESS openEVR project
# --------------------------------------
#
################################################################################

# Debug Flag: Vivado verbose mode and reports
DEBUG ?= 1

# Configuration files path
SRC_PATH=fpga/srcs

DOC_OUTDIR    := doc/html
DOXYGEN_FILE  := doc/Doxyfile
DOC_SOURCES   := $(wildcard hdl/*.vhd) README.md

# VHDL simulation

GHDL = ghdl-gcc
GHDLFLAGS = --workdir=build/

WAVE_VIEWER = gtkwave

SRC_EXT = .vhd

SRC_PATH = hdl
TB_PATH = $(SRC_PATH)/testbenches
SOURCES = $(SRC_PATH)/packages/sizing.vhd \
          $(SRC_PATH)/packages/evr_pkg.vhd \
          $(SRC_PATH)/heartbeat_mon.vhd \
          $(TB_PATH)/heartbeat_mon_tb.vhd \
          $(SRC_PATH)/packages/register_bank_config_pkg.vhdl \
          $(SRC_PATH)/interrupt_ctrl.vhd \
          $(TB_PATH)/interrupt_tb.vhd

TB1 = heartbeat_mon_tb
TB3 = interrupt_tb

TESTBENCHES = $(TB1) $(TB3)

# Targets
.PHONY: all clean opendoc run_sim $(TESTBENCHES)

all: doc opendoc

doc: $(DOC_OUTDIR)/index.html

# Canned recipes

define DO_ELAB
    @echo "\033[1;92mElaborating: $1 \033[0m"
	$(GHDL) -m $(GHDLFLAGS) $1
    @echo ""
endef

define DO_TB
    @echo "\033[1;92mSimulating: $1 \033[0m"
	$(GHDL) -r $1 --vcd=build/$1.vcd
	$(WAVE_VIEWER) build/$1.vcd waves/wavecfg_$1.gtkw
    @echo ""
endef

# Documentation rules

$(DOC_OUTDIR)/index.html: $(DOXYGEN_FILE) $(DOC_SOURCES)
	@echo "\033[1;92mBuilding: $@\033[0m"
	@mkdir -p $(DOC_OUTDIR)
	@doxygen $<

opendoc: $(DOC_OUTDIR)/index.html
	nohup firefox $(DOC_OUTDIR)/index.html >> /dev/null

# VHDL simulation rules

elab-all: $(TESTBENCHES)

## Run elaborate recipe for testbench number (denoted by %)
run-elab%: obj
	$(call DO_ELAB,$(TB$*))

## Run elaborate recipe for ALL testbenches in $(TESTBENCH) list
$(TESTBENCHES): obj
	$(call DO_ELAB,$@)

## Run simluation for ALL testbenches in $(TESTBENCH) list
run_sim: elab-all
	$(foreach var,$(TESTBENCHES),./$(var);)

## Run full testbench for testbench number (denoted by %)
## Call elaboration recipe as dependency
tb%: run-elab%
	$(call DO_TB,$(TB$*))

## Recipe to create output directory, if not already created
## and import sources.
obj: $(SOURCES)
	@mkdir -p build
	$(GHDL) -i $(GHDLFLAGS) $^

clean:
	@echo "\033[1;92mDeleting all generated files\033[0m"
	@rm -rf $(DOC_OUTDIR)
	@rm -rf build/
	@rm -f $(TESTBENCHES)
	@rm -f *.o
	@rm -f $(SRC_PATH)/*.o
	@rm -f $(SRC_PATH)/*.vcd
