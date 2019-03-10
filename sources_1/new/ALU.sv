`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2019 01:18:45 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [3:0] SEL,
    input [7:0] A, B,
    input CIN,
    output [7:0] RESULT,
    output logic Cflag,
    output logic Zflag
    );
    
    logic [8:0] nine_bit;
    
always_comb
    case(SEL)
        //ADD
        0: nine_bit = {1'b0,A} + {1'b0,B};
        //ADDC
        1: nine_bit = {1'b0,A} + {1'b0,B} + {8'b0,CIN};
        //SUB
        2: nine_bit = {1'b0,A} - {1'b0,B};
        //SUBC
        3: nine_bit = {1'b0,A} - {1'b0,B} - {8'b0,CIN};
        //CMP
        4: nine_bit = {1'b0,A} - {1'b0,B};
        //AND
        5: nine_bit = {1'b0,A} & {1'b0,B};
        //OR
        6: nine_bit = {1'b0,A} | {1'b0,B};
        //EXOR
        7: nine_bit = {1'b0,A} ^ {1'b0,B};
        //TEST
        8: nine_bit = {1'b0,A} & {1'b0,B};
        //LSL
        9: nine_bit = {A[7], A[6:0], CIN};
        //LSR
        10: nine_bit = {A[0],CIN, A[7:1]};
        //ROL
        11: nine_bit = {A[7], A[6:0], A[7]}; //{A[7], (A[6:0] & A[7])};
        //ROR
        12: nine_bit = {A[0], A[0], A[7:1]}; //{A[0], (A[0] & A[7:1])};
        //ASR
        13: nine_bit = {A[0], A[7], A[7], A[6:1]};
        //MOV
        14: nine_bit = {1'b0,B};
        //unused
        15: nine_bit = 0;
    endcase 
    
    assign Cflag = nine_bit[8];
    assign RESULT = nine_bit[7:0];
    always_comb
        begin
            if (nine_bit[7:0] == 0)
                Zflag = 1;
            else 
                Zflag = 0;
         end  
endmodule
