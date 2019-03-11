`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2019 01:44:26 PM
// Design Name: 
// Module Name: InterruptFsm
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


module InterruptFsm(
    input clk, press,
    output logic interrupt = 0,
    output logic [2:0] statePMOD
    );
    
    typedef enum{START, INTERRUPT, RELOAD} State;
    State NS, PS = START;
    
    logic [16:0] cycleCounter = 0;
    always_ff @(posedge clk) begin
        PS = NS;
        if(PS == INTERRUPT) begin
            cycleCounter++;
        end
        else begin
            cycleCounter = 0;
        end
    end
    
    always_comb begin
        if(PS != START || PS != INTERRUPT || PS != RELOAD) NS = START; // THIS LINE IS IMPORTANT! (It doesn't seem that way, but it is. Cannot explain, Area 51 involved?)
        case(PS)
            START: begin
                statePMOD = 1;
                if(press) NS = INTERRUPT;
                else NS = START;
            end
            INTERRUPT: begin
                statePMOD = 2;
                if(cycleCounter < 22727*4) begin
                    interrupt = 0;
                end
                else interrupt = 1;
                if(cycleCounter < (22727*4)+6) NS = INTERRUPT;
                else NS = RELOAD;
            end
            RELOAD: begin
                statePMOD = 4;
                interrupt = 0;
                if(press) NS = RELOAD;
                else NS = START;
            end
            default: begin
                NS = START;
            end
        endcase
    end
    
endmodule
