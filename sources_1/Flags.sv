`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 12:08:32 PM
// Design Name: 
// Module Name: Flags
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


module Flags(
    input clk,
    input c_in, z_in,
    input flg_c_set, flg_c_clr, flg_c_ld,
    input flg_z_ld,
    input flg_ld_sel,   // "high" on start of interrupt
    input flg_shad_ld,  // "high" on start of interrupt
    output c_out, z_out
    );
    
    // Interconnects
    logic t_zOut, t_shadZOut;
    logic t_zIn;
    
    logic t_cOut, t_shadCOut;
    logic t_cIn;
    
    assign c_out = t_cOut;
    assign z_out = t_zOut;
    
    // Muxes decide whether to load incoming C/Z signals (from ALU), or load Shadow registers into C/Z flag reg.
    Mux2_1 cMux( .sel(flg_ld_sel), .port0(c_in), .port1(t_shadCOut), .dOut(t_cIn) );
    Mux2_1 zMux( .sel(flg_ld_sel), .port0(z_in), .port1(t_shadZOut), .dOut(t_zIn) );
    
    FlagReg CFlag( .clk(clk), .dIn(t_cIn), .wr_en(flg_c_ld), .set(flg_c_set), .reset(flg_c_clr), .dOut(t_cOut) );
    FlagReg ZFlag( .clk(clk), .dIn(t_zIn), .wr_en(flg_z_ld), .set('0), .reset('0), .dOut(t_zOut) );
    
    // Stores C/Z register values when an interrupt is called, and supplies these values back to C/Z regs when interrupt ends.
    FlagReg ShadC( .clk(clk), .dIn(t_cOut), .wr_en(flg_shad_ld), .set(0), .reset(0), .dOut(t_shadCOut) );
    FlagReg ShadZ( .clk(clk), .dIn(t_zOut), .wr_en(flg_shad_ld), .set(0), .reset(0), .dOut(t_shadZOut) );
    
endmodule
