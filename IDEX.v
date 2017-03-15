module IDEX(clk, rst, IDEXVal, IFIDVal,
 ID_RSVal, ID_RTVal, ID_ALUSrc, ID_ALUCtl, ID_Branch, ID_DMWr, ID_DMRd, ID_RFWr, ID_A3_Src, ID_WD_Src, ID_J,
 EX_RSVal, EX_RTVal, EX_ALUSrc, EX_ALUCtl, EX_Branch, EX_DMWr, EX_DMRd, EX_RFWr, EX_A3_Src, EX_WD_Src, EX_J,
 EX_RewriteRSVal, EX_RewriteRTVal,
 EX_Bubble
);
  input clk, rst;
  input [63:0] IFIDVal;
  input [31:0] ID_RSVal, ID_RTVal, EX_RewriteRSVal, EX_RewriteRTVal;
  input ID_ALUSrc;
  input [4:0] ID_ALUCtl;
  input ID_Branch, ID_DMWr, ID_DMRd, ID_RFWr, ID_A3_Src, ID_WD_Src, EX_Bubble, ID_J;
  //
  output reg [63:0] IDEXVal;
  output reg [31:0] EX_RSVal, EX_RTVal;
  output reg EX_ALUSrc;
  output reg [4:0] EX_ALUCtl;
  output reg EX_Branch, EX_DMWr, EX_DMRd, EX_RFWr, EX_A3_Src, EX_WD_Src, EX_J;
  always @(posedge clk, posedge rst)
  begin
    if (rst)
      begin
      EX_RSVal <= 0;
      EX_RTVal <= 0;
      EX_ALUSrc <= 0;
      EX_ALUCtl <= 0;
      IDEXVal <= 0;
      EX_DMWr <= 0;
      EX_DMRd <= 0;
      EX_RFWr <= 0;
      EX_Branch <= 0;
      EX_A3_Src <= 0;
      EX_WD_Src <= 0;
      EX_J <= 1;
      end
    else begin
      if (EX_Bubble)
      begin
        EX_RSVal <= EX_RewriteRSVal;
        EX_RTVal <= EX_RewriteRTVal;
      end
      else begin
        EX_RSVal <= ID_RSVal;
        EX_RTVal <= ID_RTVal;
        EX_ALUSrc <= ID_ALUSrc;
        EX_ALUCtl <= ID_ALUCtl;
        IDEXVal <= IFIDVal[63:0];
        EX_DMWr <= ID_DMWr;
        EX_DMRd <= ID_DMRd;
        EX_RFWr <= ID_RFWr;
        EX_Branch <= ID_Branch;
        EX_J <= ID_J;
      //end
        EX_A3_Src <= ID_A3_Src;
        EX_WD_Src <= ID_WD_Src;
      end
    end
  end
endmodule
