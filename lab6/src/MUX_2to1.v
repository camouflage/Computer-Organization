//Subject:     CO project 2 - MUX 221
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖 0340249
//----------------------------------------------
//Date:        4/9/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module MUX_2to1(
               data0_i,
               data1_i,
               select_i,
               data_o
);

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input              select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function
always @(data0_i or data1_i or select_i) begin
	//data_o = select_i? data1_i: data0_i;
	if ( select_i == 1 )
		data_o = data1_i;
	else
		data_o = data0_i;
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