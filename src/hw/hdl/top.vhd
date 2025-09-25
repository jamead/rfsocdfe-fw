

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
    clk104_pl_clk_p         : in std_logic;
    clk104_pl_clk_n         : in std_logic;
    clk104_pl_sysref_p      : in std_logic; -- clk104 AMS sysref SDOut3
    clk104_pl_sysref_n      : in std_logic;   
    
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

  
  signal pl_clk0      : std_logic;
  signal pl_resetn    : std_logic;
  signal pl_reset     : std_logic;
  signal ps_leds      : std_logic_vector(7 downto 0);
  
  signal m_axi4_m2s : t_pl_regs_m2s;
  signal m_axi4_s2m : t_pl_regs_s2m;
  
  signal reg_i      : t_addrmap_pl_regs_in;
  signal reg_o      : t_addrmap_pl_regs_out;
  
  signal clk104_lmkin0_clk      : std_logic;
  signal clk104_pl_clkin        : std_logic;
  signal clk104_pl_clk          : std_logic;
  
  signal adc_data        : t_adc_raw; 
  
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
  
  
  signal reg_o_adcfifo   : t_reg_o_adc_fifo_rdout;
  signal reg_i_adcfifo   : t_reg_i_adc_fifo_rdout;
  signal reg_o_tbtfifo   : t_reg_o_tbt_fifo_rdout;
  signal reg_i_tbtfifo   : t_reg_i_tbt_fifo_rdout;

  
  signal reg_o_dsa       : t_reg_o_dsa;  
  signal reg_o_pll       : t_reg_o_pll;
  signal reg_i_pll       : t_reg_i_pll;
  signal reg_i_rfadcfifo : t_reg_i_rfadc_fifo_rdout;
  signal reg_o_rfadcfifo : t_reg_o_rfadc_fifo_rdout;	 
  
  signal reg_o_tbt       : t_reg_o_tbt;
  signal reg_o_dma       : t_reg_o_dma;
  signal reg_i_dma       : t_reg_i_dma;
  signal reg_o_evr       : t_reg_o_evr;
  signal reg_i_evr       : t_reg_i_evr;
  signal reg_o_therm     : t_reg_o_therm;
  signal reg_i_therm     : t_reg_i_therm;
  signal reg_i_freq      : t_reg_i_freq;
  
  signal tbt_data        : t_tbt_data;    
  signal sa_data         : t_sa_data;
  signal fa_data         : t_fa_data;
  
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
  
  signal cnt                 : std_logic_vector(15 downto 0);
  
  
  attribute mark_debug     : string;
  attribute mark_debug of dac0_axis_tdata: signal is "true"; 
  attribute mark_debug of dac0_axis_tvalid: signal is "true"; 
  attribute mark_debug of dac0_axis_tready: signal is "true"; 
  attribute mark_debug of cnt: signal is "true";
  
--  attribute mark_debug of adc1_axis_tvalid: signal is "true";   
--  attribute mark_debug of adc2_axis_tdata: signal is "true"; 
--  attribute mark_debug of adc2_axis_tvalid: signal is "true";   
--  attribute mark_debug of adc3_axis_tdata: signal is "true"; 
--  attribute mark_debug of adc3_axis_tvalid: signal is "true";   
--  attribute mark_debug of adc4_axis_tdata: signal is "true"; 
--  attribute mark_debug of adc4_axis_tvalid: signal is "true"; 
--  attribute mark_debug of adc5_axis_tdata: signal is "true"; 
--  attribute mark_debug of adc5_axis_tvalid: signal is "true";   
--  attribute mark_debug of adc6_axis_tdata: signal is "true"; 
--  attribute mark_debug of adc6_axis_tvalid: signal is "true";   
--  attribute mark_debug of adc7_axis_tdata: signal is "true"; 
--  attribute mark_debug of adc7_axis_tvalid: signal is "true";    
  
  --attribute mark_debug of pl_reset: signal is "true";
  --attribute mark_debug of fp_led: signal is "true";

  --attribute mark_debug of reg_o: signal is "true";
  --attribute mark_debug of reg_i: signal is "true";

begin


dbg(0) <= pl_clk0;
dbg(1) <= '0';
dbg(2) <= clk104_pl_clk;
dbg(3) <= '0';
dbg(4) <= rfadc_out_clk;
dbg(5) <= '0';
dbg(6) <= rfadc_axis_clk;
dbg(19 downto 7) <= (others => '0'); 


sfp_led(1 downto 0) <= sfp_rxlos(0) & ps_leds(0);
sfp_led(3 downto 2) <= sfp_rxlos(1) & ps_leds(1);
sfp_led(5 downto 4) <= sfp_rxlos(2) & ps_leds(2);
sfp_led(7 downto 6) <= sfp_rxlos(3) & ps_leds(3);
sfp_led(9 downto 8) <= sfp_rxlos(4) & ps_leds(4);
sfp_led(11 downto 10) <= sfp_rxlos(5) & ps_leds(5);

fp_out(0) <= evr_tbt_trig; --fp_led(0); --clk104_pl_clk;
fp_out(1) <= evr_rcvd_clk;
fp_out(2) <= rfadc_out_clk; --fp_led(2); --rfadc_axis_clk;  --125 MHz
fp_out(3) <= fp_led(3); --rfadc_axis_mmcm_clk; -- 166MHz


fp_led  <= ps_leds;



pl_reset <= not pl_resetn;

--drive the CLK104 PLL with 100MHz for now
lmk_clkout : OBUFDS port map (O => clk104_lmkin0_clk_p, OB => clk104_lmkin0_clk_n, I => evr_rcvd_clk); --clk104_lmkin0_clk);   


lmk_pl_clkin  : IBUFDS port map (O => clk104_pl_clkin, I => clk104_pl_clk_p, IB => clk104_pl_clk_n);
pl_clkin_bufg : BUFG   port map (O => clk104_pl_clk, I => clk104_pl_clkin);

rfadc_bufg    : BUFG   port map (O => rfadc_axis_clk, I => rfadc_axis_mmcm_clk);
rfdac_bufg    : BUFG   port map (O => rfdac_axis_clk, I => rfdac_out_clk);


axisclk_adc: entity work.rfadc_clk_pll  
  port map (
    reset => pl_reset, 
    clk_in1 => rfadc_out_clk,   --156.15MHz
    clk_out1 => rfadc_axis_mmcm_clk,  --416.4MHz
    locked => open  
);




lmkclk_pll: entity work.lmk_clk_pll
  port map (
    reset => pl_reset, 
    clk_in1 => pl_clk0,   --100MHz
    clk_out1 => clk104_lmkin0_clk, --124.92MHz
    locked => open  
);





ps_pl: entity work.ps_io
  port map (
    pl_clock => pl_clk0, 
    pl_reset => not pl_resetn, 
    m_axi4_m2s => m_axi4_m2s, 
    m_axi4_s2m => m_axi4_s2m, 
    fp_leds => ps_leds,
    adc_data => adc_data,
    sa_data => sa_data,
    reg_o_tbt => reg_o_tbt,  
    reg_i_rfadcfifo => reg_i_rfadcfifo, 
    reg_o_rfadcfifo => reg_o_rfadcfifo, 	 
    reg_o_adcfifo => reg_o_adcfifo, 
	reg_i_adcfifo => reg_i_adcfifo,
	reg_o_tbtfifo => reg_o_tbtfifo, 
	reg_i_tbtfifo => reg_i_tbtfifo,
	reg_o_dma => reg_o_dma,
	reg_i_dma => reg_i_dma,
	reg_o_dsa => reg_o_dsa,
	reg_o_pll => reg_o_pll,
	reg_i_pll => reg_i_pll,
	reg_o_evr => reg_o_evr, 
	reg_i_evr => reg_i_evr,
	reg_i_freq => reg_i_freq
          
  );


  
  
rfadc_fifos:  entity work.rf_adc_fifos
  port map (
    pl_clk0 => pl_clk0,  
    pl_reset => pl_reset, 
    adc_clk => rfadc_axis_clk,  
    reg_i => reg_i_rfadcfifo, 
    reg_o => reg_o_rfadcfifo,  
    
    adc0_data => adc0_axis_tdata, 
    adc1_data => adc1_axis_tdata,   
    adc2_data => adc2_axis_tdata, 
    adc3_data => adc3_axis_tdata,
    adc4_data => adc4_axis_tdata, 
    adc5_data => adc5_axis_tdata,   
    adc6_data => adc6_axis_tdata, 
    adc7_data => adc7_axis_tdata     
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
      
    trignum => evr_dma_trignum, 
    trigdly => (x"00000001"), 
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


--temp drive dac data with counter
process(rfdac_axis_clk)
  begin
    if (rising_edge(rfdac_axis_clk)) then
      if (pl_reset = '1') then
        cnt <= 16d"0";
        dac0_axis_tdata <= 256d"0";
        dac0_axis_tvalid <= '0';
      else
        cnt <= std_logic_vector(unsigned(cnt) + 1);
        dac0_axis_tdata <= cnt & cnt & cnt & cnt & cnt & cnt & cnt & cnt & cnt & cnt & cnt & cnt & cnt & cnt & cnt & cnt;
        dac0_axis_tvalid <= '1';
      end if;
    end if;
end process;  
        



system_i: component system
  port map (
    pl_clk0 => pl_clk0,
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
    --adc resets
    m0_axis_aresetn => pl_resetn,  
    m1_axis_aresetn => pl_resetn,    
    m2_axis_aresetn => pl_resetn,  
    m3_axis_aresetn => pl_resetn,
    --adc clock input
    adc2_clk_clk_p => clk104_adc_refclk_p,
    adc2_clk_clk_n => clk104_adc_refclk_n,
    sysref_in_diff_p => clk104_pl_sysref_p,
    sysref_in_diff_n => clk104_pl_sysref_n,
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
    --adc clock input
    dac0_clk_clk_p => clk104_dac_refclk_p,
    dac0_clk_clk_n => clk104_dac_refclk_n,
    --sysref_in_diff_p => clk104_pl_sysref_p,
    --sysref_in_diff_n => clk104_pl_sysref_n,
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
    clk0 => rfdac_out_clk,  --pl_clk0,           --100MHz
    clk1 => clk104_lmkin0_clk, --124.92MHz 
    clk2 => clk104_pl_clk,     --426.724MHz
    clk3 => rfadc_out_clk,     --146.686MHz
    clk4 => rfadc_axis_clk,    --391.164MHz
    reg_i => reg_i_freq
  );
  






end behv;
