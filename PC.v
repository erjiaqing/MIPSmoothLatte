/* PC

Program Counter 程序计数器
自动忽略最低2位

*/


module PC( clk, rst, PCWr, NPC, PC );

   input         clk;
   input         rst;
   input         PCWr;
   input  [31:0] NPC;
   output [31:0] PC;

   reg [31:0] PC;
   reg [1:0] tmp;

   //always @(posedge PCWr or posedge rst) begin
   always @(posedge clk or posedge rst) begin
      if ( rst )
         PC = 32'h0000_3000;
      else if ( PCWr )
         PC = NPC;
   end // end always

endmodule
