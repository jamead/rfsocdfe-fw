

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

library xil_defaultlib;
use xil_defaultlib.bpm_package.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rf_dac_awg is
  port (
    pl_clk0         : in std_logic; 
    dac_clk         : in std_logic;   
    reset           : in std_logic;

    reg_o           : in  t_reg_o_rfdac; 
    
    dac0_data       : out std_logic_vector(255 downto 0);
    dac1_data       : out std_logic_vector(255 downto 0);  
    dac2_data       : out std_logic_vector(255 downto 0);
    dac3_data       : out std_logic_vector(255 downto 0);
    dac4_data       : out std_logic_vector(255 downto 0);
    dac5_data       : out std_logic_vector(255 downto 0);  
    dac6_data       : out std_logic_vector(255 downto 0);
    dac7_data       : out std_logic_vector(255 downto 0)    
        
 );
end rf_dac_awg;

architecture behv of rf_dac_awg is

component dac_dpram IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(255 DOWNTO 0)
  );
end component;

  type     state_type is (IDLE, ACTIVE);                   
  signal   state   : state_type;   
 
  signal trig_sync  : std_logic_vector(2 downto 0) := (others => '0');
  signal trig_edge  : std_logic := '0';
  signal addr_cnt   : unsigned(13 downto 0) := (others => '0');
  signal addr       : std_logic_vector(9 downto 0);
  signal rdenb      : std_logic;
  signal doutb      : std_logic_vector(255 downto 0);

  
  attribute mark_debug     : string;
  attribute mark_debug of reg_o: signal is "true"; 
  attribute mark_debug of state: signal is "true";
  attribute mark_debug of addr: signal is "true";
  attribute mark_debug of dac0_data: signal is "true";
  attribute mark_debug of rdenb: signal is "true";
  attribute mark_debug of trig_sync: signal is "true";
  attribute mark_debug of trig_edge: signal is "true";

  
  
begin



dac0_dpram: entity work.dac_dpram 
  port map (
    clka => pl_clk0, 
    wea => (0 => reg_o.we),
    addra => reg_o.addr,
    dina => reg_o.data, 
    clkb => dac_clk, 
    enb => rdenb,  
    addrb => addr,  
    doutb => doutb
  );



process(dac_clk)
  begin
    if rising_edge(dac_clk) then
      dac0_data <= doutb;
    end if;
end process;






 -- Synchronize trigger pulse to clk domain and detect rising edge
process(dac_clk, reset)
  begin
    if rising_edge(dac_clk) then
      if reset = '1' then
        trig_sync <= (others => '0');
        trig_edge <= '0';
      else
        trig_sync <= trig_sync(1 downto 0) & reg_o.trig;
        trig_edge <= trig_sync(1) and not trig_sync(2); -- rising edge detect
      end if;
    end if;
end process;


-- Address counter: starts at 0 when triggered, counts up to NUMPTS-1
process(dac_clk, reset)
  begin
    if rising_edge(dac_clk) then
      if reset = '1' then
        addr_cnt <= (others => '0');
        rdenb <= '0';
        state <= idle;
      else
        case state is 
          when IDLE =>
            if trig_edge = '1' then
              addr_cnt <= (others => '0');
              rdenb <= '1';
              state <= active;
            end if;
            
          when ACTIVE =>
            if addr_cnt = unsigned(reg_o.numpts) - 1  then
              addr_cnt <= to_unsigned(0, addr_cnt'length);  -- restart from beginning
              state <= idle;
            else
              addr_cnt <= addr_cnt + 1;
            end if;
        
          when OTHERS => 
            state <= idle;
        
        end case;  
      end if;
    end if;
 end process;

addr <= std_logic_vector(addr_cnt(9 downto 0));



end behv;