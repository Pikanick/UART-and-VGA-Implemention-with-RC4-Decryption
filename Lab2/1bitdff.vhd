library IEEE;
use IEEE.std_logic_1164.all;

entity dff_reg is 
 port(
		registerinput: in	std_logic;
		reset: in std_logic;
		clk: in std_logic;
		registeroutput: out std_logic
	);

end dff_reg;

architecture behaviour of dff_reg is
begin
		process(clk,reset) is
		begin
		if(reset='0') then
			registeroutput<='1';
		elsif rising_edge(clk) then
			registeroutput<=registerinput;
			end if;
	  end process;

end behaviour;

