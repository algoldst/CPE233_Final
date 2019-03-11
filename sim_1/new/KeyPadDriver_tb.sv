`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2019 03:12:06 PM
// Design Name: 
// Module Name: KeyPadDriver_tb
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


module KeyPadDriver_tb(
    );
    logic clk;
    logic C = 0, A = 0, E = 0;  // columns 0,1,2 << PMOD
    logic [7:0] seg;   // sseg segments
    logic [3:0] an;    // sseg digit on/off
    logic B, G, F, D;  // rows B,G,F,D >> PMOD
    logic interrupt;
    logic [3:0] LEDS;
   
    KeyPadDriver #1 keyPadDriver_tb( .* );     // Low number for sim, 22727270 for actual use.
   
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    initial begin
        #83;    // Wait 1 cycle to check setup.
        #5;     // Wait 5 ns, then put C high while the FSM is in State CHECK_G --> 4  pressed
        C = 1;
        #20;
        C = 0;  // Finished with State CHECK_G, so this would go low again.     --> 13  "pressed"
        #80;
        C = 1;  // Put C high for CHECK_F                                       --> 7  pressed
        #20;
        C = 0;
        
    end
    
    
endmodule
