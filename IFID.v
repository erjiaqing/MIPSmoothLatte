module IFID(clk, rst, PCPlus4, INSTR, IFIDVal,
ID_Bubble, EX_Bubble);
  input clk, rst;
  input [31:0] PCPlus4, INSTR;
  input ID_Bubble, EX_Bubble;
  output reg [63:0] IFIDVal;
  always @(posedge clk, posedge rst)
  begin
    if (rst)
      IFIDVal <= 64'h0000_3000_0000_0000;
    else if (ID_Bubble)
      IFIDVal[31:26] <= 6'b111111;
    else if (EX_Bubble)
      ;
    else
      IFIDVal <= {PCPlus4[31:0], INSTR[31:0]};
  end
endmodule
