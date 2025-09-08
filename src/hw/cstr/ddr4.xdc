

set_property CLOCK_DEDICATED_ROUTE BACKBONE \
  [get_pins -hier -filter {NAME =~ */u_ddr4_infrastructure/gen_mmcme*.u_mmcme_adv_inst/CLKIN1}]

# Reference = 416.4 MHz => period 2401.537 ps
create_clock -name ddr4_sys_clk -period 2401.537 [get_ports ddr4_sys_clk_p]


#ddr4 memory
#This works
#set_property PACKAGE_PIN H13 [ get_ports "ddr4_sys_clk_p" ]
#set_property IOSTANDARD DIFF_SSTL12 [ get_ports "ddr4_sys_clk_p" ]

set_property PACKAGE_PIN AM15 [ get_ports "ddr4_sys_clk_p" ]
set_property IOSTANDARD LVDS [ get_ports "ddr4_sys_clk_p" ]
set_property IOSTANDARD LVDS [ get_ports "ddr4_sys_clk_n" ]

set_property PACKAGE_PIN C13  [get_ports {ddr4_adr[0]}]
set_property PACKAGE_PIN H7   [get_ports {ddr4_adr[1]}]
set_property PACKAGE_PIN C15  [get_ports {ddr4_adr[2]}]
set_property PACKAGE_PIN J8   [get_ports {ddr4_adr[3]}]
set_property PACKAGE_PIN B12  [get_ports {ddr4_adr[4]}]
set_property PACKAGE_PIN G8   [get_ports {ddr4_adr[5]}]
set_property PACKAGE_PIN D13  [get_ports {ddr4_adr[6]}]
set_property PACKAGE_PIN G6   [get_ports {ddr4_adr[7]}]
set_property PACKAGE_PIN C12  [get_ports {ddr4_adr[8]}]
set_property PACKAGE_PIN J7   [get_ports {ddr4_adr[9]}]
set_property PACKAGE_PIN F12  [get_ports {ddr4_adr[10]}]
set_property PACKAGE_PIN B13  [get_ports {ddr4_adr[11]}]
set_property PACKAGE_PIN J9   [get_ports {ddr4_adr[12]}]
set_property PACKAGE_PIN A11  [get_ports {ddr4_adr[13]}]
##we
set_property PACKAGE_PIN K11  [get_ports {ddr4_adr[14]}]  
##cas
set_property PACKAGE_PIN F9   [get_ports {ddr4_adr[15]}]  
##ras
set_property PACKAGE_PIN G9   [get_ports {ddr4_adr[16]}]  


set_property PACKAGE_PIN K13  [get_ports {ddr4_ba[0]}]  
set_property PACKAGE_PIN H8  [get_ports {ddr4_ba[1]}]  

set_property PACKAGE_PIN K12  [get_ports {ddr4_bg[0]}]  
#set_property PACKAGE_PIN AJ20  [get_ports {c0_ddr4_bg[1]}]  

set_property PACKAGE_PIN G12 [get_ports ddr4_ck_c]  
set_property PACKAGE_PIN G13 [get_ports ddr4_ck_t]  

set_property PACKAGE_PIN K10  [get_ports ddr4_cke]  

set_property PACKAGE_PIN F11  [get_ports ddr4_act_n]  

set_property PACKAGE_PIN D14  [get_ports ddr4_reset_n]  

set_property PACKAGE_PIN F10  [get_ports ddr4_odt]  

set_property PACKAGE_PIN K9  [get_ports {ddr4_cs_n[0]}]  
#set_property PACKAGE_PIN AU17  [get_ports {c0_ddr4_cs_n[1]}]  


set_property PACKAGE_PIN M15  [get_ports {ddr4_dq[0]}]
set_property PACKAGE_PIN M13  [get_ports {ddr4_dq[1]}]
set_property PACKAGE_PIN M17  [get_ports {ddr4_dq[2]}]
set_property PACKAGE_PIN L12  [get_ports {ddr4_dq[3]}]
set_property PACKAGE_PIN N15  [get_ports {ddr4_dq[4]}]
set_property PACKAGE_PIN N13  [get_ports {ddr4_dq[5]}]
set_property PACKAGE_PIN N17  [get_ports {ddr4_dq[6]}]
set_property PACKAGE_PIN M12  [get_ports {ddr4_dq[7]}]
set_property PACKAGE_PIN L14  [get_ports {ddr4_dqs_c[0]}]
set_property PACKAGE_PIN L15  [get_ports {ddr4_dqs_t[0]}]
set_property PACKAGE_PIN N14  [get_ports {ddr4_dm_n[0]}]

set_property PACKAGE_PIN K17  [get_ports {ddr4_dq[8]}]
set_property PACKAGE_PIN H16  [get_ports {ddr4_dq[9]}]
set_property PACKAGE_PIN J18  [get_ports {ddr4_dq[10]}]
set_property PACKAGE_PIN J16  [get_ports {ddr4_dq[11]}]
set_property PACKAGE_PIN J19  [get_ports {ddr4_dq[12]}]
set_property PACKAGE_PIN K16  [get_ports {ddr4_dq[13]}]
set_property PACKAGE_PIN L17  [get_ports {ddr4_dq[14]}]
set_property PACKAGE_PIN H17  [get_ports {ddr4_dq[15]}]
set_property PACKAGE_PIN K18  [get_ports {ddr4_dqs_c[1]}]
set_property PACKAGE_PIN K19  [get_ports {ddr4_dqs_t[1]}]
set_property PACKAGE_PIN J15  [get_ports {ddr4_dm_n[1]}]  
  
set_property PACKAGE_PIN G18  [get_ports {ddr4_dq[16]}]
set_property PACKAGE_PIN F15  [get_ports {ddr4_dq[17]}]
set_property PACKAGE_PIN E17  [get_ports {ddr4_dq[18]}]
set_property PACKAGE_PIN F16  [get_ports {ddr4_dq[19]}]
set_property PACKAGE_PIN H18  [get_ports {ddr4_dq[20]}]
set_property PACKAGE_PIN G15  [get_ports {ddr4_dq[21]}]
set_property PACKAGE_PIN E18  [get_ports {ddr4_dq[22]}]
set_property PACKAGE_PIN E16  [get_ports {ddr4_dq[23]}]
set_property PACKAGE_PIN F19  [get_ports {ddr4_dqs_c[2]}]
set_property PACKAGE_PIN G19  [get_ports {ddr4_dqs_t[2]}]
set_property PACKAGE_PIN G17  [get_ports {ddr4_dm_n[2]}]  
  
set_property PACKAGE_PIN C17  [get_ports {ddr4_dq[24]}]
set_property PACKAGE_PIN C16  [get_ports {ddr4_dq[25]}]
set_property PACKAGE_PIN A17  [get_ports {ddr4_dq[26]}]
set_property PACKAGE_PIN A16  [get_ports {ddr4_dq[27]}]
set_property PACKAGE_PIN B19  [get_ports {ddr4_dq[28]}]
set_property PACKAGE_PIN D16  [get_ports {ddr4_dq[29]}]
set_property PACKAGE_PIN A19  [get_ports {ddr4_dq[30]}]
set_property PACKAGE_PIN D15  [get_ports {ddr4_dq[31]}]
set_property PACKAGE_PIN B17  [get_ports {ddr4_dqs_c[3]}]
set_property PACKAGE_PIN B18  [get_ports {ddr4_dqs_t[3]}]
set_property PACKAGE_PIN D18  [get_ports {ddr4_dm_n[3]}]  
  
set_property PACKAGE_PIN L21  [get_ports {ddr4_dq[32]}]
set_property PACKAGE_PIN M20  [get_ports {ddr4_dq[33]}]
set_property PACKAGE_PIN L23  [get_ports {ddr4_dq[34]}]
set_property PACKAGE_PIN L20  [get_ports {ddr4_dq[35]}]
set_property PACKAGE_PIN N19  [get_ports {ddr4_dq[36]}]
set_property PACKAGE_PIN L19  [get_ports {ddr4_dq[37]}]
set_property PACKAGE_PIN L22  [get_ports {ddr4_dq[38]}]
set_property PACKAGE_PIN M19  [get_ports {ddr4_dq[39]}]
set_property PACKAGE_PIN K22  [get_ports {ddr4_dqs_c[4]}]
set_property PACKAGE_PIN K21  [get_ports {ddr4_dqs_t[4]}]
set_property PACKAGE_PIN N20  [get_ports {ddr4_dm_n[4]}]   
  
set_property PACKAGE_PIN G23  [get_ports {ddr4_dq[40]}]
set_property PACKAGE_PIN H21  [get_ports {ddr4_dq[41]}]
set_property PACKAGE_PIN H23  [get_ports {ddr4_dq[42]}]
set_property PACKAGE_PIN G22  [get_ports {ddr4_dq[43]}]
set_property PACKAGE_PIN L24  [get_ports {ddr4_dq[44]}]
set_property PACKAGE_PIN J21  [get_ports {ddr4_dq[45]}]
set_property PACKAGE_PIN K24  [get_ports {ddr4_dq[46]}]
set_property PACKAGE_PIN H22  [get_ports {ddr4_dq[47]}]
set_property PACKAGE_PIN H20  [get_ports {ddr4_dqs_c[5]}]
set_property PACKAGE_PIN J20  [get_ports {ddr4_dqs_t[5]}]
set_property PACKAGE_PIN J23  [get_ports {ddr4_dm_n[5]}]   

set_property PACKAGE_PIN F24  [get_ports {ddr4_dq[48]}]
set_property PACKAGE_PIN E22  [get_ports {ddr4_dq[49]}]
set_property PACKAGE_PIN E23  [get_ports {ddr4_dq[50]}]
set_property PACKAGE_PIN D21  [get_ports {ddr4_dq[51]}]
set_property PACKAGE_PIN E21  [get_ports {ddr4_dq[52]}]
set_property PACKAGE_PIN G20  [get_ports {ddr4_dq[53]}]
set_property PACKAGE_PIN E24  [get_ports {ddr4_dq[54]}]
set_property PACKAGE_PIN F20  [get_ports {ddr4_dq[55]}]
set_property PACKAGE_PIN D24  [get_ports {ddr4_dqs_c[6]}]
set_property PACKAGE_PIN D23  [get_ports {ddr4_dqs_t[6]}]
set_property PACKAGE_PIN F21  [get_ports {ddr4_dm_n[6]}] 

set_property PACKAGE_PIN C22  [get_ports {ddr4_dq[56]}]
set_property PACKAGE_PIN A21  [get_ports {ddr4_dq[57]}]
set_property PACKAGE_PIN C21  [get_ports {ddr4_dq[58]}]
set_property PACKAGE_PIN C20  [get_ports {ddr4_dq[59]}]
set_property PACKAGE_PIN B24  [get_ports {ddr4_dq[60]}]
set_property PACKAGE_PIN A20  [get_ports {ddr4_dq[61]}]
set_property PACKAGE_PIN A24  [get_ports {ddr4_dq[62]}]
set_property PACKAGE_PIN B20  [get_ports {ddr4_dq[63]}]
set_property PACKAGE_PIN A22  [get_ports {ddr4_dqs_c[7]}]
set_property PACKAGE_PIN B22  [get_ports {ddr4_dqs_t[7]}]
set_property PACKAGE_PIN C23  [get_ports {ddr4_dm_n[7]}]     

