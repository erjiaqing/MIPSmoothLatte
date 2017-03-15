library verilog;
use verilog.vl_types.all;
entity EXME is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        EXMEVal         : out    vl_logic_vector(63 downto 0);
        IDEXVal         : in     vl_logic_vector(63 downto 0);
        EX_Bubble       : in     vl_logic;
        EX_BranchAddr   : in     vl_logic_vector(31 downto 0);
        EX_Branch       : in     vl_logic;
        EX_DMWr         : in     vl_logic;
        EX_DMRd         : in     vl_logic;
        EX_RFWr         : in     vl_logic;
        EX_WD_Src       : in     vl_logic;
        EX_ALURes       : in     vl_logic_vector(31 downto 0);
        EX_Rd           : in     vl_logic_vector(4 downto 0);
        EX_RTVal        : in     vl_logic_vector(31 downto 0);
        ME_BranchAddr   : out    vl_logic_vector(31 downto 0);
        ME_Branch       : out    vl_logic;
        ME_DMWr         : out    vl_logic;
        ME_DMRd         : out    vl_logic;
        ME_RFWr         : out    vl_logic;
        ME_WD_Src       : out    vl_logic;
        ME_ALURes       : out    vl_logic_vector(31 downto 0);
        ME_Rd           : out    vl_logic_vector(4 downto 0);
        ME_RTVal        : out    vl_logic_vector(31 downto 0)
    );
end EXME;
