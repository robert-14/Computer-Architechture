module Hazard_Detection(
    IDEXMemRead_i,
    IDEXRegRT_i,
    IFIDRegRT_i,
    IFIDRegRS_i,
    
    IFID_o,
    PCWrite_o,
    Hazard_o              //flush control signal
);
input [4:0] IDEXRegRT_i, IFIDRegRT_i, IFIDRegRS_i;
input IDEXMemRead_i;
output reg IFID_o, PCWrite_o, Hazard_o;

//To stall one cycle for lw hazard
always@(IDEXMemRead_i or IDEXRegRT_i or IFIDRegRT_i or IFIDRegRS_i)
begin
if ( IDEXMemRead_i && ((IDEXRegRT_i == IFIDRegRT_i) || (IDEXRegRT_i == IFIDRegRS_i)) )
  begin 
    IFID_o <= 1;    //flush IFID 
    PCWrite_o <= 0; //don't update PC
    Hazard_o <= 1; //flush control signal
  end
else // as usual
  begin
    IFID_o <= 0;
    PCWrite_o <= 1;
    Hazard_o <= 0;
  end
end
endmodule
