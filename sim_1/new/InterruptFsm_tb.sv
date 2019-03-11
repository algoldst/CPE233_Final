`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2019 02:34:28 PM
// Design Name: 
// Module Name: InterruptFsm_tb
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


module InterruptFsm_tb(
    );
    logic clk, press;
    logic interrupt;
    InterruptFsm fsm( .* );
    
    always begin
        clk <= 0; #5;
        clk <= 1; #5;
    end
    
    initial begin
        #10;
        
        // Standard Press
        press <= 1;
        #10;
        press <= 0;
        #100;
        
        // Long press
        press <= 1;
        #100;
        press <= 0;
        #100;
        
        // Multiple presses
        press <= 1;
        #10;
        press <= 0;
        #10;
        press <= 1;
        #10;
        press <= 0;
    end
    
endmodule
