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
     
module MUX_4to1(
               data0_i,
               data1_i,
               data2_i,
               data3_i,
               select_i,
               data_o
);

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [size-1:0] data3_i;
input   [2-1:0]    select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function
always @(data0_i or data1_i or data2_i or data3_i or select_i)
begin
	//$display("%b %b %b", data0_i, data1_i, select_i);
	case (select_i)
		2'b00:
			data_o = data0_i;
		2'b01:
			data_o = data1_i;
		2'b10:
			data_o = data2_i;
		2'b11:
			data_o = data3_i;
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