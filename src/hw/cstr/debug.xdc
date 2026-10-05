create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list {dbg_OBUF[6]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 10 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {adctoddr/burst_count[0]} {adctoddr/burst_count[1]} {adctoddr/burst_count[2]} {adctoddr/burst_count[3]} {adctoddr/burst_count[4]} {adctoddr/burst_count[5]} {adctoddr/burst_count[6]} {adctoddr/burst_count[7]} {adctoddr/burst_count[8]} {adctoddr/burst_count[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 2 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {sync_trig/state[0]} {sync_trig/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {sync_trig/fifo_delay[0]} {sync_trig/fifo_delay[1]} {sync_trig/fifo_delay[2]} {sync_trig/fifo_delay[3]} {sync_trig/fifo_delay[4]} {sync_trig/fifo_delay[5]} {sync_trig/fifo_delay[6]} {sync_trig/fifo_delay[7]} {sync_trig/fifo_delay[8]} {sync_trig/fifo_delay[9]} {sync_trig/fifo_delay[10]} {sync_trig/fifo_delay[11]} {sync_trig/fifo_delay[12]} {sync_trig/fifo_delay[13]} {sync_trig/fifo_delay[14]} {sync_trig/fifo_delay[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 16 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {sync_trig/fifo_count[0]} {sync_trig/fifo_count[1]} {sync_trig/fifo_count[2]} {sync_trig/fifo_count[3]} {sync_trig/fifo_count[4]} {sync_trig/fifo_count[5]} {sync_trig/fifo_count[6]} {sync_trig/fifo_count[7]} {sync_trig/fifo_count[8]} {sync_trig/fifo_count[9]} {sync_trig/fifo_count[10]} {sync_trig/fifo_count[11]} {sync_trig/fifo_count[12]} {sync_trig/fifo_count[13]} {sync_trig/fifo_count[14]} {sync_trig/fifo_count[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {sync_trig/dma_delay[0]} {sync_trig/dma_delay[1]} {sync_trig/dma_delay[2]} {sync_trig/dma_delay[3]} {sync_trig/dma_delay[4]} {sync_trig/dma_delay[5]} {sync_trig/dma_delay[6]} {sync_trig/dma_delay[7]} {sync_trig/dma_delay[8]} {sync_trig/dma_delay[9]} {sync_trig/dma_delay[10]} {sync_trig/dma_delay[11]} {sync_trig/dma_delay[12]} {sync_trig/dma_delay[13]} {sync_trig/dma_delay[14]} {sync_trig/dma_delay[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {sync_trig/dma_count[0]} {sync_trig/dma_count[1]} {sync_trig/dma_count[2]} {sync_trig/dma_count[3]} {sync_trig/dma_count[4]} {sync_trig/dma_count[5]} {sync_trig/dma_count[6]} {sync_trig/dma_count[7]} {sync_trig/dma_count[8]} {sync_trig/dma_count[9]} {sync_trig/dma_count[10]} {sync_trig/dma_count[11]} {sync_trig/dma_count[12]} {sync_trig/dma_count[13]} {sync_trig/dma_count[14]} {sync_trig/dma_count[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 2 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {adctoddr/wr_state[0]} {adctoddr/wr_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 11 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {adctoddr/turn_count[0]} {adctoddr/turn_count[1]} {adctoddr/turn_count[2]} {adctoddr/turn_count[3]} {adctoddr/turn_count[4]} {adctoddr/turn_count[5]} {adctoddr/turn_count[6]} {adctoddr/turn_count[7]} {adctoddr/turn_count[8]} {adctoddr/turn_count[9]} {adctoddr/turn_count[10]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list sync_trig/fifo_pending]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list sync_trig/armed]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list sync_trig/soft_d]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list sync_trig/sync_trig_out_dma]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list adctoddr/capture_overflow]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list sync_trig/tbt_d]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list adctoddr/s_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list sync_trig/sync_trig_out_fifo]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list sync_trig/dma_pending]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list fifo_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list adctoddr/s_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list dma_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list adctoddr/s_axis_tready]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets dbg_OBUF[6]]
