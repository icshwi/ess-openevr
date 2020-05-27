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

DOC_OUTDIR         := doc/html
DOC_SOURCES        := doc/Doxyfile

# Targets
.PHONY: all clean opendoc

all: doc opendoc

doc: $(DOC_OUTDIR)/index.html


# Documentation rules

$(DOC_OUTDIR)/index.html: $(DOC_SOURCES)
	@echo "\033[1;92mBuilding: $@\033[0m"
	@mkdir -p $(DOC_OUTDIR)
	@doxygen $^

opendoc: $(DOC_OUTDIR)/index.html
	nohup firefox $(DOC_OUTDIR)/index.html

clean:
	@echo "\033[1;92mDeleting all generated files\033[0m"
	@rm -rf $(DOC_OUTDIR)


