MUX32 MUX_JUMP(
    .data1_i    (read_data2),
    .data2_i    (signExtend),
    .select_i   (control_ALUSrc),
    .data_o     (MUX_32)
); 