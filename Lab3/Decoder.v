//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖 0340249
//----------------------------------------------
//Date:        4/9/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	isOri_o,
	//isBne_o,
	// lab3
	BranchType_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   isOri_o;
//Soutput		   isBne_o;
// lab3
output [2-1:0] BranchType_o;
output         Jump_o;
output		   MemRead_o;
output		   MemWrite_o;
output [2-1:0] MemtoReg_o;

 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg 		   isOri_o;
//reg		       isBne_o;
// lab3
reg    [2-1:0] BranchType_o;
reg            Jump_o;
reg   		   MemRead_o;
reg            MemWrite_o;
reg    [2-1:0] MemtoReg_o;

//Parameter


//Main function
always @(instr_op_i)
begin
	isOri_o = 0;
	//isBne_o = 0;
	// ALU_op_o ???
	case(instr_op_i)
		// R-type
		6'b000000: begin
			RegDst_o = 1;
			ALUSrc_o = 0;
			RegWrite_o = 1;
			Branch_o = 0;
			BranchType_o = 2'b00; // don't care
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 0;
			MemtoReg_o = 2'b00; // don't care
			ALU_op_o = 3'b010;
		end
		// addi
		6'b001000: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 1;
			Branch_o = 0;
			BranchType_o = 2'b00; // don't care
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 0;
			MemtoReg_o = 2'b00; // don't care
			ALU_op_o = 3'b110;
		end
		// slti
		6'b001010: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 1;
			Branch_o = 0;
			BranchType_o = 2'b00; // don't care
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 0;
			MemtoReg_o = 2'b00; // don't care
			ALU_op_o = 3'b011;
		end
		// beq
		6'b000100: begin
			RegDst_o = 0; // don't care
			ALUSrc_o = 0;
			RegWrite_o = 0;
			Branch_o = 1;
			BranchType_o = 2'b00;
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 0;
			MemtoReg_o = 2'b00; // don't care
			ALU_op_o = 3'b001;
		end
		// lui
		6'b001111: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 1;
			Branch_o = 0;
			BranchType_o = 2'b00; // don't care
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 0;
			MemtoReg_o = 2'b00; // don't care
			ALU_op_o = 3'b100;
		end
		// ori
		6'b001101: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 1;
			Branch_o = 0;
			BranchType_o = 2'b00; // don't care
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 0;
			MemtoReg_o = 2'b00; // don't care
			ALU_op_o = 3'b111;
			isOri_o = 1;
		end
		// bne
		6'b000101: begin
			RegDst_o = 0; // don't care
			ALUSrc_o = 0;
			RegWrite_o = 0;
			Branch_o = 1;
			BranchType_o = 2'b11;
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 0;
			MemtoReg_o = 2'b00; // don't care
			ALU_op_o = 3'b101;
			//isBne_o = 1;
		end
		// lab3
		// lw
		6'b100011: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 1;
			Branch_o = 0;
			BranchType_o = 2'b00; // don't care
			Jump_o = 0;
			MemRead_o = 1;
			MemWrite_o = 0;
			MemtoReg_o = 2'b01;
			ALU_op_o = 3'b101;
		end
		// sw
		6'b101011: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 0;
			Branch_o = 0;
			BranchType_o = 2'b00; // don't care
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 1;
			MemtoReg_o = 2'b01; // don't care
			ALU_op_o = 3'b101;
		end
		// jump
		6'b000010: begin
			RegDst_o = 0; // don't care
			ALUSrc_o = 0; // don't care
			RegWrite_o = 0; // don't care
			Branch_o = 0; // don't care
			BranchType_o = 2'b00; // don't care
			Jump_o = 1;
			MemRead_o = 0; // don't care
			MemWrite_o = 0; // don't care
			MemtoReg_o = 2'b00; // don't care
			ALU_op_o = 3'b101;
		end
		// bgt
		6'b000111: begin
			RegDst_o = 0; // don't care
			ALUSrc_o = 0;
			RegWrite_o = 0;
			Branch_o = 1;
			BranchType_o = 2'b00;
			Jump_o = 0;
			MemRead_o = 0;
			MemWrite_o = 0;
			MemtoReg_o = 2'b00; // don't care
			ALU_op_o = 3'b001;
		end

		// default
		default: begin
			RegDst_o = 1'bx;
			ALUSrc_o = 1'bx;
			RegWrite_o = 1'bx;
			Branch_o = 1'bx;
			ALU_op_o = 3'bxxx;
		end
	endcase

end

endmodule

