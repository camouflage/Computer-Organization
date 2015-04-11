//Subject:     CO project 1 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖
//----------------------------------------------
//Date:        3/21/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
	rst_n,
    	src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input rst_n;
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
always @(ctrl_i or src1_i or src2_i)
begin

case( ctrl_i )
	// and
	4'b0000:
		result_o = src1_i & src2_i;
	// or
	4'b0001:
		result_o = src1_i | src2_i;
	// add
	4'b0010:
		result_o = $signed(src1_i) + $signed(src2_i);
	// sub
	4'b0110:
		result_o = $signed(src1_i) - $signed(src2_i);
	// nor
	4'b1100:
		result_o = ~(src1_i | src2_i);
	// nand
	4'b1101:
		result_o = ~(src1_i & src2_i);
	// slt
	4'b0111: 
	/* begin
		result_o = $signed(src1_i) - $signed(src2_i);
		$display(ctrl_i);
		$display(src1_i);
		$display(src2_i);
		$display(result_o[0]);
		if ( result_o[0] == 1 )
			result_o = 1;
		else
			result_o = 0;
	end */
		result_o = $signed(src1_i) < $signed(src2_i);
	// sgt
	4'b1000:
		result_o = $signed(src1_i) > $signed(src2_i);
	// sle
	4'b1001:
		result_o = $signed(src1_i) <= $signed(src2_i);
	// sge
	4'b1010:
		result_o = $signed(src1_i) >= $signed(src2_i);
	// seq
	4'b1011:
		result_o = src1_i == src2_i;
	// sne
	4'b1110:
		result_o = src1_i != src2_i;
	// mult
	4'b0011:
		result_o = src1_i * src2_i;
	// seqz
	4'b0100:
		result_o = 0;
	// default: set to unknown
	default:
		result_o = 'x;

endcase
end

assign zero_o = result_o == 0;

endmodule
