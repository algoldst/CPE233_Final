`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Current Engineer:
//Bridget Benson contributed the clock 
// 
// Create Date: 10/01/2018 10:22:13 AM
// Description: Generic Clock Divider.  Divides the input clock by MAXCOUNT*2
// 
//////////////////////////////////////////////////////////////////////////////////


module PWM (
    input CLK, 
    input [7:0] SWITCHES, //switches that as duty cycles
    output logic JA = 0
    );     
   
    logic [7:0] count = 0;    
    logic [7:0] maxcount = 255;
    always_ff @ (posedge CLK)
    begin
        count = count + 1;
        if( count <= SWITCHES)
        JA = 1;
        else
        JA = 0;
        
        if (count == maxcount)
            count = 0;      
    end
endmodule