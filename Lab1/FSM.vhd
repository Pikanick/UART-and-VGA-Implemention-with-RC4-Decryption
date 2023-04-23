LIBRARY ieee;
USE ieee.numeric_std.all; 
USE ieee.std_logic_1164.all;

entity FSM is 
	port (clock: in std_logic;
			reset: in std_logic;
			fsm : out std_logic_vector(7 downto 0);
			dir : in std_logic;
			--counter : out std_logic;
			fsm_type :out std_logic);
end FSM; 

architecture behaviour of FSM is
Type state_type is (A, B, G, D, E, F, N, I, C, O, R);
signal current_state : state_type;
--signal count: unsigned (4 downto 0) <= "00000";

signal rst: integer:=1;

begin
--process (current_state)
--	begin
--	count <= count +1; 
--	if (count = 16) then
--	--reset <= rst;
--	--count <= "00000";
--	count <=0;
--	current_state <= A;
--	end if;
--
--end process;
	process (reset, clock)
	--variable count: integer range 0 to 33;
	variable count:integer:=0;
		begin
		--count := 0;  
		if(reset = '1') then
		current_state <= A;
		--count <=0;
		elsif(rising_edge(clock)) then 
--		count <= count +1; 
--        if count = "1111" then
--            current_state <= A;
--            count <= "0000";     
--        end if; 
			CASE current_state is 
			when A=>
				fsm<= x"38";
				count :=0;
				current_state <= B;
				fsm_type <= '0';
			
			when B=>
				fsm<= x"38"; 
				current_state <= G;
				fsm_type <= '0';
			
			when G=>		
			   fsm<= x"0C"; 
				current_state <= D;
				fsm_type <= '0';
			
			when D=>		
				fsm<= x"01"; 
				current_state <= E;
				fsm_type <= '0';
			
			when E=>		
				fsm<= x"06"; 
				current_state <= F;
				fsm_type <= '0';
				
			when F=>		
				fsm<= x"80"; 
				current_state <= N;
				fsm_type <= '0';
				
			when N=>		
				fsm<= x"4E"; 
				fsm_type <= '1';
				
				if (dir = '0') then
					current_state <= I;
				elsif (dir = '1') then
					current_state <= O;
				end if;
				if (count = 55) then
				--counter <= '1';
				current_state <= A;
				end if;
				count :=count+1;
				
			when I=>		
				fsm<= x"69"; 
				fsm_type <= '1';
			
				
				if (dir = '0') then
					current_state <= C;
				elsif (dir = '1') then
					current_state <= N;
				end if;
					if (count = 55) then
				--counter <= '1';
				current_state <= A;
				end if;
				count :=count+1;
			when C=>		
				fsm<= x"63"; 
				fsm_type <= '1';
				
				
				if (dir = '0') then
					current_state <= O;
				elsif (dir = '1') then
					current_state <= I;
				end if;
				if (count = 55) then
				--counter <= '1';
				current_state <= A;
				end if;
				count :=count+1;
				
			when O=>		
				fsm<= x"6F"; 
				fsm_type <= '1';
				
				if (dir = '0') then
					current_state <= R;

				elsif (dir = '1') then
					current_state <= C;
				end if;
				if (count = 55) then
				--counter <= '1';
				current_state <= A;
				end if;
				
				count :=count+1;
				
			when R=>		
			fsm<= x"52"; 
			fsm_type <= '1';
--				count :=count+1;
				
			if (dir = '0') then
				current_state <= N;

			elsif (dir = '1') then
				current_state <= O;
			end if;
			if (count = 55) then
				--counter <= '1';
				current_state <= A;
				end if;
			count :=count+1;
		
		END CASE;
		--current_state <= current_state;
		end if;		
end process;
--fsm_type<= '1' when current_state = A else
--'1' when current_state = B else
-- '1' when current_state = G else
-- '1' when current_state = D else
-- '1' when current_state = E else
-- '1' when current_state = F else
-- '0' when current_state = N else
-- '0' when current_state = I else
-- '0' when current_state = C else
-- '0' when current_state = O;

end behaviour;