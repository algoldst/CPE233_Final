`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2019 01:56:01 PM
// Design Name: 
// Module Name: FreqMux
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


module FreqMux(
    input [7:0] SEL,
    output logic [15:0] an
    );
    
    always_comb
    case (SEL)
        0: an = 0;
        1: an = 47778;
        2: an = 45097;
        3: an = 42566;
        4: an = 40177;
        5: an = 37922;
        6: an = 35793;
        7: an = 33784;
        8: an = 31888;
        9: an = 30098;
        10: an = 28409;
        11: an = 26815;
        12: an = 25310;
        13: an = 23889;
        14: an = 22548;
        15: an = 21283;
        16: an = 20088;
        17: an = 18961;
        18: an = 17897;
        19: an = 16892;
        20: an = 15944;
        21: an = 15049;
        22: an = 14205;
        23: an = 13407;
        24: an = 12655;
        25: an = 11945;
        26: an = 11274;
        27: an = 10641;
        28: an = 10044;
        29: an = 9480;
        30: an = 8948;
        31: an = 8446;
        32: an = 7972;
        33: an = 7525;
        34: an = 7102;
        35: an = 6704;
        36: an = 6327;
        default: an = 0;
 endcase   
endmodule
