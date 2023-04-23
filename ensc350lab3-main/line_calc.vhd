library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity line_calc is
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
end entity;

architecture structure of line_calc is

    signal x0_r         : signed(8 downto 0);
    signal y0_r         : signed(8 downto 0);
    signal x1_r         : signed(8 downto 0);
    signal y1_r         : signed(8 downto 0);

    signal next_x0      : signed(8 downto 0);
    signal next_y0      : signed(8 downto 0);

    signal dx_r         : signed(8 downto 0);
    signal dy_r         : signed(8 downto 0);
    signal sx_r         : signed(8 downto 0);
    signal sy_r         : signed(8 downto 0);

    signal err_r        : signed(8 downto 0);
    signal next_err     : signed(8 downto 0);
    signal err_with_dy  : signed(8 downto 0);

    signal e2               : signed(17 downto 0);
    signal e2_gt_minus_dy   : std_logic;
    signal e2_lt_dx         : std_logic;

begin

    -- All register behaviour
    process(rst_i, clk_i)
        variable dx_v   : signed(8 downto 0);
        variable dy_v   : signed(8 downto 0);
    begin

        if(rst_i = '1') then
            x0_r    <= to_signed(0, 9);
            y0_r    <= to_signed(0, 9);
            x1_r    <= to_signed(0, 9);
            y1_r    <= to_signed(0, 9); 
            dx_r    <= to_signed(0, 9);
            dy_r    <= to_signed(0, 9);
            sx_r    <= to_signed(0, 9);
            sy_r    <= to_signed(0, 9);
            err_r   <= to_signed(0, 9);

        elsif(rising_edge(clk_i)) then
            if(init_calc_i = '1') then
                if(x1_r > x0_r) then
                    dx_v := x1_r - x0_r;
                    sx_r <= to_signed(1, sx_r'length);
                else
                    dx_v := x0_r - x1_r;
                    sx_r <= to_signed(-1, sx_r'length);
                end if;
                
                if(y1_r > y0_r) then
                    dy_v := y1_r - y0_r;
                    sy_r <= to_signed(1, sy_r'length);
                else
                    dy_v := y0_r - y1_r;
                    sy_r <= to_signed(-1, sy_r'length);
                end if;

                dx_r <= dx_v;
                dy_r <= dy_v;
                err_r <= (signed(dx_v) - signed(dy_v));
            else
                if(draw_i = '1') then
                    x0_r <= next_x0;
                elsif(load_i = '1') then
                    -- The purpose of adding 0 is to do a 1-line width conversion
                    x0_r <= signed("0" & x0_i);
                end if;

                if(draw_i = '1') then
                    y0_r <= next_y0;
                elsif(load_i = '1') then
                    y0_r <= signed("00" & y0_i);
                end if;

                if(load_i = '1') then
                    x1_r <= signed("0" & x1_i);
                    y1_r <= signed("00" & y1_i);
                end if;

                if(draw_i = '1') then
                    err_r <= next_err;
                end if;
            end if;
        end if;
    end process;

    e2 <= to_signed(2, err_r'length) * err_r;

    e2_gt_minus_dy  <= '1' when (e2 > (0 - dy_r)) else '0';
    e2_lt_dx        <= '1' when (e2 < dx_r) else '0';
    
    err_with_dy <= (err_r - dy_r) when (e2_gt_minus_dy = '1') else err_r;
    next_err    <= (err_with_dy + dx_r) when (e2_lt_dx = '1') else err_with_dy;

    next_x0 <= (x0_r + sx_r) when (e2_gt_minus_dy = '1') else x0_r;
    next_y0 <= (y0_r + sy_r) when (e2_lt_dx = '1') else y0_r;
    
    done_o <= '1' when (x0_r = x1_r and y0_r = y1_r) else '0';

    process(x0_r, y0_r)
        variable x0_vec : std_logic_vector(8 downto 0);
        variable y0_vec : std_logic_vector(8 downto 0);
    begin
        x0_vec := std_logic_vector(x0_r);
        y0_vec := std_logic_vector(y0_r);

        x_o <= x0_vec(7 downto 0);
        y_o <= y0_vec(6 downto 0);
    end process;

end architecture;