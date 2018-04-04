
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
wire [31:0] RT_data;
wire [31:0] ALU_result;
wire branch, Branch_o, Zero;
and and1(branch,Branch_o,Zero);

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (MUX_RegDst.select_i),
    .ALUOp_o    (ALU_Control.ALUOp_i),
    .ALUSrc_o   (MUX_ALUSrc.select_i),
    .RegWrite_o (Registers.RegWrite_i),
    .Jump_o     (MUX_Jump.select_i),
    .MemtoReg_o        (MUX_Memory.select_i),
    .MemWrite_o        (Data_Memory.MemWrite_i),
    .Branch_o        (Branch_o)
);

Adder Add_PC(
    .data1_i           (inst_addr),
    .data2_i           (32'd4),
    .data_o     (pc_add)
);

Adder Add_ALU(
        .data1_i        (pc_add),
        .data2_i        (),
        .data_o                (MUX_Branch.data2_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (),
    .pc_o       (inst_addr)
);
Data_Memory Data_Memory(
    .clk_i (clk_i),
    .addr_i(ALU_result),
    .data_i(RT_data),
    .MemWrite_i(),
    .data_o(MUX_Memory.data2_i)
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
    .RTdata_o   (RT_data) 
);


MUX5 MUX_RegDst(
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (),
    .data_o     (Registers.RDaddr_i)
);


MUX32 MUX_Memory(
    .data1_i    (ALU_result),
    .data2_i    (),
    .select_i   (),
    .data_o     (Registers.RDdata_i)
);

MUX32 MUX_ALUSrc(
    .data1_i    (RT_data),
    .data2_i    (instruction_extended),
    .select_i   (),
    .data_o     (ALU.data2_i)
);

MUX32 MUX_Jump(
        .data1_i        (),
        .data2_i        (),
        .select_i        (),
        .data_o                (PC.pc_i)
);

MUX32 MUX_Branch(
        .data1_i        (pc_add),
        .data2_i        (),
        .select_i       (branch),
        .data_o         (MUX_Jump.data1_i)
);
        
Shift32 Shift32(
        .data_i                (instruction_extended),
        .data_o                (Add_ALU.data2_i)
);

Shift26 Shift26(
        .data_i                (inst[25:0]),
        .data_o                (jump.data1_i)
);

Jump jump(
        .data1_i        (),
        .data2_i        (pc_add),
        .data_o                (MUX_Jump.data2_i)
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (instruction_extended)
);

  

ALU ALU(
    .data1_i    (),
    .data2_i    (),
    .ALUCtrl_i  (),
    .data_o     (ALU_result),
    .Zero_o     (Zero)
);



ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);


endmodule