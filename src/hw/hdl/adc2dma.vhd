-------------------------------------------------------------------------------
-- adc2dma.vhd
-- Capture 20 ADC-clock samples per turn, for 1000 turns after a rising trigger.
-- adc_clk = 416.4 MHz; sys_clk = 200 MHz (FIFO read / width-converter clock).
--
-- TURN_CLOCKS is START-TO-START spacing: 20 capture clocks + 1080 idle clocks.
-- To wait 1100 idle clocks AFTER each capture instead, set TURN_CLOCKS = 1120.
-- First ADC sample is taken one adc_clk edge after synchronized trigger detect.
-- Triggers received while busy are ignored (not queued).
--
-- One acquisition = 20,000 x 768-bit words = 1,920,000 bytes.
-- TLAST marks ONLY the final word of the entire acquisition.
-- Configure axis_adc_fifo for independent clocks, 768-bit data, TLAST enabled,
-- normal FIFO mode. Arm the downstream DMA before triggering capture.
--
-- Original entity/record interface retained. reg_o.adc_len is intentionally
-- unused; the three constants below define this fixed acquisition pattern.
-- reg_o.testdata_enb is synchronized and latched when a trigger is accepted.
-- Test mode emits consecutive 64-bit values, lowest 64-bit lane first.
--
-- A one-word holding register preserves AXI payload under backpressure.
-- If a scheduled sample arrives while that register is blocked, capture stops
-- and capture_overflow latches high. Sampling is NEVER delayed to hide overflow.
-- The pending word is still transferred correctly, but the acquisition is
-- incomplete and has no final TLAST. dma_active stays high until reset.
-- Observe capture_overflow with ILA; reset/re-arm the full DMA path on failure.
--
-- dma_active is synchronized to sys_clk. It remains high through FIFO draining
-- until the final 768-bit word is accepted by the downstream width converter.
-- It is NOT the DMA-to-DDR completion indication: use the DMA done status/IRQ.
--
-- Both reset and reg_o.fifo_rst reset capture and FIFO. Keep both clocks running.
-- Coordinate resets with the downstream width converter and DMA.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.bpm_package.all;

entity adc2dma is
  port (
    sys_clk       : in  std_logic;
    adc_clk       : in  std_logic;
    reset         : in  std_logic;
    trig          : in  std_logic;
    reg_o         : in  t_reg_o_dma;
    adc0_data     : in  std_logic_vector(191 downto 0);
    adc1_data     : in  std_logic_vector(191 downto 0);
    adc2_data     : in  std_logic_vector(191 downto 0);
    adc3_data     : in  std_logic_vector(191 downto 0);
    dma_active    : out std_logic;
    dma_write     : out std_logic;
    m_axis_tdata  : out std_logic_vector(767 downto 0);
    m_axis_tkeep  : out std_logic_vector(95 downto 0);
    m_axis_tlast  : out std_logic;
    m_axis_tready : in  std_logic;
    m_axis_tvalid : out std_logic
  );
end entity adc2dma;

architecture rtl of adc2dma is
  constant CAPTURE_CLOCKS : positive := 20;
  constant TURN_CLOCKS    : positive := 1100;
  constant NUM_BURSTS     : positive := 10000;

  component axis_adc_fifo is
    port (
      s_axis_aresetn     : in  std_logic;
      s_axis_aclk        : in  std_logic;
      s_axis_tvalid      : in  std_logic;
      s_axis_tready      : out std_logic;
      s_axis_tdata       : in  std_logic_vector(767 downto 0);
      s_axis_tlast       : in  std_logic;
      m_axis_aclk        : in  std_logic;
      m_axis_tvalid      : out std_logic;
      m_axis_tready      : in  std_logic;
      m_axis_tdata       : out std_logic_vector(767 downto 0);
      m_axis_tlast       : out std_logic;
      axis_wr_data_count : out std_logic_vector(31 downto 0);
      axis_rd_data_count : out std_logic_vector(31 downto 0)
    );
  end component;

  type wr_state_type is (IDLE, RUN, DRAIN, FAULT);
  signal wr_state : wr_state_type := IDLE;
  signal turn_count  : natural range 0 to TURN_CLOCKS - 1 := 0;
  signal burst_count : natural range 0 to NUM_BURSTS - 1 := 0;

  signal reset_req, adc_reset_req : std_logic;
  signal sys_reset_pipe : std_logic_vector(15 downto 0) := (others => '1');
  signal adc_reset_pipe : std_logic_vector(3 downto 0) := (others => '1');
  signal sys_rst, adc_rst, fifo_aresetn : std_logic;

  signal trig_sync : std_logic_vector(1 downto 0) := (others => '0');
  signal trig_d : std_logic := '0';
  signal test_sync : std_logic_vector(1 downto 0) := (others => '0');
  signal test_enable : std_logic := '0';
  signal test_base : unsigned(63 downto 0) := (others => '0');

  signal s_axis_tdata : std_logic_vector(767 downto 0) := (others => '0');
  signal s_axis_tvalid, s_axis_tlast : std_logic := '0';
  signal s_axis_tready : std_logic;
  signal fifo_m_valid, fifo_m_last : std_logic;
  signal fifo_wrcnt, fifo_rdcnt : std_logic_vector(31 downto 0);

  signal busy_adc : std_logic;
  signal busy_sync : std_logic_vector(1 downto 0) := (others => '0');
  signal done_toggle : std_logic := '0';
  signal done_sync : std_logic_vector(1 downto 0) := (others => '0');
  signal done_at_start : std_logic := '0';
  signal capture_overflow : std_logic := '0';

  attribute ASYNC_REG : string;
  attribute ASYNC_REG of sys_reset_pipe : signal is "TRUE";
  attribute ASYNC_REG of adc_reset_pipe : signal is "TRUE";
  attribute ASYNC_REG of trig_sync : signal is "TRUE";
  attribute ASYNC_REG of test_sync : signal is "TRUE";
  attribute ASYNC_REG of busy_sync : signal is "TRUE";
  attribute ASYNC_REG of done_sync : signal is "TRUE";

  attribute mark_debug : string;
  attribute mark_debug of wr_state : signal is "true";
  attribute mark_debug of turn_count : signal is "true";
  attribute mark_debug of burst_count : signal is "true";
  attribute mark_debug of capture_overflow : signal is "true";
  attribute mark_debug of s_axis_tvalid : signal is "true";
  attribute mark_debug of s_axis_tready : signal is "true";
  attribute mark_debug of s_axis_tlast : signal is "true";
  attribute mark_debug of fifo_wrcnt : signal is "true";
  attribute mark_debug of fifo_rdcnt : signal is "true";
  attribute mark_debug of trig_d: signal is "true";


  

begin

dma_write <= s_axis_tvalid;


  assert CAPTURE_CLOCKS <= TURN_CLOCKS
    report "CAPTURE_CLOCKS must not exceed TURN_CLOCKS" severity failure;

  -- Asynchronous assertion, synchronous release in each domain. Holding sys_rst
  -- for 16 read clocks also ensures an adequate FIFO reset duration.
  reset_req <= reset or reg_o.fifo_rst;
  sys_rst <= sys_reset_pipe(15);
  adc_reset_req <= reset_req or sys_rst;
  adc_rst <= adc_reset_pipe(3);
  fifo_aresetn <= not adc_rst;

  process (sys_clk, reset_req)
  begin
    if reset_req = '1' then
      sys_reset_pipe <= (others => '1');
    elsif rising_edge(sys_clk) then
      sys_reset_pipe <= sys_reset_pipe(14 downto 0) & '0';
    end if;
  end process;

  process (adc_clk, adc_reset_req)
  begin
    if adc_reset_req = '1' then
      adc_reset_pipe <= (others => '1');
    elsif rising_edge(adc_clk) then
      adc_reset_pipe <= adc_reset_pipe(2 downto 0) & '0';
    end if;
  end process;

  -- trig must remain high long enough to be sampled (at least 2 adc_clk periods
  -- for an asynchronous source); short pulses require a source-domain stretcher
  -- or toggle handshake. Hold testdata_enb stable before asserting trig.
--  process (adc_clk, adc_rst)
--  begin
--    if adc_rst = '1' then
--      trig_sync <= (others => '0');
--      trig_d <= '0';
--      test_sync <= (others => '0');
--      done_sync <= (others => '0');
--    elsif rising_edge(adc_clk) then
--      trig_sync <= trig_sync(0) & trig;
--      trig_d <= trig_sync(1);
--      test_sync <= test_sync(0) & reg_o.testdata_enb;
--      done_sync <= done_sync(0) & done_toggle;
--    end if;
--  end process;

  busy_adc <= '0' when wr_state = IDLE else '1';
  dma_active <= busy_sync(1);
  m_axis_tkeep <= (others => '1'); -- 96 valid bytes, not just x"FF"!
  m_axis_tvalid <= fifo_m_valid;
  m_axis_tlast <= fifo_m_last;

  process (sys_clk, sys_rst)
  begin
    if sys_rst = '1' then
      busy_sync <= (others => '0');
      done_toggle <= '0';
    elsif rising_edge(sys_clk) then
      busy_sync <= busy_sync(0) & busy_adc;
      if fifo_m_valid = '1' and m_axis_tready = '1' and fifo_m_last = '1' then
        done_toggle <= not done_toggle;
      end if;
    end if;
  end process;

  adc_fifo : axis_adc_fifo
    port map (
      s_axis_aresetn     => fifo_aresetn,
      s_axis_aclk        => adc_clk,
      s_axis_tvalid      => s_axis_tvalid,
      s_axis_tready      => s_axis_tready,
      s_axis_tdata       => s_axis_tdata,
      s_axis_tlast       => s_axis_tlast,
      m_axis_aclk        => sys_clk,
      m_axis_tvalid      => fifo_m_valid,
      m_axis_tready      => m_axis_tready,
      m_axis_tdata       => m_axis_tdata,
      m_axis_tlast       => fifo_m_last,
      axis_wr_data_count => fifo_wrcnt,
      axis_rd_data_count => fifo_rdcnt
    );

  process (adc_clk, adc_rst)
  begin
    if adc_rst = '1' then
      wr_state <= IDLE;
      turn_count <= 0;
      burst_count <= 0;
      s_axis_tdata <= (others => '0');
      s_axis_tvalid <= '0';
      s_axis_tlast <= '0';
      test_enable <= '0';
      test_base <= (others => '0');
      done_at_start <= '0';
      capture_overflow <= '0';
    elsif rising_edge(adc_clk) then
      -- Retire the previous registered word. A new scheduled sample below can
      -- replace it on the same edge, permitting one sample per ADC clock.
      if s_axis_tvalid = '1' and s_axis_tready = '1' then
        s_axis_tvalid <= '0';
        s_axis_tlast <= '0';
      end if;

      case wr_state is
        when IDLE =>
          if trig = '1' then --trig_sync(1) = '1' and trig_d = '0' then
            turn_count <= 0;
            burst_count <= 0;
            test_base <= (others => '0');
            test_enable <= test_sync(1);
            done_at_start <= done_sync(1);
            wr_state <= RUN;
          end if;

        when RUN =>
          -- Clock-based scheduling: phases 0..19 capture; 20..1099 wait.
          -- Neither the phase nor the burst spacing depends on TREADY.
          if turn_count = TURN_CLOCKS - 1 then
            turn_count <= 0;
            if burst_count < NUM_BURSTS - 1 then
              burst_count <= burst_count + 1;
            end if;
          else
            turn_count <= turn_count + 1;
          end if;

          if turn_count < CAPTURE_CLOCKS then
            if s_axis_tvalid = '0' or s_axis_tready = '1' then
              if test_enable = '1' then
                for lane in 0 to 11 loop
                  s_axis_tdata(64 * lane + 63 downto 64 * lane) <=
                    std_logic_vector(test_base + to_unsigned(lane, 64));
                end loop;
                test_base <= test_base + to_unsigned(12, 64);
              else
                -- Retain the original intended channel packing:
                -- [767:576]=ADC3, [575:384]=ADC1,  [383:192]=ADC2, [191:0]=ADC0.
                s_axis_tdata <= adc3_data & adc2_data & adc1_data & adc0_data;
              end if;
              s_axis_tvalid <= '1';
              s_axis_tlast <= '0';

              if burst_count = NUM_BURSTS - 1 and
                 turn_count = CAPTURE_CLOCKS - 1 then
                s_axis_tlast <= '1';
                wr_state <= DRAIN;
              end if;
            else
              -- Preserve the blocked AXI word. The new real-time sample cannot
              -- be stored, so flag the acquisition invalid and require reset.
              capture_overflow <= '1';
              wr_state <= FAULT;
              -- synthesis translate_off
              assert false report "adc2dma overflow: reset and re-arm acquisition"
                severity warning;
              -- synthesis translate_on
            end if;
          end if;

        when DRAIN =>
          if done_sync(1) /= done_at_start then
            wr_state <= IDLE;
          end if;

        when FAULT =>
          null; -- Sticky until reset or reg_o.fifo_rst.
      end case;
    end if;
  end process;
end architecture rtl;
