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
    output logic interrupt = 0
    );
    
    typedef enum{START, INTERRUPT, RELOAD} State;
    State NS, PS = START;
    
    logic [2:0] cycleCounter = 0;
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
        case(PS)
            START: begin
                if(press) NS = INTERRUPT;
                else NS = START;
            end
            INTERRUPT: begin
                interrupt = 1;
                if(cycleCounter < 6) NS = INTERRUPT;
                else NS = RELOAD;
            end
            RELOAD: begin
                interrupt = 0;
                if(press) NS = RELOAD;
                else NS = START;
            end
        endcase
    end
    
endmodule
