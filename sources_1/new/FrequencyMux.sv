`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2019 09:17:47 PM
// Design Name: 
// Module Name: FrequencyMux
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


module Freqclk(
input clk,
input [20:0] maxcount,
output logic sclk = 0
);

logic [29:0] count = 0;

always_ff @ (posedge clk)
    begin
    count = count + 1;
    if (count == maxcount)
        begin
        count = 0;
        sclk =~ sclk;
        end
    end
endmodule
