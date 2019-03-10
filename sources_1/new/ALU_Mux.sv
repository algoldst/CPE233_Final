`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2019 11:33:48 PM
// Design Name: 
// Module Name: ALU_Mux
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


module ALU_Mux(
    input [7:0] zero,
    input [7:0] one,
    input ALU_OPY_SEL,
    output logic [7:0] OUT
    );
    
    always_comb
    begin
        if (ALU_OPY_SEL == 0)
            OUT = zero;
        else if (ALU_OPY_SEL == 1)
            OUT = one;
        else 
            OUT = 10'h000;
    
    end    
endmodule
