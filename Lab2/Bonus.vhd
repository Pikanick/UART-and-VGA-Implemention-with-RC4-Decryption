--Library IEEE;
--use IEEE.std_logic_1164.all;
--entity BCD is
--	port ( registerinput :in  std_logic_vector(11 downto 0) ;
--	 reset: in std_logic;
--	 --clk: in std_logic;
--	 out1: out unsigned;
--	 out2: out unsigned;
--	 out3: out unsigned;
--	 out4: out unsigned);
--end BCD;
--architecture behaviour of BCD is
--signal ones : integer;
--signal tens : integer;
--signal thousands : integer;
--signal hundreds : integer;
--
--	begin
--		process(reset) is
--		begin
--		if(reset='0') then
--			registeroutput<= "000000100000";
--		else 
--		--to_integer(registerinput)
--	 
--		--modloop : for k in 0 to registerinput'length loop
--      ones := registerinput mod 10;
--		tens := (registerinput/ 10)mod 10;
--		hundreds := (registerinput/ 100)mod 10;
--		thousands := (registerinput/ 1000)mod 10;
--		out1 <= to_unsigned(ones);
--		out2 <= to_unsigned(tens);
--		out3 <= to_unsigned(hundreds);
--		out4 <= to_unsigned(thousands);
--
--		end if;
--	  end process;
--end behaviour;
--    

Library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;
entity BCD is
	port ( registerinput :in  unsigned(11 downto 0);
			 registeroutput : out unsigned(15 downto 0));
end BCD;
architecture behaviour of BCD is
signal ones, tens, thousands, hundreds : unsigned(11 downto 0);
--signal onesout, tensout, thousandsout, hundredsout : unsigned(3 downto 0);

begin
      ones <= registerinput mod 10;
		tens <= ((registerinput mod 100)/ 10);
		hundreds <= ((registerinput mod 1000)/ 100);
		thousands <= registerinput / 1000;
		registeroutput <=(thousands(3 downto 0))&(hundreds(3 downto 0))&(tens(3 downto 0))&(ones(3 downto 0));
	  
end behaviour;
    
	 
	 
	 
	 