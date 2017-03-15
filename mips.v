`include "ctrl_encode_def.v"
`include "instruction_def.v"
`include "global_def.v"
module mips( clk, rst );
   input   clk;
   input   rst;

   wire 		     PCWr;

   wire 		     Zero;

   wire JMPCTL;

// 还有没被定义的内容

// 先补充定义一下PC模块用到的东西
   reg [31:0] NNPC;
   wire [31:0] PC;  // program counter
   
   wire EX_Bubble, ID_Bubble;

// 再定义一下指令存储器用到的东西
// 接着定义RF用到的内容
   wire [31:0] WD;
   
// 这一句把instr拆开了
// instr没有被定义，先定义一下，注意instr不能assign成im_dout
   wire [31:0] instr;

// 这里发现如果不这样定义的话，那些东西好像会被认为是只有1个bit
   wire [5:0] Op, Funct, IDOp, IDFunct;
   wire [4:0] IDrs, IDrt, IDrd, EXrs, EXrt, EXrd, MErs, MErt, MErd, WBrs, WBrt, WBrd;
   wire [15:0] Imm16;
   wire [25:0] IMM;

   wire [31:0] BranchAddr;
   

   wire BranchNZero;

   // ------
  wire [31:0] IF_PCPlus4;
  // ID Level
  wire [63:0] IFIDVal;
  wire [31:0] ID_RSVal, ID_RTVal;
  wire ID_ALUSrc, ID_Jmp;
  wire [4:0] ID_ALUCtl;
  wire ID_Branch, ID_DMWr, ID_DMRd, ID_RFWr, ID_A3_Src, ID_WD_Src;
  
  wire [25:0] ID_IMM;
  assign ID_IMM = IFIDVal[25:0];
  
  assign IDrs = IFIDVal[25:21];assign IDrt = IFIDVal[20:16];assign IDrd = IFIDVal[15:11];
  assign IDOp = IFIDVal[31:26];assign IDFunct = IFIDVal[5:0];
  
  // EX Level 
  wire [63:0] IDEXVal;
  wire [31:0] EX_RSVal, EX_RTVal, EX_ALUB, EX_ALUA, EX_RTVal2, EX_ALURes;
  wire EX_ALUSrc, EX_J;
  wire [4:0] EX_ALUCtl, EX_Rd;
  wire EX_Branch, EX_DMWr, EX_DMRd, EX_RFWr, EX_A3_Src, EX_WD_Src;
  wire [31:0] EX_BranchAddr, EX_Imm16Sft2;
  
  wire [31:0] EX_ALU_ExtendedImm16;
  
  wire [1:0] EX_ALU_FwdA, EX_ALU_FwdB;
  
  wire [31:0] _EX_MUX_EX_RSVal, _EX_MUX_EX_RTVal, _EX_MUX_EX_RSValRe, _EX_MUX_EX_RTValRe;
  
  assign EXrs = IDEXVal[25:21];assign EXrt = IDEXVal[20:16];assign EXrd = IDEXVal[15:11];
  assign EX_Imm16Sft2 = {{14{IDEXVal[15]}}, IDEXVal[15:0], 2'b00};
  assign EX_BranchAddr = IDEXVal[63:32] + EX_Imm16Sft2;
  
  
  // ME Level
  wire [63:0] EXMEVal;
  wire ME_DMWr, ME_DMRd, ME_RFWr, ME_WD_Src, ME_Branch;
  wire [4:0] ME_Rd;
  wire [31:0] ME_ALURes, ME_RFData, ME_DMData;
  
  wire [31:0] ME_RTVal, ME_BranchAddr;
  
  assign MErs = EXMEVal[25:21];assign MErt = EXMEVal[20:16];assign MErd = EXMEVal[15:11];
  
  
  // WB Level
  wire [63:0] MEWBVal;
  wire WB_RFWr, WB_WD_Src;
  wire [31:0] WB_ALURes, WB_RFData, WB_DMData;
  wire [4:0] WB_Rd;
  
  assign WBrs = MEWBVal[25:21];assign WBrt = MEWBVal[20:16];assign WBrd = MEWBVal[15:11];
   // ------
   
   
   /*
     根据定义的话，instr存的应该是当前正在运算的指令
     这个应该是第一个周期干的事情
   */
   assign Op = instr[31:26];
   assign Funct = instr[5:0];

   assign Imm16= instr[15:0];
   assign IMM = instr[25:0];

   assign ExtendedImm16 = {{16{Imm16[15]}}, Imm16[15:0]};

   assign BranchNZero = (EX_Branch & Zero);

// ALU B数据选择的mux
   // vvvvv IF

// PC的控制
   /*PC U_PC (
      .clk(clk), .rst(rst), .PCWr(PCWr), .NPC(NPC), .PC(PC)
   );*/// 指令存储器
   assign IF_PCPlus4 = PC + 4;
   
   always @(posedge rst) begin NNPC = 32'h0000_3000; end
   always @(PC) NNPC = PC;
   
   im_4k U_IM (
      .addr(NNPC[11:0]) , .dout(instr), .clk(clk)
   );
   
   // ^^^^^ IF
   
   
   IFID R_IFID(
     .clk(clk), .rst(rst),
     .PCPlus4(IF_PCPlus4),
     .INSTR(instr),
     .IFIDVal(IFIDVal),
     .ID_Bubble(ID_Bubble), .EX_Bubble(EX_Bubble)
   );
   
   
   // vvvvv ID
   
   wire nop;
   assign nop = (EX_Branch);

   RF U_RF (
      .A1(IDrs), .A2(IDrt), .A3(WB_Rd), .WD(WD), .clk(clk),
      .RFWr(WB_RFWr), .RD1(ID_RSVal), .RD2(ID_RTVal)
   );

   ctrl U_CTRL(
     .clk(clk), .rst(rst), .nop(nop), .Op(IDOp), .Funct(IDFunct),
     .PCWr(PCWr), .WD_Src(ID_WD_Src), .Branch(ID_Branch), .DMRd(ID_DMRd),
     .RFWr(ID_RFWr), .DMWr(ID_DMWr), .ALU_B_Select(ID_ALUSrc), .A3_Src(ID_A3_Src), .ALUCtl(ID_ALUCtl), .JMPCTL(ID_Jmp)
   );
   
   wire [31:0] RealNxtPC;
   
   
   mux2 MUX_BRANCH(
     .d0(RealNxtPC), .d1(ME_BranchAddr), .s(ME_Branch),
     .y(BranchAddr)
   );
   
   mux2 NOPIgnore(
     .d0(IFIDVal[63:32]), .d1(PC), .s(nop), .y(RealNxtPC)
   );
   
   mux2 MUX_NPC(
     .d0({IFIDVal[63:60], ID_IMM[25:0], 2'b00}), .d1(BranchAddr), .s(EX_J),
     .y(PC)
   );
   
   wire _IDEX_RS_SEL, _IDEX_RT_SEL;
   wire [31:0] RealIDRsVal, RealIDRtVal;
   assign _IDEX_RS_SEL = (WB_RFWr && WB_Rd != 0 && WB_Rd == IDrs);
   assign _IDEX_RT_SEL = (WB_RFWr && WB_Rd != 0 && WB_Rd == IDrt);
   
   mux2 IDEX_RS_VAL_MUX(
   .d0(ID_RSVal), .d1(WD), .s(_IDEX_RS_SEL), .y(RealIDRsVal)
   );

   mux2 IDEX_RT_VAL_MUX(
   .d0(ID_RTVal), .d1(WD), .s(_IDEX_RT_SEL), .y(RealIDRtVal)
   );

  // ^^^^^ ID

   IDEX R_IDEX(
     .clk(clk), .rst(rst), .IDEXVal(IDEXVal), .IFIDVal(IFIDVal),
     .ID_RSVal(RealIDRsVal), .ID_RTVal(RealIDRtVal), .ID_ALUSrc(ID_ALUSrc),
     .ID_ALUCtl(ID_ALUCtl), .ID_Branch(ID_Branch), .ID_DMWr(ID_DMWr),
     .ID_DMRd(ID_DMRd), .ID_RFWr(ID_RFWr), .ID_A3_Src(ID_A3_Src), .ID_WD_Src(ID_WD_Src),
     .ID_J(ID_Jmp),
     
     .EX_RSVal(EX_RSVal), .EX_RTVal(EX_RTVal), .EX_ALUSrc(EX_ALUSrc),
     .EX_ALUCtl(EX_ALUCtl), .EX_Branch(EX_Branch), .EX_DMWr(EX_DMWr),
     .EX_DMRd(EX_DMRd), .EX_RFWr(EX_RFWr), .EX_A3_Src(EX_A3_Src), .EX_WD_Src(EX_WD_Src),
     .EX_J(EX_J),
     
     .EX_RewriteRSVal(_EX_MUX_EX_RSValRe), .EX_RewriteRTVal(_EX_MUX_EX_RTValRe),
     
     .EX_Bubble(EX_Bubble)
   );
   
   // vvvvv EX


   // ALU 算术逻辑单元
   
   assign EX_Rd = (EX_A3_Src == 1 ? EXrd : EXrt);
   assign EX_ALU_FwdA = {((ME_RFWr && ME_Rd != 0 && ME_Rd == EXrs) ? 1'b1 : 1'b0), (WB_RFWr && WB_Rd != 0 && WB_Rd == EXrs) ? 1'b1 : 1'b0};
   assign EX_ALU_FwdB = {((ME_RFWr && ME_Rd != 0 && ME_Rd == EXrt) ? 1'b1 : 1'b0), (WB_RFWr && WB_Rd != 0 && WB_Rd == EXrt) ? 1'b1 : 1'b0};
   
   EXT EXT_ALU(IDEXVal[15:0], `EXT_SIGNED, EX_ALU_ExtendedImm16);
   mux4 MUX_EX_RSVal(
   .d0(EX_RSVal),
   .d1(WD),
   .d2(ME_ALURes),
   .d3(ME_ALURes),
   .s(EX_ALU_FwdA),
   .y(_EX_MUX_EX_RSVal)
   );
   mux4 MUX_EX_RTVal(
   .d0(EX_RTVal),
   .d1(WD),
   .d2(ME_ALURes),
   .d3(ME_ALURes),
   .s(EX_ALU_FwdB),
   .y(_EX_MUX_EX_RTVal)
   );
   
   assign _EX_MUX_EX_RSValRe = _EX_MUX_EX_RSVal;
   assign _EX_MUX_EX_RTValRe = _EX_MUX_EX_RTVal;
   
   mux2 MUX_ALUSRCB(
      // Register // imm16
      .d0(_EX_MUX_EX_RTVal), .d1(EX_ALU_ExtendedImm16), .s(EX_ALUSrc),
      .y(EX_ALUB)
   );

   alu U_ALU (
     .A(_EX_MUX_EX_RSVal), .B(EX_ALUB), .ALUOp(EX_ALUCtl), .C(EX_ALURes), .Zero(Zero)
   );
   
   
   // ^^^^^ EX


   EXME R_EXME(.clk(clk), .rst(rst), .EXMEVal(EXMEVal), .IDEXVal(IDEXVal), .EX_Bubble(EX_Bubble),
     .EX_BranchAddr(EX_BranchAddr), .EX_Branch(BranchNZero), .EX_DMWr(EX_DMWr), .EX_DMRd(EX_DMRd), .EX_RFWr(EX_RFWr), .EX_Rd(EX_Rd), .EX_WD_Src(EX_WD_Src), .EX_ALURes(EX_ALURes), .EX_RTVal(_EX_MUX_EX_RTVal),
     .ME_BranchAddr(ME_BranchAddr), .ME_Branch(ME_Branch), .ME_DMWr(ME_DMWr), .ME_DMRd(ME_DMRd), .ME_RFWr(ME_RFWr), .ME_Rd(ME_Rd), .ME_WD_Src(ME_WD_Src), .ME_ALURes(ME_ALURes), .ME_RTVal(ME_RTVal)
   );
   
   
   // vvvvv ME


   dm_4k U_DM (
      .addr(ME_ALURes[11:0]), .din(ME_RTVal), .DMWr(ME_DMWr), .clk(clk), .dout(ME_DMData)
   );
   
   
   //^^^^^ ME
   
   
   MEWB R_MEWB(.clk(clk), .rst(rst), .MEWBVal(MEWBVal), .EXMEVal(EXMEVal),
     .ME_RFWr(ME_RFWr), .ME_Rd(ME_Rd), .ME_WD_Src(ME_WD_Src), .ME_ALURes(ME_ALURes), .ME_RFData(ME_RFData), .ME_DMData(ME_DMData),
     .WB_RFWr(WB_RFWr), .WB_Rd(WB_Rd), .WB_WD_Src(WB_WD_Src), .WB_ALURes(WB_ALURes), .WB_RFData(WB_RFData), .WB_DMData(WB_DMData)
   );
   
   //vvvvv WB
   
   assign WD = (WB_WD_Src == 0 ? WB_ALURes : WB_DMData);
   assign EX_Bubble = (ME_DMRd && (EXrs == ME_Rd || EXrt == ME_Rd));
   assign ID_Bubble = (ID_Branch || EX_Branch || !ID_Jmp);
   
endmodule

/* 什么改炸了，明明就是把核心代码删掉了嘛…… */
