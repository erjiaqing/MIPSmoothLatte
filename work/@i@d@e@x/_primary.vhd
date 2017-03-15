library verilog;
use verilog.vl_types.all;
entity IDEX is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        IDEXVal         : out    vl_logic_vector(63 downto 0);
        IFIDVal         : in     vl_logic_vector(63 downto 0);
        ID_RSVal        : in     vl_logic_vector(31 downto 0);
        ID_RTVal        : in     vl_logic_vector(31 downto 0);
        ID_ALUSrc       : in     vl_logic;
        ID_ALUCtl       : in     vl_logic_vector(4 downto 0);
        ID_Branch       : in     vl_logic;
        ID_DMWr         : in     vl_logic;
        ID_DMRd         : in     vl_logic;
        ID_RFWr         : in     vl_logic;
        ID_A3_Src       : in     vl_logic;
        ID_WD_Src       : in     vl_logic;
        ID_J            : in     vl_logic;
        EX_RSVal        : out    vl_logic_vector(31 downto 0);
        EX_RTVal        : out    vl_logic_vector(31 downto 0);
        EX_ALUSrc       : out    vl_logic;
        EX_ALUCtl       : out    vl_logic_vector(4 downto 0);
        EX_Branch       : out    vl_logic;
        EX_DMWr         : out    vl_logic;
        EX_DMRd         : out    vl_logic;
        EX_RFWr         : out    vl_logic;
        EX_A3_Src       : out    vl_logic;
        EX_WD_Src       : out    vl_logic;
        EX_J            : out    vl_logic;
        EX_RewriteRSVal : in     vl_logic_vector(31 downto 0);
        EX_RewriteRTVal : in     vl_logic_vector(31 downto 0);
        EX_Bubble       : in     vl_logic
    );
end IDEX;
