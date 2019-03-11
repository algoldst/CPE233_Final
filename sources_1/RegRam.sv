`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Alex Goldstein
//
// Create Date: 01/24/2019 08:50:31 AM
// Design Name:
// Module Name: RegRam
// Project Name: CPE 233 Lab Rat 3.1
// Target Devices:
// Tool Versions:
// Description: 32 x 8-bit register memory. Synchronous write, async read from two addresses adrX, adrY.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module RegRam(
    input [7:0] dIn,         // 8-bit register
    input [4:0] adrX, adrY,  // 32 registers
    input rf_wr,             // write-enable
    input clk,
    output [7:0] dX_out, dY_out
    );

    // Init register with 0 at all addresses
    logic [7:0] regs [0:31];
    initial begin
        int i;
        for (i=0; i<32; i++) begin
            regs[i] = 0;
        end
    end


    // Synchronous write
    always_ff @(posedge clk) begin
        if(rf_wr) begin
            regs[adrX] <= dIn;
        end
    end


    // Async read
    assign dX_out = regs[adrX];
    assign dY_out = regs[adrY];


endmodule
