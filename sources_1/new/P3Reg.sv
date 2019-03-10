`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kadin Paul Stephens
// 
// Create Date: 01/17/2019 01:40:48 PM
// Design Name: 
// Module Name: ProgramCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Program Counter: Creates the address signal for the ProgROM 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module P3Reg(
    input [3:0] DIN,
    input LD,
    input CLK,
    output logic [3:0] Q
    );
        
    always_ff @(posedge CLK)
        begin
            if (LD == 1)
                Q <= DIN;
            else
                Q <= 4'b0;  
        end
endmodule