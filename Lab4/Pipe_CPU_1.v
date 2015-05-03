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


/**** EX stage ****/
wire [32-1:0]  ALUIn2;
wire [32-1:0]  ALUResult;
wire           ALUZero;
wire [5-1:0]   WriteReg;
wire [148-1:0] AfterID_EX;
//control signal
wire [4-1:0]   ALUCtrl;


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
PC PC(
        .clk_i(clk_i),      
	    .rst_i(rst_n),     
        .pc_in_i(pcOld),   
        .pc_out_o(pcNew) 
);

Instr_Memory IM(
        .pc_addr_i(pcNew),  
	    .instr_o(instr)
);
			
Adder Add_pc(
        .src1_i(pcNew),     
	    .src2_i(32'd4),     
	    .sum_o(pcOld)  
);

Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
        .rst_i(rst_n),
        .clk_i(clk_i),
                 // pc + 4
        .data_i({pcOld, instr}),
        .data_o(AfterIF_ID)
);
		
//Instantiate the components in ID stage
Reg_File RF(
	    .clk_i(clk_i),      
	    .rst_i(rst_i),     
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
        .Branch(Branch),   
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .RegWrite_o(RegWrite),
        .MemtoReg_o(MemtoReg)
);

Sign_Extend Sign_Extend(
        .data_i(AfterIF_ID[15:0]), // instr[15:0]
        .data_o(immediate)
);	

Pipe_Reg #(.size(148)) ID_EX(
        .rst_i(rst_n),
        .clk_i(clk_i),
                 // control
        .data_i({RegDst, ALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite,
                          // pc + 4
                MemtoReg, AfterIF_ID[63:32], RSdata, RTdata, immediate,
                // RT,             RD
                AfterIF_ID[20:16], AfterIF_ID[15:11]}),
        .data_o(AfterID_EX)
);
		
//Instantiate the components in EX stage	   
ALU ALU(
        .rst_n(rst_i),
        .src1_i(AfterID_EX[105:74]), // RSdata
	    .src2_i(ALUIn2),
	    .ctrl_i(ALUCtrl),
        .shamt_i(AfterID_EX[20:16]), // instr[10:6]
	    .result_o(ALUResult),
	    .zero_o(ALUZero)
);
		
ALU_Control ALU_Control(
        .funct_i(AfterID_EX[15:10]),   // instr[5:0]
        .ALUOp_i(AfterID_EX[146:144]),   // ALUOp
        .ALUCtrl_o(ALUCtrl)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
	    .data0_i(AfterID_EX[73:42]), // RTdata
        .data1_i(AfterID_EX[41:10]), // immediate
        .select_i(AfterID_EX[143]), // ALUSrc
        .data_o(ALUIn2)
);
		
MUX_2to1 #(.size(5)) Mux_RegDst(
        .data0_i(AfterID_EX[9:5]), // RT
        .data1_i(AfterID_EX[4:0]), // RD
        .select_i(AfterID_EX[147]), // RegDst
        .data_o(WriteReg)
);

Pipe_Reg #(.size(107)) EX_MEM(
        .rst_i(rst_n),
        .clk_i(clk_i),
                           // control, pc + 4
        .data_i({AfterID_EX[142:138], AfterID_EX[137:106], ALUZero, ALUResult,
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

Pipe_Reg #(.size(71)) MEM_WB(
        .rst_i(rst_n),
        .clk_i(clk_i),
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

