library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity line_drawer is
    port(
        clk_i       : in std_logic;
        rst_i       : in std_logic;

        colour_o    : out std_logic_vector(2 downto 0);
        x_o         : out std_logic_vector(7 downto 0);
        y_o         : out std_logic_vector(6 downto 0);
        plot_o      : out std_logic
    );
end entity;


architecture structure of line_drawer is

    component controller is
        port(
            clk_i       : in std_logic;
            rst_i       : in std_logic;
            done_fill_i : in std_logic;
            -- line drawer control signals
            done_draw_i : in std_logic;
            load_o      : out std_logic;
            init_calc_o : out std_logic;
            draw_o      : out std_logic;
            line_num_o  : out unsigned(3 downto 0);
            fill_o 	    : out std_logic
        );
    end component;

    component line_calc is
        port(
            clk_i       : in std_logic;
            rst_i       : in std_logic;
            load_i      : in std_logic;
            init_calc_i : in std_logic;
            draw_i      : in std_logic;
    
            x0_i        : in unsigned(7 downto 0);
            y0_i        : in unsigned(6 downto 0);
            x1_i        : in unsigned(7 downto 0);
            y1_i        : in unsigned(6 downto 0);
    
            x_o         : out std_logic_Vector(7 downto 0);
            y_o         : out std_logic_vector(6 downto 0);
            done_o      : out std_logic
        );
    end component;
	 
    component lab3_filling is
	    port(
            clk_i       : in  std_logic;
            reset       : in  std_logic;
            fill        : in  std_logic;
		    colour 	    : out std_logic_vector(2 downto 0);
		    xpos	    : out std_logic_vector(7 downto 0);
		    ypos	    : out std_logic_vector(6 downto 0);
		    done_fill   : out std_logic
        );
    end component;

    -- Controller Signals
    signal done_draw    : std_logic;
    signal load         : std_logic;
    signal init_calc    : std_logic;
    signal draw         : std_logic;
    signal line_num     : unsigned(3 downto 0);

    -- line_calc signals
    signal x0           : unsigned(7 downto 0);
    signal y0           : unsigned(6 downto 0);
    signal x1           : unsigned(7 downto 0);
    signal y1           : unsigned(6 downto 0);
    signal x_line_calc  : std_logic_vector(7 downto 0);
    signal y_line_calc  : std_logic_vector(6 downto 0);
	 
	 
	--filling signals
	signal done_fill    : std_logic;
	signal fill 	    : std_logic;
	signal xFill        : std_logic_vector(7 downto 0);
    signal yFill        : std_logic_vector(6 downto 0);

begin

    controller0 : controller
        port map(
            clk_i       => clk_i,
            rst_i       => rst_i,
            done_fill_i => done_fill,
            fill_o      => fill,
            done_draw_i => done_draw,
            load_o      => load,
            init_calc_o => init_calc,
            draw_o      => draw,
            line_num_o  => line_num
        );

    line_calc0 : line_calc
        port map(
            clk_i       => clk_i,
            rst_i       => rst_i,
            load_i      => load,
            init_calc_i => init_calc,
            draw_i      => draw,
            x0_i        => x0,
            y0_i        => y0,
            x1_i        => x1,
            y1_i        => y1,
            x_o         => x_line_calc,
            y_o         => y_line_calc,
            done_o      => done_draw
        );

	lab3_filling0 : lab3_filling
		port map(
			clk_i 	    => clk_i,
			reset		=> rst_i,
			fill	    => fill,
			xpos        => xFill,
			ypos        => yFill,
			done_fill   => done_fill
		);
		
    x0 <= to_unsigned(0, x0'length);
    -- y0 = 8 * line_num
    y0 <= shift_left(("000" & line_num), 3);
    x1 <= to_unsigned(159, x1'length);
    -- y1 = 120 - 8 * line_num
    y1 <= to_unsigned(120, y1'length) - shift_left(("000" & line_num), 3);

    plot_o <= draw or fill;
    x_o <= x_line_calc when (draw = '1') else xFill;
    y_o <= y_line_calc when (draw = '1') else yFill;

    colour_o(0) <= (line_num(1) xor line_num(0)) when (draw = '1') else '0';
    colour_o(1) <= (line_num(2) xor line_num(1)) when (draw = '1') else '0';
    colour_o(2) <= line_num(2) when (draw = '1') else '0';

end architecture;