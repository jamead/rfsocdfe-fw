library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trigger_sync is
  generic (
    DELAY_WIDTH : positive := 16
  );
  port (
    adc_clk           : in  std_logic;
    adc_rst           : in  std_logic;

    tbt_trig          : in  std_logic;
    soft_trig         : in  std_logic;

    -- Delay settings, in ADC clock cycles.
    fifo_delay        : in  std_logic_vector(DELAY_WIDTH-1 downto 0);
    dma_delay         : in  std_logic_vector(DELAY_WIDTH-1 downto 0);

    -- One-ADC-clock trigger pulses.
    sync_trig_out_fifo : out std_logic := '0';
    sync_trig_out_dma  : out std_logic := '0';

    -- High while waiting for TbT or either delayed output.
    armed             : out std_logic := '0'
  );
end entity trigger_sync;

architecture rtl of trigger_sync is

  type state_type is (IDLE, WAIT_TBT, DELAY_TRIGGERS);
  signal state : state_type := IDLE;

  signal tbt_sync  : std_logic_vector(1 downto 0) := (others => '0');
  signal soft_sync : std_logic_vector(1 downto 0) := (others => '0');
  signal tbt_d     : std_logic := '0';
  signal soft_d    : std_logic := '0';

  signal fifo_count : unsigned(DELAY_WIDTH-1 downto 0)
                    := (others => '0');
  signal dma_count  : unsigned(DELAY_WIDTH-1 downto 0)
                    := (others => '0');

  signal fifo_pending : std_logic := '0';
  signal dma_pending  : std_logic := '0';

  attribute ASYNC_REG : string;
  attribute ASYNC_REG of tbt_sync  : signal is "TRUE";
  attribute ASYNC_REG of soft_sync : signal is "TRUE";


  attribute MARK_DEBUG : string;
  attribute MARK_DEBUG of tbt_sync  : signal is "TRUE";
  attribute MARK_DEBUG of tbt_d     : signal is "TRUE";
  attribute MARK_DEBUG of soft_sync : signal is "TRUE";
  attribute MARK_DEBUG of soft_d    : signal is "TRUE";
  attribute MARK_DEBUG of fifo_delay  : signal is "TRUE";
  attribute MARK_DEBUG of dma_delay  : signal is "TRUE";
  attribute MARK_DEBUG of state : signal is "TRUE";
  attribute MARK_DEBUG of armed : signal is "TRUE";
  attribute MARK_DEBUG of fifo_count : signal is "TRUE";
  attribute MARK_DEBUG of dma_count  : signal is "TRUE";
  attribute MARK_DEBUG of fifo_pending : signal is "TRUE";
  attribute MARK_DEBUG of dma_pending  : signal is "TRUE";
  attribute MARK_DEBUG of sync_trig_out_fifo : signal is "TRUE";
  attribute MARK_DEBUG of sync_trig_out_dma  : signal is "TRUE";



begin

  process (adc_clk)
  begin
    if rising_edge(adc_clk) then
      if adc_rst = '1' then
        tbt_sync          <= (others => '0');
        soft_sync         <= (others => '0');
        tbt_d             <= '0';
        soft_d            <= '0';

        fifo_count        <= (others => '0');
        dma_count         <= (others => '0');
        fifo_pending      <= '0';
        dma_pending       <= '0';

        sync_trig_out_fifo <= '0';
        sync_trig_out_dma  <= '0';
        armed              <= '0';
        state              <= IDLE;

      else
        -- Synchronize trigger inputs into the ADC clock domain.
        tbt_sync  <= tbt_sync(0) & tbt_trig;
        soft_sync <= soft_sync(0) & soft_trig;

        tbt_d  <= tbt_sync(1);
        soft_d <= soft_sync(1);

        -- Default: each output pulse lasts one ADC clock.
        sync_trig_out_fifo <= '0';
        sync_trig_out_dma  <= '0';

        case state is

          when IDLE =>
            if soft_sync(1) = '1' and soft_d = '0' then
              -- Latch both delay settings for this acquisition.
              fifo_count <= unsigned(fifo_delay);
              dma_count  <= unsigned(dma_delay);

              fifo_pending <= '0';
              dma_pending  <= '0';

              armed <= '1';
              state <= WAIT_TBT;
            end if;

          when WAIT_TBT =>
            if tbt_sync(1) = '1' and tbt_d = '0' then

              -- Zero delay fires on this detected TbT edge.
              if fifo_count = 0 then
                sync_trig_out_fifo <= '1';
                fifo_pending      <= '0';
              else
                fifo_pending <= '1';
              end if;

              if dma_count = 0 then
                sync_trig_out_dma <= '1';
                dma_pending      <= '0';
              else
                dma_pending <= '1';
              end if;

              if fifo_count = 0 and dma_count = 0 then
                armed <= '0';
                state <= IDLE;
              else
                state <= DELAY_TRIGGERS;
              end if;
            end if;

          when DELAY_TRIGGERS =>
            -- Countdown starts on the clock after TbT detection.
            if fifo_pending = '1' then
              if fifo_count = 1 then
                sync_trig_out_fifo <= '1';
                fifo_pending      <= '0';
                fifo_count        <= (others => '0');
              else
                fifo_count <= fifo_count - 1;
              end if;
            end if;

            if dma_pending = '1' then
              if dma_count = 1 then
                sync_trig_out_dma <= '1';
                dma_pending      <= '0';
                dma_count        <= (others => '0');
              else
                dma_count <= dma_count - 1;
              end if;
            end if;

            -- Both outputs have fired, or finish on this edge.
            if (fifo_pending = '0' or fifo_count = 1) and
               (dma_pending = '0' or dma_count = 1) then
              armed <= '0';
              state <= IDLE;
            end if;

        end case;
      end if;
    end if;
  end process;

end architecture rtl;