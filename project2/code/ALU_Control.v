module ALU_Control
(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);

input [5:0] funct_i;
input [1:0] ALUOp_i;
output [2:0] ALUCtrl_o;
reg ALUCtrl_o = 0;
always@(funct_i or ALUOp_i)
begin
	if(ALUOp_i == 2'b11) //R type
	begin
		if(funct_i == 6'b100000) // add
		begin
			ALUCtrl_o <= 3'b010;
		end
		if(funct_i == 6'b100010) // sub
		begin
			ALUCtrl_o <= 3'b110;
		end
		if(funct_i == 6'b100100) // and
		begin
			ALUCtrl_o <= 3'b000;
		end
		if(funct_i == 6'b100101) // or
		begin
			ALUCtrl_o <= 3'b001;
		end
		if(funct_i == 6'b011000) // mul
		begin
			ALUCtrl_o <= 3'b011;
		end
	end
	if(ALUOp_i == 2'b00) //add(lw sw addi)
	begin
		ALUCtrl_o <= 3'b010;
	end
	if(ALUOp_i == 2'b01) //beq(sub)
	begin
		ALUCtrl_o <= 3'b110;
	end
	if(ALUOp_i == 2'b10) //or(ori)
	begin
		ALUCtrl_o <= 3'b001;
	end

end
endmodule
