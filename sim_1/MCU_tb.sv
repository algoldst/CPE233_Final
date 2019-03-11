`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2019 08:58:33 PM
// Design Name: 
// Module Name: MCU_tb
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


module MCU_tb(
    );
    
    logic clk, interrupt = 0, reset = 0; // Inputs
    logic [7:0] in_port;
    logic io_strb; // Output
    logic [7:0] out_port, port_id; // Output
    
    MCU mcu_tb( .* );
    
    // Simulate Clock
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    // Simulation
    initial begin
        in_port = 8'hFF;
        #200;
        reset = 1;
        #20;
    end
endmodule
