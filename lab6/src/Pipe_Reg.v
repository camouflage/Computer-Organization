//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
            rst_i,
			clk_i,
			pipeRegWrite_i,
			data_i,
			data_o
);
					
parameter size = 0;
input                    rst_i;
input                    clk_i;		
input					 pipeRegWrite_i;
input      [size-1: 0] 	 data_i;
output reg [size-1: 0]   data_o;
	  
always @(posedge clk_i or negedge  rst_i) begin
	if ( rst_i == 0 )
		data_o <= 0;
    else if ( pipeRegWrite_i )
    	data_o <= data_i;
    //else
    //	$display("%b", data_o);
end

endmodule	