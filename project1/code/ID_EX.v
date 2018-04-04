module ID_EX(
    clk_i,
    regA_i,//data in register
    regB_i,//data in register
    PC_i,
    RegDst_i,//control signal
    ALUOp_i, 
    ALUSrc_i,
    RegWrite_i,
    MemtoReg_i,
    MemWrite_i,
    MemRead_i,
    RegistersRS_i,  //5bits instruction
    RegistersRT_i,  //5bits instruction
    RegistersRD_i, //5bits instruction
    immidiate_i, //immidiate value
    regA_o,
    regB_o,
    PC_o,
    RegDst_o,
    ALUOp_o, 
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemWrite_o,
    MemRead_o,
    RegistersRS_o,
    RegistersRT_o,
    RegistersRD_o,
    immidiate_o 
);

input clk_i;
input [31:0] regA_i, regB_i, PC_i;
//control signal
input [1:0] ALUOp_i;
input RegDst_i, ALUSrc_i, RegWrite_i, MemtoReg_i, MemWrite_i, MemRead_i;
//5bits instruction
input [4:0] RegistersRD_i, RegistersRS_i, RegistersRT_i;
input [31:0] immidiate_i;

output [31:0] regA_o, regB_o, PC_o;
output [1:0] ALUOp_o;
//control signal
output RegDst_o, ALUSrc_o, RegWrite_o, MemtoReg_o, MemWrite_o, MemRead_o;
//5bits instruction
output [4:0] RegistersRD_o, RegistersRS_o, RegistersRT_o;
output [31:0] immidiate_o;
reg regA_o, regB_o, PC_o, RegDst_o, ALUOp_o, ALUSrc_o, RegWrite_o, MemtoReg_o, MemWrite_o, MemRead_o, RegistersRD_o, RegistersRS_o, RegistersRT_o, immidiate_o;

always@(posedge clk_i)
begin
  regA_o <= regA_i;
  regB_o <= regB_i;
  PC_o <= PC_i;
  RegDst_o <= RegDst_i;
  ALUOp_o <= ALUOp_i;
  ALUSrc_o <= ALUSrc_i;
  RegWrite_o <= RegWrite_i;
  MemtoReg_o <= MemtoReg_i;
  MemWrite_o <= MemWrite_i;
  MemRead_o <= MemRead_i;
  RegistersRD_o <= RegistersRD_i;
  RegistersRS_o <= RegistersRS_i;
  RegistersRT_o <= RegistersRT_i;
  immidiate_o <= immidiate_i;
end

endmodule
