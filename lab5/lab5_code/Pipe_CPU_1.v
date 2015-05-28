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
wire [32-1:0]  pcBeforeJump;
wire [32-1:0]  instr;
wire [32-1:0]  instrAfterFlush;


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
wire [16-1:0]  IDControl;
wire [2-1:0]   BranchType;
wire           ReadDataReg;
wire           IsJal;
wire [2-1:0]   IsJJr;


/**** EX stage ****/
wire [32-1:0]  ALUSrc1;
wire [32-1:0]  ALUSrc2;
wire [32-1:0]  ALUResult;
wire           ALUZero;
wire [5-1:0]   WriteReg;
wire [154-1:0] AfterID_EX;
wire [32-1:0]  ForwardBOut;
wire [32-1:0]  pcAddIm;
wire [32-1:0]  ReadData2;
wire [32-1:0]  immediateSL2;
wire [32-1:0]  RTimmediate;
//control signal
wire [4-1:0]   ALUCtrl;
wire [2-1:0]   ForwardA;
wire [2-1:0]   ForwardB;
wire [8-1:0]   EXControl;

/**** MEM stage ****/
wire [32-1:0]  ReadData;
wire [142-1:0] AfterEX_MEM;
wire [5-1:0]   WriteRegAfterJal;


/**** WB stage ****/
wire [32-1:0]  WriteRegData;
wire [32-1:0]  WriteRegDataAfterJal;
wire [104-1:0]  AfterMEM_WB;
//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i(rst_n),
        .PCWrite_i(PCWrite), // lw-use hazard
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

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pcAdd4),
        .data1_i(AfterEX_MEM[101:70]), // pcAddIm
        .select_i(AfterEX_MEM[106] && Branch2), // Branch && Branch2
        .data_o(pcBeforeJump)
);

MUX_4to1 #(.size(32)) MUX_JJr (
        .data0_i(pcBeforeJump),
        .data1_i(ALUSrc1), // RSdata
        // pcAdd4[31:28], instr[25:0]
        .data2_i({AfterID_EX[137:134],
                  AfterID_EX[4:0], AfterID_EX[9:5], AfterID_EX[25:10],
                  2'b00}),
        .data3_i(),
        .select_i(AfterID_EX[152:151]), // isJJr
        .data_o(pcOld)
);

MUX_2to1 #(.size(32)) Mux_Instr(
        .data0_i(instr),
        .data1_i(32'd0),
        // flush on control hazard or jump,        isJJr
        .select_i((AfterEX_MEM[106] && Branch2) || AfterID_EX[152:151] != 2'b00),
        .data_o(instrAfterFlush)
);

Pipe_Reg #(.size(64)) IF_ID(       // N is the total length of input/output
        .rst_i(rst_n), // IF_Flush
        .clk_i(clk_i),
        .pipeRegWrite_i(IF_IDWrite), // lw-use hazard
                 // pcAdd4
        .data_i({pcAdd4, instrAfterFlush}),
        .data_o(AfterIF_ID)
);

//Instantiate the components in ID stage
Reg_File RF(
	    .clk_i(clk_i),      
	    .rst_n(rst_n),     
        .RSaddr_i(AfterIF_ID[25:21]),  // instr[25:21]
        .RTaddr_i(AfterIF_ID[20:16]),  // instr[20:16]
        .RDaddr_i(AfterMEM_WB[4:0]),
        .RDdata_i(WriteRegDataAfterJal),
        .RegWrite_i(AfterMEM_WB[70]), // RegWrite
        .RSdata_o(RSdata),
        .RTdata_o(RTdata) 
);

Decoder Control(
	    .instr_op_i(AfterIF_ID[31:26]), // instr[31:26]
        .instr_funct_i(AfterIF_ID[5:0]), // instr[10:6]
        .RegDst_o(RegDst),
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),
        .Branch_o(Branch),   
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .RegWrite_o(RegWrite),
        .MemtoReg_o(MemtoReg),
        .BranchType_o(BranchType),
        .ReadDataReg_o(ReadDataReg),
        .isJal_o(IsJal),
        .isJJr_o(IsJJr)
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

MUX_2to1 #(.size(16)) Mux_IDControl(
        .data0_i({IsJal, IsJJr, ReadDataReg, BranchType, RegDst, ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg}), // control
        .data1_i(16'd0),
        // lw-use hazard or control hazard
        .select_i(Stall || (AfterEX_MEM[106] && Branch2) ||
                  // isJJr
                  AfterID_EX[152:151] != 2'b00), // ID_Flush
        .data_o(IDControl)
);

Sign_Extend #(.size(16)) Sign_Extend(
        .zeroExtend_i(1'b0),
        .data_i(AfterIF_ID[15:0]), // instr[15:0]
        .data_o(immediate)
);

Pipe_Reg #(.size(154)) ID_EX(
        .rst_i(rst_n),
        .clk_i(clk_i),
        .pipeRegWrite_i(1'b1),
                            // pcAdd4,                         
        .data_i({IDControl, AfterIF_ID[63:32], RSdata, RTdata,
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

MUX_4to1 #(.size(32)) Mux_ForwardA(
        .data0_i(AfterID_EX[105:74]), // RSdata
        .data1_i(WriteRegDataAfterJal), // WB_ALUResult
        .data2_i(AfterEX_MEM[68:37]), // MEM_ALUResult
        .data3_i(),
        .select_i(ForwardA),
        .data_o(ALUSrc1)
);

MUX_4to1 #(.size(32)) Mux_ForwardB(
        .data0_i(AfterID_EX[73:42]), // RTdata
        .data1_i(WriteRegDataAfterJal), // WB_ALUResult
        .data2_i(AfterEX_MEM[68:37]), // MEM_ALUResult
        .data3_i(),
        .select_i(ForwardB),
        .data_o(ForwardBOut)
);

Sign_Extend #(.size(5)) SE_RTimm (
        .zeroExtend_i(1'b1),
        .data_i(AfterID_EX[9:5]), // RT
        .data_o(RTimmediate)
);

// For begz: rt field has const 1.
MUX_2to1 #(.size(32)) MUX_ReadData2 (
        .data0_i(RTimmediate),
        .data1_i(ForwardBOut), // Register data
        .select_i(AfterID_EX[150]), // ReadDataReg
        .data_o(ReadData2)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
	    .data0_i(ReadData2),
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

Shift_Left_Two_32 Shifter(
        .data_i(AfterID_EX[41:10]), // immediate
        .data_o(immediateSL2)
);

Adder Add_PCIm(
        .src1_i(AfterID_EX[137:106]), //pcAdd4  
        .src2_i(immediateSL2),
        .sum_o(pcAddIm)     
);

MUX_2to1 #(.size(8)) Mux_EXControl(
               // control: isJal,      BranchType   
        .data0_i({AfterID_EX[153], AfterID_EX[149:148], AfterID_EX[142:138]}),
        .data1_i(8'd0),
        .select_i(AfterEX_MEM[106] && Branch2), // EX_Flush
        .data_o(EXControl)
);

Pipe_Reg #(.size(142)) EX_MEM(
        .rst_i(rst_n),
        .clk_i(clk_i),
        .pipeRegWrite_i(1'b1),
              // pcAdd4
        .data_i({AfterID_EX[137:106], EXControl, pcAddIm, ALUZero, ALUResult,
                // RTdata
                ForwardBOut, WriteReg}),
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

MUX_4to1 #(.size(1)) MUX_BranchType (
        .data0_i(AfterEX_MEM[69]), // ALUZero, for beq
        .data1_i(!(AfterEX_MEM[69] || AfterEX_MEM[68])), // !(ALUZero || ALUResult[31]), for bgt
        .data2_i(!AfterEX_MEM[68]), // !ALUResult[31], for bgez
        .data3_i(!AfterEX_MEM[69]), // !ALUZero, for bne
        .select_i(AfterEX_MEM[108:107]), // BranchType
        .data_o(Branch2)
);

MUX_2to1 #(.size(5)) Mux_RegDstAfterJal(
        .data0_i(AfterEX_MEM[4:0]), // RT or RD
        .data1_i(5'b11111), // $r31
        .select_i(AfterEX_MEM[109]), // RegDst
        .data_o(WriteRegAfterJal)
);

Pipe_Reg #(.size(104)) MEM_WB(
        .rst_i(rst_n),
        .clk_i(clk_i),
        .pipeRegWrite_i(1'b1),
              // pcAdd4,               control: isJal                     
        .data_i({AfterEX_MEM[141:110], AfterEX_MEM[109], AfterEX_MEM[103:102], 
                       // ALUResult
                ReadData, AfterEX_MEM[68:37], WriteRegAfterJal}),
        .data_o(AfterMEM_WB)
);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux_MemToReg(
        .data0_i(AfterMEM_WB[68:37]), // ReadData
        .data1_i(AfterMEM_WB[36:5]), // ALUResult
        .select_i(AfterMEM_WB[69]), // MemtoReg
        .data_o(WriteRegData)
);

MUX_2to1 #(.size(32)) Mux_MemToRegAfterJal(
        .data0_i(WriteRegData),
        .data1_i(AfterMEM_WB[103:72]), // pcAdd4
        .select_i(AfterMEM_WB[71]), // isJal
        .data_o(WriteRegDataAfterJal)
);

/****************************************
signal assignment
****************************************/	
endmodule
