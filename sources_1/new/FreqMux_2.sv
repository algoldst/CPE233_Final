`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2019 03:03:28 PM
// Design Name: 
// Module Name: FreqMux_2
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


module FreqMux_2(
    input SEL,
    input A, B,
    output logic an
    );
    
    always_comb
    begin
    
    case(SEL)    
        0: an = A;
        1: an = B;
        default: an = A;
        endcase
        end
endmodule