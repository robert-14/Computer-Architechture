
module MUX3_32
(
        data1_i,
        data2_i,
        data3_i,
        select_i,
        data_o
);

input [31:0] data1_i, data2_i, data3_i;
input [1:0] select_i;
output [31:0] data_o;
reg data_o;
always @(data1_i, data2_i, select_i)
begin
        if(select_i == 2'b00)
        begin
                data_o <= data1_i;
        end
        if(select_i == 2'b01)
        begin
                data_o <= data2_i;
        end
        if(select_i == 2'b10)
        begin
                data_o <= data3_i;
        end
end

endmodule
