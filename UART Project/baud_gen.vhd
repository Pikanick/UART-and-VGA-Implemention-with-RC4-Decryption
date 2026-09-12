library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;


entity baud_gen is

	generic(
		CLOCK			: 	integer := 50000000; -- Clock frequency that we use to generate Baud rate
		BAUD_RATE	:	integer := 9600 -- Our Baud rate to transmit/receive bits
	);

	port(
	
		clk_in		:	in std_logic;
		reset			:	in std_logic;
		
		baud_out		:	out std_logic
	
	);

end entity;


architecture bhv of baud_gen is

	-- The transmitter/receiver FSMs advance one bit per clk_in rising edge
	-- of baud_out directly (they don't do their own 16x oversampling), so
	-- baud_out needs to actually pulse at BAUD_RATE Hz. This used to be a
	-- hardcoded "count = 15", i.e. one pulse every 16 CLOCK_50 cycles =
	-- 3.125 MHz -- about 325x faster than 9600 baud, and completely
	-- disconnected from the BAUD_RATE generic. Compute it from the
	-- generics instead so a change to CLOCK or BAUD_RATE stays correct.
	constant CLKS_PER_BIT : integer := (CLOCK / BAUD_RATE) - 1;

begin

	process(reset, clk_in)
	
		variable count : integer := 0;
	
	begin
		
		if	(reset = '0') then
			
			count := 0; -- Reset counter
			baud_out <= '0'; -- Reset baud rate clock
		
		elsif (rising_edge(clk_in)) then
			
			-- If we are at Baud rate, then...
			if(count = CLKS_PER_BIT) then
			
				count := 0; -- Reset counter
				baud_out <= '1'; -- Activate baud_rate clock
			
			else
			
				count := count + 1; -- Else increment counter by one
				baud_out <= '0'; -- And maintain a baud clock of 0
	
			end if;
	
		end if;
	
	end process;

end architecture;