module Control
(
        Op_i,
        Hazard_i,
        RegDst_o,
        ALUOp_o,
        ALUSrc_o,
        RegWrite_o,
        Jump_o,
        MemtoReg_o,
        MemWrite_o,
		MemRead_o,
        Branch_o
);

input [5:0] Op_i;
input Hazard_i;
output [1:0] ALUOp_o;
output RegDst_o, ALUSrc_o, RegWrite_o;
output MemtoReg_o, MemWrite_o, MemRead_o, Branch_o, Jump_o; //lw sw beq j
reg RegDst_o, ALUSrc_o, RegWrite_o, ALUOp_o;
reg MemtoReg_o, MemWrite_o, MemRead_o, Branch_o, Jump_o;
always@(Op_i, Hazard_i)
begin
        if(Hazard_i == 1'b1)
        begin
                RegDst_o <= 0;
                ALUOp_o <= 0;
                ALUSrc_o <= 0;
                RegWrite_o <= 0;
                Jump_o <= 0;
                MemtoReg_o <= 0;
                MemWrite_o <= 0;
				MemRead_o <= 0;
                Branch_o <= 0;
        end
        else begin
                if(Op_i == 6'b000000) //R type
                begin
                        RegDst_o <= 1;
                        ALUSrc_o <= 0;
                        MemtoReg_o <= 0;
                        RegWrite_o <= 1;
                        MemWrite_o <= 0;
						MemRead_o <= 0;
                        Branch_o <= 0;
                        Jump_o <= 0;
                        ALUOp_o <= 2'b11;
                end
                if(Op_i == 6'b001000) //addi
                begin
                        RegDst_o <= 0;
                        ALUSrc_o <= 1;
                        MemtoReg_o <= 0;
                        RegWrite_o <= 1;
                        MemWrite_o <= 0;
						MemRead_o <= 0;
                        Branch_o <= 0;
                        Jump_o <= 0;
                        ALUOp_o <= 2'b00;
                end
                if(Op_i == 6'b100011) //lw
                begin
                        RegDst_o <= 0;
                        ALUSrc_o <= 1;
                        MemtoReg_o <= 1;
                        RegWrite_o <= 1;
                        MemWrite_o <= 0;
						MemRead_o <= 1;
                        Branch_o <= 0;
                        Jump_o <= 0;
                        ALUOp_o <= 2'b00;
                end
                if(Op_i == 6'b101011) //sw
                begin
                        ALUSrc_o <= 1;
                        RegWrite_o <= 0;
                        MemWrite_o <= 1;
						MemRead_o <= 0;
                        Branch_o <= 0;
                        Jump_o <= 0;
                        ALUOp_o <= 2'b00;
                end
                if(Op_i == 6'b000100) //beq
                begin
                        ALUSrc_o <= 0;
                        RegWrite_o <= 0;
                        MemWrite_o <= 0;
						MemRead_o <= 0;
                        Branch_o <= 1;
                        Jump_o <= 0;
                        ALUOp_o <= 2'b01;
                end
                if(Op_i == 6'b000010) //jump
                begin
                        RegWrite_o <= 0;
                        MemWrite_o <= 0;
						MemRead_o <= 0;
                        Branch_o <= 0;
                        Jump_o <= 1;
                end
        end
end

endmodule