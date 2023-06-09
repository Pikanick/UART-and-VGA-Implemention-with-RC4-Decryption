library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3_task2 is
    port(
        CLOCK_50            : in  std_logic;
        KEY                 : in  std_logic_vector(3 downto 0);
        SW                  : in  std_logic_vector(17 downto 0);
        VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
        VGA_HS              : out std_logic;
        VGA_VS              : out std_logic;
        VGA_BLANK           : out std_logic;
        VGA_SYNC            : out std_logic;
        VGA_CLK             : out std_logic
    );
end lab3_task2;

architecture behvaiour of lab3_task2 is

 --Component from the Verilog file: vga_adapter.v

    component vga_adapter
        generic(RESOLUTION : string);
        port (
            resetn                                          : in  std_logic;
            clock                                           : in  std_logic;
            colour                                          : in  std_logic_vector(2 downto 0);
            x                                               : in  std_logic_vector(7 downto 0);
            y                                               : in  std_logic_vector(6 downto 0);
            plot                                            : in  std_logic;
            VGA_R, VGA_G, VGA_B                             : out std_logic_vector(9 downto 0);
            VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK    : out std_logic
        );
    end component;

	 component lab3_filling_task2 is
    port(
        clk_i       : in  std_logic;
        reset       : in  std_logic;
        colour 		: out std_logic_vector(2 downto 0);
        xpos        : out std_logic_vector(7 downto 0);
        ypos        : out std_logic_vector(6 downto 0);
        plot	: out std_logic);
	 end component;
	 
	 
	 component pixel_test is
    port(
        clk_i       : in std_logic;
        rst_i       : in std_logic;

        colour_o    : out std_logic_vector(2 downto 0);
        x_o         : out std_logic_vector(7 downto 0);
        y_o         : out std_logic_vector(6 downto 0);
        plot_o      : out std_logic
    );
	end component;

    signal colour       : std_logic_vector(2 downto 0);
    signal plot         : std_logic;
    signal x            : std_logic_vector(7 downto 0);
    signal y            : std_logic_vector(6 downto 0);

    signal rst_active_1 : std_logic;
	 signal set_base     : std_logic;
	 
	 signal fill			: std_logic;

begin

  -- includes the vga adapter, which should be in your project

    rst_active_1 <= not KEY(3);
	 set_base     <= not KEY(0);

    vga_u0 : vga_adapter
        generic map(RESOLUTION => "160x120")
        port map(
            resetn    => KEY(3),
            clock     => CLOCK_50,
            colour    => colour,
            x         => x,
            y         => y,
            plot      => plot,
            VGA_R     => VGA_R,
            VGA_G     => VGA_G,
            VGA_B     => VGA_B,
            VGA_HS    => VGA_HS,
            VGA_VS    => VGA_VS,
            VGA_BLANK => VGA_BLANK,
            VGA_SYNC  => VGA_SYNC,
            VGA_CLK   => VGA_CLK
        );


    lab3_filling0 : lab3_filling_task2
        port map(
            clk_i      => CLOCK_50,
            reset      => rst_active_1,
            colour     => colour,
            xpos          => x,
            ypos          => y,
            plot       => plot
        );

end architecture;