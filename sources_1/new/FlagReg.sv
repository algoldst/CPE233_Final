`timescale 1ns / 1ps

/* FlagReg.sv

Description:
Stores value for flags (Carry and Zero). 
    Z only needs to load; doesn't use set or clr.
    
Precedence: clr > set > wr_en

*/

module FlagReg(
    input clk, dIn, ld, set, clr,
    output logic dOut
    );
    always_ff @(posedge clk) begin
        if (clr) dOut = 0;
        else if (set) dOut = 1;
        else if (ld) dOut = dIn;
        else dOut = dOut;
    end
endmodule