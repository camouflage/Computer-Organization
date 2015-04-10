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
		3'b010: begin
			case (funct_i)
				// add
				6'b100000:
					ALUCtrl_o = 0010;
				// sub
				6'b100010:
					ALUCtrl_o = 0110;
				// and
				6'b100100:
					ALUCtrl_o = 0000;
				// or
				6'b100101:
					ALUCtrl_o = 0001;
				// slt
				6'b101010:
					ALUCtrl_o = 0111;

				// using unused ALU_ctrl
				// sll
				6'b000000:
					ALUCtrl_o = 0101;
				// srlv
				6'b000110:
					ALUCtrl_o = 1111;
			endcase

		3'b001: 
		end
	endcase
end
endmodule     





                    
                    