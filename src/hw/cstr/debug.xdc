create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list system_i/zynq_ultra_ps_e_0/U0/pl_clk0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {rfadc_fifos/adc0_fifo/adc_trig_sr[0]} {rfadc_fifos/adc0_fifo/adc_trig_sr[1]} {rfadc_fifos/adc0_fifo/adc_trig_sr[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[0]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[1]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[2]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[3]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[4]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[5]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[6]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[7]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[8]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[9]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[10]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[11]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[12]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[13]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[14]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {rfadc_fifos/adc0_fifo/sample_num[0]} {rfadc_fifos/adc0_fifo/sample_num[1]} {rfadc_fifos/adc0_fifo/sample_num[2]} {rfadc_fifos/adc0_fifo/sample_num[3]} {rfadc_fifos/adc0_fifo/sample_num[4]} {rfadc_fifos/adc0_fifo/sample_num[5]} {rfadc_fifos/adc0_fifo/sample_num[6]} {rfadc_fifos/adc0_fifo/sample_num[7]} {rfadc_fifos/adc0_fifo/sample_num[8]} {rfadc_fifos/adc0_fifo/sample_num[9]} {rfadc_fifos/adc0_fifo/sample_num[10]} {rfadc_fifos/adc0_fifo/sample_num[11]} {rfadc_fifos/adc0_fifo/sample_num[12]} {rfadc_fifos/adc0_fifo/sample_num[13]} {rfadc_fifos/adc0_fifo/sample_num[14]} {rfadc_fifos/adc0_fifo/sample_num[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 2 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {rfadc_fifos/adc0_fifo/state[0]} {rfadc_fifos/adc0_fifo/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list tbt_gen/tbt_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list rfadc_fifos/evr_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list rfadc_fifos/dac_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {rfadc_fifos/reg_i[wrdone]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list rfadc_fifos/adc0_fifo/fifo_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list rfadc_fifos/adc0_fifo/fifo_rdstr_prev]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list rfadc_fifos/adc0_fifo/fifo_rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list rfadc_fifos/adc0_fifo/fifo_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list rfadc_fifos/soft_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {rfadc_fifos/reg_o[softtrig]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list rfadc_fifos/adc0_fifo/fifo_rdstr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {rfadc_fifos/reg_o[rst]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list rfadc_fifos/adc0_fifo/fifo_rdstr_fe]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {rfadc_fifos/reg_o[rdoutdone]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list rfadc_fifos/adc0_fifo/adc_trig_s]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets dbg_OBUF[0]]
