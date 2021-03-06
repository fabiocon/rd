--- Index counter module, keep track of current write index for the memory

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_counter is
    generic (g_SIZE : natural := 11);
    port (
        i_clk: in  std_logic;
        o_count: out  std_logic_vector(g_SIZE-1 downto 0));
end simple_counter;

architecture behavior of simple_counter is
	constant maxCount : integer := 2**g_SIZE-1;

	signal r_count : natural range 0 to maxCount := 0;

begin
	process(i_clk, r_count)
	begin
		if rising_edge(i_clk) then
			r_count <= (r_count + 1) mod (maxCount+1);
		end if;
	end process;

	o_count <= std_logic_vector(to_unsigned(r_count, o_count'length));
end;
