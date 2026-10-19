

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

library desyrdl;
use desyrdl.common.all;

use desyrdl.pkg_pl_regs.all;

library xil_defaultlib;
use xil_defaultlib.bpm_package.ALL;


entity top is
generic(
    FPGA_VERSION			: integer := 9;
    SIM_MODE				: integer := 0
    );
  port (  
   
    clk104_lmkin0_clk_p     : out std_logic; -- clk104 lmk04828 clkin0
    clk104_lmkin0_clk_n     : out std_logic;
    clk104_adc_refclk_p     : in std_logic;  -- clk104 lmk04828 Dout12
    clk104_adc_refclk_n     : in std_logic; 
    clk104_dac_refclk_p     : in std_logic;  -- clk104 lmk04828 Dout6
    clk104_dac_refclk_n     : in std_logic;
    clk104_pl_clk_p         : in std_logic;  -- clk104 lmk04828 Dout8  83.28MHz  PL Clock 83.28MHz
    clk104_pl_clk_n         : in std_logic;
    clk104_pl_sysref_p      : in std_logic;  -- clk104 lmk04828 SDout9  4.164MHz  PL sysref (Bank64 pins AL16, AL15) 
    clk104_pl_sysref_n      : in std_logic;   
    clk104_ams_sysref_p     : in std_logic;  -- clk104 lmk04828 SDout3  4.164MHz  analog sysref (dedicated pins U4, U5)  
    clk104_ams_sysref_n     : in std_logic;
    
    
    adc0_in_p               : in std_logic; 
    adc0_in_n               : in std_logic;  
    adc1_in_p               : in std_logic; 
    adc1_in_n               : in std_logic;      
    adc2_in_p               : in std_logic; 
    adc2_in_n               : in std_logic;  
    adc3_in_p               : in std_logic; 
    adc3_in_n               : in std_logic;  
    adc4_in_p               : in std_logic; 
    adc4_in_n               : in std_logic;  
    adc5_in_p               : in std_logic; 
    adc5_in_n               : in std_logic;      
    adc6_in_p               : in std_logic; 
    adc6_in_n               : in std_logic;  
    adc7_in_p               : in std_logic; 
    adc7_in_n               : in std_logic;    
    
    dac0_out_p               : out std_logic; 
    dac0_out_n               : out std_logic;  
    dac1_out_p               : out std_logic; 
    dac1_out_n               : out std_logic;      
    dac2_out_p               : out std_logic; 
    dac2_out_n               : out std_logic;  
    dac3_out_p               : out std_logic; 
    dac3_out_n               : out std_logic;  
    dac4_out_p               : out std_logic; 
    dac4_out_n               : out std_logic;  
    dac5_out_p               : out std_logic; 
    dac5_out_n               : out std_logic;      
    dac6_out_p               : out std_logic; 
    dac6_out_n               : out std_logic;  
    dac7_out_p               : out std_logic; 
    dac7_out_n               : out std_logic;        
    
    
    
    -- evr
    gty_evr_refclk_p        : in std_logic; 
    gty_evr_refclk_n        : in std_logic; 
    gty_evr_tx_p            : out std_logic; 
    gty_evr_tx_n            : out std_logic;
    gty_evr_rx_p            : in std_logic; 
    gty_evr_rx_n            : in std_logic; 
    
    sfp_led                 : out std_logic_vector(11 downto 0);
    sfp_rxlos               : in std_logic_vector(5 downto 0);  
    fp_in                   : in std_logic_vector(3 downto 0);
    fp_out                  : out std_logic_vector(3 downto 0);    
       
    fp_led                  : out std_logic_vector(7 downto 0);
    dbg                     : out std_logic_vector(19 downto 0)

  );
end top;


architecture behv of top is

  
  signal pl_clk0                : std_logic;
  signal pl_clk1                : std_logic;
  signal pl_resetn              : std_logic;
  signal pl_reset               : std_logic;
  signal rfadc_reset            : std_logic;
  signal ps_leds                : std_logic_vector(7 downto 0);
  signal rfadc_mmcm_locked      : std_logic;
  
  signal m_axi4_m2s             : t_pl_regs_m2s;
  signal m_axi4_s2m             : t_pl_regs_s2m;
  
  signal reg_i                  : t_addrmap_pl_regs_in;
  signal reg_o                  : t_addrmap_pl_regs_out;
  
  signal clk104_lmkin0_clk      : std_logic;
  signal clk104_pl_clkin        : std_logic;
  signal clk104_pl_clk          : std_logic;
  signal clk104_pl_sysref_raw   : std_logic;
  signal clk104_pl_sysref       : std_logic;
  
  signal adc_data               : t_adc_raw; 
  
  signal adc0_axis_tdata        : std_logic_vector(191 downto 0); 
  signal adc0_axis_tready       : std_logic;
  signal adc0_axis_tvalid       : std_logic; 
  signal adc1_axis_tdata        : std_logic_vector(191 downto 0); 
  signal adc1_axis_tready       : std_logic;
  signal adc1_axis_tvalid       : std_logic; 
  signal adc2_axis_tdata        : std_logic_vector(191 downto 0); 
  signal adc2_axis_tready       : std_logic;
  signal adc2_axis_tvalid       : std_logic;   
  signal adc3_axis_tdata        : std_logic_vector(191 downto 0); 
  signal adc3_axis_tready       : std_logic;
  signal adc3_axis_tvalid       : std_logic;     
  signal adc4_axis_tdata        : std_logic_vector(191 downto 0); 
  signal adc4_axis_tready       : std_logic;
  signal adc4_axis_tvalid       : std_logic; 
  signal adc5_axis_tdata        : std_logic_vector(191 downto 0); 
  signal adc5_axis_tready       : std_logic;
  signal adc5_axis_tvalid       : std_logic; 
  signal adc6_axis_tdata        : std_logic_vector(191 downto 0); 
  signal adc6_axis_tready       : std_logic;
  signal adc6_axis_tvalid       : std_logic;   
  signal adc7_axis_tdata        : std_logic_vector(191 downto 0); 
  signal adc7_axis_tready       : std_logic;
  signal adc7_axis_tvalid       : std_logic;     
  
  
  signal dac0_axis_tdata        : std_logic_vector(255 downto 0); 
  signal dac0_axis_tready       : std_logic;
  signal dac0_axis_tvalid       : std_logic; 
  signal dac1_axis_tdata        : std_logic_vector(255 downto 0); 
  signal dac1_axis_tready       : std_logic;
  signal dac1_axis_tvalid       : std_logic; 
  signal dac2_axis_tdata        : std_logic_vector(255 downto 0); 
  signal dac2_axis_tready       : std_logic;
  signal dac2_axis_tvalid       : std_logic;   
  signal dac3_axis_tdata        : std_logic_vector(255 downto 0); 
  signal dac3_axis_tready       : std_logic;
  signal dac3_axis_tvalid       : std_logic;     
  signal dac4_axis_tdata        : std_logic_vector(255 downto 0); 
  signal dac4_axis_tready       : std_logic;
  signal dac4_axis_tvalid       : std_logic; 
  signal dac5_axis_tdata        : std_logic_vector(255 downto 0); 
  signal dac5_axis_tready       : std_logic;
  signal dac5_axis_tvalid       : std_logic; 
  signal dac6_axis_tdata        : std_logic_vector(255 downto 0); 
  signal dac6_axis_tready       : std_logic;
  signal dac6_axis_tvalid       : std_logic;   
  signal dac7_axis_tdata        : std_logic_vector(255 downto 0); 
  signal dac7_axis_tready       : std_logic;
  signal dac7_axis_tvalid       : std_logic;       
  
  
  signal rfadc_out_clk          : std_logic;
  signal rfadc_axis_mmcm_clk    : std_logic;
  signal rfadc_axis_clk         : std_logic;
  
  
  signal rfdac_out_clk          : std_logic;
  signal rfdac_axis_mmcm_clk    : std_logic;
  signal rfdac_axis_clk         : std_logic;  

  signal reg_o_rfdac            : t_reg_o_rfdac;

  signal reg_i_rfadcfifo        : t_reg_i_rfadc_fifo_rdout;
  signal reg_o_rfadcfifo        : t_reg_o_rfadc_fifo_rdout;	 

  signal reg_o_evr              : t_reg_o_evr;
  signal reg_i_evr              : t_reg_i_evr;

  signal reg_i_freq             : t_reg_i_freq;
  
  signal reg_o_dma              : t_reg_o_dma;
  
  signal evr_gty_reset       : std_logic_vector(7 downto 0);
  signal evr_ref_clk         : std_logic;
  signal evr_rcvd_clk        : std_logic;
  signal evr_tbt_trig        : std_logic;
  signal evr_fa_trig         : std_logic;
  signal evr_sa_trig         : std_logic;
  signal evr_gps_trig        : std_logic;
  signal evr_dma_trig        : std_logic;
  signal evr_dbg             : std_logic_vector(19 downto 0);
  signal evr_dma_trignum     : std_logic_vector(7 downto 0);
  signal evr_ts              : std_logic_vector(63 downto 0); 
  
  signal tbt_trig            : std_logic;
  
  signal dma_adc_active      : std_logic;
  signal dma_adc_tdata       : std_logic_vector(767 downto 0);

  signal dma_adc_tlast       : std_logic;
  signal dma_adc_tready      : std_logic;
  signal dma_adc_tvalid      : std_logic;

  signal fifo_start          : std_logic;
  signal dma_start           : std_logic;
  signal dma_write_active    : std_logic;
  
  
  
  attribute mark_debug     : string;
  attribute mark_debug of dac0_axis_tdata: signal is "true"; 
  attribute mark_debug of dac0_axis_tvalid: signal is "true"; 
  attribute mark_debug of dac0_axis_tready: signal is "true"; 
  attribute mark_debug of adc0_axis_tdata: signal is "true";
  
  attribute mark_debug of fifo_start: signal is "true";
  attribute mark_debug of dma_start: signal is "true";
  
  attribute mark_debug of evr_tbt_trig: signal is "true";
  attribute mark_debug of reg_o_rfadcfifo: signal is "true";



begin


dbg(0) <= pl_clk0;
dbg(1) <= '0';
dbg(2) <= clk104_pl_sysref_raw; --clk104_pl_clk;
dbg(3) <= '0';
dbg(4) <= rfadc_out_clk;
dbg(5) <= '0';
dbg(6) <= rfadc_axis_clk;
dbg(7) <= '0';
dbg(8) <= evr_rcvd_clk;
dbg(19 downto 9) <= (others => '0'); 


sfp_led(1 downto 0) <= sfp_rxlos(0) & evr_gps_trig; --ps_leds(0);
sfp_led(3 downto 2) <= sfp_rxlos(1) & ps_leds(1);
sfp_led(5 downto 4) <= sfp_rxlos(2) & ps_leds(2);
sfp_led(7 downto 6) <= sfp_rxlos(3) & ps_leds(3);
sfp_led(9 downto 8) <= sfp_rxlos(4) & ps_leds(4);
sfp_led(11 downto 10) <= sfp_rxlos(5) & ps_leds(5);

fp_out(0) <= dma_write_active; --evr_rcvd_clk; 
fp_out(1) <= dma_write_active; --'0'; --rfdac_out_clk;   --124.92MHz
fp_out(2) <= evr_dma_trig; -- rfadc_out_clk;   --416.4MHz
fp_out(3) <= evr_tbt_trig; 


fp_led  <= ps_leds;



pl_reset <= not pl_resetn;
rfadc_reset <= pl_reset or not rfadc_mmcm_locked;

--drive the CLK104 PLL with the 124.92 EVR recovered clock
lmk_clkout : OBUFDS port map (O => clk104_lmkin0_clk_p, OB => clk104_lmkin0_clk_n, I => evr_rcvd_clk);    

--clk104 lmk04828 Dout8  499.68MHz  PL Clock 499.68MHz
--lmk_pl_clk_ibuf  : IBUFDS port map (O => clk104_pl_clkin, I => clk104_pl_clk_p, IB => clk104_pl_clk_n);

--May not need?  Does MMCM need bufg on input?
--pl_clkin_bufg : BUFG   port map (O => clk104_pl_clk, I => clk104_pl_clkin);

--Separate PL SYSREF from LMK SDCLK9. This is NOT the analog SYSREF, which remains connected to the RFSoC dedicated pins U5/U4.
pl_sysref_ibuf  : IBUFDS port map (O => clk104_pl_sysref_raw, I => clk104_pl_sysref_p, IB => clk104_pl_sysref_n);



--MMCM already drives BUFG
--rfadc_bufg    : BUFG   port map (O => rfadc_axis_clk, I => rfadc_axis_mmcm_clk);

rfdac_bufg    : BUFG   port map (O => rfdac_axis_clk, I => rfdac_out_clk);



--axisclk_adc: entity work.rfadc_clk_pll  
--  port map (
--    reset => pl_reset, 
--    clk_in1 => rfadc_out_clk,   --156.15MHz
--    clk_out1 => rfadc_axis_mmcm_clk,  --416.4MHz
--    locked => rfadc_mmcm_locked
--);


lmkclk_pll: entity work.lmk_clk_pll
  port map (
    reset => pl_reset, 
    clk_in1 => pl_clk0,   --100MHz
    clk_out1 => clk104_lmkin0_clk, --124.92MHz
    locked => open  
);


plclk_pll: entity work.pl_clk_pll
  port map (
    reset => pl_reset, 
    clk_in1_p => clk104_pl_clk_p,   --83.28MHz
    clk_in1_n => clk104_pl_clk_n,
    clk_out1 => rfadc_axis_clk, --rfadc_axis_mmcm_clk, --416.4MHz
    locked => rfadc_mmcm_locked  
);


-- PG269 PL SYSREF capture: sample on the shared ADC AXI clock.
-- IMPORTANT: Validate input setup/hold with report_datasheet and tune
-- LMK SYSREF output delay/phase. This register alone does NOT guarantee
-- deterministic capture without timing closure.
process(rfadc_axis_clk)
begin
  if rising_edge(rfadc_axis_clk) then
    if rfadc_reset = '1' then
      clk104_pl_sysref <= '0';
    else
      clk104_pl_sysref <= clk104_pl_sysref_raw;
    end if;
  end if;
end process;







ps_pl: entity work.ps_io
  port map (
    pl_clock => pl_clk0, 
    pl_reset => not pl_resetn, 
    m_axi4_m2s => m_axi4_m2s, 
    m_axi4_s2m => m_axi4_s2m, 
    fp_leds => ps_leds, 
    reg_o_rfdac => reg_o_rfdac,
    reg_i_rfadcfifo => reg_i_rfadcfifo, 
    reg_o_rfadcfifo => reg_o_rfadcfifo, 	
    reg_o_dma => reg_o_dma, 
	reg_o_evr => reg_o_evr, 
	reg_i_evr => reg_i_evr,
	reg_i_freq => reg_i_freq
          
  );







sync_trig: entity work.trigger_sync
  port map (
    adc_clk => rfadc_axis_clk,
    adc_rst => rfadc_reset, --pl_reset,
    tbt_trig => evr_tbt_trig,
    soft_trig => reg_o_rfadcfifo.softtrig,
    fifo_delay => reg_o_rfadcfifo.trig_delay,
    dma_delay => reg_o_dma.trig_delay,
    sync_trig_out_fifo => fifo_start,
    sync_trig_out_dma => dma_start,
    armed => open
  );


  
-- store entire adc data for about 3 turns to internal FIFO 
rfadc_fifos:  entity work.rf_adc_fifos
  port map (
    pl_clk0 => pl_clk0,  
    pl_reset => rfadc_reset, --pl_reset, 
    adc_clk => rfadc_axis_clk,  
    reg_i => reg_i_rfadcfifo, 
    reg_o => reg_o_rfadcfifo,
    soft_trig => fifo_start,
    dac_trig => reg_o_rfdac.trig,
    evr_trig => evr_dma_trig,  
    adc0_data => adc0_axis_tdata, 
    adc1_data => adc1_axis_tdata,    
    adc2_data => adc2_axis_tdata,  
    adc3_data => adc3_axis_tdata, 
    adc4_data => adc4_axis_tdata, 
    adc5_data => adc5_axis_tdata,   
    adc6_data => adc6_axis_tdata, 
    adc7_data => adc7_axis_tdata     
 );  
  
  
-- DMA a window of adc data for 1000 turns.
adctoddr: entity work.adc2dma
  port map(
    sys_clk => pl_clk1, 
    adc_clk => rfadc_axis_clk,  
    reset => rfadc_reset, --pl_reset,                        
    trig => dma_start,  
    reg_o => reg_o_dma, 	 
    adc0_data => adc0_axis_tdata, 
    adc1_data => adc1_axis_tdata,   
    adc2_data => adc2_axis_tdata, 
    adc3_data => adc3_axis_tdata,
	dma_active => dma_adc_active,
	dma_write => dma_write_active,
    m_axis_tdata => dma_adc_tdata, 
    m_axis_tlast => dma_adc_tlast, 
    m_axis_tready => dma_adc_tready, 
    m_axis_tvalid => dma_adc_tvalid   
  );      
  
  
  
 
  
  
dac0_axis_tvalid <= '1';
dac1_axis_tvalid <= '1';
dac2_axis_tvalid <= '1';
dac3_axis_tvalid <= '1';
dac4_axis_tvalid <= '1';
dac5_axis_tvalid <= '1';
dac6_axis_tvalid <= '1';
dac7_axis_tvalid <= '1';



  
dac_awg: entity work.rf_dac_awg
  port map(
    pl_clk0 => pl_clk0,
    dac_clk => rfdac_axis_clk,     
    reset => pl_reset, 
    reg_o => reg_o_rfdac,
    dac0_data => dac0_axis_tdata, 
    dac1_data => dac1_axis_tdata,  
    dac2_data => dac2_axis_tdata, 
    dac3_data => dac3_axis_tdata,
    dac4_data => dac4_axis_tdata, 
    dac5_data => dac5_axis_tdata,   
    dac6_data => dac6_axis_tdata, 
    dac7_data => dac7_axis_tdata           
 );
 


--embedded event receiver
evr: entity work.evr_top 
  generic map (
    SIM_MODE => SIM_MODE
  )
  port map(
    sys_clk => pl_clk0,
    sys_rst => pl_reset, 
    reg_o => reg_o_evr,
    reg_i => reg_i_evr,
    refclk_p => gty_evr_refclk_p,  -- 312.5 MHz reference clock
    refclk_n => gty_evr_refclk_n,
    tx_p => gty_evr_tx_p,
    tx_n => gty_evr_tx_n,
    rx_p => gty_evr_rx_p,
    rx_n => gty_evr_rx_n,
      
    --trignum => evr_dma_trignum, 
    --trigdly => (x"00000001"), 
    tbt_trig => evr_tbt_trig, 
    fa_trig => evr_fa_trig, 
    sa_trig => evr_sa_trig, 
    usr_trig => evr_dma_trig, 
    gps_trig => evr_gps_trig, 
    timestamp => evr_ts,  
    evr_rcvd_clk => evr_rcvd_clk,
    evr_ref_clk => evr_ref_clk,
    dbg => evr_dbg
);	


tbt_gen: entity work.pt_cntrl
  port map (
    evr_clk => evr_rcvd_clk, 
    reset => pl_reset,                
    evr_tbt_trig => evr_tbt_trig,  
    inttrig_enb => '0', 
    tbt_trig => tbt_trig
  );    








system_i: component system
  port map (
    pl_clk0 => pl_clk0,
    pl_clk1 => pl_clk1,
    pl_resetn => pl_resetn,
    -- axi-lite interface for register I/O    
    m_axi_araddr => m_axi4_m2s.araddr, 
    m_axi_arprot => m_axi4_m2s.arprot,
    m_axi_arready => m_axi4_s2m.arready,
    m_axi_arvalid => m_axi4_m2s.arvalid,
    m_axi_awaddr => m_axi4_m2s.awaddr,
    m_axi_awprot => m_axi4_m2s.awprot,
    m_axi_awready => m_axi4_s2m.awready,
    m_axi_awvalid => m_axi4_m2s.awvalid,
    m_axi_bready => m_axi4_m2s.bready,
    m_axi_bresp => m_axi4_s2m.bresp,
    m_axi_bvalid => m_axi4_s2m.bvalid,
    m_axi_rdata => m_axi4_s2m.rdata,
    m_axi_rready => m_axi4_m2s.rready,
    m_axi_rresp => m_axi4_s2m.rresp,
    m_axi_rvalid => m_axi4_s2m.rvalid,
    m_axi_wdata => m_axi4_m2s.wdata,
    m_axi_wready => m_axi4_s2m.wready,
    m_axi_wstrb => m_axi4_m2s.wstrb,
    m_axi_wvalid => m_axi4_m2s.wvalid,
    
    --axis DMA data
    s_axis_adc_tdata => dma_adc_tdata,
    s_axis_adc_tlast => dma_adc_tlast, 
    s_axis_adc_tready => dma_adc_tready,
    s_axis_adc_tvalid => dma_adc_tvalid,
    
    --sysref inputs
    sysref_in_diff_p => clk104_ams_sysref_p,
    sysref_in_diff_n => clk104_ams_sysref_n,     
    
    user_sysref_adc => clk104_pl_sysref,
    
    --adc resets
    m0_axis_aresetn => pl_resetn,  
    m1_axis_aresetn => pl_resetn,    
    m2_axis_aresetn => pl_resetn,  
    m3_axis_aresetn => pl_resetn,
    --adc clock input
    adc2_clk_clk_p => clk104_adc_refclk_p,
    adc2_clk_clk_n => clk104_adc_refclk_n,
    --adc inputs
    vin0_01_v_p => adc4_in_p,
    vin0_01_v_n => adc4_in_n, 
    vin0_23_v_p => adc5_in_p,
    vin0_23_v_n => adc5_in_n, 
    vin1_01_v_p => adc6_in_p,
    vin1_01_v_n => adc6_in_n,         
    vin1_23_v_p => adc7_in_p,
    vin1_23_v_n => adc7_in_n, 
    vin2_01_v_p => adc0_in_p,
    vin2_01_v_n => adc0_in_n, 
    vin2_23_v_p => adc1_in_p,
    vin2_23_v_n => adc1_in_n, 
    vin3_01_v_p => adc2_in_p,
    vin3_01_v_n => adc2_in_n,         
    vin3_23_v_p => adc3_in_p,
    vin3_23_v_n => adc3_in_n,       
    --clock output to drive axis clock via PLL 
    clk_adc0 => open,
    clk_adc1 => open, 
    clk_adc2 => rfadc_out_clk, 
    clk_adc3 => open,
    --axis clock    
    m0_axis_aclk => rfadc_axis_clk,
    m1_axis_aclk => rfadc_axis_clk,
    m2_axis_aclk => rfadc_axis_clk,
    m3_axis_aclk => rfadc_axis_clk,
    --axis data
    m00_axis_tready => '1',    
    m00_axis_tdata => adc4_axis_tdata, 
    m00_axis_tvalid => adc4_axis_tvalid,
    m02_axis_tready => '1',    
    m02_axis_tdata => adc5_axis_tdata, 
    m02_axis_tvalid => adc5_axis_tvalid,
    m10_axis_tready => '1',    
    m10_axis_tdata => adc6_axis_tdata, 
    m10_axis_tvalid => adc6_axis_tvalid,    
    m12_axis_tready => '1',    
    m12_axis_tdata => adc7_axis_tdata, 
    m12_axis_tvalid => adc7_axis_tvalid,           
    m20_axis_tready => '1',    
    m20_axis_tdata => adc0_axis_tdata, 
    m20_axis_tvalid => adc0_axis_tvalid,
    m22_axis_tready => '1',    
    m22_axis_tdata => adc1_axis_tdata, 
    m22_axis_tvalid => adc1_axis_tvalid,
    m30_axis_tready => '1',    
    m30_axis_tdata => adc2_axis_tdata, 
    m30_axis_tvalid => adc2_axis_tvalid,    
    m32_axis_tready => '1',    
    m32_axis_tdata => adc3_axis_tdata, 
    m32_axis_tvalid => adc3_axis_tvalid,       

    --dac resets
    s0_axis_aresetn => pl_resetn,  
    s1_axis_aresetn => pl_resetn,    
    s2_axis_aresetn => pl_resetn,  
    s3_axis_aresetn => pl_resetn,
    --dac clock input
    dac0_clk_clk_p => clk104_dac_refclk_p,
    dac0_clk_clk_n => clk104_dac_refclk_n,
    --dac outputs
    vout00_v_p => dac0_out_p,
    vout00_v_n => dac0_out_n, 
    vout02_v_p => dac1_out_p,
    vout02_v_n => dac1_out_n, 
    vout10_v_p => dac2_out_p,
    vout10_v_n => dac2_out_n, 
    vout12_v_p => dac3_out_p,
    vout12_v_n => dac3_out_n, 
    vout20_v_p => dac4_out_p,
    vout20_v_n => dac4_out_n, 
    vout22_v_p => dac5_out_p,
    vout22_v_n => dac5_out_n, 
    vout30_v_p => dac6_out_p,
    vout30_v_n => dac6_out_n, 
    vout32_v_p => dac7_out_p,
    vout32_v_n => dac7_out_n, 
       
    --clock output to drive axis clock via PLL 
    clk_dac0 => rfdac_out_clk, 
    clk_dac1 => open, 
    clk_dac2 => open,
    clk_dac3 => open,
    --axis clock    
    s0_axis_aclk => rfdac_axis_clk,
    s1_axis_aclk => rfdac_axis_clk,
    s2_axis_aclk => rfdac_axis_clk,
    s3_axis_aclk => rfdac_axis_clk,
    --axis data
    s00_axis_tready => open,    
    s00_axis_tdata => dac0_axis_tdata, 
    s00_axis_tvalid => dac0_axis_tvalid,
    s02_axis_tready => dac0_axis_tready, --open,    
    s02_axis_tdata => dac1_axis_tdata, 
    s02_axis_tvalid => dac1_axis_tvalid,
    s10_axis_tready => open,    
    s10_axis_tdata => dac2_axis_tdata, 
    s10_axis_tvalid => dac2_axis_tvalid,    
    s12_axis_tready => open,    
    s12_axis_tdata => dac3_axis_tdata, 
    s12_axis_tvalid => dac3_axis_tvalid,           
    s20_axis_tready => open,    
    s20_axis_tdata => dac4_axis_tdata, 
    s20_axis_tvalid => dac4_axis_tvalid,
    s22_axis_tready => open,    
    s22_axis_tdata => dac5_axis_tdata, 
    s22_axis_tvalid => dac5_axis_tvalid,
    s30_axis_tready => open,    
    s30_axis_tdata => dac6_axis_tdata, 
    s30_axis_tvalid => dac6_axis_tvalid,    
    s32_axis_tready => open,    
    s32_axis_tdata => dac7_axis_tdata, 
    s32_axis_tvalid => dac7_axis_tvalid    

    );


clk_meas: entity work.clk_meas_freq
  port map (
    pl_clk0 => pl_clk0,
    reset => pl_reset,
    clk0 => rfadc_out_clk,      --416.4MHz,
    clk1 => clk104_lmkin0_clk, --124.92MHz 
    clk2 => rfdac_out_clk,     --426.724MHz
    clk3 => pl_clk0, --clk104_pl_sysref,  --4.164MHz
    clk4 => rfadc_axis_clk,    --416.4MHz
    reg_i => reg_i_freq
  );
  






end behv;
