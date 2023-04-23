LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
--  This is a skeleton you can use for the win subblock.  This block determines
--  whether each of the 3 bets is a winner.  As described in the lab
--  handout, the first bet is a "straight-up" bet, teh second bet is 
--  a colour bet, and the third bet is a "dozen" bet.
--
--  This should be a purely combinational block.  There is no clock.
--  Remember the rules associated with Pattern 1 in the lectures.
--
---------------------------------------------------------------

ENTITY win IS
	PORT(spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
             bet1_value : in unsigned(5 downto 0); -- value for bet 1
             bet2_colour : in std_logic;  -- colour for bet 2
             bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
             bet1_wins : out std_logic;  -- whether bet 1 is a winner
             bet2_wins : out std_logic;  -- whether bet 2 is a winner
             bet3_wins : out std_logic); -- whether bet 3 is a winner
END win;


ARCHITECTURE behavioural OF win IS
--  Your code goes here
BEGIN
   process(spin_result_latched, bet1_value, bet2_colour, bet3_dozen)
	variable colour: std_logic;
	variable dozen: unsigned(1 downto 0);
	begin
	--spin_result_latched(0) = '0' --1=red, 0=black
	
	if ((((spin_result_latched >= 0) and (spin_result_latched <= 10)) or 
	((spin_result_latched >= 19) and (spin_result_latched <= 28))) and (spin_result_latched(0) = '0') ) then 
	colour := '0'; --red
	elsif((((spin_result_latched >= 0) and (spin_result_latched <= 10)) or 
	((spin_result_latched >= 19) and (spin_result_latched <= 28))) and (spin_result_latched(0) = '1') ) then 
	colour := '1'; --black
	end if;
	
	if ((((spin_result_latched >= 11) and (spin_result_latched <=18)) or 
	((spin_result_latched >= 29) and (spin_result_latched <= 36))) and (spin_result_latched(0) = '0') ) then 
	colour := '1'; --red
	elsif((((spin_result_latched >= 11) and (spin_result_latched <=18)) or 
	((spin_result_latched >= 29) and (spin_result_latched <= 36))) and (spin_result_latched(0) = '1') ) then 
	colour := '0'; --black
	end if;
	
--	if ((to_integer(spin_result_latched)= 1) OR 
--	(to_integer(spin_result_latched)= 3) OR 
--	(to_integer(spin_result_latched)= 5) OR 
--	(to_unsigned(spin_result_latched)= 7) OR 
--	(spin_result_latched= 9) OR 
--	(spin_result_latched= 19) OR 
--	(spin_result_latched= 21) OR 
--	(spin_result_latched= 23) OR 
--	(spin_result_latched= 25) OR 
--	(spin_result_latched= 27) OR 
--	(spin_result_latched= 12) OR 
--	(spin_result_latched= 14) OR 
--	(spin_result_latched= 16) OR 
--	(spin_result_latched= 18) OR 
--	(spin_result_latched= 30) OR 
--	(spin_result_latched= 32) OR 
--	(spin_result_latched= 34) OR 
--	(spin_result_latched= 36)) then -- red numbers
--	colour := '1';
--	
--	elsif((spin_result_latched= 2) OR 
--	(spin_result_latched= 4) OR 
--	(spin_result_latched= 6) OR 
--	(spin_result_latched= 8) OR 
--	(spin_result_latched= 10) OR 
--	(spin_result_latched= 20) OR 
--	(spin_result_latched= 22) OR 
--	(spin_result_latched= 24) OR 
--	(spin_result_latched= 26) OR 
--	(spin_result_latched= 28) OR 
--	(spin_result_latched= 11) OR 
--	(spin_result_latched= 13) OR 
--	(spin_result_latched= 15) OR 
--	(spin_result_latched= 17) OR 
--	(spin_result_latched= 29) OR 
--	(spin_result_latched= 31) OR 
--	(spin_result_latched= 33) OR 
--	(spin_result_latched= 35)) then    --black number  
--	colour := '0';
--	end if;
	
	if ((spin_result_latched >= 1) and (spin_result_latched <= 12)) then -- First Dozen
	dozen := "00";
	elsif((spin_result_latched >= 13) and (spin_result_latched <= 24)) then -- Second Dozen
	dozen := "01";
	elsif((spin_result_latched >= 25) and (spin_result_latched <= 36)) then -- Third Dozen
	dozen := "10";
	end if;
	
	if (bet1_value = spin_result_latched) then
	bet1_wins<='1';
	else
	bet1_wins<='0';
	end if;
	if (bet2_colour = colour ) then
	bet2_wins<='1';
	else
	bet2_wins<='0';
	end if;
	if (bet3_dozen = dozen ) then
	bet3_wins<='1';
	else
	bet3_wins<='0';
	end if;
	end process;
END;
