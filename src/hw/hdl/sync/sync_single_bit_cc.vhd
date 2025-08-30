-------------------------------------------------------------------------------
-- common library component: single bit synchonizer
-------------------------------------------------------------------------------
--! @copyright Copyright 2023 Brookhaven National Laboratory
------------------------------------------------------------------------------
--! @date 2023-10-20
--! @author Kevin Mernick   <kmernick@bnl.gov>
------------------------------------------------------------------------------
--! @brief
--! single bit synchronizer - N-stage chained flip-flop synchronizer
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_single_bit_cc is
  generic (
    g_stages : integer := 2
  );
  port (
    clk : in std_logic;
    din : in std_logic;
    dout : out std_logic
  );
end sync_single_bit_cc;

architecture rtl of sync_single_bit_cc is
  signal p : std_logic_vector(g_stages-1 downto 0);
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of p : signal is "TRUE";

begin
  process(clk)
  begin
    if rising_edge(clk) then
      p(g_stages - 1) <= din;
      for i in (g_stages - 1) downto 1 loop
        p(i - 1) <= p(i);
      end loop;
    end if;
  end process;

  dout <= p(0);
end architecture rtl;
