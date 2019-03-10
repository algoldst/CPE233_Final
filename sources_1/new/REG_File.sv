`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2019 11:42:11 AM
// Design Name: 
// Module Name: REG_File
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


module REG_File(
    input [7:0] DIN,
    input [4:0] ADRX,
    input [4:0] ADRY,
    input RF_WR, CLK,
    output logic [7:0] DX_OUT,
    output logic [7:0] DY_OUT
    );

logic [7:0] mem1 [0:31];
initial
    begin
        int i;
        for (i = 0; i < 32; i++)
            mem1[i] = 0;
    end
        
always_ff @ (posedge CLK)
    begin
        if (RF_WR == 1)
            mem1[ADRX] <= DIN;
    end
    
assign DX_OUT = mem1[ADRX];
assign DY_OUT = mem1[ADRY];
endmodule
