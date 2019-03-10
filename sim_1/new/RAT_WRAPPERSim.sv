`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2019 09:55:44 PM
// Design Name: 
// Module Name: RAT_WRAPPERSim
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


module RAT_WRAPPERSim(

    );
    
    logic CLK;
    logic BTNC, BTNL;
    logic INTERRUPT;
    logic [7:0] SWITCHES;
    logic [3:0] ANODES;
    logic [7:0] CATHODES;
    logic [7:0] LEDS;
    
    RAT_WRAPPER inst(.*);
    
    always begin
        CLK = 0; #5;
        CLK = 1; #5;
    end
    
    initial begin
    #300
    BTNL <= 1;
    #30
    BTNL <= 0;
    #500
    BTNL <= 1;
    end


endmodule
