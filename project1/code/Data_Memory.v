module Data_Memory
(
	clk_i,
	addr_i,
	data_i,
	MemWrite_i,
	data_o
);

input clk_i;
input [31:0] addr_i;
input [31:0] data_i;
input MemWrite_i;

output [31:0] data_o;
reg [7:0] memory [0:31];


always@(posedge clk_i)
begin
	if(MemWrite_i == 1)
	begin
		memory[addr_i] <= data_i;
	end
end

assign data_o = memory[addr_i];

endmodule
