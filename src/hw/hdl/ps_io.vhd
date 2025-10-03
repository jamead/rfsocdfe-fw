
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library desyrdl;
use desyrdl.common.all;
use desyrdl.pkg_pl_regs.all;

library xil_defaultlib;
use xil_defaultlib.bpm_package.ALL;

library work;
use work.bpm_package.ALL;


entity ps_io is
  port (  
     pl_clock         : in std_logic;
     pl_reset         : in std_logic;
   
     m_axi4_m2s       : in t_pl_regs_m2s;
     m_axi4_s2m       : out t_pl_regs_s2m;   

     reg_i_rfadcfifo : in  t_reg_i_rfadc_fifo_rdout;
     reg_o_rfadcfifo : out t_reg_o_rfadc_fifo_rdout;	
     
     reg_o_rfdac     : out t_reg_o_rfdac; 
	 
	 reg_o_evr       : out t_reg_o_evr;
	 reg_i_evr       : in  t_reg_i_evr;
	 reg_i_freq      : in  t_reg_i_freq;
 
     fp_leds         : out std_logic_vector(7 downto 0)
  );
end ps_io;


architecture behv of ps_io is

  

  
  signal reg_i        : t_addrmap_pl_regs_in;
  signal reg_o        : t_addrmap_pl_regs_out;

  attribute mark_debug     : string;
  attribute mark_debug of reg_o: signal is "true";



begin

fp_leds <= reg_o.FP_LEDS.val.data;



reg_i.freq_clk0.val.data <= reg_i_freq.clk0_freq;
reg_i.freq_clk1.val.data <= reg_i_freq.clk1_freq;
reg_i.freq_clk2.val.data <= reg_i_freq.clk2_freq;
reg_i.freq_clk3.val.data <= reg_i_freq.clk3_freq;
reg_i.freq_clk4.val.data <= reg_i_freq.clk4_freq;


-- dac DPRAM's
reg_o_rfdac.chsel <= reg_o.rfdac_dpram_sel.val.data;
reg_o_rfdac.numpts <= reg_o.rfdac_dpram_numpts.val.data;
reg_o_rfdac.sync2tbt <= reg_o.rfdac_dpram_sync2tbt.val.data(0);
reg_o_rfdac.loopenb <= reg_o.rfdac_dpram_loopenb.val.data(0);
reg_o_rfdac.trig <= reg_o.rfdac_dpram_trig.val.data(0);

reg_o_rfdac.we <= reg_o.rfdac_dpram_we.val.data(0);
reg_o_rfdac.addr <= reg_o.rfdac_dpram_addr.val.data(13 downto 0);
reg_o_rfdac.data <= reg_o.rfdac_dpram_data.val.data;


-- adc FIFO's
reg_o_rfadcfifo.enb <= reg_o.rfadcfifo_trig.data.data(0); 
reg_o_rfadcfifo.rst <= reg_o.rfadcfifo_reset.data.data(0);

reg_o_rfadcfifo.adc0_rdstr <= reg_o.rfadc0fifo_dout.data.swacc;
reg_i.rfadc0fifo_dout.data.data <= reg_i_rfadcfifo.adc0_dout;  
reg_i.rfadc0fifo_wdcnt.data.data <= reg_i_rfadcfifo.adc0_rdcnt; 

reg_o_rfadcfifo.adc1_rdstr <= reg_o.rfadc1fifo_dout.data.swacc;
reg_i.rfadc1fifo_dout.data.data <= reg_i_rfadcfifo.adc1_dout;  
reg_i.rfadc1fifo_wdcnt.data.data <= reg_i_rfadcfifo.adc1_rdcnt; 

reg_o_rfadcfifo.adc2_rdstr <= reg_o.rfadc2fifo_dout.data.swacc;
reg_i.rfadc2fifo_dout.data.data <= reg_i_rfadcfifo.adc2_dout;  
reg_i.rfadc2fifo_wdcnt.data.data <= reg_i_rfadcfifo.adc2_rdcnt; 

reg_o_rfadcfifo.adc3_rdstr <= reg_o.rfadc3fifo_dout.data.swacc;
reg_i.rfadc3fifo_dout.data.data <= reg_i_rfadcfifo.adc3_dout;  
reg_i.rfadc3fifo_wdcnt.data.data <= reg_i_rfadcfifo.adc3_rdcnt; 

reg_o_rfadcfifo.adc4_rdstr <= reg_o.rfadc4fifo_dout.data.swacc;
reg_i.rfadc4fifo_dout.data.data <= reg_i_rfadcfifo.adc4_dout;  
reg_i.rfadc4fifo_wdcnt.data.data <= reg_i_rfadcfifo.adc4_rdcnt; 

reg_o_rfadcfifo.adc5_rdstr <= reg_o.rfadc5fifo_dout.data.swacc;
reg_i.rfadc5fifo_dout.data.data <= reg_i_rfadcfifo.adc5_dout;  
reg_i.rfadc5fifo_wdcnt.data.data <= reg_i_rfadcfifo.adc5_rdcnt; 

reg_o_rfadcfifo.adc6_rdstr <= reg_o.rfadc6fifo_dout.data.swacc;
reg_i.rfadc6fifo_dout.data.data <= reg_i_rfadcfifo.adc6_dout;  
reg_i.rfadc6fifo_wdcnt.data.data <= reg_i_rfadcfifo.adc6_rdcnt; 

reg_o_rfadcfifo.adc7_rdstr <= reg_o.rfadc7fifo_dout.data.swacc;
reg_i.rfadc7fifo_dout.data.data <= reg_i_rfadcfifo.adc7_dout;  
reg_i.rfadc7fifo_wdcnt.data.data <= reg_i_rfadcfifo.adc7_rdcnt; 




reg_i.ts_ns.val.data <= reg_i_evr.ts_ns; 
reg_i.ts_s.val.data <= reg_i_evr.ts_s; 

reg_o_evr.reset <= reg_o.evr_reset.data.data(0);
reg_o_evr.dma_trigno <= reg_o.dma_trig_eventno.val.data;






regs: pl_regs
  port map (
    pi_clock => pl_clock, 
    pi_reset => pl_reset, 

    pi_s_top => m_axi4_m2s, 
    po_s_top => m_axi4_s2m, 
    -- to logic interface
    pi_addrmap => reg_i,  
    po_addrmap => reg_o
  );





end behv;
