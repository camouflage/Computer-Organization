//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖
//----------------------------------------------
//Date:        4/29/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
	    rst_n
);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_n;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0]  pcOld;
wire [32-1:0]  pcNew;
wire [32-1:0]  pcAdd4;
wire [32-1:0]  instr;


/**** ID stage ****/
wire [32-1:0]  RSdata;
wire [32-1:0]  RTdata;
wire [32-1:0]  immediate;
wire [64-1:0]  AfterIF_ID;
//control signal
wire           RegDst;
wire [3-1:0]   ALUOp;
wire           ALUSrc;
wire           Branch;
wire           MemRead;
wire           MemWrite;
wire           RegWrite;
wire           MemtoReg;
wire           PCWrite;
wire           IF_IDWrite;
wire           Stall;
wire [10-1:0]  ControlSignal;
wire [2-1:0]   BranchType;


/**** EX stage ****/
wire [32-1:0]  ALUSrc1;
wire [32-1:0]  ALUSrc2;
wire [32-1:0]  ALUResult;
wire           ALUZero;
wire [5-1:0]   WriteReg;
wire [148-1:0] AfterID_EX;
wire [32-1:0]  ForwardBOut;
wire [32-1:0]  pcAddIm;
//control signal
wire [4-1:0]   ALUCtrl;
wire [2-1:0]   ForwardA;
wire [2-1:0]   ForwardB;

/**** MEM stage ****/
wire [32-1:0]  ReadData;
wire [107-1:0] AfterEX_MEM;


/**** WB stage ****/
wire [32-1:0]  WriteDataReg;
wire [71-1:0]  AfterMEM_WB;
//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i(rst_n),
        .PCWrite_i(PCWrite),     
        .pc_in_i(pcOld),   
        .pc_out_o(pcNew) 
);

Instruction_Memory IM(
        .addr_i(pcNew),  
	    .instr_o(instr)
);
			
Adder Add_PC4(
        .src1_i(pcNew),     
	    .src2_i(32'd4),     
	    .sum_o(pcAdd4)  
);

Pipe_Reg #(.size(64)) IF_ID(       // N is the total length of input/output
        .rst_i(rst_n),
        .clk_i(clk_i),
        .pipeRegWrite_i(IF_IDWrite),
                 // pc + 4
        .data_i({pcAdd4, instr}),
        .data_o(AfterIF_ID)
);

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pcAdd4),
        .data1_i(pcADDIm),
        .select_i(Branch && Branch2),
        .data_o(pcOld)
);
		
//Instantiate the components in ID stage
Reg_File RF(
	    .clk_i(clk_i),      
	    .rst_n(rst_n),     
        .RSaddr_i(AfterIF_ID[25:21]),  // instr[25:21]
        .RTaddr_i(AfterIF_ID[20:16]),  // instr[20:16]
        .RDaddr_i(AfterMEM_WB[4:0]),
        .RDdata_i(WriteDataReg),
        .RegWrite_i(AfterMEM_WB[70]), // RegWrite
        .RSdata_o(RSdata),
        .RTdata_o(RTdata) 
);

Decoder Control(
	    .instr_op_i(AfterIF_ID[31:26]), // instr[31:26]
        .RegDst_o(RegDst),
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),
        .Branch_o(Branch),   
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .RegWrite_o(RegWrite),
        .MemtoReg_o(MemtoReg),
        .BranchType_o(BranchType)
);

Hazard_Dection_Unit Hazard_Dection_Unit(
        .rs_i(AfterIF_ID[25:21]),
        .rt_i(AfterIF_ID[20:16]),
        .EX_Rt_i(AfterID_EX[9:5]),
        .EX_MEMRead_i(AfterID_EX[141]),
        .PCWrite_o(PCWrite),
        .IF_IDWrite_o(IF_IDWrite),
        .Stall_o(Stall)
);

MUX_2to1 #(.size(12)) Mux_Control(
        .data0_i({BranchType, RegDst, ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg}), // control
        .data1_i(12'b0),
        .select_i(Stall),
        .data_o(ControlSignal)
);

Sign_Extend Sign_Extend(
        .data_i(AfterIF_ID[15:0]), // instr[15:0]
        .data_o(immediate)
);

Pipe_Reg #(.size(150)) ID_EX(
        .rst_i(rst_n),
        .clk_i(clk_i),
        .pipeRegWrite_i(1'b1),
                                // pc + 4,                         
        .data_i({ControlSignal, AfterIF_ID[63:32], RSdata, RTdata,
             // contains RD,       RT,             RS
                immediate, AfterIF_ID[20:16], AfterIF_ID[25:21]}),
        .data_o(AfterID_EX)
);
		
//Instantiate the components in EX stage	   
ALU ALU(
        .rst_n(rst_n),
        .src1_i(ALUSrc1), 
	    .src2_i(ALUSrc2),
	    .ctrl_i(ALUCtrl),
        .shamt_i(AfterID_EX[20:16]), // instr[10:6]
	    .result_o(ALUResult),
	    .zero_o(ALUZero)
);
		
ALU_Ctrl ALU_Control(
        .funct_i(AfterID_EX[15:10]),   // instr[5:0]
        .ALUOp_i(AfterID_EX[146:144]),   // ALUOp
        .ALUCtrl_o(ALUCtrl)
);

Forwarding_Unit Forwarding_Unit(
        .rs_i(AfterID_EX[4:0]),
        .rt_i(AfterID_EX[9:5]),
        .MEM_RegDst_i(AfterEX_MEM[4:0]),
        .WB_RegDst_i(AfterMEM_WB[4:0]),
        .MEM_RegWrite_i(AfterEX_MEM[103]),
        .WB_RegWrite_i(AfterMEM_WB[70]),
        .ForwardA_o(ForwardA),
        .ForwardB_o(ForwardB)
);

MUX_3to1 #(.size(32)) Mux_ForwardA(
        .data0_i(AfterID_EX[105:74]), // RSdata
        .data1_i(WriteDataReg), // WB_ALUResult
        .data2_i(AfterEX_MEM[68:37]), // MEM_ALUResult
        //.data3_i(),
        .select_i(ForwardA),
        .data_o(ALUSrc1)
);

MUX_3to1 #(.size(32)) Mux_ForwardB(
        .data0_i(AfterID_EX[73:42]), // RTdata
        .data1_i(WriteDataReg), // WB_ALUResult
        .data2_i(AfterEX_MEM[68:37]), // MEM_ALUResult
        //.data3_i(),
        .select_i(ForwardB),
        .data_o(ForwardBOut)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
	    .data0_i(ForwardBOut), // 
        .data1_i(AfterID_EX[41:10]), // immediate
        .select_i(AfterID_EX[143]), // ALUSrc
        .data_o(ALUSrc2)
);
		
MUX_2to1 #(.size(5)) Mux_RegDst(
        .data0_i(AfterID_EX[9:5]), // RT
        .data1_i(AfterID_EX[25:21]), // RD
        .select_i(AfterID_EX[147]), // RegDst
        .data_o(WriteReg)
);

Adder Add_PCIm(
        .src1_i(pcAdd4),     
        .src2_i(immediateSL2),
        .sum_o(pcADDIm)     
);

Pipe_Reg #(.size(109)) EX_MEM(
        .rst_i(rst_n),
        .clk_i(clk_i),
        .pipeRegWrite_i(1'b1),
                 // control (BranchType)   
        .data_i({AfterID_EX[149:148], AfterID_EX[142:138], pcADDIm, ALUZero, ALUResult,
                // RTdata
                AfterID_EX[73:42], WriteReg}),
        .data_o(AfterEX_MEM)
);
	   
//Instantiate the components in MEM stage
Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(AfterEX_MEM[68:37]), // ALUResult
        .data_i(AfterEX_MEM[36:5]), // RTdata
        .MemRead_i(AfterEX_MEM[105]), // MemRead
        .MemWrite_i(AfterEX_MEM[104]), // MemWrite
        .data_o(ReadData)
);
// TO DO
MUX_4to1 #(.size(1)) MUX_BranchType (
        .data0_i(ALUZero),
        .data1_i(!(ALUZero || ALUResult[31])),
        .data2_i(!ALUResult[31]),
        .data3_i(!ALUZero),
        .select_i(BranchType),
        .data_o(Branch2)
);

Pipe_Reg #(.size(71)) MEM_WB(
        .rst_i(rst_n),
        .clk_i(clk_i),
        .pipeRegWrite_i(1'b1),
                 // control,                     ALUResult
        .data_i({AfterEX_MEM[103:102], ReadData, AfterEX_MEM[68:37],
                // WriteReg
                AfterEX_MEM[4:0]}),
        .data_o(AfterMEM_WB)
);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux_MemToReg(
        .data0_i(AfterMEM_WB[68:37]), // ReadData
        .data1_i(AfterMEM_WB[36:5]), // ALUResult
        .select_i(AfterMEM_WB[69]), // MemtoReg
        .data_o(WriteDataReg)
);

/****************************************
signal assignment
****************************************/	
endmodule
