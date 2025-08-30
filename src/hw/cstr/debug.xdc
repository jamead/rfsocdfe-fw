

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
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {ps_pl/reg_o[cha_gain][data][data][0]} {ps_pl/reg_o[cha_gain][data][data][1]} {ps_pl/reg_o[cha_gain][data][data][2]} {ps_pl/reg_o[cha_gain][data][data][3]} {ps_pl/reg_o[cha_gain][data][data][4]} {ps_pl/reg_o[cha_gain][data][data][5]} {ps_pl/reg_o[cha_gain][data][data][6]} {ps_pl/reg_o[cha_gain][data][data][7]} {ps_pl/reg_o[cha_gain][data][data][8]} {ps_pl/reg_o[cha_gain][data][data][9]} {ps_pl/reg_o[cha_gain][data][data][10]} {ps_pl/reg_o[cha_gain][data][data][11]} {ps_pl/reg_o[cha_gain][data][data][12]} {ps_pl/reg_o[cha_gain][data][data][13]} {ps_pl/reg_o[cha_gain][data][data][14]} {ps_pl/reg_o[cha_gain][data][data][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {ps_pl/reg_o[chb_gain][data][data][0]} {ps_pl/reg_o[chb_gain][data][data][1]} {ps_pl/reg_o[chb_gain][data][data][2]} {ps_pl/reg_o[chb_gain][data][data][3]} {ps_pl/reg_o[chb_gain][data][data][4]} {ps_pl/reg_o[chb_gain][data][data][5]} {ps_pl/reg_o[chb_gain][data][data][6]} {ps_pl/reg_o[chb_gain][data][data][7]} {ps_pl/reg_o[chb_gain][data][data][8]} {ps_pl/reg_o[chb_gain][data][data][9]} {ps_pl/reg_o[chb_gain][data][data][10]} {ps_pl/reg_o[chb_gain][data][data][11]} {ps_pl/reg_o[chb_gain][data][data][12]} {ps_pl/reg_o[chb_gain][data][data][13]} {ps_pl/reg_o[chb_gain][data][data][14]} {ps_pl/reg_o[chb_gain][data][data][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {ps_pl/reg_o[chc_gain][data][data][0]} {ps_pl/reg_o[chc_gain][data][data][1]} {ps_pl/reg_o[chc_gain][data][data][2]} {ps_pl/reg_o[chc_gain][data][data][3]} {ps_pl/reg_o[chc_gain][data][data][4]} {ps_pl/reg_o[chc_gain][data][data][5]} {ps_pl/reg_o[chc_gain][data][data][6]} {ps_pl/reg_o[chc_gain][data][data][7]} {ps_pl/reg_o[chc_gain][data][data][8]} {ps_pl/reg_o[chc_gain][data][data][9]} {ps_pl/reg_o[chc_gain][data][data][10]} {ps_pl/reg_o[chc_gain][data][data][11]} {ps_pl/reg_o[chc_gain][data][data][12]} {ps_pl/reg_o[chc_gain][data][data][13]} {ps_pl/reg_o[chc_gain][data][data][14]} {ps_pl/reg_o[chc_gain][data][data][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 16 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {ps_pl/reg_o[chd_gain][data][data][0]} {ps_pl/reg_o[chd_gain][data][data][1]} {ps_pl/reg_o[chd_gain][data][data][2]} {ps_pl/reg_o[chd_gain][data][data][3]} {ps_pl/reg_o[chd_gain][data][data][4]} {ps_pl/reg_o[chd_gain][data][data][5]} {ps_pl/reg_o[chd_gain][data][data][6]} {ps_pl/reg_o[chd_gain][data][data][7]} {ps_pl/reg_o[chd_gain][data][data][8]} {ps_pl/reg_o[chd_gain][data][data][9]} {ps_pl/reg_o[chd_gain][data][data][10]} {ps_pl/reg_o[chd_gain][data][data][11]} {ps_pl/reg_o[chd_gain][data][data][12]} {ps_pl/reg_o[chd_gain][data][data][13]} {ps_pl/reg_o[chd_gain][data][data][14]} {ps_pl/reg_o[chd_gain][data][data][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 18 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[0]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[1]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[2]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[3]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[4]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[5]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[6]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[7]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[8]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[9]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[10]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[11]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[12]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[13]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[14]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[15]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[16]} {rfadc_fifos/adc0_fifo/fifo_rd_data_cnt[17]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {rfadc_fifos/reg_i[adc0_dout][0]} {rfadc_fifos/reg_i[adc0_dout][1]} {rfadc_fifos/reg_i[adc0_dout][2]} {rfadc_fifos/reg_i[adc0_dout][3]} {rfadc_fifos/reg_i[adc0_dout][4]} {rfadc_fifos/reg_i[adc0_dout][5]} {rfadc_fifos/reg_i[adc0_dout][6]} {rfadc_fifos/reg_i[adc0_dout][7]} {rfadc_fifos/reg_i[adc0_dout][8]} {rfadc_fifos/reg_i[adc0_dout][9]} {rfadc_fifos/reg_i[adc0_dout][10]} {rfadc_fifos/reg_i[adc0_dout][11]} {rfadc_fifos/reg_i[adc0_dout][12]} {rfadc_fifos/reg_i[adc0_dout][13]} {rfadc_fifos/reg_i[adc0_dout][14]} {rfadc_fifos/reg_i[adc0_dout][15]} {rfadc_fifos/reg_i[adc0_dout][16]} {rfadc_fifos/reg_i[adc0_dout][17]} {rfadc_fifos/reg_i[adc0_dout][18]} {rfadc_fifos/reg_i[adc0_dout][19]} {rfadc_fifos/reg_i[adc0_dout][20]} {rfadc_fifos/reg_i[adc0_dout][21]} {rfadc_fifos/reg_i[adc0_dout][22]} {rfadc_fifos/reg_i[adc0_dout][23]} {rfadc_fifos/reg_i[adc0_dout][24]} {rfadc_fifos/reg_i[adc0_dout][25]} {rfadc_fifos/reg_i[adc0_dout][26]} {rfadc_fifos/reg_i[adc0_dout][27]} {rfadc_fifos/reg_i[adc0_dout][28]} {rfadc_fifos/reg_i[adc0_dout][29]} {rfadc_fifos/reg_i[adc0_dout][30]} {rfadc_fifos/reg_i[adc0_dout][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {rfadc_fifos/reg_i[adc0_rdcnt][0]} {rfadc_fifos/reg_i[adc0_rdcnt][1]} {rfadc_fifos/reg_i[adc0_rdcnt][2]} {rfadc_fifos/reg_i[adc0_rdcnt][3]} {rfadc_fifos/reg_i[adc0_rdcnt][4]} {rfadc_fifos/reg_i[adc0_rdcnt][5]} {rfadc_fifos/reg_i[adc0_rdcnt][6]} {rfadc_fifos/reg_i[adc0_rdcnt][7]} {rfadc_fifos/reg_i[adc0_rdcnt][8]} {rfadc_fifos/reg_i[adc0_rdcnt][9]} {rfadc_fifos/reg_i[adc0_rdcnt][10]} {rfadc_fifos/reg_i[adc0_rdcnt][11]} {rfadc_fifos/reg_i[adc0_rdcnt][12]} {rfadc_fifos/reg_i[adc0_rdcnt][13]} {rfadc_fifos/reg_i[adc0_rdcnt][14]} {rfadc_fifos/reg_i[adc0_rdcnt][15]} {rfadc_fifos/reg_i[adc0_rdcnt][16]} {rfadc_fifos/reg_i[adc0_rdcnt][17]} {rfadc_fifos/reg_i[adc0_rdcnt][18]} {rfadc_fifos/reg_i[adc0_rdcnt][19]} {rfadc_fifos/reg_i[adc0_rdcnt][20]} {rfadc_fifos/reg_i[adc0_rdcnt][21]} {rfadc_fifos/reg_i[adc0_rdcnt][22]} {rfadc_fifos/reg_i[adc0_rdcnt][23]} {rfadc_fifos/reg_i[adc0_rdcnt][24]} {rfadc_fifos/reg_i[adc0_rdcnt][25]} {rfadc_fifos/reg_i[adc0_rdcnt][26]} {rfadc_fifos/reg_i[adc0_rdcnt][27]} {rfadc_fifos/reg_i[adc0_rdcnt][28]} {rfadc_fifos/reg_i[adc0_rdcnt][29]} {rfadc_fifos/reg_i[adc0_rdcnt][30]} {rfadc_fifos/reg_i[adc0_rdcnt][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {ps_pl/reg_o[rfadc0fifo_dout][data][swacc]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {ps_pl/reg_o[rfadc1fifo_dout][data][swacc]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {ps_pl/reg_o[rfadc2fifo_dout][data][swacc]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {ps_pl/reg_o[rfadcfifo_trig][data][swacc]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {ps_pl/reg_o[rfadc3fifo_dout][data][swacc]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {rfadc_fifos/reg_o[enb]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {rfadc_fifos/reg_o[rst]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {rfadc_fifos/reg_o[adc0_rdstr]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {ps_pl/reg_o[rfadcfifo_trig][data][data]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {ps_pl/reg_o[rfadcfifo_trig][data][swmod]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {ps_pl/reg_o[rfadcfifo_reset][data][data]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list rfadc_fifos/adc0_fifo/fifo_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list rfadc_fifos/adc0_fifo/fifo_rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list rfadc_fifos/adc0_fifo/fifo_rdstr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {ps_pl/reg_o[rfadcfifo_reset][data][swmod]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {ps_pl/reg_o[rfadcfifo_reset][data][swacc]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list rfadc_fifos/adc0_fifo/sys_rst]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list {dbg_OBUF[6]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 192 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {rfadc_fifos/adc0_fifo/adc_data[0]} {rfadc_fifos/adc0_fifo/adc_data[1]} {rfadc_fifos/adc0_fifo/adc_data[2]} {rfadc_fifos/adc0_fifo/adc_data[3]} {rfadc_fifos/adc0_fifo/adc_data[4]} {rfadc_fifos/adc0_fifo/adc_data[5]} {rfadc_fifos/adc0_fifo/adc_data[6]} {rfadc_fifos/adc0_fifo/adc_data[7]} {rfadc_fifos/adc0_fifo/adc_data[8]} {rfadc_fifos/adc0_fifo/adc_data[9]} {rfadc_fifos/adc0_fifo/adc_data[10]} {rfadc_fifos/adc0_fifo/adc_data[11]} {rfadc_fifos/adc0_fifo/adc_data[12]} {rfadc_fifos/adc0_fifo/adc_data[13]} {rfadc_fifos/adc0_fifo/adc_data[14]} {rfadc_fifos/adc0_fifo/adc_data[15]} {rfadc_fifos/adc0_fifo/adc_data[16]} {rfadc_fifos/adc0_fifo/adc_data[17]} {rfadc_fifos/adc0_fifo/adc_data[18]} {rfadc_fifos/adc0_fifo/adc_data[19]} {rfadc_fifos/adc0_fifo/adc_data[20]} {rfadc_fifos/adc0_fifo/adc_data[21]} {rfadc_fifos/adc0_fifo/adc_data[22]} {rfadc_fifos/adc0_fifo/adc_data[23]} {rfadc_fifos/adc0_fifo/adc_data[24]} {rfadc_fifos/adc0_fifo/adc_data[25]} {rfadc_fifos/adc0_fifo/adc_data[26]} {rfadc_fifos/adc0_fifo/adc_data[27]} {rfadc_fifos/adc0_fifo/adc_data[28]} {rfadc_fifos/adc0_fifo/adc_data[29]} {rfadc_fifos/adc0_fifo/adc_data[30]} {rfadc_fifos/adc0_fifo/adc_data[31]} {rfadc_fifos/adc0_fifo/adc_data[32]} {rfadc_fifos/adc0_fifo/adc_data[33]} {rfadc_fifos/adc0_fifo/adc_data[34]} {rfadc_fifos/adc0_fifo/adc_data[35]} {rfadc_fifos/adc0_fifo/adc_data[36]} {rfadc_fifos/adc0_fifo/adc_data[37]} {rfadc_fifos/adc0_fifo/adc_data[38]} {rfadc_fifos/adc0_fifo/adc_data[39]} {rfadc_fifos/adc0_fifo/adc_data[40]} {rfadc_fifos/adc0_fifo/adc_data[41]} {rfadc_fifos/adc0_fifo/adc_data[42]} {rfadc_fifos/adc0_fifo/adc_data[43]} {rfadc_fifos/adc0_fifo/adc_data[44]} {rfadc_fifos/adc0_fifo/adc_data[45]} {rfadc_fifos/adc0_fifo/adc_data[46]} {rfadc_fifos/adc0_fifo/adc_data[47]} {rfadc_fifos/adc0_fifo/adc_data[48]} {rfadc_fifos/adc0_fifo/adc_data[49]} {rfadc_fifos/adc0_fifo/adc_data[50]} {rfadc_fifos/adc0_fifo/adc_data[51]} {rfadc_fifos/adc0_fifo/adc_data[52]} {rfadc_fifos/adc0_fifo/adc_data[53]} {rfadc_fifos/adc0_fifo/adc_data[54]} {rfadc_fifos/adc0_fifo/adc_data[55]} {rfadc_fifos/adc0_fifo/adc_data[56]} {rfadc_fifos/adc0_fifo/adc_data[57]} {rfadc_fifos/adc0_fifo/adc_data[58]} {rfadc_fifos/adc0_fifo/adc_data[59]} {rfadc_fifos/adc0_fifo/adc_data[60]} {rfadc_fifos/adc0_fifo/adc_data[61]} {rfadc_fifos/adc0_fifo/adc_data[62]} {rfadc_fifos/adc0_fifo/adc_data[63]} {rfadc_fifos/adc0_fifo/adc_data[64]} {rfadc_fifos/adc0_fifo/adc_data[65]} {rfadc_fifos/adc0_fifo/adc_data[66]} {rfadc_fifos/adc0_fifo/adc_data[67]} {rfadc_fifos/adc0_fifo/adc_data[68]} {rfadc_fifos/adc0_fifo/adc_data[69]} {rfadc_fifos/adc0_fifo/adc_data[70]} {rfadc_fifos/adc0_fifo/adc_data[71]} {rfadc_fifos/adc0_fifo/adc_data[72]} {rfadc_fifos/adc0_fifo/adc_data[73]} {rfadc_fifos/adc0_fifo/adc_data[74]} {rfadc_fifos/adc0_fifo/adc_data[75]} {rfadc_fifos/adc0_fifo/adc_data[76]} {rfadc_fifos/adc0_fifo/adc_data[77]} {rfadc_fifos/adc0_fifo/adc_data[78]} {rfadc_fifos/adc0_fifo/adc_data[79]} {rfadc_fifos/adc0_fifo/adc_data[80]} {rfadc_fifos/adc0_fifo/adc_data[81]} {rfadc_fifos/adc0_fifo/adc_data[82]} {rfadc_fifos/adc0_fifo/adc_data[83]} {rfadc_fifos/adc0_fifo/adc_data[84]} {rfadc_fifos/adc0_fifo/adc_data[85]} {rfadc_fifos/adc0_fifo/adc_data[86]} {rfadc_fifos/adc0_fifo/adc_data[87]} {rfadc_fifos/adc0_fifo/adc_data[88]} {rfadc_fifos/adc0_fifo/adc_data[89]} {rfadc_fifos/adc0_fifo/adc_data[90]} {rfadc_fifos/adc0_fifo/adc_data[91]} {rfadc_fifos/adc0_fifo/adc_data[92]} {rfadc_fifos/adc0_fifo/adc_data[93]} {rfadc_fifos/adc0_fifo/adc_data[94]} {rfadc_fifos/adc0_fifo/adc_data[95]} {rfadc_fifos/adc0_fifo/adc_data[96]} {rfadc_fifos/adc0_fifo/adc_data[97]} {rfadc_fifos/adc0_fifo/adc_data[98]} {rfadc_fifos/adc0_fifo/adc_data[99]} {rfadc_fifos/adc0_fifo/adc_data[100]} {rfadc_fifos/adc0_fifo/adc_data[101]} {rfadc_fifos/adc0_fifo/adc_data[102]} {rfadc_fifos/adc0_fifo/adc_data[103]} {rfadc_fifos/adc0_fifo/adc_data[104]} {rfadc_fifos/adc0_fifo/adc_data[105]} {rfadc_fifos/adc0_fifo/adc_data[106]} {rfadc_fifos/adc0_fifo/adc_data[107]} {rfadc_fifos/adc0_fifo/adc_data[108]} {rfadc_fifos/adc0_fifo/adc_data[109]} {rfadc_fifos/adc0_fifo/adc_data[110]} {rfadc_fifos/adc0_fifo/adc_data[111]} {rfadc_fifos/adc0_fifo/adc_data[112]} {rfadc_fifos/adc0_fifo/adc_data[113]} {rfadc_fifos/adc0_fifo/adc_data[114]} {rfadc_fifos/adc0_fifo/adc_data[115]} {rfadc_fifos/adc0_fifo/adc_data[116]} {rfadc_fifos/adc0_fifo/adc_data[117]} {rfadc_fifos/adc0_fifo/adc_data[118]} {rfadc_fifos/adc0_fifo/adc_data[119]} {rfadc_fifos/adc0_fifo/adc_data[120]} {rfadc_fifos/adc0_fifo/adc_data[121]} {rfadc_fifos/adc0_fifo/adc_data[122]} {rfadc_fifos/adc0_fifo/adc_data[123]} {rfadc_fifos/adc0_fifo/adc_data[124]} {rfadc_fifos/adc0_fifo/adc_data[125]} {rfadc_fifos/adc0_fifo/adc_data[126]} {rfadc_fifos/adc0_fifo/adc_data[127]} {rfadc_fifos/adc0_fifo/adc_data[128]} {rfadc_fifos/adc0_fifo/adc_data[129]} {rfadc_fifos/adc0_fifo/adc_data[130]} {rfadc_fifos/adc0_fifo/adc_data[131]} {rfadc_fifos/adc0_fifo/adc_data[132]} {rfadc_fifos/adc0_fifo/adc_data[133]} {rfadc_fifos/adc0_fifo/adc_data[134]} {rfadc_fifos/adc0_fifo/adc_data[135]} {rfadc_fifos/adc0_fifo/adc_data[136]} {rfadc_fifos/adc0_fifo/adc_data[137]} {rfadc_fifos/adc0_fifo/adc_data[138]} {rfadc_fifos/adc0_fifo/adc_data[139]} {rfadc_fifos/adc0_fifo/adc_data[140]} {rfadc_fifos/adc0_fifo/adc_data[141]} {rfadc_fifos/adc0_fifo/adc_data[142]} {rfadc_fifos/adc0_fifo/adc_data[143]} {rfadc_fifos/adc0_fifo/adc_data[144]} {rfadc_fifos/adc0_fifo/adc_data[145]} {rfadc_fifos/adc0_fifo/adc_data[146]} {rfadc_fifos/adc0_fifo/adc_data[147]} {rfadc_fifos/adc0_fifo/adc_data[148]} {rfadc_fifos/adc0_fifo/adc_data[149]} {rfadc_fifos/adc0_fifo/adc_data[150]} {rfadc_fifos/adc0_fifo/adc_data[151]} {rfadc_fifos/adc0_fifo/adc_data[152]} {rfadc_fifos/adc0_fifo/adc_data[153]} {rfadc_fifos/adc0_fifo/adc_data[154]} {rfadc_fifos/adc0_fifo/adc_data[155]} {rfadc_fifos/adc0_fifo/adc_data[156]} {rfadc_fifos/adc0_fifo/adc_data[157]} {rfadc_fifos/adc0_fifo/adc_data[158]} {rfadc_fifos/adc0_fifo/adc_data[159]} {rfadc_fifos/adc0_fifo/adc_data[160]} {rfadc_fifos/adc0_fifo/adc_data[161]} {rfadc_fifos/adc0_fifo/adc_data[162]} {rfadc_fifos/adc0_fifo/adc_data[163]} {rfadc_fifos/adc0_fifo/adc_data[164]} {rfadc_fifos/adc0_fifo/adc_data[165]} {rfadc_fifos/adc0_fifo/adc_data[166]} {rfadc_fifos/adc0_fifo/adc_data[167]} {rfadc_fifos/adc0_fifo/adc_data[168]} {rfadc_fifos/adc0_fifo/adc_data[169]} {rfadc_fifos/adc0_fifo/adc_data[170]} {rfadc_fifos/adc0_fifo/adc_data[171]} {rfadc_fifos/adc0_fifo/adc_data[172]} {rfadc_fifos/adc0_fifo/adc_data[173]} {rfadc_fifos/adc0_fifo/adc_data[174]} {rfadc_fifos/adc0_fifo/adc_data[175]} {rfadc_fifos/adc0_fifo/adc_data[176]} {rfadc_fifos/adc0_fifo/adc_data[177]} {rfadc_fifos/adc0_fifo/adc_data[178]} {rfadc_fifos/adc0_fifo/adc_data[179]} {rfadc_fifos/adc0_fifo/adc_data[180]} {rfadc_fifos/adc0_fifo/adc_data[181]} {rfadc_fifos/adc0_fifo/adc_data[182]} {rfadc_fifos/adc0_fifo/adc_data[183]} {rfadc_fifos/adc0_fifo/adc_data[184]} {rfadc_fifos/adc0_fifo/adc_data[185]} {rfadc_fifos/adc0_fifo/adc_data[186]} {rfadc_fifos/adc0_fifo/adc_data[187]} {rfadc_fifos/adc0_fifo/adc_data[188]} {rfadc_fifos/adc0_fifo/adc_data[189]} {rfadc_fifos/adc0_fifo/adc_data[190]} {rfadc_fifos/adc0_fifo/adc_data[191]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 3 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {rfadc_fifos/adc0_fifo/adc_enb_sr[0]} {rfadc_fifos/adc0_fifo/adc_enb_sr[1]} {rfadc_fifos/adc0_fifo/adc_enb_sr[2]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 16 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {rfadc_fifos/adc0_fifo/sample_num[0]} {rfadc_fifos/adc0_fifo/sample_num[1]} {rfadc_fifos/adc0_fifo/sample_num[2]} {rfadc_fifos/adc0_fifo/sample_num[3]} {rfadc_fifos/adc0_fifo/sample_num[4]} {rfadc_fifos/adc0_fifo/sample_num[5]} {rfadc_fifos/adc0_fifo/sample_num[6]} {rfadc_fifos/adc0_fifo/sample_num[7]} {rfadc_fifos/adc0_fifo/sample_num[8]} {rfadc_fifos/adc0_fifo/sample_num[9]} {rfadc_fifos/adc0_fifo/sample_num[10]} {rfadc_fifos/adc0_fifo/sample_num[11]} {rfadc_fifos/adc0_fifo/sample_num[12]} {rfadc_fifos/adc0_fifo/sample_num[13]} {rfadc_fifos/adc0_fifo/sample_num[14]} {rfadc_fifos/adc0_fifo/sample_num[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 2 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list {rfadc_fifos/adc0_fifo/state[0]} {rfadc_fifos/adc0_fifo/state[1]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list rfadc_fifos/adc0_fifo/adc_enb_s]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list rfadc_fifos/adc0_fifo/fifo_wren]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets dbg_OBUF[6]]
