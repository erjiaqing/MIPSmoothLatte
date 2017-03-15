module MEWB(clk, rst, MEWBVal, EXMEVal,
 ME_RFWr, ME_Rd, ME_WD_Src, ME_ALURes, ME_RFData, ME_DMData,
 WB_RFWr, WB_Rd, WB_WD_Src, WB_ALURes, WB_RFData, WB_DMData
);
  input clk, rst;
  input [63:0] EXMEVal;
  input ME_RFWr, ME_WD_Src;
  input [4:0] ME_Rd;
  input [31:0] ME_ALURes, ME_RFData, ME_DMData;
  //
  output reg [63:0] MEWBVal;
  output reg WB_RFWr, WB_WD_Src;
  output reg [4:0] WB_Rd;
  output reg [31:0] WB_ALURes, WB_RFData, WB_DMData;
  //
  always @(posedge clk, posedge rst)
  begin
    if (rst)
      begin
        MEWBVal <= 0;
        WB_RFWr <= 0;
        WB_Rd   <= 0;
        WB_WD_Src <= 0;
        WB_ALURes <= 0;
        WB_RFData <= 0;
        WB_DMData <= 0;
      end
    else
      begin
        MEWBVal <= EXMEVal[63:0];
        WB_RFWr <= ME_RFWr;
        WB_Rd   <= ME_Rd;
        WB_WD_Src <= ME_WD_Src;
        WB_ALURes <= ME_ALURes;
        WB_RFData <= ME_RFData;
        WB_DMData <= ME_DMData;
      end
  end
endmodule