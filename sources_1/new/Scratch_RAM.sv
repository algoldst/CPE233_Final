`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Kadin Stephens
// 
// Create Date: 01/26/2019 11:58:22 AM
// Design Name: 
// Module Name: Scratch_RAM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: First, it provides a temporary scratch pad for saving data that will not fit into the 
//  register file and is not immediately necessary for operating on. Data can be directly transferred 
//  between the register file and the scratch RAM. The scratch RAM is also used for the stack memory of the 
//  RAT MCU.
//////////////////////////////////////////////////////////////////////////////////


module Scratch_RAM(
input [9:0] DATA_IN,
input [7:0] SCR_ADDR,
input SCR_WE, CLK,
output logic [9:0] DATA_OUT
    );
      
logic [9:0] mem1 [0:255];
initial
    begin
        int i;
        for (i = 0; i < 256; i++)
            mem1[i] = 0;
    end
    
always_ff @ (posedge CLK)
    begin
        if (SCR_WE == 1)
            mem1[SCR_ADDR] = DATA_IN;
    end
    
assign DATA_OUT = mem1[SCR_ADDR];
endmodule
