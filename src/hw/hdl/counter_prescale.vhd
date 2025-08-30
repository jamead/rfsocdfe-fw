-------------------------------------------------------------------------------
-- common library component: prescaler counter
-------------------------------------------------------------------------------
--! @copyright Copyright 2023 Brookhaven National Laboratory
------------------------------------------------------------------------------
--! @date 2023-10-20
--! @author Kevin Mernick   <kmernick@bnl.gov>
------------------------------------------------------------------------------
--! @brief
--! prescaler counter - generate a pulse at rate determined by counter
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_prescale is
  generic (
    g_counter_width : integer := 32
  );
  port (
    clk : in std_logic;
    reset : in std_logic;
    prescale : in std_logic_vector(g_counter_width-1 downto 0);
    tc : out std_logic
  );
end counter_prescale;

architecture rtl of counter_prescale is
  signal count : std_logic_vector(g_counter_width-1 downto 0) := (others => '0');
  signal tc_i : std_logic := '0';
begin
  tc <= tc_i;

  p_count : process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        count <= (others => '0');
        tc_i <= '0';
      elsif unsigned(count) = (unsigned(prescale) - 1) then
        count <= (others => '0');
        tc_i <= '1';
      else
        count <= std_logic_vector(unsigned(count) + 1);
        tc_i <= '0';
      end if;
    end if;
  end process;
  
end architecture rtl;

