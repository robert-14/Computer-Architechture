`define CYCLE_TIME 50            

module TestBench;

reg                Clk;
reg                Start;
reg	           Reset;
integer            i, outfile, counter;
integer            stall, flush;

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .rst_i  (Reset),
    .start_i(Start)
);
  
initial begin
    counter = 0;
    stall = 0;
    flush = 0;
    
    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end
    
    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 8'b0;
    end    
        
    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Registers.register[i] = 32'b0;
    end
    
    // Load instructions into instruction memory
    $readmemb("instruction.txt", CPU.Instruction_Memory.memory);
    
    // Open output file
    outfile = $fopen("Fibonacci_output.txt") | 1;
    
    // Set Input n into data memory at 0x00
    CPU.Data_Memory.memory[0] = 8'h5;       // n = 5 for example
    
    Clk = 1;
    Reset = 0;
    Start = 0;
    
    #(`CYCLE_TIME/4) 
    Reset = 1;
    Start = 1;
    $dumpfile("test.vcd");
	$dumpvars; 
    
end
always@(posedge Clk) begin
    if(counter == 65)    // stop after 30 cycles
        $stop;

    // put in your own signal to count stall and flush
    if(CPU.Hazard_Detection.Hazard_o == 1 && CPU.Control.Jump_o == 0 && CPU.Control.Branch_o == 0)stall = stall + 1;
    if(CPU.IF_Flush == 1)flush = flush + 1;  

    // print PC
    $fdisplay(outfile, "cycle = %d, Start = %d, Stall = %d, Flush = %d\nPC = %d", counter, Start, stall, flush, CPU.PC.pc_o);
    //$fdisplay(outfile, "inst = %b clk_i = %d rst_i = %d start_i = %d\n", CPU.IF_ID.inst_i, CPU.clk_i, CPU.rst_i, CPU.start_i);
    //$fdisplay(outfile, "IF_ID.inst_i = %b\n", CPU.IF_ID.inst_i);
    //$fdisplay(outfile, "IF_ID.inst_o = %b\n", CPU.IF_ID.inst_o);
    //$fdisplay(outfile, "Registers.RSdata_o = %d RTdata_o = %d\n", CPU.Registers.RSdata_o, CPU.Registers.RTdata_o);
    //$fdisplay(outfile, "Sign_Extend = %d\n", CPU.Sign_Extend.data_o);
    //$fdisplay(outfile, "ALU.data_o = %d\n", CPU.ALU.data_o);
    //$fdisplay(outfile, "MUX4.data1_i = %d data2_i = %d select_i = %d\n", CPU.MUX4.data1_i, CPU.MUX4.data2_i, CPU.MUX4.select_i);
    //$fdisplay(outfile, "MUX6.data1_i = %d data2_i = %d data3_i = %d select_i = %d\n", CPU.MUX6.data1_i, CPU.MUX6.data2_i, CPU.MUX6.data3_i, CPU.MUX6.select_i);
    //$fdisplay(outfile, "MUX7.data1_i = %d data2_i = %d data3_i = %d select_i = %d\n", CPU.MUX7.data1_i, CPU.MUX7.data2_i, CPU.MUX7.data3_i, CPU.MUX7.select_i);
    //$fdisplay(outfile, "pc_add = %d\n", CPU.pc_add);
    //$fdisplay(outfile, "Add_PC.data_o = %d\n", CPU.Add_PC.data_o);
    //$fdisplay(outfile, "PC.pc_i = %d\n", CPU.PC.pc_i);
    //$fdisplay(outfile, "MUX1.data1_i = %d data2_i = %d\n", CPU.MUX1.data1_i, CPU.MUX1.data2_i);
    //$fdisplay(outfile, "MUX2.data1_i = %d data2_i = %d select_i = %d\n", CPU.MUX2.data1_i, CPU.MUX2.data2_i, CPU.MUX2.select_i);
    //$fdisplay(outfile, "pc_start = %d\n", CPU.pc_start);
    //$fdisplay(outfile, "Data_Memory.data_i = %d addr_i = %d MemWrite = %d\n", CPU.Data_Memory.data_o, CPU.Data_Memory.addr_i, CPU.Data_Memory.MemWrite_i);
    
    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0(r0) = %d, R8 (t0) = %d, R16(s0) = %d, R24(t8) = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "R1(at) = %d, R9 (t1) = %d, R17(s1) = %d, R25(t9) = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "R2(v0) = %d, R10(t2) = %d, R18(s2) = %d, R26(k0) = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "R3(v1) = %d, R11(t3) = %d, R19(s3) = %d, R27(k1) = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "R4(a0) = %d, R12(t4) = %d, R20(s4) = %d, R28(gp) = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "R5(a1) = %d, R13(t5) = %d, R21(s5) = %d, R29(sp) = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "R6(a2) = %d, R14(t6) = %d, R22(s6) = %d, R30(s8) = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "R7(a3) = %d, R15(t7) = %d, R23(s7) = %d, R31(ra) = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 = %d", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 = %d", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 = %d", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c = %d", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 = %d", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 = %d", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 = %d", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c = %d", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});
	
    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
    
      
end

  
endmodule
