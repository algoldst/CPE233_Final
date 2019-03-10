`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2019 02:37:38 PM
// Design Name: 
// Module Name: AssignmentTwoTopLevel
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


module PC(
    input [9:0] FROM_IMMED,FROM_STACK,
    input PC_LD, PC_INC, RST, CLK,
    input [1:0] PC_MUX_SEL,
    output logic [9:0] PC_COUNT
    );
    
    logic [9:0] t1;
    
    PC_Mux inst1 (.FROM_IMMED(FROM_IMMED), .FROM_STACK(FROM_STACK),.DIN(t1), .PC_MUX_SEL(PC_MUX_SEL));
    ProgramCounter inst2 (.DIN(t1), .PC_LD(PC_LD), .PC_INC(PC_INC), .RST(RST), .CLK(CLK), .PC_COUNT(PC_COUNT));
endmodule
