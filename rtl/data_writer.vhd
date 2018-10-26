library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- writes out two data channels simultaneously over two lines for the two channels.
-- o_valid is high whenever it is sending data.

entity data_writer is
  generic (
    g_WORDSIZE : natural := 13
    );
  port (
    -- inputs
    i_data      : in std_logic_vector(2*g_WORDSIZE-1 downto 0);
    i_dataready : in std_logic;
    i_clk       : in std_logic;
    -- outputs
    o_data_1    : out std_logic := '1';
    o_data_2    : out std_logic := '1';
    o_valid     : out std_logic := '1';
    o_clk       : out std_logic
    );
end data_writer;


architecture behave of data_writer is
  -- state machine type:
  type t_State is (s_Idle, s_Busy);
  -- variables:
  signal r_State : t_State := s_Idle;
  signal r_Count : natural range 0 to g_WORDSIZE-1 := 0;
  signal r_Buffer : std_logic_vector(2*g_WORDSIZE-1 downto 0) := (others => '0');
begin

  o_clk <= not i_clk;
-- main program
  p_transmit : process (i_clk) is
  begin
    if rising_edge(i_clk) then
      if r_State = s_Idle then
        if i_dataready = '1' then
          r_State <= s_Busy;
          r_Count <= 0;
          r_Buffer <= i_data;
          -- immediately start first bit
          o_data_1 <= i_data(g_WORDSIZE-1);
          o_data_2 <= i_data(2*g_WORDSIZE-1);
        else
            o_data_1 <= '1';
            o_data_2 <= '1';
        end if;
		
      else
        if r_Count = g_WORDSIZE-2 then
          r_State <= s_Idle; -- make sure we start next transmission on next clock edge
        end if;	
        
        o_data_1 <= r_Buffer(g_WORDSIZE - r_Count - 2);
        o_data_2 <= r_Buffer(2*g_WORDSIZE - r_Count - 2);
        r_Count <= r_Count + 1;
      end if;
      o_valid <= i_dataready;
    end if; -- if rising_edge(i_clk)
  end process;
  
  
end behave;
