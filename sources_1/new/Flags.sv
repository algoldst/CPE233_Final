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
    input flg_c_set, flg_c_clr, flg_c_ld, intr_set, intr_clr,
    input flg_z_ld,
    input flg_ld_sel,
    input flg_shad_ld,
    output c_flag, z_flag, intr_out
    );
    
    logic c_in_s, z_in_s, c_mux_s, z_mux_s, t1, t2;
    
    FlagReg CFlag( .clk(clk), .dIn(c_in_s), .ld(flg_c_ld), .set(flg_c_set), .clr(flg_c_clr), .dOut(t1) );
    FlagReg ZFlag( .clk(clk), .dIn(z_in_s), .ld(flg_z_ld), .set(1'b0), .clr(1'b0), .dOut(t2) );
    FlagReg SHADCFLag (.clk(clk), .dIn(t1), .ld(flg_shad_ld), .set(1'b0), .clr(1'b0), .dOut(c_mux_s));
    FlagReg SHADZFlag (.clk(clk), .dIn(t2), .ld(flg_shad_ld), .set(1'b0), .clr(1'b0), .dOut(z_mux_s));
    flag_mux_c inst1 (.zero(c_in), .one(c_mux_s), .FLG_LD_SEL(flg_ld_sel), .OUT(c_in_s));
    flag_mux_z inst2 (.zero(z_in), .one(z_mux_s), .FLG_LD_SEL(flg_ld_sel), .OUT(z_in_s));
    FlagReg Interrupt (.clk(clk), .dIn(1'b0), .ld(1'b0), .set(intr_set), .clr(intr_clr), .dOut(intr_out)); 
    
    assign c_flag = t1;
    assign z_flag = t2; 
endmodule