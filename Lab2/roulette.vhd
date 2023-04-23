LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

----------------------------------------------------------------------
--
--  This is the top level template for Lab 2.  Use the schematic on Page 4
--  of the lab handout to guide you in creating this structural description.
--  The combinational blocks have already been designed in previous tasks,
--  and the spinwheel block is given to you.  Your task is to combine these
--  blocks, as well as add the various registers shown on the schemetic, and
--  wire them up properly.  The result will be a roulette game you can play
--  on your DE2.
--
-----------------------------------------------------------------------

ENTITY roulette IS
	PORT(   CLOCK_50 : IN STD_LOGIC; -- the fast clock for spinning wheel
		KEY : IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
		SW : IN STD_LOGIC_VECTOR(17 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ledg
		HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
		HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
	);
END roulette;


ARCHITECTURE structural OF roulette IS
 --- Your code goes here 
 
	COMPONENT new_balance IS
	PORT(money : in unsigned(11 downto 0);
          value1 : in unsigned(2 downto 0);
          value2 : in unsigned(2 downto 0);
          value3 : in unsigned(2 downto 0);
          bet1_wins : in std_logic;
          bet2_wins : in std_logic;
          bet3_wins : in std_logic;
          new_money : out unsigned(11 downto 0));
   END COMPONENT;
	
	COMPONENT win IS
	PORT(spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
			 bet1_value : in unsigned(5 downto 0); -- value for bet 1
			 bet2_colour : in std_logic;  -- colour for bet 2
			 bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
			 bet1_wins : out std_logic;  -- whether bet 1 is a winner
			 bet2_wins : out std_logic;  -- whether bet 2 is a winner
			 bet3_wins : out std_logic); -- whether bet 3 is a winner
	END COMPONENT;
	
	COMPONENT digit7seg IS
	PORT(
          digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
          seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- one per segment
	);
	END COMPONENT;
	
	COMPONENT spinwheel IS
	PORT(
		fast_clock : IN  STD_LOGIC;  -- This will be a 27 Mhz Clock
		resetb : IN  STD_LOGIC;      -- asynchronous reset
		spin_result  : OUT UNSIGNED(5 downto 0));  -- current value of the wheel
	END COMPONENT;
	
	COMPONENT six_bit_reg is
	port ( registerinput :in  std_logic_vector(5 downto 0);
	 reset: in std_logic;
	 clk: in std_logic;
	 registeroutput: out std_logic_vector(5 downto 0)
	 );
	END COMPONENT;
	
	COMPONENT two_bit_reg is
	port ( registerinput :in  std_logic_vector(1 downto 0);
	 reset: in std_logic;
	 clk: in std_logic;
	 registeroutput: out std_logic_vector(1 downto 0)
	 );
	END COMPONENT;
	
	COMPONENT three_bit_reg is
	port ( registerinput :in  std_logic_vector(2 downto 0);
	 reset: in std_logic;
	 clk: in std_logic;
	 registeroutput: out std_logic_vector(2 downto 0)
	 );
	END COMPONENT;
	
	COMPONENT twelve_bit_reg is
	port ( registerinput :in  std_logic_vector(11 downto 0);
	 reset: in std_logic;
	 clk: in std_logic;
	 registeroutput: out std_logic_vector(11 downto 0)
	 );
	END COMPONENT;
	
	COMPONENT dff_reg is 
	port(
		registerinput: in	std_logic;
		reset: in std_logic;
		clk: in std_logic;
		registeroutput: out std_logic
	);
	END COMPONENT;
	
	COMPONENT BCD is
	port ( registerinput :in  unsigned(11 downto 0);
			 registeroutput : out unsigned(15 downto 0));
	END COMPONENT;
	
	COMPONENT debounce IS
   GENERIC(
    clk_freq    : INTEGER := 50_000_000;  --system clock frequency in Hz
    stable_time : INTEGER := 10);         --time button must remain stable in ms
   PORT(
    clk     : IN  STD_LOGIC;  --input clock
    reset_n : IN  STD_LOGIC;  --asynchronous active low reset
    button  : IN  STD_LOGIC;  --input signal to be debounced
    result  : OUT STD_LOGIC); --debounced signal
	END COMPONENT;
	
----Signals
signal spin_result : unsigned(5 downto 0);
signal spin_result_latched : STD_LOGIC_VECTOR(5 downto 0);
signal BCDspin_result_latched : unsigned(15 downto 0);
signal bet1_value : STD_LOGIC_VECTOR(5 downto 0);
signal bet2_colour : std_logic;
signal bet3_dozen : STD_LOGIC_VECTOR(1 downto 0);
signal bet1_wins : std_logic;
signal bet2_wins : std_logic;
signal bet3_wins : std_logic;
signal money : std_logic_vector(11 downto 0);
signal new_money : unsigned(11 downto 0);
signal BCDnew_money : unsigned(15 downto 0);
signal bet1_amount : std_logic_vector(2 downto 0);
signal bet2_amount : std_logic_vector(2 downto 0);
signal bet3_amount : std_logic_vector(2 downto 0);
signal resetb : std_logic := key(1);
signal resetdb : std_logic := key(3);

signal clockdebounced : std_logic;
signal resetdebounced : std_logic;

signal fast_clock : std_logic := CLOCK_50;
signal slow_clock : std_logic := NOT key(0);
signal debouncedk0 : std_logic := NOT key(0);
signal debouncedk1 : std_logic := NOT key(0);
signal outobj1, outobj2, outobj3, outobj4, outobj5 : STD_LOGIC_VECTOR(6 DOWNTO 0);
signal switches: std_logic_vector(17 downto 0) := SW(17 downto 0);

BEGIN

--obj1: digit7seg PORT MAP(("00" & unsigned(spin_result_latched(5 downto 4))), HEX7);
--			 
--obj2: digit7seg PORT MAP(unsigned(spin_result_latched(3 downto 0)), HEX6);



obj20: debounce PORT MAP(fast_clock, resetdb, resetb, resetdebounced );

obj21: debounce PORT MAP(fast_clock, resetdb, slow_clock, clockdebounced ); 

obj1: digit7seg PORT MAP(("00" & unsigned(BCDspin_result_latched(5 downto 4))), HEX7);
			 
obj2: digit7seg PORT MAP(unsigned(BCDspin_result_latched(3 downto 0)), HEX6);

obj3: digit7seg PORT MAP(unsigned(BCDnew_money(11 downto 8)), HEX2); --unsigned(new_money(11 downto 8))

obj4: digit7seg PORT MAP(unsigned(BCDnew_money(7 downto 4)), HEX1);-- unsigned(new_money(7 downto 4))
	
obj5: digit7seg PORT MAP(unsigned(BCDnew_money(3 downto 0)), HEX0); --unsigned(new_money(3 downto 0))

obj16: spinwheel PORT MAP( CLOCK_50, resetdebounced, spin_result);
			 
obj6: six_bit_reg PORT MAP (STD_LOGIC_VECTOR(spin_result), resetdebounced, clockdebounced, spin_result_latched);
	
obj7: six_bit_reg PORT MAP ( SW(8 downto 3), resetdebounced, clockdebounced, bet1_value);

obj12: dff_reg PORT MAP(SW(12), resetdebounced, clockdebounced, bet2_colour);

obj13: two_bit_reg PORT MAP( SW(17 downto 16), resetdebounced, clockdebounced, bet3_dozen);	

obj11: win PORT MAP(unsigned(spin_result_latched), unsigned(bet1_value), bet2_colour, unsigned(bet3_dozen), bet1_wins, bet2_wins, bet3_wins); 

LEDG(0)<=bet1_wins;
LEDG(1)<=bet2_wins;
LEDG(2)<=bet3_wins;
	 
obj8: three_bit_reg PORT MAP (SW(2 downto 0), resetdebounced, clockdebounced, bet1_amount);
	 
obj9: three_bit_reg PORT MAP (SW(11 downto 9), resetdebounced, clockdebounced, bet2_amount);
	 
obj10: three_bit_reg PORT MAP (SW(15 downto 13), resetdebounced, clockdebounced, bet3_amount);
		
obj14:  twelve_bit_reg PORT MAP(STD_LOGIC_VECTOR(new_money), resetdebounced, clockdebounced, money);	

obj15:  new_balance PORT MAP(unsigned(money), unsigned(bet1_amount), unsigned(bet2_amount), unsigned(bet3_amount), bet1_wins, bet2_wins, bet3_wins, new_money);

obj17:  BCD PORT MAP(unsigned(new_money), BCDnew_money);

obj18: digit7seg PORT MAP(unsigned(BCDnew_money(15 downto 12)), HEX3);

obj19:  BCD PORT MAP("000000" &unsigned(spin_result_latched), BCDspin_result_latched);
	
END;
