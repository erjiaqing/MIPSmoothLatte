/* flopr 异步复位触发器
 * 根据文档就是 clk 时钟
 * rst 复位
 * d 输入
 * q 输出
 * 同样没有任何问题
 */

module flopr #(parameter WIDTH = 8)
              (clk, rst, d, q);
               
   input              clk;
   input              rst;
   input  [WIDTH-1:0] d;
   output [WIDTH-1:0] q;
   
   reg [WIDTH-1:0] q_r;
               
   always @(negedge clk or posedge rst) begin
      if ( rst ) 
         q_r <= 0;
      else 
         q_r <= d;
   end // end always
   
   assign q = q_r;
      
endmodule
