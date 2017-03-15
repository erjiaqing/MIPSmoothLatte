module EXME(clk, rst, EXMEVal, IDEXVal, EX_Bubble,
 EX_BranchAddr, EX_Branch, EX_DMWr, EX_DMRd, EX_RFWr, EX_WD_Src, EX_ALURes, EX_Rd, EX_RTVal,
 ME_BranchAddr, ME_Branch, ME_DMWr, ME_DMRd, ME_RFWr, ME_WD_Src, ME_ALURes, ME_Rd, ME_RTVal
);
  input clk, rst;
  input [63:0] IDEXVal;
  input EX_DMWr, EX_DMRd, EX_RFWr, EX_WD_Src, EX_Bubble, EX_Branch;
  input [31:0] EX_ALURes, EX_RTVal, EX_BranchAddr;
  input [4:0] EX_Rd;
  //
  output reg [63:0] EXMEVal;
  output reg ME_DMWr, ME_DMRd, ME_RFWr, ME_WD_Src, ME_Branch;
  output reg [31:0] ME_ALURes, ME_RTVal, ME_BranchAddr;
  output reg [4:0] ME_Rd;
  always @(posedge clk, posedge rst)
  begin
    if (rst)
      begin
        EXMEVal <= 0;
        ME_DMWr <= 0;
        ME_DMRd <= 0;
        ME_RFWr <= 0;
        ME_Rd   <= 0;
        ME_RTVal <= 0;
        ME_WD_Src <= 0;
        ME_ALURes <= 0;
        ME_Branch <= 0;
      end
    else
      begin
        EXMEVal <= IDEXVal[63:0];
        if (EX_Bubble) begin
          ME_DMWr <= 0;
          ME_DMRd <= 0;
          ME_RFWr <= 0;
          ME_Branch <= 0;
        end else begin
          ME_DMWr <= EX_DMWr;
          ME_DMRd <= EX_DMRd;
          ME_RFWr <= EX_RFWr;
          ME_Branch <= EX_Branch;
        end
        ME_Rd   <= EX_Rd;
        ME_RTVal <= EX_RTVal;
        ME_WD_Src <= EX_WD_Src;
        ME_ALURes <= EX_ALURes;
        ME_BranchAddr <= EX_BranchAddr;
      end
  end
endmodule