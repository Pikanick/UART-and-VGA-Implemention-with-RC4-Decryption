LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity six_bit_reg is
	port ( registerinput : in unsigned(5 downto 0);
	 reset: in std_logic;
	 clk: in std_logic;
	 registeroutput: out unsigned(5 downto 0)
	 );
end six_bit_reg;
architecture behaviour of six_bit_reg is
	begin
		process(clk,reset) is
		begin
		if(reset='0') then
			registeroutput<="000000";
		elsif rising_edge(clk) then
			registeroutput<=registerinput;
			end if;
	  end process;
end behaviour;