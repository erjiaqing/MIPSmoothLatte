library verilog;
use verilog.vl_types.all;
entity ctrl is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        Op              : in     vl_logic_vector(5 downto 0);
        Funct           : in     vl_logic_vector(5 downto 0);
        PCWr            : out    vl_logic;
        A3_Src          : out    vl_logic;
        WD_Src          : out    vl_logic;
        Branch          : out    vl_logic;
        RFWr            : out    vl_logic;
        DMWr            : out    vl_logic;
        ALU_B_Select    : out    vl_logic;
        ALUCtl          : out    vl_logic_vector(4 downto 0);
        JMPCTL          : out    vl_logic;
        DMRd            : out    vl_logic;
        nop             : in     vl_logic
    );
end ctrl;
