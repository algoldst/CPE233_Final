`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 12:21:42 PM
// Design Name: 
// Module Name: Flags_tb
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


module Flags_tb(
    );
    logic clk = 0;
    logic c_in = 0, z_in = 0;
    logic flg_c_set = 0, flg_c_clr = 0, flg_c_ld = 0;
    logic flg_z_ld = 0;
    logic flg_ld_sel = 0;
    logic flg_shad_ld = 0;
    logic c_out = 0, z_out = 0;
    
    Flags flags_tb( .* );
    
    always begin
        clk <= 0; #5;
        clk <= 1; #5;
    end
    
    initial begin
        // Both C,Z high
        c_in <= 1; z_in <= 1;
        #10;
        
        // Load flags
        flg_c_ld = 1; flg_z_ld = 1; 
        #10;
        
        // Load shadow flags
        flg_c_ld <= 0; flg_z_ld <= 0;
        flg_shad_ld <= 1; 
        #10;
        
        // Clear regs
        flg_shad_ld <= 0;
        flg_c_clr <= 1;
        #10;
        
        // Load shad >> c,z
        flg_c_clr <= 0;
        flg_ld_sel <= 1;
        flg_z_ld <=1; flg_c_ld <= 1;
        #10;
        
    end
    
endmodule
