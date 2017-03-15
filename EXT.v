/* 符号拓展
 * Imm16 16位数
 * EXTOp 符号拓展方式：0填充 符号填充 低位填0 （左移 16位）
 */

`include "ctrl_encode_def.v"
module EXT( Imm16, EXTOp, Imm32 );
    
   input  [15:0] Imm16;
   input  [1:0]  EXTOp;
   output [31:0] Imm32;
   
   reg [31:0] Imm32;
    
   always @(*) begin
      case (EXTOp)
         `EXT_ZERO:    Imm32 = {16'd0, Imm16};
         `EXT_SIGNED:  Imm32 = {{16{Imm16[15]}}, Imm16};
         `EXT_HIGHPOS: Imm32 = {Imm16, 16'd0};
         default: ;
      endcase
   end // end always
    
endmodule
