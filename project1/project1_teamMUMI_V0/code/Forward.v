module Forward(
  EXMEMRegRD_i,//destination from EX_MEM
  EXMEMRegWrite_i,//control signal from EX_MEM
  EXMEMMemtoReg_i,//control signal from EX_MEM
  MEMWBRegRD_i,//destination from MEM_WB
  MEMWBRegWrite_i,//control signal from MEM_WB
  IDEXRegRT_i,//form ID_EX
  IDEXRegRS_i,//from ID_EX
    
  ForwardA_o,//control signal to MUX6
  ForwardB_o //control signal to MUX7
);

input [4:0] EXMEMRegRD_i, MEMWBRegRD_i, IDEXRegRT_i, IDEXRegRS_i;
input EXMEMRegWrite_i, EXMEMMemtoReg_i, MEMWBRegWrite_i;

output reg [1:0] ForwardA_o, ForwardB_o;

// for MUX6 (RS)
always@(EXMEMRegRD_i or EXMEMRegWrite_i or EXMEMMemtoReg_i or MEMWBRegRD_i or MEMWBRegWrite_i or IDEXRegRT_i or IDEXRegRS_i)
begin
if ( EXMEMRegWrite_i && (EXMEMRegRD_i != 0) && (EXMEMRegRD_i == IDEXRegRS_i) )//ex add
  ForwardA_o <= 2'b10;
else if( MEMWBRegWrite_i && ( MEMWBRegRD_i != 0) && ( MEMWBRegRD_i == IDEXRegRS_i) && ( EXMEMRegRD_i != IDEXRegRS_i) )   //ex, lw => forward result of MEMWB to MUX6   
  ForwardA_o <= 2'b01;
else     //no forward
  ForwardA_o <= 2'b00;
  
// for MUX7 (RT)
if ( EXMEMRegWrite_i && (EXMEMRegRD_i != 0) && (EXMEMRegRD_i == IDEXRegRT_i) )//ex add
  ForwardB_o <= 2'b10;
else if( MEMWBRegWrite_i && ( MEMWBRegRD_i != 0) && ( MEMWBRegRD_i == IDEXRegRT_i) && ( EXMEMRegRD_i != IDEXRegRT_i) )   //ex, lw => forward result of MEMWB to MUX7   
  ForwardB_o <= 2'b01;
else     //no forward
  ForwardB_o <= 2'b00;  
end
endmodule
