# =============================================================================
# @file   ess_evr.xdc
# @brief  Top constraint file for the ESS openEVR in standalone mode
# -----------------------------------------------------------------------------
# @author Felipe Torres González <felipe.torresgonzalez@ess.eu>
# @company European Spallation Source ERIC
# @date 20200424
# 
# Platform:       picoZED 7030
# Carrier board:  Tallinn picoZED carrier board (aka FPGA-based IOC) rev. B
# Based on the AVNET xdc file for the picozed 7z030 RevC v2
# =============================================================================

create_clock -period 11.2 -name clk_mgt [get_ports i_ZYNQ_CLKREF0_N];
create_clock -period 11.2 -name clk_sys [get_ports i_ZYNQ_MRCC_LVDS_N];