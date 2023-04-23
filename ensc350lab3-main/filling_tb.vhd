library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filling_tb is
  -- no inputs or outputs
end entity;

architecture tb of filling_tb is

   -- We will use an array of records to hold a list of test vectors and expected outputs.
   -- This simplifies adding more tests; we just have to add another line in the array.
   -- Each element of the array is a record that corresponds to one test vector.
   
   -- Define the record that describes one test vector

	 
	component lab3_filling is
	
	  port(CLOCK_50, reset     : in  std_logic;
			 colour 					: out std_logic_vector(2 downto 0);
			 xpos						: out std_logic_vector(7 downto 0);
			 ypos						: out std_logic_vector(6 downto 0);
			 plot						: out std_logic;
			 fillDone				: out std_logic);
			 
	end component;

	 
	 -- local signals we will use in the testbench 
	 
	 
    signal clk : std_logic := '1';
	 
    signal reset : std_logic := '0';
	
	
	 signal plot : std_logic := '0';
	 
	 signal fillDone : std_logic := '0';
	 
	 
    signal xpos : std_logic_vector(7 downto 0);
	 
    signal ypos : std_logic_vector(6 downto 0);
	 
    signal colour : std_logic_vector(2 downto 0);
	 
	 

begin

	-- instantiate the design-under-test

    DUT : lab3_filling
	 
        port map(CLOCK_50 => clk, xpos => xpos, ypos => ypos, colour => colour,
            reset => reset, fillDone => fillDone);

    clk <= not clk after 5 ns; -- generate the clock pulses
	 
	 
	 
process 
	 
	 begin

        reset <= '1';
		  
        wait for 20 ns;
		  
        reset <= '0';
		  
        wait for 20 ns; -- 10 ns clock cycle
		  
        for i in 0 to 19199 loop
		  
				wait for 10 ns;
				
        end loop; 
	 
	-- Code to drive inputs and check outputs.  This is written by one process.
   -- Note there is nothing in the sensitivity list here; this means the process is
   -- executed at time 0.  It would also be restarted immediately after the process
   -- finishes, however, in this case, the process will never finish (because there is
   -- a wait statement at the end of the process).

	 end process;
end architecture;