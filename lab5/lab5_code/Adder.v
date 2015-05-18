//Subject:     CO project 2 - Adder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖 0340249
//----------------------------------------------
//Date:        4/9/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Adder(
    	src1_i,
	src2_i,
	sum_o
);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
output [32-1:0]	 sum_o;

//Internal Signals
wire    [32-1:0]	 sum_o;

//Parameter
    
//Main function
assign sum_o = $signed(src1_i) + $signed(src2_i);

endmodule

/*
module stimulus;

reg[32-1: 0] in1;
reg[32-1: 0] in2;
wire[32-1: 0] out;

Adder add(in1, in2, out);

initial
begin
	in1 = 31;
	in2 = -32;
	#1 $display("%b %b", in2, out);
	

	in2 = 1;
	#1 $display("%b %b", in2, out);
end

endmodule
*/


                    
                    