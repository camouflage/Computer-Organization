//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖
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
);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   isOri_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg 		   isOri_o;

//Parameter


//Main function
always @(instr_op_i)
begin
	isOri_o = 0;
	// ALU_op_o ???
	case(instr_op_i)
		// R-type
		6'b000000: begin
			RegDst_o = 1;
			ALUSrc_o = 0;
			RegWrite_o = 1;
			Branch_o = 0;
			ALU_op_o = 3'b010;
		end
		// addi
		6'b001000: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 1;
			Branch_o = 0;
			ALU_op_o = 3'b110;
		end
		// slti
		6'b001010: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 1;
			Branch_o = 0;
			ALU_op_o = 3'b011;
		end
		// beq
		6'b000100: begin
			RegDst_o = 0; // dont care
			ALUSrc_o = 0;
			RegWrite_o = 0;
			Branch_o = 1;
			ALU_op_o = 3'b001;
		end
		// lui
		6'b001111: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 1;
			Branch_o = 0;
			ALU_op_o = 3'b100;
		end
		// ori
		6'b001101: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			RegWrite_o = 1;
			Branch_o = 0;
			ALU_op_o = 3'b111;
			isOri_o = 1;
		end
		// bne
		6'b001010: begin
			RegDst_o = 0; // don't care
			ALUSrc_o = 0;
			RegWrite_o = 0;
			Branch_o = 1;
			ALU_op_o = 3'b101;
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

