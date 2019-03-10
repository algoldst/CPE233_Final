`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2019 12:47:18 PM
// Design Name: 
// Module Name: KPPSim
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


module KPPSim(

    );
    logic C, A, E, B, G, F,D, CLK;
    logic interrupt;
    logic [7:0] CATHODES;
    logic [3:0] ANODES;
    
    always 
    begin
     CLK = 0;
     #5;
     CLK = 1;
     #5;
     end
    
    KeypadPeripheral KPP_inst (.*);
    
    initial
    begin
    C = 0;
    A = 0;
    E = 0;
    #20;
    C = 1;
    
    #20;
    C = 0;
    A = 1;
    end
    
    
endmodule
