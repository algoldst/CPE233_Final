`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Alex Goldstein
// 
// Create Date: 01/10/2019 10:52:40 AM
// Design Name: ProgRom Simulation
// Module Name: ProgRom_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simulation for ProgRom
// 
// Dependencies: ProgRom.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ProgRom_tb(
    );

logic PROG_CLK;
logic [9:0] PROG_ADDR; // This is the progROM address which contains the instruction we want to load.
logic [17:0] PROG_IR; // Outputs the 18-bit instruction contained at the address

ProgRom ProgRom_tb(.*);
 
always begin
    PROG_CLK = 1; #5;
    PROG_CLK = 0; #5;
end

initial begin
    #10;
    
    PROG_ADDR = 10'h40; // On each address change, the sim output PROG_IR should show the instruction contained on that line.
    #10;
    PROG_ADDR = 10'h41;
    #10;
    PROG_ADDR = 10'h42;
    #10;
    PROG_ADDR = 10'h43;
    #10;
    PROG_ADDR = 10'h44;
    #10;
    PROG_ADDR = 10'h45;
    #10;
    PROG_ADDR = 10'h46;
    #10;
    PROG_ADDR = 10'h47;
    #10;
    
end
endmodule
