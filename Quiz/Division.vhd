library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE. NUMERIC_STD.ALL;

entity Division is
     Port (
	  clock, reset, start : in STD_LOGIC;
 	  dividend, divisor : in  STD_LOGIC_VECTOR (3 downto 0);     
	  quotient, remainder : out  STD_LOGIC_VECTOR (3 downto 0));   
end Division;
 
architecture Behavioral of Division is
	type state_type is (S0, S1);  
	signal current_state : state_type;   
	signal Done : std_logic := '0'; 
begin
	process (reset, clock, start, Done)
	variable extended_dividend : STD_LOGIC_VECTOR (7 downto 0):= "00000000";
	variable extension, dividendvar : STD_LOGIC_VECTOR (3 downto 0):= "0000";
	begin
		if rising_edge(clock) then 
			CASE current_state is 
				when S0=> --initialize registers and signals
					Done <='0';
					if start='0'  then 
						current_state <= S0;
					elsif start='1'  then
						dividendvar := dividend;
						extended_dividend:= extension & dividendvar;
						current_state <= S1;
					end if;
				when S1=> -- do logic
					if Done = '0' then
						for i in 3 downto 0  loop
							if extended_dividend (i+3 downto i) >= divisor(3 downto 0) then
								quotient(i) <= '1'; 
								extended_dividend(i+3 downto i) := std_logic_vector(unsigned(extended_dividend(i+3 downto i)) - unsigned(divisor(3 downto 0)));
							else
								quotient(i) <= '0'; 
							end if;
						end loop;
					end if;
					Done <='1';
					remainder <= extended_dividend(3 downto 0);
					if reset ='0' then 
						current_state <= S1;
					elsif reset ='1' then 
						current_state <= S0;
					end if;
			END CASE;
		end if;
	end process;
end Behavioral; 



--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE. NUMERIC_STD.ALL;
--
--entity Division is
--     Port (
--	  clock, reset, start : in STD_LOGIC;
-- 	  dividend : in  STD_LOGIC_VECTOR (3 downto 0);     
--	  divisor : in  STD_LOGIC_VECTOR (3 downto 0);   
--	  quotient : out  STD_LOGIC_VECTOR (3 downto 0);    
--	  remainder : out  STD_LOGIC_VECTOR (3 downto 0));   
--	--ready, ovfl : out STD_LOGIC
--	    -- Indicates end of algorithm and overflow condition
--end Division;
-- 
--architecture Behavioral of Division is
--type state_type is (S0, S1, S2);  
--signal current_state : state_type;   
--signal Done : std_logic := '0'; 
--begin
--
--	process (reset, clock, start, Done)
--	variable extended_dividend : STD_LOGIC_VECTOR (7 downto 0):= "00000000";
--	variable extension : STD_LOGIC_VECTOR (3 downto 0):= "0000";
--	variable dividendvar : STD_LOGIC_VECTOR (3 downto 0):= dividend;
--	begin
--		if reset='1' then
--			current_state <= S0;
--		elsif rising_edge(clock) then 
--			CASE current_state is 
--			when S0=>
--			--initialize registers and signals
--				Done <='0';
--				extended_dividend:= extension & dividendvar;
--				if start='0'  then 
--				current_state <= S0;
--				elsif start='1'  then 
--				current_state <= S1;
--				end if;
--			
--			when S1=>
--			-- do logic
--			for i in 3 downto 0  loop
--				if extended_dividend (i+3 downto i) >= divisor(3 downto 0) then
--				quotient(i) <= '1'; 
--				extended_dividend(i+3 downto i) := std_logic_vector(unsigned(extended_dividend (i+3 downto i)) - unsigned(divisor(3 downto 0)));
--				else
--				quotient(i) <= '0'; 
--				end if;
--				remainder <= extended_dividend(3 downto 0);
--			end loop;
--			Done <='1';
--			if Done='0' then 
--			current_state <= S1;
--			elsif Done ='1' then 
--			current_state <= S2;
--			end if;
--
--			when S2=>
--			-- do nothing and wait for next input
--				if reset ='0' then 
--				current_state <= S2;
--				elsif reset ='1' then 
--				current_state <= S0;
--				end if;
--			END CASE;
--		end if;
--	end process;
--end Behavioral;