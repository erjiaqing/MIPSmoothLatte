/* 指令存储器 没有问题 */

/* 在 mips_tb 这个模块中，

首先将文件里写的指令读到im.imem里面
然后在根据pc中的值从im里面读取指令*/

module im_4k( addr, dout, clk );
    
    input [11:0] addr;
    output wire [31:0] dout;
    
    input clk;
    
    reg [31:0] imem[1023:0];
    assign dout = imem[{addr[11:2]}];
    
endmodule    
