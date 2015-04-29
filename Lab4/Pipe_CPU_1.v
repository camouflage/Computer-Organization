//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
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
wire [32-1:0] pcOld;
wire [32-1:0] pcNew;
wire [32-1:0] instr;

/**** ID stage ****/
wire [32-1:0] RSdata;
wire [32-1:0] RTdata;
wire [32-1:0] immediate;
wire [32-1:0] ALUIn2;
wire [32-1:0] ALUResult;
wire          ALUZero;
wire [64-1:0] AfterIF_ID;
//control signal
wire RegDst;
wire [3-1:0] ALUOp;
wire ALUSrc;
wire Branch;
wire MemRead;
wire MemWrite;
wire RegWrite;
wire MemtoReg;

/**** EX stage ****/

//control signal
wire [4-1:0] ALUCtrl;
//control signal


/**** MEM stage ****/


/**** WB stage ****/

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

		
Pipe_Reg #(64)) IF_ID(       //N is the total length of input/output
        .rst_i(rst_n),
        .clk_i(clk_i),
        .data_i({pcOld, instr}),
        .data_o(AfterIF_ID)
);
		
//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),      
	.rst_i(rst_i),     
        .RSaddr_i(AfterIF_ID[25:21]),  
        .RTaddr_i(AfterIF_ID[20:16]),  
        .RDaddr_i(),  
        .RDdata_i(),
        .RegWrite_i(),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata) 
);

Decoder Control(
	.instr_op_i(AfterIF_ID[31:26]),
        .RegDst_o(RegDst),
	.ALU_op_o(ALUOp),   
	.ALUSrc_o(ALUSrc),   
        .MemRead_o(MemRead),
        .Branch(Branch),
        .MemWrite_o(MemWrite),
        .RegWrite_o(RegWrite),
        .MemtoReg_o(MemtoReg)
);

Sign_Extend Sign_Extend(
        .data_i(AfterIF_ID[15:0]),
        .data_o(immediate)
);	

Pipe_Reg #(.size() ID_EX(
        .rst_i(rst_n),
        .clk_i(clk_i),
        .data_i({RegDst, ALUOp, ALUSrc, MemRead, Branch, MemWrite, RegWrite,
                MemtoReg, }) // HERE!!!!!!!!!!!!!!

);
		
//Instantiate the components in EX stage	   
ALU ALU(
        .rst_n(rst_i),
        .src1_i(RSdata),
	.src2_i(ALUIn2),
	.ctrl_i(ALUCtrl),
        .shamt_i(instr[10:6]),
	.result_o(ALUResult),
	.zero_o(ALUZero)
);
		
ALU_Control ALU_Control(
        .funct_i(instr[6-1:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
	.data0_i(RTdata),
        .data1_i(immediate),
        .select_i(ALUSrc),
        .data_o(ALUIn2)
);
		
MUX_2to1 #(.size(5)) Mux2(

);

Pipe_Reg #(.size()) EX_MEM(

);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(ALUResult),
        .data_i(RTdata),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(ReadData)
);

Pipe_Reg #(.size()) MEM_WB(
        
		);

//Instantiate the components in WB stage
MUX_3to1 #(.size(32)) Mux3(

);

/****************************************
signal assignment
****************************************/	
endmodule

