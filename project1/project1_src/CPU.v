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
wire [31:0] instruction_extended;
wire [31:0] jump_pc;
wire [31:0] pc_add;
reg branch;

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (MUX_RegDst.select_i),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .ALUSrc_o   (MUX_ALUSrc.select_i),
    .RegWrite_o (Registers.RegWrite_i),
	.Jump_o     (),
	.MemtoReg_o	(),
	.MemWrite_o	(),
	.MemRead_o	(),
	.Branch_o	()
);

Adder Add_PC(
    .data1_i   	(inst_addr),
    .data2_i   	(32'd4),
    .data_o     (pc_add)
);

Adder Add_ALU(
	.data1_i	(pc_add),
	.data2_i	(Shift32.data_o),
	.data_o		(MUX_Branch.data2_i),
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (MUX_Jump.data_o),
    .pc_o       (Add_PC.data1_in)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (), 
    .RDdata_i   (),
    .RegWrite_i (), 
    .RSdata_o   (ALU.data1_i), 
    .RTdata_o   (MUX_ALUSrc.data1_i) 
);


MUX5 MUX_RegDst(
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (),
    .data_o     (Registers.RDaddr_i)
);



MUX32 MUX_ALUSrc(
    .data1_i    (),
    .data2_i    (instruction_extended),
    .select_i   (),
    .data_o     (ALU.data2_i)
);

MUX32 MUX_Jump(
	.data1_i	(MUX_Branch.data_o),
	.data2_i	(),
	.select_i	(Control.Jump_o),
	.data_o		()
);

MUX32 MUX_Branch(
	.data1_i	(pc_add),
	.data2_i	(Add_ALU.data_o),
	.select_i	(Control.Branch_o),
	.data_o		(MUX_Jump.data1_i)
);
	
Shift32 Shift32(
	.data_i		(instruction_extended),
	.data_o		(Add_ALU.data2_i)
);

Shift26 Shift26(
	.data_i		(inst[25:0]),
	.data_o		(),
);

Jump jump(
	.data1_i	(),
	.data2_i	(),
	.data_o		()
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (instruction_extended)
);

  

ALU ALU(
    .data1_i    (),
    .data2_i    (),
    .ALUCtrl_i  (),
    .data_o     (Registers.RDdata_i),
    .Zero_o     ()
);



ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);


endmodule

