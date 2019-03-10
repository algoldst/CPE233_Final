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


module ProgramCounter(
    input [9:0] DIN,
    input PC_LD,
    input PC_INC,
    input RST,
    input CLK,
    output logic [9:0] PC_COUNT
    );
        
    always_ff @(posedge CLK)
        begin
            if (RST == 1)
                    PC_COUNT = 0;
            else if (PC_LD == 1)
                PC_COUNT <= DIN;
            else if (PC_INC == 1)
                PC_COUNT++;    
        end
endmodule
