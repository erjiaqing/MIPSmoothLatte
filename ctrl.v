/*
设想的流程应该是这样的；
在时钟上升沿
  控制元件工作（有些计算元件，如ALU之类的也会计算，但是没有任何的数据写入）
    各信号清零，禁止各类写入操作
    根据当前状态
      状态0 - IF阶段
        写PC, IR -> 下一状态1
      状态1 - ID阶段
        NPC = PC + 4
        仅读取
        根据rs， rt读寄存器
        处理J指令的跳转
      状态2 - EXE阶段
        仅读取
        根据指令设置ALU信号（R指令下一阶段为阶段4）
        计算BEQ的跳转地址（BEQ下一阶段为阶段5）
      状态3 - MEM阶段
        根据信号，设置内存读取参数
      状态4 - WB阶段
        写入寄存器
      状态5 - BEQ转移发生阶段（属于MEM阶段）
在时钟下降沿，各计算元件工作
*/
`include "ctrl_encode_def.v"
`include "instruction_def.v"
`include "global_def.v"
//                                写PC  写指令 内存写源 内存写数  分支否   写寄  写内存  ALU_B_Select  ALUCtl  JMPCTL
module ctrl( clk, rst, Op, Funct, PCWr, A3_Src, WD_Src, Branch, RFWr, DMWr, ALU_B_Select, ALUCtl, JMPCTL, DMRd, nop);
  input   clk, rst, nop;
  input [5:0] Op, Funct;
  output reg PCWr, A3_Src, WD_Src, Branch, RFWr, DMWr, ALU_B_Select, JMPCTL, DMRd;
  output reg [4:0] ALUCtl;

  reg State, NxtState;

  //reg isWriteBack;
  
  initial
  begin
    PCWr = 1;
    Branch = 0;
    RFWr = 0;
    DMWr = 0;
    JMPCTL = 1;
    WD_Src = 0;
    
    PCWr = 1;
    A3_Src = 0;
    WD_Src = 0;
    Branch = 0;
    RFWr = 0;
    DMWr = 0;
    ALU_B_Select = 0;
    JMPCTL = 0;
  end
   
  always @(Op or Funct)
  begin
    RFWr = 0;
    DMWr = 0;
    DMRd = 0;
    Branch = 0;
    JMPCTL = 1;
    WD_Src = 0;
  if (nop == 0)
  begin
    case (Op)
      `INSTR_J_OP:
        JMPCTL = 0;
      `INSTR_RTYPE_OP:
      begin
        A3_Src = 1;
        WD_Src = 0;
        ALU_B_Select = 0;
        RFWr = 1;
        case (Funct)
          `INSTR_ADDU_FUNCT:  ALUCtl = `ALUOp_ADDU;
          `INSTR_SUBU_FUNCT:  ALUCtl = `ALUOp_SUBU;
          `INSTR_MULTU_FUNCT: ALUCtl = `ALUOp_MULTU;
          `INSTR_XOR_FUNCT:   ALUCtl = `ALUOp_XOR;
          `INSTR_OR_FUNCT:    ALUCtl = `ALUOp_OR;
          `INSTR_AND_FUNCT:   ALUCtl = `ALUOp_AND;
        endcase
      end
      `INSTR_ORI_OP:
      begin
        A3_Src = 0;
        WD_Src = 0;
        RFWr = 1;
        ALUCtl = `ALUOp_OR;
        ALU_B_Select = 1;
      end
      `INSTR_BEQ_OP:
      begin
        RFWr = 0;
        ALUCtl = `ALUOp_SUBU;
        ALU_B_Select = 0;
        Branch = 1;
      end
      `INSTR_LW_OP:
      begin
        ALUCtl = `ALUOp_ADDU;
        ALU_B_Select = 1;
        A3_Src = 0;
        WD_Src = 1;
        DMRd = 1;
        RFWr = 1;
      end
      `INSTR_SW_OP:
      begin
        ALUCtl = `ALUOp_ADDU;
        ALU_B_Select = 1;
        DMWr = 1;
        RFWr = 0;
      end
    endcase
  end
  end


endmodule
