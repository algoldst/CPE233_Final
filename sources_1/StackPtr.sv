`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2019 12:06:35 PM
// Design Name: 
// Module Name: StackPtr
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


module StackPtr(
    input clk,
    input [7:0] dIn,
    input rst, ld, incr, decr,
    output logic [7:0] dOut = 0 // starts at 0, first item >> 0xFF, second item >> 0xFE, etc.
    );
    
    always_ff @(posedge clk) begin
        if(rst) dOut = '0;
        else if(ld) dOut = dIn;
        else if(incr) dOut++;
        else if(decr) dOut--;
        else dOut = dOut; // hold value
    end
    
endmodule
