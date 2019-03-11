`timescale 1ns / 1ps

/* FlagReg.sv

Description:
Stores value for flags (Carry and Zero). 
    Z only needs to load; doesn't use set or reset.
    
Precedence: reset > set > wr_en

*/

module FlagReg(
    input clk, dIn, wr_en, set, reset,
    output logic dOut = 0
    );
    always_ff @(posedge clk) begin
        if (reset) dOut <= 0;
        else if (set) dOut <= 1;
        else if (wr_en) dOut <= dIn;
        else dOut <= dOut;
    end
endmodule
