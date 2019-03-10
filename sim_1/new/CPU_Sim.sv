`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2019 11:20:29 AM
// Design Name: 
// Module Name: CPU_Sim
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


module CPU_Sim(
    );
    
    logic INTERRUPT, RESET, CLK; 
    logic [7:0] IN_PORT;
    logic IO_STRB; 
    logic [7:0] OUT_PORT, PORT_ID;
    
    Computer inst(.*);
    
    always
    begin
        CLK = 0; #5;
        CLK = 1; #5;
    end
    
    
    
    initial begin
    RESET = 1;
    #10
    RESET = 0;
    IN_PORT = 8'h69; 
    end
    
endmodule
