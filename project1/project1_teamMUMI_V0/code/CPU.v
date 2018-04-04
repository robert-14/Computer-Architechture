module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] inst_addr, inst;
wire [31:0] pc_add;
wire [31:0] MUX1_o;
wire IF_Flush;
//  IF/ID
wire [31:0] pc_ID;
wire [31:0] RT_data, RS_data;
wire [31:0] instruction_extended;
wire eq, Jump;
//  ID/EX
wire [31:0] immidiate_o;
wire [31:0] MUX7_o;
wire [4:0] RegistersRT_o;
wire MemRead_o;
//  EX/MEM
wire [31:0] addr_i;
wire [4:0] EM_RegistersRD_o;
wire EM_RegWrite_o;
//  MEN/WB
wire [31:0] MUX5_o;
wire [4:0] MW_RegistersRD_o;
wire MW_RegWrite_o;

wire branch, Branch_o;
and and1(branch,Branch_o,eq);
or or1(IF_Flush,Jump,branch);
Control Control(
    .Op_i       (inst[31:26]),
    .Hazard_i   (),
    .RegDst_o   (ID_EX.RegDst_i),
    .ALUOp_o    (ID_EX.ALUOp_i),
    .ALUSrc_o   (ID_EX.ALUSrc_i),
    .RegWrite_o (ID_EX.RegWrite_i),
    .Jump_o     (Jump), // or branch_out
    .MemtoReg_o        (ID_EX.MemtoReg_i),
    .MemWrite_o        (ID_EX.MemWrite_i),
	.MemRead_o		   (ID_EX.MemRead_i),
    .Branch_o        (Branch_o) // and eq
);

Adder Add_PC( //Done
    .data1_i           (inst_addr),
    .data2_i           (32'd4),
    .data_o     (pc_add)
);
//Adder between IF_ID and ID_EX
Adder Add_ID( 
        .data1_i        (),
        .data2_i        (pc_ID),
        .data_o                (MUX1.data2_i)
);
Equal Equal(
    .data1_i(RS_data),
    .data2_i(RT_data),
    .data_o (eq)
);

PC PC( //Done
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (),
    .write_i      (),
    .pc_o       (inst_addr)
);
Data_Memory Data_Memory(
    .clk_i (clk_i),
    .addr_i(addr_i),
    .data_i(),
    .MemWrite_i(),
    .data_o(MEM_WB.MemoryDataRead_i)
);
Instruction_Memory Instruction_Memory( // Done
    .addr_i     (inst_addr), 
    .instr_o    (IF_ID.inst_i)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MW_RegistersRD_o), 
    .RDdata_i   (MUX5_o),
    .RegWrite_i (MW_RegWrite_o), 
    .RSdata_o   (RS_data), 
    .RTdata_o   (RT_data) 
);


MUX32 MUX1(
    .data1_i    (pc_add),
    .data2_i    (),
    .select_i   (branch),
    .data_o     (MUX1_o)
);

MUX32 MUX2(
    .data1_i    (MUX1_o),
    .data2_i    (),
    .select_i   (Jump),
    .data_o     (PC.pc_i)
);

MUX5 MUX3(
    .data1_i    (RegistersRT_o),
    .data2_i    (),
    .select_i   (),
    .data_o     (EX_MEM.RegistersRD_i)
);

MUX32 MUX4(
    .data1_i    (MUX7_o),
    .data2_i    (immidiate_o),
    .select_i   (),
    .data_o     (ALU.data2_i)
);

MUX32 MUX5(
    .data1_i    (),
    .data2_i    (),
    .select_i   (),
    .data_o     (MUX5_o)
);

MUX3_32 MUX6(
    .data1_i    (),
    .data2_i    (MUX5_o),
    .data3_i    (addr_i),
    .select_i   (),
    .data_o     (ALU.data1_i)
);

MUX3_32 MUX7(
    .data1_i    (),
    .data2_i    (MUX5_o),
    .data3_i    (addr_i),
    .select_i   (),
    .data_o     (MUX7_o)
);

Shift32 Shift32( //done
        .data_i                (instruction_extended),
        .data_o                (Add_ID.data1_i)
);

Shift26 Shift26(
        .data_i                (inst[25:0]),
        .data_o                (jump.data1_i)
);

Jump jump(
        .data1_i        (),
        .data2_i        (MUX1_o),
        .data_o                (MUX2.data2_i)
);

Sign_Extend Sign_Extend( //done
    .data_i     (inst[15:0]),
    .data_o     (instruction_extended)
);

  

ALU ALU(
    .data1_i    (),
    .data2_i    (),
    .ALUCtrl_i  (),
    .data_o     (EX_MEM.ALUout_i),
    .Zero_o     ()
);



ALU_Control ALU_Control(
    .funct_i    (immidiate_o[5:0]),
    .ALUOp_i    (),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);
//following is pipeline module
IF_ID IF_ID( // done
    .clk_i (clk_i),
    .pc_i (pc_add),
    .inst_i (),
    .flush_i (IF_Flush),
    .write_i(),
    .pc_o (pc_ID),
    .inst_o (inst)
);

ID_EX ID_EX(
    .clk_i      (clk_i),
    .regA_i     (RS_data),//data in register
    .regB_i    (RT_data),//data in register
    .PC_i       (pc_ID),
    .RegDst_i   (),//control signal
    .ALUOp_i    (), 
    .ALUSrc_i   (),
    .RegWrite_i    (),
    .MemtoReg_i (),
    .MemWrite_i (),
	.MemRead_i  (),
    .RegistersRS_i (inst[25:21]),  //5bits instruction
    .RegistersRT_i (inst[20:16]),  //5bits instruction
    .RegistersRD_i (inst[15:11]), //5bits instruction
    .immidiate_i   (instruction_extended), //immidiate value
    .regA_o    (MUX6.data1_i),
    .regB_o    (MUX7.data1_i),
    .PC_o       (),
    .RegDst_o   (MUX3.select_i),
    .ALUOp_o    (ALU_Control.ALUOp_i), 
    .ALUSrc_o   (MUX4.select_i),
    .RegWrite_o    (EX_MEM.RegWrite_i),
    .MemtoReg_o (EX_MEM.MemtoReg_i),
    .MemWrite_o (EX_MEM.MemWrite_i),
    .MemRead_o  (MemRead_o),
    .RegistersRS_o (Forward.IDEXRegRS_i),
    .RegistersRT_o (RegistersRT_o),
    .RegistersRD_o (MUX3.data2_i),
    .immidiate_o   (immidiate_o) 
);

EX_MEM EX_MEM(
    .clk_i      (clk_i),
    .ALUout_i     (), //32bits
    .Zero_i       (), //1 bit
    .PC_i         (), //32bits
    .regB_i      (MUX7_o), //32bits
    .JumpAddr_i   (), //32bits
    .RegistersRD_i (),
    .RegWrite_i      (),//control signal
    .RegRead_i    (),
    .MemtoReg_i   (),
    .MemWrite_i   (),
    .MemRead_i    (MemRead_o),

    .ALUout_o     (addr_i),
    .Zero_o       (),
    .PC_o         (),
    .regB_o      (Data_Memory.data_i),
    .JumpAddr_o   (),
    .RegistersRD_o (EM_RegistersRD_o),
    .RegWrite_o      (EM_RegWrite_o),
    .RegRead_o    (),
    .MemtoReg_o   (MEM_WB.MemtoReg_i),
    .MemWrite_o   (Data_Memory.MemWrite_i),
    .MemRead_o    () //???to the flag in Data_Memory???
);

MEM_WB MEM_WB(
    .clk_i        (clk_i),
    .ALUout_i     (addr_i),
    .MemoryDataRead_i (),//read data from memory
    .RegistersRD_i  (EM_RegistersRD_o),
    .RegWrite_i      (EM_RegWrite_o),
    .MemtoReg_i     (),
    
    .ALUout_o      (MUX5.data1_i),
    .MemoryDataRead_o (MUX5.data2_i),
    .RegistersRD_o (MW_RegistersRD_o), //to forward unit    
    .RegWrite_o       (MW_RegWrite_o), //20171210
    .MemtoReg_o    (MUX5.select_i)
    
);

Forward Forward(
    .EXMEMRegRD_i  (EM_RegistersRD_o),//destination from EX_MEM
    .EXMEMRegWrite_i     (EM_RegWrite_o),//control signal from EX_MEM
    .EXMEMMemtoReg_i     (),//control signal from EX_MEM ???? where?
    .MEMWBRegRD_i  (MW_RegistersRD_o),//destination from MEM_WB
    .MEMWBRegWrite_i     (MW_RegWrite_o),//control signal from MEM_WB
    .IDEXRegRT_i   (RegistersRT_o),//form ID_EX
    .IDEXRegRS_i   (),//from ID_EX
    
    .ForwardA_o          (MUX6.select_i),//control signal to MUX6
    .ForwardB_o          (MUX7.select_i) //control signal to MUX7
);

Hazard_Detection Hazard_Detection(
    .IDEXMemRead_i       (MemRead_o),
    .IDEXRegRT_i   (RegistersRT_o),
    .IFIDRegRT_i   (inst[20:16]),
    .IFIDRegRS_i   (inst[25:21]),
    
    .IFID_o              (IF_ID.write_i),
    .PCWrite_o           (PC.write_i),
    .Hazard_o              (Control.Hazard_i) //I don't know
        
);
endmodule
