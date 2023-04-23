Library IEEE;
use IEEE.std_logic_1164.all;
entity twelve_bit_reg is
	port ( registerinput :in  std_logic_vector(11 downto 0) ;
	 reset: in std_logic;
	 clk: in std_logic;
	 registeroutput: out std_logic_vector(11 downto 0)
	 );
end twelve_bit_reg;
architecture behaviour of twelve_bit_reg is
	begin
		process(clk,reset) is
		begin
		if(reset='0') then
			registeroutput<= "000000100000";
		elsif rising_edge(clk) then
			registeroutput<=registerinput;
			end if;
	  end process;
end behaviour;