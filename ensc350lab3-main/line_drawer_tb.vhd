library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity line_drawer_tb is
end entity;

architecture tb of line_drawer_tb is

    component line_drawer is
        port(
            clk_i       : in  std_logic;
            rst_i       : in  std_logic;
    
            colour_o    : out std_logic_vector(2 downto 0);
            x_o         : out std_logic_vector(7 downto 0);
            y_o         : out std_logic_vector(6 downto 0);
            plot_o      : out std_logic
        );
    end component;

    signal clk_i       : std_logic := '1';
    signal rst_i       : std_logic := '0';
    signal colour_o    : std_logic_vector(2 downto 0);
    signal x_o         : std_logic_vector(7 downto 0);
    signal y_o         : std_logic_vector(6 downto 0);
    signal plot_o      : std_logic;

begin

    DUT: line_drawer
        port map(
            clk_i       => clk_i,
            rst_i       => rst_i,
            colour_o    => colour_o,
            x_o         => x_o,
            y_o         => y_o,
            plot_o      => plot_o
        );

    clk_i <= not clk_i after 5 ns;

    process begin
        rst_i <= '1';

        wait for 10 ns;

        rst_i <= '0';

        wait for 10 ns;

        wait;
    end process;

end architecture;