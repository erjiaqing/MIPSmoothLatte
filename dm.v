/*
 * 数据存储器，反正都是仿真出来的，跟寄存器没啥区别
 * addr 访问的地址
 * din 写入数据
 * DMWr 写使能 Data Memory Write
 * clk 时钟信号
 * dout 读出数据
 */
`include "global_def.v"
module dm_4k( addr, din, DMWr, clk, dout );
   
   input  [11:0] addr;
   input  [31:0] din;
   input         DMWr;
   input         clk;
   output [31:0] dout;
     
   reg [31:0] dmem[1023:0];
   
   always @(posedge clk) begin
      if (DMWr)
         dmem[addr[11:2]] <= din;
      `ifdef DEBUG
         $display("M[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", dmem[0], dmem[1], dmem[2], dmem[3], dmem[4], dmem[5], dmem[6], dmem[7]);
         $display("M[08-15]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", dmem[8], dmem[9], dmem[10], dmem[11], dmem[12], dmem[13], dmem[14], dmem[15]);
         $display("M[16-23]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", dmem[16], dmem[17], dmem[18], dmem[19], dmem[20], dmem[21], dmem[22], dmem[23]);
         $display("M[24-31]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", dmem[24], dmem[25], dmem[26], dmem[27], dmem[28], dmem[29], dmem[30], dmem[31]);
         $display("M[%4X]=%8X", addr[11:2], dmem[addr[11:2]]);
      `endif
   end // end always
   
   assign dout = dmem[addr[11:2]];
    
endmodule    
