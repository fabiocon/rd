--- Simple clock_divider test

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divider is
  port (
    i_clk: in std_logic;
    o_clk: out std_logic);
end clock_divider;

architecture behavior of clock_divider is
  --constant MAX_COUNT : integer := 8; -- 40MHz clock / 8 = 5MHz
  constant MAX_COUNT : integer := 40; -- 40MHz clock / 40 = 1MHz
  --constant MAX_COUNT : integer := 347; -- 40MHz clock / 347 ~= 115200 baud

  signal r_count : natural range 0 to MAX_COUNT-1 := 0;

begin
  process(i_clk)
  begin
    if rising_edge(i_clk) then
      if r_count = MAX_COUNT-1 then
        r_count <= 0;
      else
        r_count <= (r_count+1);
      end if;
	  if r_count < MAX_COUNT/2 then
		o_clk <= '0';
	  else
		o_clk <= '1';
	  end if;
    end if;
  end process;
end;

