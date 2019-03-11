`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Matt Stallings
// 
// Create Date: 02/07/2019 09:44:48 AM
// Design Name: 
// Module Name: ProgCounterMux
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


module Mux4_1 #(parameter WIDTH=1)(
    input [WIDTH-1:0] port0,
    input [WIDTH-1:0] port1,
    input [WIDTH-1:0] port2,
    input [WIDTH-1:0] port3,
    input [1:0] sel,
    output logic [WIDTH-1:0] dOut
    );
        
    always_comb
    begin
        if(sel == 0)
            dOut = port0;
        else if(sel == 1)
            dOut = port1;
        else if(sel == 2)
            dOut = port2;
        else
            dOut = port3; 
    end
endmodule
