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
		EX_MEM_RegDst_i,
		MEM_WB_RegDst_i,
		EX_MEM_RegWrite_i,
		MEM_WB_RegWrite_i,
		ForwardA_o,
		ForwardB_o
);
     
//I/O ports
input  [5-1:0]   rs_i;
input  [5-1:0]	 rt_i;
input  [5-1:0]	 EX_MEM_RegDst_i;
input  [5-1:0]	 MEM_WB_RegDst_i;
input  			 EX_MEM_RegWrite_i;
input  			 MEM_WB_RegWrite_i;

output [2-1:0]	 ForwardA_o;
output [2-1:0]	 ForwardB_o;

//Internal Signals
reg    [2-1:0]	 ForwardA_o;
reg    [2-1:0]	 ForwardB_o;

//Parameter
    
//Main function


endmodule


                    
                    