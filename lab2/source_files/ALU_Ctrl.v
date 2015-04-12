//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖
//----------------------------------------------
//Date:        4/9/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
);
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(funct_i or ALUOp_i)
begin
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
			endcase
		end
		// addi
		3'b110: begin
			ALUCtrl_o =  4'b0010;
		end
		// slti
		3'b011:
			ALUCtrl_o =  4'b0111;
		// beq (sub)
		3'b001:
			ALUCtrl_o =  4'b0110;
		// lui
		3'b100:
			ALUCtrl_o =  4'b0100;
		// ori
		3'b111:
			ALUCtrl_o =  4'b0001;
		// bne (sub)
		3'b101:
			ALUCtrl_o =  4'b0110;
		// default
		default:
			ALUCtrl_o = 4'bxxxx;
	endcase
end
endmodule     





                    
                    