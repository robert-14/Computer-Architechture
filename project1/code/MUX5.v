module MUX5
(
	data1_i,
	data2_i,
	select_i,
	data_o
);

input [4:0] data1_i, data2_i;
input select_i;
output [4:0] data_o;
reg data_o;
always @(data1_i, data2_i, select_i)
begin
	if(select_i == 1'b0)
	begin
		data_o <= data1_i;
	end
	if(select_i == 1'b1)
	begin
		data_o <= data2_i;
	end
end

endmodule
