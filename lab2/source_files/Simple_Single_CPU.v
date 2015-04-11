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

// data
wire [32-1:0] RSdata;
wire [32-1:0] RTdata;
wire [32-1:0] ALUResult;
wire [16-1:0] immediate;
wire [32-1:0] ALUIn2;

// control
wire RegDst;
wire RegWrite;
wire ALUSrc;
wire Branch;
wire [3-1:0] ALUOp;
wire [4-1:0] ALUCtrl;
wire isOri;

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
        .src1_i(pcOld),     
	.src2_i(32'd4),     
	.sum_o(pcAdd4)    
);
	
Instr_Memory IM(
        .pc_addr_i(pcOld),  
	.instr_o(instr)    
);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(WriteReg)
);	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i),     
        .RSaddr_i(instr[25:21]),  
        .RTaddr_i(instr[20:16]),  
        .RDaddr_i(WriteReg),  
        .RDdata_i(ALUResult), 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata)   
);
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	.RegWrite_o(RegWrite), 
	.ALU_op_o(ALUOp),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),   
	.Branch_o(Branch),
        .isOri_o(isOri)
);

ALU_Ctrl AC(
        .funct_i(instr[6-1:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl) 
);
	
Sign_Extend SE(
        .isOri_i(isOri), // ori: zero-extend.
        .data_i(instr[15:0]),
        .data_o(immediate)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata),
        .data1_i(immediate),
        .select_i(ALUSrc),
        .data_o(ALUIn2)
);	
		
ALU ALU(
        .src1_i(),
	.src2_i(),
	.ctrl_i(),
	.result_o(),
	.zero_o()
);

// PC + immediate
Adder Adder2(
        .src1_i(pcAdd4),     
	.src2_i(immediate),
        .sum_o(pcADDIm)     
);
		
Shift_Left_Two_32 Shifter(
        .data_i(),
        .data_o()
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pcAdd4),
        .data1_i(pcADDIm),
        .select_i(),
        .data_o(pcNew)
);	

endmodule
		  


