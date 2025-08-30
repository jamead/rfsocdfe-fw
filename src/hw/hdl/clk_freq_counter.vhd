-------------------------------------------------------------------------------
-- counts edges of a clock using another clock as reference
-------------------------------------------------------------------------------
--! @copyright Copyright 2023 Brookhaven National Laboratory
------------------------------------------------------------------------------
--! @date 2023-10-20
--! @author Kevin Mernick   <kmernick@bnl.gov>
------------------------------------------------------------------------------
--! @brief
--! generates a one second window from a reference clock and counts clock
--! pulses for a second clock within that window
--!
--! requires false path or max delay constraints (for latch_count to 
--! freq_reg CDC) and internal to sync_pulse_ack_cc components
-- In Vivado:
-- set_false_path \
--     -from [get_pins -filter {REF_PIN_NAME==C} -of_objects \
--             [get_cells -hierarchical -filter {NAME=~<PATH_TO_MODULE>/inst_sync_*/s_req_reg*}]] \
--     -to [get_pins -filter {REF_PIN_NAME==D} -of_objects \
--             [get_cells -hierarchical -filter {NAME=~<PATH_TO_MODULE>/inst_sync_*/p_reg*}]]
-- set_false_path \
--     -from [get_pins -filter {REF_PIN_NAME==C} -of_objects \
--             [get_cells -hierarchical -filter {NAME=~<PATH_TO_MODULE>/inst_sync_*/inst_req_sync/p_reg*}]] \
--     -to [get_pins -filter {REF_PIN_NAME==D} -of_objects \
--             [get_cells -hierarchical -filter {NAME=~<PATH_TO_MODULE>/inst_sync_*/inst_ack_sync/p_reg*}]]
-- set_max_delay \
--     -from [get_pins -filter {REF_PIN_NAME==C} -of_objects \
--             [get_cells -hierarchical -filter {NAME=~<PATH_TO_MODULE>/latch_count_reg*}]] \
--     -to [get_pins -filter {REF_PIN_NAME==D} -of_objects \
--             [get_cells -hierarchical -filter {NAME=~<PATH_TO_MODULE>/freq_reg_reg*}]] \
--      -datapath_only 10.0
-- 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity clk_freq_counter is
  generic (
    g_ref_clk_freq : integer := 100000000; -- in Hz
    g_count_width : integer := 32
  );
  port (
    ref_clk : in std_logic;
    reset : in std_logic;
    meas_freq : out std_logic_vector(g_count_width-1 downto 0);

    meas_clk : in std_logic
  );
end clk_freq_counter;

architecture rtl of clk_freq_counter is
  -- ref_clk clock domain signals
  signal prescale_tc : std_logic;
  signal freq_reg : std_logic_vector(g_count_width-1 downto 0) := (others => '0');
  signal latch_freq : std_logic;

  -- meas_clk clock domain signals
  signal counter : std_logic_vector(g_count_width-1 downto 0);
  signal latch_count : std_logic_vector(g_count_width-1 downto 0) := (others => '0');
  signal latch_req : std_logic;

  attribute ASYNC_REG : string;
  attribute ASYNC_REG of freq_reg : signal is "true";
begin
  meas_freq <= freq_reg;

  inst_prescale : entity work.counter_prescale
    generic map (
      g_counter_width => g_count_width
    )
    port map (
      clk => ref_clk,
      reset => reset,
      prescale => std_logic_vector(to_unsigned(g_ref_clk_freq, g_count_width)),
      tc => prescale_tc
    );

  inst_sync_req : entity work.sync_pulse_ack_cc
    port map (
      src_clk => ref_clk,
      src_reset => reset,
      src_pulse => prescale_tc,
      rcv_clk => meas_clk,
      rcv_pulse => latch_req
    );

  p_freq_count : process(meas_clk)
  begin
    if rising_edge(meas_clk) then
      if latch_req = '1' then
        counter <= (others => '0');
        latch_count <= std_logic_vector(unsigned(counter) + 1);
      else
        counter <= std_logic_vector(unsigned(counter) + 1);
      end if;
    end if;
  end process;

  inst_sync_latch : entity work.sync_pulse_ack_cc
    port map (
      src_clk => meas_clk,
      src_reset => '0',
      src_pulse => latch_req,
      rcv_clk => ref_clk,
      rcv_pulse => latch_freq
    );

  p_freq_reg : process(ref_clk)
  begin
    if rising_edge(ref_clk) then
      if reset = '1' then
        freq_reg <= (others => '0');
      elsif latch_freq = '1' then
        freq_reg <= latch_count;
      end if;
    end if;
  end process;

end architecture rtl;

