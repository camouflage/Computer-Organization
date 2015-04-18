//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖 0340249
//----------------------------------------------
//Date:        4/9/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
          isJr_o,
);
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;
output			   isJr_o;
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg 			   isJr_o;
//Parameter

       
//Select exact operation
always @(funct_i or ALUOp_i)
begin
	isJr_o = 0;
	case (ALUOp_i)
		// R-type
		3'b010: begin
			case (funct_i)
				// add
				6'b100000:
					ALUCtrl_o = 4'b0010;
				// sub
				6'b100010:
					ALUCtrl_o = 4'b0110;
				// and
				6'b100100:
					ALUCtrl_o = 4'b0000;
				// or
				6'b100101:
					ALUCtrl_o = 4'b0001;
				// slt
				6'b101010:
					ALUCtrl_o = 4'b0111;

				// using unused ALU_ctrl
				// sll
				6'b000000:
					ALUCtrl_o = 4'b0101;
				// srlv
				6'b000110:
					ALUCtrl_o = 4'b1111;

				// lab3
				// mult
				6'b011000:
					ALUCtrl_o = 4'b0011;
				// jr
				6'b001000: begin
					ALUCtrl_o = 4'b0011;
					isJr_o = 1;
				end
			endcase
		end
		// addi & lw & sw
		3'b110:
			ALUCtrl_o =  4'b0010;
		// slti
		3'b011:
			ALUCtrl_o =  4'b0111;
		// beq & bne (sub) & bgt
		3'b001:
			ALUCtrl_o =  4'b0110;
		// lui
		3'b100:
			ALUCtrl_o =  4'b0100;
		// ori
		3'b111:
			ALUCtrl_o =  4'b0001;

		// extra in lab3
		// bgez (mul)
		3'b101:
			ALUCtrl_o = 4'b0011;
		// default
		default:
			ALUCtrl_o = 4'bxxxx;
	endcase
end
endmodule     





                    
                    