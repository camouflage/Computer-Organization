//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖
//----------------------------------------------
//Date:        4/11/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pcOld;
wire [32-1:0] pcAdd4;
wire [32-1:0] pcADDIm;
wire [32-1:0] pcNew;
wire [32-1:0] instr;
wire [32-1:0] pcBeforeJump;
wire [32-1:0] pcBeforeJr;
wire [5-1:0]  RegToWrite1;

// data
wire [32-1:0] RSdata;
wire [32-1:0] RTdata;
wire [32-1:0] immediate;
wire [32-1:0] immediateSL2;
wire [32-1:0] ALUIn2;
wire [32-1:0] ALUResult;
wire          ALUZero;
wire [32-1:0] ReadData;
wire [32-1:0] WriteDataMem;
wire [32-1:0] WriteDataReg;

// extra
wire [32-1:0] ReadData2;
wire [32-1:0] RTimmediate;

// control
wire RegDst;
wire RegWrite;
wire ALUSrc;
wire Branch;
wire [3-1:0] ALUOp;
wire [4-1:0] ALUCtrl;
wire isOri;

// lab3
wire [2-1:0] BranchType;
wire Jump;
wire MemRead;
wire MenWrite;
wire [2-1:0] MemtoReg;
wire Branch2;
// extra
wire ReadDataReg;
wire IsJal;
//wire IsJr;
wire [2-1:0] IsJJr;

// register
wire [5-1:0] WriteReg;



//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	.rst_i(rst_i),     
        .pc_in_i(pcOld),   
        .pc_out_o(pcNew) 
);

// PC + 4
Adder Adder1(
        .src1_i(pcNew),     
	.src2_i(32'd4),     
	.sum_o(pcAdd4)    
);
	
Instr_Memory IM(
        .pc_addr_i(pcNew),  
	.instr_o(instr)
);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(RegToWrite1)
);	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i),     
        .RSaddr_i(instr[25:21]),  
        .RTaddr_i(instr[20:16]),  
        .RDaddr_i(WriteReg),  
        .RDdata_i(WriteDataReg), 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata)   
);
	
Decoder Decoder(
        .instr_op_i(instr[31:26]),
        .instr_funct_i(instr[5:0]),
        .RegWrite_o(RegWrite), 
	.ALU_op_o(ALUOp),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),   
	.Branch_o(Branch),
        .isOri_o(isOri),
        .BranchType_o(BranchType),
        //.Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MenWrite),
        .MemtoReg_o(MemtoReg),
        .ReadDataReg_o(ReadDataReg),
        .isJal_o(IsJal),
        //.isJr_o(IsJr)
        .isJJr_o(IsJJr)
);

ALU_Ctrl AC(
        .funct_i(instr[6-1:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl)
);
	
Sign_Extend #(.size(16)) SE(
        .isOri_i(isOri), // ori: zero-extend.
        .data_i(instr[15:0]),
        .data_o(immediate)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(ReadData2),
        .data1_i(immediate),
        .select_i(ALUSrc),
        .data_o(ALUIn2)
);	
		
ALU ALU(
        .rst_n(rst_i), // no use?
        .src1_i(RSdata),
	.src2_i(ALUIn2),
	.ctrl_i(ALUCtrl),
        .shamt_i(instr[10:6]),
	.result_o(ALUResult),
	.zero_o(ALUZero)
);

// PC + immediate
Adder Adder2(
        .src1_i(pcAdd4),     
	.src2_i(immediateSL2),
        .sum_o(pcADDIm)     
);

Shift_Left_Two_32 Shifter(
        .data_i(immediate),
        .data_o(immediateSL2)
); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pcAdd4),
        .data1_i(pcADDIm),
        .select_i(Branch && Branch2),
        .data_o(pcBeforeJump)
);	

// lab3
/*
MUX_2to1 #(.size(32)) MUX_Jump (
        .data0_i(pcBeforeJump),
        .data1_i({pcAdd4[31:28], instr[25:0], 2'b00}), // cancatenation
        .select_i(Jump),
        .data_o(pcBeforeJr)
        //.data_o(pcOld)
);
*/
MUX_4to1 #(.size(1)) MUX_BranchType (
        .data0_i(ALUZero),
        .data1_i(!(ALUZero || ALUResult[31])),
        .data2_i(!ALUResult[31]),
        .data3_i(!ALUZero),
        .select_i(BranchType),
        .data_o(Branch2)
);

MUX_4to1 #(.size(32)) MUX_MemToReg (
        .data0_i(ALUResult),
        .data1_i(ReadData),
        .data2_i(immediate),
        .data3_i(pcAdd4), // for jal
        .select_i(MemtoReg),
        .data_o(WriteDataReg)
);

Data_Memory DM (
        .clk_i(clk_i),
        .addr_i(ALUResult),
        .data_i(ReadData2),
        .MemRead_i(MemRead),
        .MemWrite_i(MenWrite),
        .data_o(ReadData)
);

// sign-extend for RTimmediate in instruction bnez & bgez
Sign_Extend #(.size(5)) SE_RTimm (
        .isOri_i(1'b0), // ori: zero-extend.
        .data_i(instr[20:16]),
        .data_o(RTimmediate)
);

MUX_2to1 #(.size(32)) MUX_ReadData2 (
        .data0_i(RTimmediate),
        .data1_i(RTdata),
        .select_i(ReadDataReg),
        .data_o(ReadData2)
);

MUX_2to1 #(.size(5)) MUX_Jal (
        .data0_i(RegToWrite1),
        .data1_i(5'b11111), // $ra
        .select_i(IsJal),
        .data_o(WriteReg)
);
/*
MUX_2to1 #(.size(32)) MUX_Jr (
        .data0_i(pcBeforeJr),
        .data1_i(RSdata),
        .select_i(IsJr),
        .data_o(pcOld)
);
*/

MUX_4to1 #(.size(32)) MUX_JJr (
        .data0_i(pcBeforeJump),
        .data1_i(RSdata),
        .data2_i({pcAdd4[31:28], instr[25:0], 2'b00}),
        .data3_i(),
        .select_i(IsJJr),
        .data_o(pcOld)
);

endmodule
		  


