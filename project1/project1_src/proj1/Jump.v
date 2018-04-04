module Jump
(
	data1_i,
	data2_i,
	data_o
);

input 	[27:0] 	data1_i;
input   [31:0]	data2_i;
output 	[31:0] 	data_o;

assign data_o[31:28] = data2_i[31:28];
assign data_o[27:0]  = data1_i;

endmodule
