`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2019 11:51:22 PM
// Design Name: 
// Module Name: REG_File_Mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SCR_Mux_2(
    input [7:0] zero, 
    input [9:0] one,
    input SCR_DATA_SEL,
    output logic [9:0] OUT
    );
    
    always_comb
    begin
        if (SCR_DATA_SEL == 0)
            OUT = zero;
        else if (SCR_DATA_SEL == 1)
            OUT = one;                   
        else 
            OUT = 10'h000; 
    end    
endmodule