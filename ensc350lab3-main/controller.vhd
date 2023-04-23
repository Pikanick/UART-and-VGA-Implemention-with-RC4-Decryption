library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
    port(
        clk_i       : in std_logic;
        rst_i       : in std_logic;

        -- fill block control signals
		done_fill_i : in std_logic;
		fill_o 	    : out std_logic;

        -- line drawer control signals
        done_draw_i : in std_logic;
        load_o      : out std_logic;
        init_calc_o : out std_logic;
        draw_o      : out std_logic;
        line_num_o  : out unsigned(3 downto 0)
    );
end entity;

architecture behaviour of controller is

    type state_t is (
        RESET,
        CLEAR,
        LOAD,
        INIT_CALC,
        DRAW,
        SIT
    );

    signal curr_state : state_t;
    signal next_state : state_t;

    -- Line counter signals
    constant MAX_LINE_COUNT     : unsigned(3 downto 0) := to_unsigned(14, 4);
    constant MIN_LINE_COUNT     : unsigned(3 downto 0) := to_unsigned(1, 4);
    signal line_counter_r       : unsigned(3 downto 0);
    signal line_counter_en      : std_logic;
    signal line_counter_done    : std_logic;

    -- SIT state signals
    -- Wait for 1 second after drawing a line (50M clock cycles with 50 MHz clk)
    constant MAX_SIT_COUNT  : unsigned(25 downto 0) := to_unsigned(50000000, 26);
    signal sit_counter_r    : unsigned(25 downto 0);
    signal sit_counter_done : std_logic;
	 
begin

    -- curr_state control
    process(clk_i, rst_i) begin
        if(rst_i = '1') then
            curr_state <= RESET;
        elsif(rising_edge(clk_i)) then
            curr_state <= next_state;
        end if;
    end process;

    -- Combinational next_state
    process(curr_state, done_draw_i, sit_counter_done, done_fill_i) begin
        -- Default next_state is curr_state
        next_state <= curr_state;

        case curr_state is
            when RESET =>
                next_state <= CLEAR;

            when CLEAR =>
				if(done_fill_i = '1') then
						next_state <= LOAD;
				end if;
					
            when LOAD =>
                next_state <= INIT_CALC;
            
            when INIT_CALC =>
                next_state <= DRAW;
            
            when DRAW =>
                if(done_draw_i = '1') then
                    next_state <= SIT;
                end if;
            
            when SIT =>
                if(sit_counter_done = '1') then
                    next_state <= CLEAR;
                end if;
					 
        end case;
		  
    end process;

    -- Combinational output control signals
	fill_o      <= '1' when (curr_state = CLEAR)        else '0';
    load_o      <= '1' when (curr_state = LOAD)         else '0';
    init_calc_o <= '1' when (curr_state = INIT_CALC)    else '0';
    draw_o      <= '1' when (curr_state = DRAW)         else '0';

    -- Line counter
    process(clk_i, rst_i) begin
        if(rst_i = '1') then
            line_counter_r <= MIN_LINE_COUNT;
        elsif(rising_edge(clk_i)) then
            if(line_counter_en = '1') then
                if(line_counter_done = '1') then
                    line_counter_r <= MIN_LINE_COUNT;
                else
                    line_counter_r <= line_counter_r + 1;
                end if;
            end if;
        end if;
    end process;

    line_counter_en <= '1' when (curr_state = DRAW and next_state = SIT) else '0';
    line_counter_done <= '1' when (line_counter_r = MAX_LINE_COUNT) else '0';
    line_num_o <= line_counter_r;

    -- Sit counter
    process(clk_i, rst_i) begin
        if(rst_i = '1') then
            sit_counter_r <= to_unsigned(0, sit_counter_r'length);
        elsif(rising_edge(clk_i)) then
            if(curr_state = SIT) then
                if(sit_counter_done = '1') then
                    sit_counter_r <= to_unsigned(0, sit_counter_r'length);
                else
                    sit_counter_r <= sit_counter_r + 1;
                end if;
            end if;
        end if;
    end process;

    sit_counter_done <= '1' when (sit_counter_r = MAX_SIT_COUNT) else '0';

end architecture;