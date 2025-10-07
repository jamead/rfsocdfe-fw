

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.bpm_package.ALL;

entity pt_cntrl is
  port (
    evr_clk         : in std_logic;              
    evr_tbt_trig    : in std_logic;  
    reset	        : in std_logic; 
    inttrig_enb     : in  std_logic;
    tbt_trig        : out std_logic
  );    
end pt_cntrl;

architecture behv of pt_cntrl is
  
  signal tbt_trig_i      : std_logic;
  signal tbt_cnt         : std_logic_vector(8 downto 0);
  
  
  attribute mark_debug     : string;
  attribute mark_debug of tbt_trig_i: signal is "true"; 
  attribute mark_debug of evr_tbt_trig: signal is "true";
  attribute mark_debug of tbt_cnt: signal is "true";   
  attribute mark_debug of tbt_trig: signal is "true";

begin  



--select between evr or internal trigger.
tbt_trig  <= tbt_trig_i when (inttrig_enb = '0') else evr_tbt_trig;



--generate internal tbt_trig
process (evr_clk, reset)
  begin
    if (rising_edge(evr_clk))  then
      if (reset = '1') then
        tbt_trig_i <= '0';
        tbt_cnt <= 9d"0";
      else
        if (tbt_cnt = 9d"329") then
          tbt_trig_i <= '1';
          tbt_cnt <= 9d"0";
        else
          tbt_trig_i <= '0';
          tbt_cnt <= tbt_cnt + 1;
        end if;
      end if;
    end if;
end process;




  
end behv;
