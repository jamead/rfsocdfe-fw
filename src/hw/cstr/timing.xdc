


set_clock_groups -name clkpl0_2_rfadcclk -asynchronous -group [get_clocks clk_pl_0] -group [get_clocks -of_objects [get_pins axisclk_adc/inst/mmcme4_adv_inst/CLKOUT0]]

set_clock_groups -name clkpl0_2_rfdacclk -asynchronous -group [get_clocks clk_pl_0] -group [get_clocks RFDAC0_CLK]


# clock measurement false paths
set_false_path -from [get_pins -filter REF_PIN_NAME==C -of_objects [get_cells -hierarchical -filter {NAME =~ */inst_sync_*/s_req_reg*}]] -to [get_pins -filter REF_PIN_NAME==D -of_objects [get_cells -hierarchical -filter {NAME =~ */inst_sync_*/p_reg*}]]
set_false_path -from [get_pins -filter REF_PIN_NAME==C -of_objects [get_cells -hierarchical -filter {NAME =~ */inst_sync_*/inst_req_sync/p_reg*}]] -to [get_pins -filter REF_PIN_NAME==D -of_objects [get_cells -hierarchical -filter {NAME =~ */inst_sync_*/inst_ack_sync/p_reg*}]]
set_max_delay -datapath_only -from [get_pins -filter REF_PIN_NAME==C -of_objects [get_cells -hierarchical -filter {NAME =~ */latch_count_reg*}]] -to [get_pins -filter REF_PIN_NAME==D -of_objects [get_cells -hierarchical -filter {NAME =~ */freq_reg_reg*}]] 10.000




