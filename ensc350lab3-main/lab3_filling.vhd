library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3_filling is
    port(
        clk_i       : in  std_logic;
        reset       : in  std_logic;
        fill        : in  std_logic;
        colour 		: out std_logic_vector(2 downto 0);
        xpos        : out std_logic_vector(7 downto 0);
        ypos        : out std_logic_vector(6 downto 0);
        done_fill	: out std_logic);
end lab3_filling;

architecture behaviour of lab3_filling is

 -- 160 x 120 image
 
 -- [0, 0] [1, 0] ...... [159, 0]
 -- [0, 1] [1, 1] ...... [159, 1]
 --	.					.
 --	.					.
 --	.					.
 --[0,119] [1,119] ..... [159, 119]
 
 -- registers
signal iteratorX_reg : std_logic_vector(7 downto 0);
signal iteratorY_reg : std_logic_vector(6 downto 0);

-- internal signals
signal colourSig : std_logic_vector(7 downto 0);
signal fillFlag : std_logic;
signal iteratorX_en : std_logic;
signal iteratorY_en : std_logic;
 
begin

	loading : process(clk_i, reset) begin
		if(reset = '1') then -- asynch reset
			iteratorX_reg <= "00000000";
			iteratorY_reg <= "0000000";

		elsif(rising_edge(clk_i)) then -- register loading
			if(fill = '0') then
				iteratorX_reg <= "00000000";
				iteratorY_reg <= "0000000";
			end if;	
		
			if(iteratorX_en = '1') then
				iteratorX_reg <= std_logic_vector(unsigned(iteratorX_reg) + 1);
				iteratorY_reg <= "0000000";
			end if;
			
			if(fillFlag = '1') then
				iteratorX_reg <= "00000000";
			end if;
			
			if(iteratorY_en = '1') then
				if(iteratorY_reg >= std_logic_vector(to_unsigned(119, 7))) then
					iteratorY_reg <= "0000000";
				else
					iteratorY_reg <= std_logic_vector(unsigned(iteratorY_reg) + 1);
				end if;
			end if;
		end if;
	end process;

	fill_process : process(iteratorX_reg, iteratorY_reg, fillFlag, colourSig) begin
		if(unsigned(iteratorX_reg) <= 159) then
			if(unsigned(iteratorY_reg) < 119) then
				iteratorY_en <= '1';
				iteratorX_en <= '0';	
			else
				iteratorX_en <= '1';
				iteratorY_en <= '1';
			end if;	
		else
			iteratorX_en <= '0';
			iteratorY_en <= '0';
		end if;
	end process;

    xpos <= iteratorX_reg;
    ypos <= iteratorY_reg;
    colourSig <= std_logic_vector((unsigned(iteratorX_reg) mod 8));
    colour <= colourSig(2 downto 0); -- need to fix the colour bits
	
	fillFlag <= '1' when ((unsigned(iteratorX_reg) = 159) AND (unsigned(iteratorY_reg) = 119)) else '0';
	done_fill <= fillFlag;

end behaviour;
