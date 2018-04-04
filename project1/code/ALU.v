module ALU
(
	data1_i,
	data2_i,
	ALUCtrl_i,
	data_o,
	Zero_o
);

input [31:0] data1_i, data2_i;
input [2:0] ALUCtrl_i;
output [31:0] data_o;
output Zero_o;
reg Zero_o, data_o;
// wire can't be assign in always block
always @(data1_i or data2_i or ALUCtrl_i)
begin
	if(ALUCtrl_i == 3'b010) //Add
	begin
		data_o <= data1_i + data2_i;
	end
	if(ALUCtrl_i == 3'b110) //Sub
	begin
		data_o <= data1_i - data2_i;
	end
	if(ALUCtrl_i == 3'b001) //Or
	begin
		data_o <= data1_i | data2_i;
	end
	if(ALUCtrl_i == 3'b000) //And
	begin
		data_o <= data1_i & data2_i;
	end
	if(ALUCtrl_i == 3'b011) //Mul
	begin
		data_o <= data1_i * data2_i;
	end
	if(data_o == 32'h0000)
	begin
		Zero_o <= 1'b1;
	end
	else
	begin
		Zero_o <= 1'b0;
	end
end

endmodule
