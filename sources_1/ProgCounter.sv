`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Matt Stallings
// 
// Create Date: 02/07/2019 09:43:14 AM
// Design Name: 
// Module Name: ProgCounter
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


module ProgCounter(
         input [9:0] muxPort0, muxPort1, muxPort2, muxPort3,
         input [1:0] mux_sel,
         input ld, inc, rst, clk,
         output logic [9:0] pc_count
         );
    
    logic [9:0] t1;
    
Mux4_1 #(10) pcMux(.port0(muxPort0), .port1(muxPort1), .port2(muxPort2), .port3(muxPort3),
                    .sel(mux_sel), .dOut(t1) );
ProgCounterReg pcReg(.clk(clk), .dIn(t1), .pc_ld(ld), .pc_inc(inc), .rst(rst), .pc_count(pc_count));
    
endmodule
