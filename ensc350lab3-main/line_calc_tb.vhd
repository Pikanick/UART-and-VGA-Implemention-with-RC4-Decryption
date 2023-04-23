library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity line_calc_tb is
end entity;

architecture tb of line_calc_tb is

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

    signal clk_i        : std_logic := '1';
    signal rst_i        : std_logic := '0';
    signal load_i       : std_logic := '0';
    signal init_calc_i  : std_logic := '0';
    signal draw_i       : std_logic := '0';

    signal x0_i         : unsigned(7 downto 0);
    signal y0_i         : unsigned(6 downto 0);
    signal x1_i         : unsigned(7 downto 0);
    signal y1_i         : unsigned(6 downto 0);

    signal x_o          : std_logic_Vector(7 downto 0);
    signal y_o          : std_logic_vector(6 downto 0);
    signal done_o       : std_logic;

begin

    DUT: line_calc
        port map(
            clk_i       => clk_i,
            rst_i       => rst_i,
            load_i      => load_i,
            init_calc_i => init_calc_i,
            draw_i      => draw_i,
            x0_i        => x0_i,
            y0_i        => y0_i,
            x1_i        => x1_i,
            y1_i        => y1_i,
            x_o         => x_o,
            y_o         => y_o,
            done_o      => done_o
        );

    clk_i <= not clk_i after 5 ns;

    process begin

        rst_i <= '1';

        wait for 5 ns;

        rst_i <= '0';

        wait for 25 ns;

        load_i <= '1';
        x0_i <= to_unsigned(10, x0_i'length);
        y0_i <= to_unsigned(100, y0_i'length);
        x1_i <= to_unsigned(40, x1_i'length);
        y1_i <= to_unsigned(40, y1_i'length);

        wait for 10 ns;

        load_i <= '0';
        init_calc_i <= '1';

        wait for 10 ns;

        init_calc_i <= '0';
        draw_i <= '1';

        wait until done_o = '1';

        draw_i <= '0';

        wait;

    end process;

end architecture;