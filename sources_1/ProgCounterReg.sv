`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Matt Stallings
// 
// Create Date: 02/07/2019 09:45:27 AM
// Design Name: 
// Module Name: ProgCounterReg
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


module ProgCounterReg(
    input [9:0] dIn,
    input pc_ld, pc_inc, rst, clk,
    output logic [9:0] pc_count = 0);
    
    always_ff @ (posedge clk)
    begin
        if(pc_ld == 1)
            pc_count <= dIn;
        if(rst == 1)
            pc_count <= 0;
        if(pc_inc == 1)
            pc_count <= pc_count + 1;
    end
endmodule
