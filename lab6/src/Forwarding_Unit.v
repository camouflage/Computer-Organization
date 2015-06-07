//Subject:     CO project 5 - Forwarding_Unit
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖 0340249
//----------------------------------------------
//Date:        5/18/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Forwarding_Unit(
    	rs_i,
		rt_i,
		MEM_RegDst_i,
		WB_RegDst_i,
		MEM_RegWrite_i,
		WB_RegWrite_i,
		ForwardA_o,
		ForwardB_o
);
     
//I/O ports
input  [5-1:0]   rs_i;
input  [5-1:0]	 rt_i;
input  [5-1:0]	 MEM_RegDst_i;
input  [5-1:0]	 WB_RegDst_i;
input  			 MEM_RegWrite_i;
input  			 WB_RegWrite_i;

output [2-1:0]	 ForwardA_o;
output [2-1:0]	 ForwardB_o;

//Internal Signals
reg    [2-1:0]	 ForwardA_o;
reg    [2-1:0]	 ForwardB_o;

//Parameter
    
//Main function
always @(*) begin
	//$display("%b, %b, %b, %b, %b, %b", rs_i, rt_i, MEM_RegDst_i, WB_RegDst_i, MEM_RegWrite_i, WB_RegWrite_i);
	// forwardA
	if ( MEM_RegWrite_i && MEM_RegDst_i != 0 && MEM_RegDst_i == rs_i )
		ForwardA_o = 2'b10;
	else if ( WB_RegWrite_i && WB_RegDst_i != 0 && WB_RegDst_i == rs_i &&
		!(MEM_RegWrite_i && MEM_RegDst_i != 0 && MEM_RegDst_i == rs_i) )
		ForwardA_o = 2'b01;
	else 
		ForwardA_o = 2'b00;

	// forwardB
	if ( MEM_RegWrite_i && MEM_RegDst_i != 0 && MEM_RegDst_i == rt_i )
		ForwardB_o = 2'b10;
	else if ( WB_RegWrite_i && WB_RegDst_i != 0 && WB_RegDst_i == rt_i &&
		!(MEM_RegWrite_i && MEM_RegDst_i != 0 && MEM_RegDst_i == rt_i) )
		ForwardB_o = 2'b01;
	else 
		ForwardB_o = 2'b00;
	//$display("%b, %b", ForwardA_o, ForwardB_o);
end

endmodule


                    
                    