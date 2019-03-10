`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kadin Paul Stephens 
// 
// Create Date: 01/17/2019 01:43:36 PM
// Design Name: 
// Module Name: PC_Mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Selects what input signal, DIN, goes into the Program Counter
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC_Mux(
    input [9:0] FROM_IMMED,
    input [9:0] FROM_STACK,
    input [1:0] PC_MUX_SEL,
    output logic [9:0] DIN
    );
    
    always_comb
    begin
        if (PC_MUX_SEL == 0)
            DIN = FROM_IMMED;
        else if (PC_MUX_SEL == 1)
            DIN = FROM_STACK;
        else if (PC_MUX_SEL == 2)
            DIN = 10'h3FF;
        else if (PC_MUX_SEL ==3)
            DIN = 111;
        else 
            DIN = 10'h000;
    
    end
endmodule
