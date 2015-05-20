//Subject:     CO project 5 - MUX 3to1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖 0340249
//----------------------------------------------
//Date:        5/20/2015
//----------------------------------------------
//Description: For debug use.
//--------------------------------------------------------------------------------
     
module MUX_3to1(
               data0_i,
               data1_i,
               data2_i,
               select_i,
               data_o
);

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [2-1:0]    select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function
always @(data0_i or data1_i or data2_i or select_i)
begin
	//$display("%b %b %b %b", data0_i, data1_i, data2_i, select_i);
	case (select_i)
		2'b00:
			data_o = data0_i;
		2'b01:
			data_o = data1_i;
		2'b10:
			data_o = data2_i;
	endcase
end

endmodule      

/*
module stimulus;

reg in0, in1;
reg s;
wire out;

MUX_2to1 mux(in0, in1, s, out);

initial
begin
	in0 = 1; in1 = 2;
	$display("%b, %b", in0, in1);

	s = 0;
	#1 $display("%b", out);

	s = 1;
	#1 $display("%b", out);
end

endmodule
*/