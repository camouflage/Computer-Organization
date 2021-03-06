//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖 0340249
//----------------------------------------------
//Date:        4/9/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
	//isOri_i,
    data_i,
    data_o
);

//parameter size = 1;

//I/O ports
//input	isOri_i;
//input   [size-1:0] data_i;
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always @(data_i)
begin
	//if ( data_i[size - 1] == 0 || isOri_i )
	if ( data_i[16 - 1] == 0 )
		data_o = data_i;
	else
		data_o = data_i | 32'b1111_1111_1111_1111_0000_0000_0000_0000;       
end
endmodule

/*
module stimulus;
reg isOri;
reg[5-1: 0] in;
wire[32-1: 0] out;

Sign_Extend #(.size(5)) se(isOri, in, out);

initial
begin
	isOri = 0;
	in = 5'b11100;
	#1 $display("%b %b", in, out);
	

	in = 5'b00001;
	#1 $display("%b %b", in, out);
end

endmodule
*/