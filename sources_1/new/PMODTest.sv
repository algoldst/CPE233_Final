`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2019 03:47:32 PM
// Design Name: 
// Module Name: PMODTest
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


module PMODTest(
    input clk,
    output interrupt
    );
    logic press = 0;
    logic [26:0] counter = 0;
    always_ff @(posedge clk) begin
        if(counter > 200000) begin
            press = 1;
            counter++;
            if(counter > 200010) counter = 0;
        end
        else begin
            press = 0;
            counter++;
        end
    end
    InterruptFsm(.clk(clk), .press(press), .interrupt(interrupt));
endmodule
