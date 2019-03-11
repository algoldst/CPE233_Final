`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2019 02:32:14 PM
// Design Name: 
// Module Name: DReg_tb
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


module DReg_tb();
    parameter [2:0] WIDTH = 4;
    logic clk, ld=0, set=0, clr=0;
    logic [WIDTH-1:0] dIn=0;
    logic [WIDTH-1:0] dOut = 0;
    
    DReg #4 dreg_tb( .* );
    always begin
        clk <= 0; #5;
        clk <= 1; #5;
    end
    
    initial begin
        dIn <= 0;
        #20;
        dIn <= 13; ld <= 1;
        #20;
        dIn <= 0; ld <= 0;
    end
endmodule
