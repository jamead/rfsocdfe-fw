#Clock                  Frequency	Status
#clk104_pl_clk_p	     83.28 MHz	Correct
#clk_out1_pl_clk_pll	 416.4 MHz	Correct
#clk_pl_0	             100 MHz	Correct
#clk_pl_1	             200 MHz	Correct
#RFADC0_CLK-RFADC3_CLK	 156.15 MHz	Expected RFdc internal clocks
#RFDAC0_CLK-RFDAC3_CLK	 124.92 MHz	Expected RFdc internal clocks


set_clock_groups -name clkpl0_2_rfadcclk -asynchronous \
    -group [get_clocks clk_pl_0] \
    -group [get_clocks clk_out1_pl_clk_pll]

set_clock_groups -name clkpl0_2_rfdacclk -asynchronous \
    -group [get_clocks clk_pl_0] \
    -group [get_clocks RFDAC0_CLK]


# ------------------------------------------------------------
# Asynchronous clock domains
# ------------------------------------------------------------

# PS 200 MHz clock vs RFADC 416.4 MHz clock
set_clock_groups -name ps200_rfadc_async -asynchronous \
    -group [get_clocks clk_pl_1] \
    -group [get_clocks clk_out1_pl_clk_pll]

# EVR 125 MHz clock vs RFADC 416.4 MHz clock
set_clock_groups -name evr_rfadc_async -asynchronous \
    -group [get_clocks {rxoutclk_out[0]}] \
    -group [get_clocks clk_out1_pl_clk_pll]



# clock measurement false paths
set_false_path -from [get_pins -filter REF_PIN_NAME==C -of_objects [get_cells -hierarchical -filter {NAME =~ */inst_sync_*/s_req_reg*}]] -to [get_pins -filter REF_PIN_NAME==D -of_objects [get_cells -hierarchical -filter {NAME =~ */inst_sync_*/p_reg*}]]
set_false_path -from [get_pins -filter REF_PIN_NAME==C -of_objects [get_cells -hierarchical -filter {NAME =~ */inst_sync_*/inst_req_sync/p_reg*}]] -to [get_pins -filter REF_PIN_NAME==D -of_objects [get_cells -hierarchical -filter {NAME =~ */inst_sync_*/inst_ack_sync/p_reg*}]]
set_max_delay -datapath_only -from [get_pins -filter REF_PIN_NAME==C -of_objects [get_cells -hierarchical -filter {NAME =~ */latch_count_reg*}]] -to [get_pins -filter REF_PIN_NAME==D -of_objects [get_cells -hierarchical -filter {NAME =~ */freq_reg_reg*}]] 10.000









