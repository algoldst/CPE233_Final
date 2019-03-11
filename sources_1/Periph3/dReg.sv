`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2019 12:16:29 PM
// Design Name: 
// Module Name: dReg
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


module DReg (
    input clk, ld, 
    input [3:0] dIn,
    output logic [3:0] dOut
    );
    always_ff @(posedge clk) begin
        //if (clr) dOut <= 0;
        //else if (set) dOut <= 1;
        if (ld) dOut = dIn;
    end
endmodule
