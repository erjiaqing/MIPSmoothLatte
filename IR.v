/*
 IR 指令寄存器
 在一条指令执行完毕（mem阶段或者是wb阶段或者是遇到了j，beq等指令的时候，IRWr（写使能变成1
 */


module IR (clk, rst, im_dout, instr);

   input         clk;
   input         rst;
   input  [31:0] im_dout;
   output [31:0] instr;

   wire [31:0] instr;
   assign instr = im_dout;
endmodule
