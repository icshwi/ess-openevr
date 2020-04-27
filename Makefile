################################################################################
#
# Makefile for the ESS openEVR project
# --------------------------------------
#
################################################################################

# Debug Flag: Vivado verbose mode and reports
DEBUG ?= 0

# Configuration files path
SRC_PATH=fpga/srcs
# Scripts path
SCRIPT_DIR=$(SRC_PATH)/script
# Main configuration file path
CONFIG_NAME=$(SCRIPT_DIR)/project.options


# Configuration file parsing
BUILD_DIR          := $(shell grep -e 'directory.build'  $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
SRC_ROOT           := $(shell grep -e 'directory.src'    $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
OUTPUT_DIR         := $(shell grep -e 'directory.output' $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
LOG_DIR            := $(shell grep -e 'directory.log'    $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
PROJECT_NAME       := $(shell grep -e 'project.name'     $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
PROJECT_DIR        := $(shell grep -e 'project.dir'      $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
HDL_FILES_FILENAME := $(shell grep -e 'files.hdl'        $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
XDC_FILES_FILENAME := $(shell grep -e 'files.xdc'        $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
TCL_FILES_FILENAME := $(shell grep -e 'files.tcl'        $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
PROJECT_TCL        := $(shell grep -e 'project.tcl'      $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
DOC_OUTDIR         := $(shell grep -e 'doc.output.html'  $(CONFIG_NAME) | sed 's/[^:]*:\s*//')
DOC_SOURCES        := $(shell grep -e 'directory.doc'    $(CONFIG_NAME) | sed 's/[^:]*:\s*//')

# create lists of files to be used in targets
#IP_FILES          := $(strip $(shell cat $(IP_FILES_FILENAME)))
#HDL_FILES         := $(strip $(shell cat $(HDL_FILES_FILENAME) | awk '// {printf("%s/%s ","$(SRC_ROOT)",$$0) }'))
#XDC_FILES         := $(strip $(shell cat $(XDC_FILES_FILENAME) | awk '// {printf("%s/%s ","$(SRC_ROOT)",$$0) }'))

# Common environment variables
ifeq ($(DEBUG), 0)
VIVADO_OPTS:=-mode batch -nojournal -nolog -m64 -notrace
else
VIVADO_OPTS:=-mode batch -m64
endif

# Arguments for the Vivado mode batch
TCLARGS := --name $(PROJECT_NAME) --% --debug $(DEBUG) --import-dcp $(IMPORT_PRODUCTS) 2>&1 | tee  $(LOG_DIR)/%.log

# Targets
.PHONY: all clean project

all: bitstream

project: $(PROJECT_DIR)/$(PROJECT_NAME).xpr
doc: $(OUTPUT_DIR)/$(DOC_OUTDIR)/index.html


# Vivado workflow steps

#project file generation.
$(PROJECT_DIR)/$(PROJECT_NAME).xpr: $(TCL_FILES_FILENAME)/$(PROJECT_TCL)
	@echo "\033[1;92mBuilding: $@\033[0m"
	@mkdir -p $(LOG_DIR)
	@vivado $(VIVADO_OPTS) -source $^ 2>&1 | tee $(LOG_DIR)/project.log
ifeq ($(SO), LINUX)
	@! grep -e '^ERROR' $(LOG_DIR)/project.log
endif

# Documentation rules

$(OUTPUT_DIR)/$(DOC_OUTDIR)/index.html: $(DOC_SOURCES)/Doxyfile
	@echo "\033[1;92mBuilding: $@\033[0m"
	@mkdir -p $(LOG_DIR)
	@mkdir -p $(OUTPUT_DIR)/$(DOC_OUTDIR) 
	@doxygen $^ 2>&1 | tee $(LOG_DIR)/doc.log

clean:
	@echo "\033[1;92mDeleting all generated files\033[0m"
	@rm -rf $(OUTPUT_DIR)
	@rm -rf $(LOG_DIR)
	@rm -f *.jou
	@rm -f *.log
	@rm -f *.dmp
	@rm -f *.os
	@rm -f *.html
	@rm -f *.str
	@rm -rf $(PROJECT_DIR)
	@rm -rf `find . -maxdepth 2 -type d -name '.Xil'`

clean_project:
	@echo "\033[1;92mDeleting project files\033[0m"
	rm -rf $(PROJECT_DIR)
	rm -rf `find . -maxdepth 4 -type d -name '.Xil'`


