`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2019 02:15:25 PM
// Design Name: 
// Module Name: flag_mux_c
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


module flag_mux_z(
    input zero, one,
    input FLG_LD_SEL,
    output logic OUT
);

    always_comb
    begin
        if (FLG_LD_SEL == 0)
            OUT = zero;
        else if (FLG_LD_SEL == 1)
            OUT = one;                   
        else 
            OUT = 10'h000; 
    end    
endmodule