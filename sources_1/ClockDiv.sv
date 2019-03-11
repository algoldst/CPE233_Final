`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2019 10:42:30 AM
// Design Name: 
// Module Name: ClockDiv
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


module PWM #(parameter MAX_COUNT = 255)(
    input clk,
    input [7:0] duty, // 0-255
    output logic sclk = 0
    );     
   
    logic [7:0] count = 0;
    
    always_ff @ (posedge clk) begin
    
        if (duty == 0) sclk = 0;
        else if (count < duty) sclk = 1;   // The signal should be high until count reaches duty
        else if (count >= duty) sclk = 0;  // Then, once count reaches duty, it should go low
        
        count = count + 1; 
        if (count == MAX_COUNT) count = 0; // This resets the counter to maintain the period of the divider
    end

endmodule
