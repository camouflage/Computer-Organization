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
		EX_Rt_i,
		EX_MEMRead_i,
		PCWrite_o,
		IF_IDWrite_o,
		Stall_o
);
     
//I/O ports
input  [5-1:0]   rs_i;
input  [5-1:0]	 rt_i;
input  [5-1:0]	 EX_Rt_i;
input  			 EX_MEMRead_i;

output  		 PCWrite_o;
output  		 IF_IDWrite_o;
output  		 Stall_o;

//Internal Signals
reg  		 	 PCWrite_o;
reg  		 	 IF_IDWrite_o;
reg  		 	 Stall_o;

//Parameter
    
//Main function
always @(*) begin
	if ( EX_MEMRead_i && (EX_Rt_i == rs_i || EX_Rt_i == rt_i) ) begin
		PCWrite_o = 0;
		IF_IDWrite_o = 0;
		Stall_o = 1;
		//$display("stall!!");
	end else begin
		PCWrite_o = 1;
		IF_IDWrite_o = 1;
		Stall_o = 0;
	end
end

endmodule


                    
                    