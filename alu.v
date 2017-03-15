`include "ctrl_encode_def.v"
module alu (A, B, ALUOp, C, Zero);

   input  [31:0] A, B;
   input  [4:0]  ALUOp; // 这里为什么是[1:0]的？
   output [31:0] C;
   output        Zero;

   reg [31:0] C;

   always @( A or B or ALUOp ) begin
      case ( ALUOp )
         /* ALUOp_XXXX 是长度为5的二进制向量，但是ALUOp传进来却是长度为2的二进制向量？ */
         `ALUOp_ADDU:    C = A + B;
         `ALUOp_SUBU:    C = A - B;
         `ALUOp_AND:     C = (A & B);
         `ALUOp_OR:      C = (A | B);
         `ALUOp_MULTU:   C = A * B;
         `ALUOp_DIVU:    C = A / B;
         `ALUOp_XOR:     C = (A ^ B);
         /* 这里好像没写or操作，补上，怕有奇怪的优先级问题加上括号 */
         default:   ;
      endcase
   end // end always;

   assign Zero = (A == B) ? 1 : 0;

endmodule
