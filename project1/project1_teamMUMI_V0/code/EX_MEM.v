module EX_MEM(
    clk_i,
    ALUout_i, //32bits
    Zero_i, //1 bit
    PC_i, //32bits
    regB_i, //32bits
    JumpAddr_i, //32bits
    RegistersRD_i, //32bits
    RegWrite_i,//control signal
    RegRead_i,
    MemtoReg_i,
    MemWrite_i,
    MemRead_i,

    ALUout_o,
    Zero_o,
    PC_o,
    regB_o,
    JumpAddr_o,
    RegistersRD_o,
    RegWrite_o,
    RegRead_o,
    MemtoReg_o,
    MemWrite_o,
    MemRead_o
);
input clk_i, Zero_i;
input [4:0] RegistersRD_i;
input [31:0] PC_i, ALUout_i, regB_i, JumpAddr_i;
//control signal
input RegWrite_i, RegRead_i, MemtoReg_i, MemWrite_i, MemRead_i;

output Zero_o;
output [4:0] RegistersRD_o;
output [31:0] PC_o,ALUout_o, regB_o, JumpAddr_o;
//control signal
output RegWrite_o, RegRead_o, MemtoReg_o, MemWrite_o, MemRead_o;
reg Zero_o, PC_o, ALUout_o, regB_o, JumpAddr_o, RegistersRD_o, RegWrite_o, RegRead_o, MemtoReg_o, MemWrite_o, MemRead_o;

always@(posedge clk_i)
begin
  ALUout_o <= ALUout_i;
  Zero_o <= Zero_i;
  PC_o <= PC_i;
  regB_o <= regB_i;
  JumpAddr_o <= JumpAddr_i;
  RegistersRD_o <= RegistersRD_i;
  RegWrite_o <= RegWrite_i;
  RegRead_o <= RegRead_i;
  MemtoReg_o <= MemtoReg_i;
  MemWrite_o <= MemWrite_i;
  MemRead_o <= MemRead_i;
end
endmodule
