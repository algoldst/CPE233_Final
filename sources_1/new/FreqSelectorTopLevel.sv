`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2019 02:03:03 PM
// Design Name: 
// Module Name: FreqSelectorTopLevel
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


module FreqSelectorTopLevel(
input CLK,
input [7:0] SWITCHES,
output logic JA
    );
    
    logic [15:0] t1;
    logic t2, toggle;
    
    FreqMux inst1 (.SEL(SWITCHES), .an(t1));                 
    FreqCLK inst2 (.clk(CLK), .maxcount(t1), .sclk(t2));
    FreqMux_2 inst3 (.SEL(toggle), .A(0), .B(t2), .an(JA));
    
    always_comb
    begin
        if(SWITCHES == 0 || SWITCHES > 36) 
                toggle = 0;
            else
                toggle = 1;
    end
endmodule