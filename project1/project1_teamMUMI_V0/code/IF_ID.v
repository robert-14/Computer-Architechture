module IF_ID(
	clk_i,
	pc_i,
	inst_i,
	flush_i,
	write_i,
	pc_o,
	inst_o
);

input clk_i, flush_i, write_i;
input [31:0] pc_i, inst_i;
output [31:0] pc_o, inst_o;
reg pc_o, inst_o;
always@(posedge clk_i)
begin // modified at 12/8 18:46 by toetoe
	if(write_i == 0)
	begin
		pc_o <= pc_i;
		// 20171210
		if(flush_i == 1) // check whether we need to flush  
		begin
			inst_o <= 32'b0;
		end
		else
		begin
			inst_o <= inst_i; 
		end
		/*pc_o = pc_i;
		inst_o = inst_i;*/
	end
	else
	begin
		//flush
	end
end
endmodule
