//Subject:     CO project 6 - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns / 1ps
`define CYCLE_TIME 10			

module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
integer     count;
integer     i;
integer     handle;

wire [32-1:0]  ReadData;
wire [32-1:0]  instr;
wire [32-1:0]  instr2;
// Create tested modle  
Pipe_CPU_1 cpu (
        .clk_i(CLK),
	    .rst_n(RST)
);

Pipe_CPU_2 cpu2 (
        .clk_i(CLK),
	    .rst_n(RST)
);

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i({cpu.AfterEX_MEM[68:37], cpu2.AfterEX_MEM[68:37]}), // ALUResult
        .data_i({cpu.AfterEX_MEM[36:5], cpu2.AfterEX_MEM[36:5]}), // RTdata
        .MemRead_i({cpu.AfterEX_MEM[105], cpu2.AfterEX_MEM[105]}), // MemRead
        .MemWrite_i({cpu.AfterEX_MEM[104], cpu.AfterEX_MEM[104]}), // MemWrite
        .data_o(ReadData)
);

Instruction_Memory IM(
        .addr_i(cpu.pcNew),  
	    .instr_o(instr)
);

Instruction_Memory2 IM2(
        .addr_i(cpu2.pcNew),  
	    .instr_o(instr2)
);
//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial  begin
//$readmemb("LAB6_machine_1.txt", cpu.IM.instruction_file);
//$readmemb("LAB6_machine_2.txt", cpu2.IM.instruction_file);
	CLK = 0;
	RST = 0;
	count = 0;
    
    #(`CYCLE_TIME)      RST = 1;
    #(`CYCLE_TIME*800)      $stop;

end


always@(posedge CLK) begin
    count = count + 1;
	if( count == 650 ) begin 
	//print result to transcript 
	$display("Register===========================================================\n");
	$display("r0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d\n",
	cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], cpu.RF.Reg_File[4], 
	cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7],
	);
	$display("r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d, r15=%d\n",
	cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], cpu.RF.Reg_File[10], cpu.RF.Reg_File[11], cpu.RF.Reg_File[12], 
	cpu.RF.Reg_File[13], cpu.RF.Reg_File[14], cpu.RF.Reg_File[15],
	);
	$display("r16=%d, r17=%d, r18=%d, r19=%d, r20=%d, r21=%d, r22=%d, r23=%d\n",
	cpu.RF.Reg_File[16], cpu.RF.Reg_File[17], cpu.RF.Reg_File[18], cpu.RF.Reg_File[19], cpu.RF.Reg_File[20], 
	cpu.RF.Reg_File[21], cpu.RF.Reg_File[22], cpu.RF.Reg_File[23],
	);
	$display("r24=%d, r25=%d, r26=%d, r27=%d, r28=%d, r29=%d, r30=%d, r31=%d\n",
	cpu.RF.Reg_File[24], cpu.RF.Reg_File[25], cpu.RF.Reg_File[26], cpu.RF.Reg_File[27], cpu.RF.Reg_File[28], 
	cpu.RF.Reg_File[29], cpu.RF.Reg_File[30], cpu.RF.Reg_File[31],
	);

	$display("\nRegister2===========================================================\n");
	$display("r0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d\n",
	cpu2.RF.Reg_File[0], cpu2.RF.Reg_File[1], cpu2.RF.Reg_File[2], cpu2.RF.Reg_File[3], cpu2.RF.Reg_File[4], 
	cpu2.RF.Reg_File[5], cpu2.RF.Reg_File[6], cpu2.RF.Reg_File[7],
	);
	$display("r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d, r15=%d\n",
	cpu2.RF.Reg_File[8], cpu2.RF.Reg_File[9], cpu2.RF.Reg_File[10], cpu2.RF.Reg_File[11], cpu2.RF.Reg_File[12], 
	cpu2.RF.Reg_File[13], cpu2.RF.Reg_File[14], cpu2.RF.Reg_File[15],
	);
	$display("r16=%d, r17=%d, r18=%d, r19=%d, r20=%d, r21=%d, r22=%d, r23=%d\n",
	cpu2.RF.Reg_File[16], cpu2.RF.Reg_File[17], cpu2.RF.Reg_File[18], cpu2.RF.Reg_File[19], cpu2.RF.Reg_File[20], 
	cpu2.RF.Reg_File[21], cpu2.RF.Reg_File[22], cpu2.RF.Reg_File[23],
	);
	$display("r24=%d, r25=%d, r26=%d, r27=%d, r28=%d, r29=%d, r30=%d, r31=%d\n",
	cpu2.RF.Reg_File[24], cpu2.RF.Reg_File[25], cpu2.RF.Reg_File[26], cpu2.RF.Reg_File[27], cpu2.RF.Reg_File[28], 
	cpu2.RF.Reg_File[29], cpu2.RF.Reg_File[30], cpu2.RF.Reg_File[31],
	);
	
	$display("\nMemory===========================================================\n");
	$display("m0=%d, m1=%d, m2=%d, m3=%d, m4=%d, m5=%d, m6=%d, m7=%d\n\nm8=%d, m9=%d, m10=%d, m11=%d, m12=%d, m13=%d, m14=%d, m15=%d\n\nr16=%d, m17=%d, m18=%d, m19=%d, m20=%d, m21=%d, m22=%d, m23=%d\n\nm24=%d, m25=%d, m26=%d, m27=%d, m28=%d, m29=%d, m30=%d, m31=%d",							 
	          DM.memory[0], DM.memory[1], DM.memory[2], DM.memory[3],
				 DM.memory[4], DM.memory[5], DM.memory[6], DM.memory[7],
				 DM.memory[8], DM.memory[9], DM.memory[10], DM.memory[11],
				 DM.memory[12], DM.memory[13], DM.memory[14], DM.memory[15],
				 DM.memory[16], DM.memory[17], DM.memory[18], DM.memory[19],
				 DM.memory[20], DM.memory[21], DM.memory[22], DM.memory[23],
				 DM.memory[24], DM.memory[25], DM.memory[26], DM.memory[27],
				 DM.memory[28], DM.memory[29], DM.memory[30], DM.memory[31]
			  );
	//$display("\nPC=%d\n",cpu.PC.pc_i);
	end
	else ;
end
  
endmodule

