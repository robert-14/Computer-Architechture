module PC
(
    clk_i,
    rst_i,
    start_i,
	stall_i,
	pcEnable_i,
    pc_i,
    write_i,
    pc_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input               write_i;
input				stall_i;
input	          pcEnable_i;
input   [31:0]      pc_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;


always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_o <= 32'b0;
    end
    else begin
		pc_o <= pc_o;
		if(stall_i) begin
			pc_o <= pc_o;
    	end
        else if(write_i) begin
            if(start_i || pcEnable_i) begin
                pc_o <= pc_i;
            end
            else begin
                pc_o <= pc_o;
            end
        end
    end
end

endmodule
