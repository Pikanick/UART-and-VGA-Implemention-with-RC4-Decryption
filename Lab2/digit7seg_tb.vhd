LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY WORK;
USE WORK.ALL;


ENTITY digit7seg_tb IS
  -- no inputs or outputs
END digit7seg_tb;

-- The architecture part decribes the behaviour of the test bench

ARCHITECTURE behavioural OF digit7seg_tb IS

   -- We will use an array of records to hold a list of test vectors and expected outputs.
   -- This simplifies adding more tests; we just have to add another line in the array.
   -- Each element of the array is a record that corresponds to one test vector.
   
   -- Define the record that describes one test vector
   
   TYPE test_case_record IS RECORD
      digit : UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
		desiredseg7 : unsigned(6 DOWNTO 0);  -- one per segment
   END RECORD;

   -- Define a type that is an array of the record.

   TYPE test_case_array_type IS ARRAY (0 to 15) OF test_case_record;
     
   -- Define the array itself.  We will initialize it, one line per test vector.
   -- each line of the array is one record, and the 2 numbers in each
   -- line correspond to the 2 entries in the record.  one of these entries 
   -- represent inputs to apply, and the other represents the expected output.
    
   signal test_case_array : test_case_array_type := (
        ("0000", "1000000"),
        ("0001", "1111001"),
        ("0010", "0100100"),
        ("0011", "0110000"),
        ("0100", "0011001"),
        ("0101", "0010010"),                      
        ("0110", "0000010"),  
        ("0111", "1111000"),  
        ("1000", "0000000"),
		  ("1001", "0010000"),
		  ("1010", "0001000"),
		  ("1011", "0000011"),
		  ("1100", "1000110"),
		  ("1101", "0100001"),
		  ("1110", "0000110"),
		  ("1111", "0001110")   
        );             

  -- Define the digit7seg subblock, which is the component we are testing

  COMPONENT digit7seg IS
      PORT(digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
          seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));  -- one per segment
   END COMPONENT;

   -- local signals we will use in the testbench 

   SIGNAL digit_test : unsigned(3 downto 0) := "0000"; 
   SIGNAL seg7_test : std_logic_vector(6 downto 0); 

begin

   -- instantiate the design-under-test

   dut : digit7seg PORT MAP(
          digit => digit_test,
          seg7 => seg7_test
			 );


   -- Code to drive inputs and check outputs.  This is written by one process.
   -- Note there is nothing in the sensitivity list here; this means the process is
   -- executed at time 0.  It would also be restarted immediately after the process
   -- finishes, however, in this case, the process will never finish (because there is
   -- a wait statement at the end of the process).

   process
   begin   
       
      -- starting values for simulation.  Not really necessary, since we initialize
      -- them above anyway

      digit_test <= "0000"; 
    
      -- Loop through each element in our test case array.  Each element represents
      -- one test case (along with expected outputs).
      
      for i in test_case_array'low to test_case_array'high loop
        
        -- Print information about the testcase to the transcript window (make sure when
        -- you run this, your transcript window is large enough to see what is happening)
        
        report "-------------------------------------------";
        report "Test case " & integer'image(i) & ":" &
                 " digit=" & integer'image(to_integer(test_case_array(i).digit));

        -- assign the values to the inputs of the DUT (design under test)

        digit_test <= test_case_array(i).digit;             

        -- wait for some time, to give the DUT circuit time to respond (1ns is arbitrary)                

        wait for 1 ns;
        
        -- now print the results along with the expected results
        
        report "Expected result= " &  
                    integer'image(to_integer(test_case_array(i).desiredseg7)) &
               "  Actual result= " &  
                    integer'image(to_integer(unsigned(seg7_test)));

        -- This assert statement causes a fatal error if there is a mismatch
                                                                    
        assert (test_case_array(i).desiredseg7 = unsigned(seg7_test) )
            report "MISMATCH.  THERE IS A PROBLEM IN YOUR DESIGN THAT YOU NEED TO FIX"
            severity failure;
      end loop;
                                           
      report "================== ALL TESTS PASSED =============================";
                                                                              
      wait; --- we are done.  Wait for ever
    end process;
end behavioural;