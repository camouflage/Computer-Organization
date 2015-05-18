//Subject:     CO project 5 - Hazard_Dection_Unit
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      孫聖 0340249
//----------------------------------------------
//Date:        5/18/2015
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Hazard_Dection_Unit(
    	rs_i,
		rt_i,
		ID_EX_Rt_i,
		ID_EX_MEMRead_i,
		PCWrite_o,
		IF_IDWrite_o,
		Stall_o
);
     
//I/O ports
input  [5-1:0]   rs_i;
input  [5-1:0]	 rt_i;
input  [5-1:0]	 ID_EX_Rt_i;
input  			 ID_EX_MEMRead_i;

output  		 PCWrite_o;
output  		 IF_IDWrite_o;
output  		 Stall_o;

//Internal Signals
reg  		 	 PCWrite_o;
reg  		 	 IF_IDWrite_o;
reg  		 	 Stall_o;

//Parameter
    
//Main function


endmodule


                    
                    