-------------------------------------------------------------------------------
-- common library component: multibit register synchonizer with handshake
-------------------------------------------------------------------------------
--! @copyright Copyright 2023 Brookhaven National Laboratory
------------------------------------------------------------------------------
--! @date 2023-11-08
--! @author Kevin Mernick   <kmernick@bnl.gov>
------------------------------------------------------------------------------
--! @brief
--! register synchronizer - use req/ack synchronizer to transfer register value
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library bnl_cp;

entity sync_reg_ack_cc is
  generic (
    g_stages : integer := 2;
    g_reg_num_bits : integer := 16
  );
  port (
    src_clk : in std_logic;
    src_reset : in std_logic;
    src_pulse : in std_logic;
    src_reg : in std_logic_vector(g_reg_num_bits-1 downto 0);
    src_busy : out std_logic;
    rcv_clk : in std_logic;
    rcv_pulse : out std_logic;
    rcv_reg : out std_logic_vector(g_reg_num_bits-1 downto 0)
  );
end sync_reg_ack_cc;

architecture rtl of sync_reg_ack_cc is
  -- src_clk domain
  signal s_busy : std_logic;

  -- rcv_clk domain
  signal r_req : std_logic;

begin
  rcv_pulse <= r_req;
  src_busy <= s_busy;

  inst_req_sync : entity bnl_cp.sync_pulse_ack_cc
  generic map (
    g_stages => g_stages
  )
  port map (
    src_clk     => src_clk,
    src_reset   => src_reset,
    src_pulse   => src_pulse,
    src_busy    => s_busy,
    rcv_clk     => rcv_clk,
    rcv_pulse   => r_req
  );

  process(rcv_clk)
  begin
    if rising_edge(rcv_clk) then
      if r_req = '1' then
        rcv_reg <= src_reg;
      end if;
    end if;
  end process;

end architecture rtl;