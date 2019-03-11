`timescale 1ns / 1ps

/* FlagReg_tb.sv

Description: Test bench for FlagReg possible inputs.

*/

module FlagReg_tb(
    );
    
    logic dIn = 0, wr_en = 0, set = 0, reset = 0;
    logic dOut = 0;
    
    FlagReg flagreg( .* );
    
    // Begin Simulation
    initial begin
    #10;
    dIn = 1;
    #10;
    wr_en = 1;
    #10;
    wr_en = 0;
    #10;
    set = 1;
    #10;
    reset = 1;
    #10;
    reset = 0;
    end
    
    
endmodule
