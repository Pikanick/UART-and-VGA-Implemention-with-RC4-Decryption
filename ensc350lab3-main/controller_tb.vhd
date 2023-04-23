library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_tb is
end entity;

architecture tb of controller_tb is

    component controller is
        port(
            clk_i       : in std_logic;
            rst_i       : in std_logic;
    
            -- line drawer control signals
            done_draw_i : in std_logic;
            load_o      : out std_logic;
            init_calc_o : out std_logic;
            draw_o      : out std_logic;
            line_num_o  : out unsigned(3 downto 0)
        );
    end component;

    signal clk_i       : std_logic := '1';
    signal rst_i       : std_logic := '0';

    signal done_draw_i : std_logic := '0';
    signal load_o      : std_logic;
    signal init_calc_o : std_logic;
    signal draw_o      : std_logic;
    signal line_num_o  : unsigned(3 downto 0);

begin

    DUT: controller
        port map(
            clk_i       => clk_i,
            rst_i       => rst_i,
            done_draw_i => done_draw_i,
            load_o      => load_o,
            init_calc_o => init_calc_o,
            draw_o      => draw_o,
            line_num_o  => line_num_o
        );

    clk_i <= not clk_i after 5 ns;

    process begin
        rst_i <= '1';

        wait for 10 ns;

        rst_i <= '0';

        for i in 0 to 10 loop
            wait until draw_o = '1';

            wait for 50 ns;

            done_draw_i <= '1';

            wait for 10 ns;

        end loop;

        wait;

    end process;

end architecture;