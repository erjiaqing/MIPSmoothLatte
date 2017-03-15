library verilog;
use verilog.vl_types.all;
entity IFID is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        PCPlus4         : in     vl_logic_vector(31 downto 0);
        INSTR           : in     vl_logic_vector(31 downto 0);
        IFIDVal         : out    vl_logic_vector(63 downto 0);
        ID_Bubble       : in     vl_logic;
        EX_Bubble       : in     vl_logic
    );
end IFID;
