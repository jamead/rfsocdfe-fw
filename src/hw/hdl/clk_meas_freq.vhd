

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library xil_defaultlib;
use xil_defaultlib.bpm_package.ALL;



entity clk_meas_freq is
  port (
    pl_clk0         : in std_logic; 
    reset           : in std_logic;    
    clk0            : in std_logic;
    clk1            : in std_logic;
    clk2            : in std_logic;
    clk3            : in std_logic;
    clk4            : in std_logic;
    reg_i           : out t_reg_i_freq 

 );
end clk_meas_freq;

architecture behv of clk_meas_freq is


  attribute mark_debug     : string;
  attribute mark_debug of reg_i: signal is "true"; 


begin

meas_clk0 : entity work.clk_freq_counter
    generic map (
      g_ref_clk_freq => 100000000
    )
    port map (
      ref_clk => pl_clk0,
      reset => reset,
      meas_freq => reg_i.clk0_freq,
      meas_clk => clk0
    );


meas_clk1 : entity work.clk_freq_counter
    generic map (
      g_ref_clk_freq => 100000000
    )
    port map (
      ref_clk => pl_clk0,
      reset => reset,
      meas_freq => reg_i.clk1_freq,
      meas_clk => clk1
    );

meas_clk2 : entity work.clk_freq_counter
    generic map (
      g_ref_clk_freq => 100000000
    )
    port map (
      ref_clk => pl_clk0,
      reset => reset,
      meas_freq => reg_i.clk2_freq,
      meas_clk => clk2
    );


meas_clk3 : entity work.clk_freq_counter
    generic map (
      g_ref_clk_freq => 100000000
    )
    port map (
      ref_clk => pl_clk0,
      reset => reset,
      meas_freq => reg_i.clk3_freq,
      meas_clk => clk3
    );


meas_clk4 : entity work.clk_freq_counter
    generic map (
      g_ref_clk_freq => 100000000
    )
    port map (
      ref_clk => pl_clk0,
      reset => reset,
      meas_freq => reg_i.clk4_freq,
      meas_clk => clk4
    );



end behv;