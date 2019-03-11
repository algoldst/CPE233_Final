`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Alex Goldstein
//
// Create Date: 01/24/2019 09:59:31 AM
// Design Name: CPE 233 Lab Rat 3.2
// Module Name: ScrRam
// Project Name:
// Target Devices:
// Tool Versions:
// Description: 256 x 10-bit register memory. Synchronous write, async read from 1 address, scr_addr.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module ScrRam(
    input [9:0] dIn,         // register data size is 10-bit
    input [7:0] scr_addr,    // register address [0,255]
    input scr_wr,            // write-enable
    input clk,
    output [9:0] dOut
    );


    // Init register with 0 at all addresses
    logic [9:0] regs [0:255];
    initial begin
        for (int i = 0; i < 256; i++) begin
            regs[i] = 0;
        end
    end


    // Synchronous write
    always_ff @(posedge clk) begin
        if(scr_wr) begin
            regs[scr_addr] <= dIn;
        end
    end


    // Async read
    assign dOut = regs[scr_addr];


endmodule
