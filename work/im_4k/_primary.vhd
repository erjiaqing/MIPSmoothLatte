library verilog;
use verilog.vl_types.all;
entity im_4k is
    port(
        addr            : in     vl_logic_vector(11 downto 0);
        dout            : out    vl_logic_vector(31 downto 0);
        clk             : in     vl_logic
    );
end im_4k;
