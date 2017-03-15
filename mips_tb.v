 module mips_tb();

   reg clk, rst;
   
   integer i;

   mips U_MIPS(
      .clk(clk), .rst(rst)
   );

   initial begin
      $display("This is SMOOTH LATTE V2");
      $readmemh( "code.txt" , U_MIPS.U_IM.imem ) ;
      for (i = 0; i < 5; i = i + 1) $display("%8X: %8X", i, U_MIPS.U_IM.imem[i]);
      $monitor(
      "PC = 0x%8X, IR = 0x%8X",
      U_MIPS.PC, U_MIPS.instr);
      clk = 1 ;
      rst = 0 ;
      #5 ;
      rst = 1 ;
      #5 ;
      rst = 0 ;
   end

   always
   begin
	   #(50) clk = ~clk;
     #(50) clk = ~clk;
   end

endmodule
