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


module SCR_Mux(
    input [7:0] zero, one, two, three,
    input [1:0] SCR_ADDR_SEL,
    output logic [7:0] OUT
    );
    
    always_comb
    begin
        if (SCR_ADDR_SEL == 0)
            OUT = zero;
        else if (SCR_ADDR_SEL == 1)
            OUT = one;
        else if (SCR_ADDR_SEL == 2)
            OUT = two;
        else if (SCR_ADDR_SEL == 3)
            OUT = three;                    
        else 
            OUT = 10'h000; 
    end    
endmodule