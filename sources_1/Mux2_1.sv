`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 02:35:17 PM
// Design Name: 
// Module Name: Mux2_1
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


module Mux2_1 #(parameter WIDTH=1)(
    input [WIDTH-1:0] port0,
    input [WIDTH-1:0] port1,
    input sel,
    output logic [WIDTH-1:0] dOut
    );
        
    always_comb
    begin
        if(sel == 0)
            dOut = port0;
        else
            dOut = port1; 
    end
endmodule