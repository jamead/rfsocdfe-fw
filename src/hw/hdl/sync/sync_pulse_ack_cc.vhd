-------------------------------------------------------------------------------
-- common library component: pulse synchonizer with handshake
-------------------------------------------------------------------------------
--! @copyright Copyright 2023 Brookhaven National Laboratory
------------------------------------------------------------------------------
--! @date 2023-10-20
--! @author Kevin Mernick   <kmernick@bnl.gov>
------------------------------------------------------------------------------
--! @brief
--! pulse synchronizer - pulse stretched until acknowledge sent back
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library bnl_cp;

entity sync_pulse_ack_cc is
  generic (
    g_stages : integer := 2
  );
  port (
    src_clk : in std_logic;
    src_reset : in std_logic;
    src_pulse : in std_logic;
    src_busy : out std_logic;
    rcv_clk : in std_logic;
    rcv_pulse : out std_logic
  );
end sync_pulse_ack_cc;

architecture rtl of sync_pulse_ack_cc is
  -- src_clk domain
  signal s_req : std_logic := '0';
  signal s_ack : std_logic;

  -- rcv_clk domain
  signal r_req : std_logic;
  signal r_req_d : std_logic := '0';

begin
  src_busy <= s_req or s_ack;
  rcv_pulse <= r_req and not r_req_d;

  process(src_clk)
  begin
    if rising_edge(src_clk) then
      if src_reset = '1' then
        s_req <= '0';
      elsif src_pulse = '1' then
        s_req <= '1';
      elsif s_ack = '1' then
        s_req <= '0';
      end if;
    end if;
  end process;

  inst_req_sync : entity work.sync_single_bit_cc
  generic map (
    g_stages => g_stages
  )
  port map (
    clk => rcv_clk,
    din => s_req,
    dout => r_req
  );

  process(rcv_clk)
  begin
    if rising_edge(rcv_clk) then
      r_req_d <= r_req;
    end if;
  end process;

  inst_ack_sync : entity work.sync_single_bit_cc
  generic map (
    g_stages => g_stages
  )
  port map (
    clk => src_clk,
    din => r_req,
    dout => s_ack
  );

end architecture rtl;