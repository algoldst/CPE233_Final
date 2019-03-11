`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2019 12:03:53 PM
// Design Name: 
// Module Name: KeyPadDriver
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


module KeyPadDriver #(parameter clkDiv = 227272)(    // Use clkDiv = 2272727 for 22 Hz clkdiv
    input clk,
    input C, A, E,  // columns 0,1,2 << PMOD
    //output [7:0] seg,   // sseg segments
    //output [3:0] an,    // sseg digit on/off
    output B, G, F, D,  // rows B,G,F,D >> PMOD
    output interrupt,
    output [3:0] data,
    output [2:0] statePMOD
    //output [3:0] LEDS
    );
    
    // Clock Divider to create 22 MHz Clock //////////////////////////////////
    logic [26:0] s_clkCounter = 0;
    logic s_clk = 0;
    always_ff @(posedge clk) begin
        s_clkCounter = s_clkCounter + 1;
        if(s_clkCounter >= /*clkDiv*/ 22727) begin
            s_clk <= ~s_clk;
            s_clkCounter <= 0;
        end
    end
    
    // Key FSM and KeyPressReg
    logic [3:0] t_keyOut_imm, t_keyOut;
    logic t_press;
    KeyFsm keyFsm(.clk(s_clk), .C(C), .A(A), .E(E), .B(B), .G(G), .F(F), .D(D), .press(t_press), .keyOut(t_keyOut_imm));
    DReg keyPressReg(.clk(s_clk), .dIn(t_keyOut_imm), .ld(t_press), .dOut(t_keyOut));
    
    // Interrupt FSM -- Sends interrupt signal for 60ns = 3 MCU clock cycles
    InterruptFsm interruptFsm(.clk(clk), .press(t_press), .interrupt(interrupt), .statePMOD(statePMOD) );
    
    // SSEG Driver
//    SevSegDisp sseg(.CLK(clk), .MODE(0), .DATA_IN(t_keyOut), .CATHODES(seg), 
//                    .ANODES(an) );  
//    assign LEDS = t_keyOut;
    assign data = t_keyOut;
endmodule
