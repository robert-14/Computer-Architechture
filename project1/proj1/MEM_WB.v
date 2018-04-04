module MEM_WB(
    clk_i,
    ALUout_i,
    MemoryDataRead_i,//read data from memory
    RegistersRD_i,
    RegWrite_i,
    MemtoReg_i,
	
    ALUout_o,
    MemoryDataRead_o,
    RegistersRD_o, //to forward unit    
    RegWrite_o,
    MemtoReg_o
);

input clk_i;
input [31:0] ALUout_i, PC_i, MemoryDataRead_i;
input [4:0] RegistersRD_i;
input RegWrite_i, MemtoReg_i;

output [31:0] ALUout_o, PC_o, MemoryDataRead_o;
output [4:0] RegistersRD_o;
output RegWrite_o, MemtoReg_o;
reg ALUout_o, MemoryDataRead_o, RegistersRD_o, RegWrite_o, MemtoReg_o;

always@(posedge clk_i)
begin
	ALUout_o <= ALUout_i;
	MemoryDataRead_o <= MemoryDataRead_i;
	RegistersRD_o <= RegistersRD_i;
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;
end
endmodule
