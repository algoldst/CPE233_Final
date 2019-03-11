`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2019 10:59:13 AM
// Design Name: 
// Module Name: ClockDiv_tb
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


module PWM_tb(
    );
    logic clk, sclk;
    logic [15:0] duty = 0; // 0-255
    
    PWM #(255) pwm( .* );
    
    // Simulate clk
    always begin
        clk <= 0; #5;
        clk <= 1; #5;
    end
    
    // Simulation
    initial begin
        // Loop through each duty cycle 0-255 to test output
        for(int i = 0; i <= 255; i++) begin
            duty = i;
            #2550; // Wait 1 loop of MAX_COUNT
        end
    end
endmodule
