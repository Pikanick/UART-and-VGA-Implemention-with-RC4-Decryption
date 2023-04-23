LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY WORK;
USE WORK.ALL;

ENTITY Division_tb IS
  -- no inputs or outputs
END Division_tb;

-- The architecture part decribes the behaviour of the test bench

ARCHITECTURE behavioural OF Division_tb IS

   -- We will use an array of records to hold a list of test vectors and expected outputs.
   -- This simplifies adding more tests; we just have to add another line in the array.
   -- Each element of the array is a record that corresponds to one test vector.
   
   -- Define the record that describes one test vector
   
   TYPE test_case_record IS RECORD
	  --clock, reset, start : in STD_LOGIC;
 	  dividend :  STD_LOGIC_VECTOR (3 downto 0);     
	  divisor :  STD_LOGIC_VECTOR (3 downto 0);   
	  quotient :  STD_LOGIC_VECTOR (3 downto 0);    
	  remainder :  STD_LOGIC_VECTOR (3 downto 0);   
   END RECORD;

   -- Define a type that is an array of the record.

   TYPE test_case_array_type IS ARRAY (0 to 15) OF test_case_record;
     
   -- Define the array itself.  We will initialize it, one line per test vector.
   -- each line of the array is one record, and the 2 numbers in each
   -- line correspond to the 2 entries in the record.  one of these entries 
   -- represent inputs to apply, and the other represents the expected output.
	
	--(clock, reset, start, dividend, divisor, quotient, remainder)
	
   signal test_case_array : test_case_array_type := (
		("1100", "1001", "0001", "0011"),
		("1011", "0101", "0010", "0001"),
		("0101", "1000", "0000", "0101"),
		("0011", "1100", "0000", "0011"),
		("1000", "1111", "0000", "1000"),
		("0010", "1011", "0000", "0010"),
		("1010", "0101", "0010", "0000"),
		("1110", "0111", "0010", "0000"),
		("1101", "1000", "0001", "0101"),
		("1111", "0110", "0010", "0011"),
		("1001", "1101", "0000", "1001"),
		("0110", "0100", "0001", "0010"),
		("1100", "1110", "0000", "1100"),
		("0111", "1000", "0000", "0111"),
		("1011", "1110", "0000", "1011"),
		("0100", "1001", "0000", "0100")
         );             

  -- Define the digit7seg subblock, which is the component we are testing
  
     COMPONENT Division is
     Port (
	  clock, reset, start : in STD_LOGIC;
 	  dividend : in  STD_LOGIC_VECTOR (3 downto 0);     
	  divisor : in  STD_LOGIC_VECTOR (3 downto 0);   
	  quotient : out  STD_LOGIC_VECTOR (3 downto 0);    
	  remainder : out  STD_LOGIC_VECTOR (3 downto 0));   
     END COMPONENT;

   -- local signals we will use in the testbench 
	 signal clock: STD_LOGIC := '1';
	 signal reset, start : STD_LOGIC:= '0';
 	 signal dividend :  STD_LOGIC_VECTOR (3 downto 0);     
	 signal divisor :  STD_LOGIC_VECTOR (3 downto 0);   
	 signal quotient :  STD_LOGIC_VECTOR (3 downto 0);    
	 signal remainder :  STD_LOGIC_VECTOR (3 downto 0);   
		
    constant ClockFrequency : integer := 16e8; -- 100 MHz
    constant ClockPeriod    : time    := 1000 ms / ClockFrequency;

begin

   -- instantiate the design-under-test

   dut : Division PORT MAP(clock, reset, start, dividend, divisor, quotient, remainder);
	
	clock <= not clock after ClockPeriod / 2;
	
   -- Code to drive inputs and check outputs.  This is written by one process.
   -- Note there is nothing in the sensitivity list here; this means the process is
   -- executed at time 0.  It would also be restarted immediately after the process
   -- finishes, however, in this case, the process will never finish (because there is
   -- a wait statement at the end of the process).

   process
   begin      
      -- Loop through each element in our test case array.  Each element represents
      -- one test case (along with expected outputs).
      
      for i in test_case_array'low to test_case_array'high loop
		
		  -- Take the DUT to S0
		  reset <= '1';
		  start <= '0';
		  wait for 1 ns;
		  reset <= '0';
		  
		  -- Print information about the testcase to the transcript window (make sure when
        -- you run this, your transcript window is large enough to see what is happening)
        
        report "-------------------------------------------";
        report "Test case " & integer'image(i) & ":" &
                 " dividend= " & integer'image(to_integer(unsigned(test_case_array(i).dividend))) & "," &
					  " divisor= " & integer'image(to_integer(unsigned(test_case_array(i).divisor))) & ":";

        -- assign the values to the inputs of the DUT (design under test)

        dividend <= test_case_array(i).dividend; 
		  divisor <= test_case_array(i).divisor;  
		  start <= '1';		  

        -- wait for some time, to give the DUT circuit time to respond (1ns is arbitrary)                

        wait for 5 ns;
        
        -- now print the results along with the expected results
        
        report "Expected quotient= " &  
                    integer'image(to_integer(unsigned(test_case_array(i).quotient))) &
               ", Actual quotient= " &  
                    integer'image(to_integer(unsigned(quotient))) & " ," &
				   "Expected remainder= " &  
                    integer'image(to_integer(unsigned(test_case_array(i).remainder))) &
               ", Actual remainder= " &  
                    integer'image(to_integer(unsigned(remainder)));

        -- This assert statement causes a fatal error if there is a mismatch
                                                                    
        assert (unsigned(test_case_array(i).dividend) = unsigned(dividend) )
            report "MISMATCHED Dividends"
            severity failure;
		  
		  assert (unsigned(test_case_array(i).divisor) = unsigned(divisor) )
            report "MISMATCHED Divisors"
            severity failure;
	     
		  assert (unsigned(test_case_array(i).quotient) = unsigned(quotient) )
            report "MISMATCHED Quotients"
            severity failure;
		  
		  assert (unsigned(test_case_array(i).remainder) = unsigned(remainder) )
				report "MISMATCHED Remainders"
				severity failure;
				
      end loop;
                                           
      report "================== ALL TESTS PASSED =============================";
                                                                              
      wait; --- we are done.  Wait for ever
    end process;
end behavioural;

--LIBRARY ieee;
--USE ieee.std_logic_1164.all;
--USE ieee.numeric_std.all;
--
--LIBRARY WORK;
--USE WORK.ALL;
--
--ENTITY Division_tb IS
--  -- no inputs or outputs
--END Division_tb;
--
---- The architecture part decribes the behaviour of the test bench
--
--ARCHITECTURE behavioural OF Division_tb IS
--
--   -- We will use an array of records to hold a list of test vectors and expected outputs.
--   -- This simplifies adding more tests; we just have to add another line in the array.
--   -- Each element of the array is a record that corresponds to one test vector.
--   
--   -- Define the record that describes one test vector
--   
--   TYPE test_case_record IS RECORD
--	  --clock, reset, start : in STD_LOGIC;
-- 	  dividend :  STD_LOGIC_VECTOR (3 downto 0);     
--	  divisor :  STD_LOGIC_VECTOR (3 downto 0);   
--	  quotient :  STD_LOGIC_VECTOR (3 downto 0);    
--	  remainder :  STD_LOGIC_VECTOR (3 downto 0);   
--   END RECORD;
--
--   -- Define a type that is an array of the record.
--
--   TYPE test_case_array_type IS ARRAY (0 to 15) OF test_case_record;
--     
--   -- Define the array itself.  We will initialize it, one line per test vector.
--   -- each line of the array is one record, and the 2 numbers in each
--   -- line correspond to the 2 entries in the record.  one of these entries 
--   -- represent inputs to apply, and the other represents the expected output.
--	
--	--(clock, reset, start, dividend, divisor, quotient, remainder)
--	
----	     ("0000", "1000000"), --0
----      ("0001", "1111001"), --1
----      ("0010", "0100100"), --2
----      ("0011", "0110000"), --3
----      ("0100", "0011001"), --4
----      ("0101", "0010010"), --5                      
----      ("0110", "0000010"), --6 
----      ("0111", "1111000"), --7 
----      ("1000", "0000000"), --8
----	     ("1001", "0010000"), --9
----	     ("1010", "0001000"), --10
----	     ("1011", "0000011"), --11
----	     ("1100", "1000110"), --12
----	     ("1101", "0100001"), --13
----	     ("1110", "0000110"), --14
----	     ("1111", "0001110")  --15 
--	
--   signal test_case_array : test_case_array_type := (
--      ("0101", "1000", "0000", "1000"),
--		("1011", "1110", "0000", "1110"),
--		("0110", "1100", "0000", "1100"),
--		("0001", "0100", "0000", "0100"),
--		("1000", "0110", "0001", "0010"),
--		("0000", "0010", "0000", "0010"),
--		("1001", "1111", "0000", "1111"),
--		("1110", "1010", "0001", "0100"),
--		("0100", "1001", "0000", "1001"),
--		("0111", "0001", "0111", "0000"),
--		("0011", "0011", "0001", "0000"),
--		("1111", "0111", "0001", "1000"),
--		("1010", "1011", "0000", "1011"),
--		("1101", "0000", "1101", "0000"),
--		("0010", "1101", "0000", "1101"),
--		("1100", "0101", "0010", "0010")
--         );             
--
--  -- Define the digit7seg subblock, which is the component we are testing
--  
--     COMPONENT Division is
--     Port (
--	  clock, reset, start : in STD_LOGIC;
-- 	  dividend : in  STD_LOGIC_VECTOR (3 downto 0);     
--	  divisor : in  STD_LOGIC_VECTOR (3 downto 0);   
--	  quotient : out  STD_LOGIC_VECTOR (3 downto 0);    
--	  remainder : out  STD_LOGIC_VECTOR (3 downto 0));   
--     END COMPONENT;
--
--   -- local signals we will use in the testbench 
--	 signal clock: STD_LOGIC := '1';
--	 signal reset, start : STD_LOGIC:= '0';
-- 	 signal dividend :  STD_LOGIC_VECTOR (3 downto 0);     
--	 signal divisor :  STD_LOGIC_VECTOR (3 downto 0);   
--	 signal quotient :  STD_LOGIC_VECTOR (3 downto 0);    
--	 signal remainder :  STD_LOGIC_VECTOR (3 downto 0);   
--		
--    constant ClockFrequency : integer := 100e6; -- 100 MHz
--    constant ClockPeriod    : time    := 1000 ms / ClockFrequency;
--
--begin
--
--   -- instantiate the design-under-test
--
--   dut : Division PORT MAP(clock, reset, start, dividend, divisor, quotient, remainder);
--	
--	clock <= not clock after ClockPeriod / 2;
--	
--   -- Code to drive inputs and check outputs.  This is written by one process.
--   -- Note there is nothing in the sensitivity list here; this means the process is
--   -- executed at time 0.  It would also be restarted immediately after the process
--   -- finishes, however, in this case, the process will never finish (because there is
--   -- a wait statement at the end of the process).
--
--   process
--   begin      
--      -- Loop through each element in our test case array.  Each element represents
--      -- one test case (along with expected outputs).
--      
--      for i in test_case_array'low to test_case_array'high loop
--		
--		  -- Take the DUT to S0
--		  reset <= '1';
--		  start <= '0';
--		  wait for 2 ns;
--		  -- Take DUT to S1
--		  reset <= '0';
--		  start <= '1';
--        wait for 2 ns;
--        
--        -- Print information about the testcase to the transcript window (make sure when
--        -- you run this, your transcript window is large enough to see what is happening)
--        
--        report "-------------------------------------------";
--        report "Test case " & integer'image(i) & ":" &
--                 " dividend= " & integer'image(to_integer(unsigned(test_case_array(i).dividend))) & "," &
--					  " divisor= " & integer'image(to_integer(unsigned(test_case_array(i).divisor))) & "," &
--					  " quotient= " & integer'image(to_integer(unsigned(test_case_array(i).quotient))) & "," &
--					  " remainder= " & integer'image(to_integer(unsigned(test_case_array(i).remainder)));
--
--        -- assign the values to the inputs of the DUT (design under test)
--
--        dividend <= test_case_array(i).dividend; 
--		  divisor <= test_case_array(i).divisor;  
--		  quotient <= test_case_array(i).quotient;  
--		  remainder <= test_case_array(i).remainder;  		  
--
--        -- wait for some time, to give the DUT circuit time to respond (1ns is arbitrary)                
--
--        wait for 2 ns;
--        
--        -- now print the results along with the expected results
--        
--        report "Expected dividend= " &  
--                    integer'image(to_integer(unsigned(test_case_array(i).dividend))) &
--               ", Actual dividend= " &  
--                    integer'image(to_integer(unsigned(dividend))) & " ," &
--				   "Expected divisor= " &  
--                    integer'image(to_integer(unsigned(test_case_array(i).divisor))) &
--               ", Actual divisor= " &  
--                    integer'image(to_integer(unsigned(divisor))) & " ," &
--				   "Expected quotient= " &  
--                    integer'image(to_integer(unsigned(test_case_array(i).quotient))) &
--               ", Actual quotient= " &  
--                    integer'image(to_integer(unsigned(quotient))) & " ," &
--				   "Expected remainder= " &  
--                    integer'image(to_integer(unsigned(test_case_array(i).remainder))) &
--               ", Actual remainder= " &  
--                    integer'image(to_integer(unsigned(remainder)));
--
--        -- This assert statement causes a fatal error if there is a mismatch
--                                                                    
--        assert (unsigned(test_case_array(i).dividend) = unsigned(dividend) )
--            report "MISMATCHED Dividends"
--            severity failure;
--		  
--		  assert (unsigned(test_case_array(i).divisor) = unsigned(divisor) )
--            report "MISMATCHED Divisors"
--            severity failure;
--	     
--		  assert (unsigned(test_case_array(i).quotient) = unsigned(quotient) )
--            report "MISMATCHED Quotients"
--            severity failure;
--		  
--		  assert (unsigned(test_case_array(i).remainder) = unsigned(remainder) )
--				report "MISMATCHED Remainders"
--				severity failure;
--				
--      end loop;
--                                           
--      report "================== ALL TESTS PASSED =============================";
--                                                                              
--      wait; --- we are done.  Wait for ever
--    end process;
--end behavioural;