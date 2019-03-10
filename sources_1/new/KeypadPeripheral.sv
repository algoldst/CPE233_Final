`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2019 12:25:16 PM
// Design Name: 
// Module Name: KeypadPeripheral
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


module KeypadPeripheral(
    input CLK,
    input C, A, E, 
    output logic B, G, F, D, 
//    output [7:0] CATHODES,
//    output [3:0] ANODES,
    output interrupt,
    output data
    );
    
    logic t1, t2;
    logic [3:0] t3; //, t4;
    
    KeyFSM inst1 (.CLK(t1), .C(C), .A(A), .E(E), .press(t2), 
                    .data(t3), .B(B), .G(G), .F(F), .D(D) );
    INTRFSM inst2 (.CLK(CLK), .press(t2), .interrupt(interrupt));
    P3Reg inst3 (.CLK(t1), .LD(t2), .DIN(t3), .Q(data));
    //SevSegDisp inst4 (.CLK(CLK), .MODE(1'b0), .DATA_IN(t4), .CATHODES(CATHODES), .ANODES(ANODES));
    clk_divider inst5 (.clk(CLK), .maxcount(2272727), .sclk(t1));    
endmodule
