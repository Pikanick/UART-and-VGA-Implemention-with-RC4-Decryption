Library IEEE;
use IEEE.std_logic_1164.all;
entity two_bit_reg is
	port ( registerinput :in  std_logic_vector(1 downto 0) ;
	 reset: in std_logic;
	 clk: in std_logic;
	 registeroutput: out std_logic_vector(1 downto 0)
	 );
end two_bit_reg;
architecture behaviour of two_bit_reg is
	begin
		process(clk,reset) is
		begin
		if(reset='0') then
			registeroutput<="00";
		elsif rising_edge(clk) then
			registeroutput<=registerinput;
			end if;
	  end process;
end behaviour;