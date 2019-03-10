`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2019 01:33:57 PM
// Design Name: 
// Module Name: StackPointer
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


module StackPointer(
    input [7:0] DATA_IN,
    input RST,
    input LD,
    input INCR,
    input DECR,
    input CLK,
    output logic [7:0] DATA_OUT
    );
    
    always_ff @(posedge CLK)
        begin
            if (RST == 1)
                    DATA_OUT = 0;
            else if (LD == 1)
                DATA_OUT <= DATA_IN;
            else if (INCR == 1)
                DATA_OUT++;
            else if (DECR == 1)
                DATA_OUT--;       
        end
endmodule
