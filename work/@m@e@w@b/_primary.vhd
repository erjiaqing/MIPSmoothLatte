library verilog;
use verilog.vl_types.all;
entity MEWB is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        MEWBVal         : out    vl_logic_vector(63 downto 0);
        EXMEVal         : in     vl_logic_vector(63 downto 0);
        ME_RFWr         : in     vl_logic;
        ME_Rd           : in     vl_logic_vector(4 downto 0);
        ME_WD_Src       : in     vl_logic;
        ME_ALURes       : in     vl_logic_vector(31 downto 0);
        ME_RFData       : in     vl_logic_vector(31 downto 0);
        ME_DMData       : in     vl_logic_vector(31 downto 0);
        WB_RFWr         : out    vl_logic;
        WB_Rd           : out    vl_logic_vector(4 downto 0);
        WB_WD_Src       : out    vl_logic;
        WB_ALURes       : out    vl_logic_vector(31 downto 0);
        WB_RFData       : out    vl_logic_vector(31 downto 0);
        WB_DMData       : out    vl_logic_vector(31 downto 0)
    );
end MEWB;
