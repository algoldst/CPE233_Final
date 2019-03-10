`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2019 02:10:36 PM
// Design Name: 
// Module Name: ProgRom_Sim
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


module ProgRom_Sim();

logic PROG_CLK;
logic [9:0] PROG_ADDR;
logic [17:0] PROG_IR;

ProgRom ROM1 (.*);

always 
begin
PROG_CLK = 0; #5;
PROG_CLK = 1; #5;
end

initial begin
PROG_ADDR = 10'h40;
#10;

PROG_ADDR = 10'h41; 
#10;

PROG_ADDR = 10'h42; 
#10;
   
PROG_ADDR = 10'h43; 
#10;
      
PROG_ADDR = 10'h44; 
#10;

PROG_ADDR = 10'h44;
#10;

PROG_ADDR = 10'h45;
#10

PROG_ADDR = 10'h46;
 
end

endmodule