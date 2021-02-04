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
.PHONY: all clean opendoc run_sim

all: doc opendoc

doc: $(DOC_OUTDIR)/index.html


# Documentation rules

$(DOC_OUTDIR)/index.html: $(DOXYGEN_FILE) $(DOC_SOURCES)
	@echo "\033[1;92mBuilding: $@\033[0m"
	@mkdir -p $(DOC_OUTDIR)
	@doxygen $<

opendoc: $(DOC_OUTDIR)/index.html
	nohup firefox $(DOC_OUTDIR)/index.html >> /dev/null

# VHDL simulation rules

run_sim: elab1
	$(foreach var,$(TESTBENCHES),./$(var);)

tb1: elab1
	$(GHDL) -r $(TB1) --vcd=build/$(TB1).vcd
	$(WAVE_VIEWER) build/$(TB1).vcd waves/wavecfg_$(TB1).gtkw

tb3: elab1
	$(GHDL) -r $(TB3) --vcd=build/$(TB3).vcd
	$(WAVE_VIEWER) build/$(TB3).vcd waves/wavecfg_$(TB3).gtkw

elab1: obj
	$(GHDL) -m $(GHDLFLAGS) $(TB1)

elab3: obj
	$(GHDL) -m $(GHDLFLAGS) $(TB3)

obj: $(SOURCES)
	@mkdir -p build
	$(GHDL) -i $(GHDLFLAGS) $^

clean:
	@echo "\033[1;92mDeleting all generated files\033[0m"
	@rm -rf $(DOC_OUTDIR)
	@rm -rf build/
	@rm -f $(TB1)
	@rm -f $(TB3)
	@rm -f *.o
	@rm -f $(SRC_PATH)/*.o
	@rm -f $(SRC_PATH)/*.vcd
