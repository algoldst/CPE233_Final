`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Alex Goldstein
//
// Create Date: 01/31/2019 12:06:18 PM
// Design Name:
// Module Name: ALU_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Test simulation for RAT ALU
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module ALU_tb(
    );

    // Initialize simulation
    logic [3:0] sel=0;
    logic [7:0] a=0, b=0;
    logic cIn=0;
    logic [7:0] result=0;
    logic c=0, z=0;
    ALU ALU_tb( .* );

    logic [7:0] result_exp; // Expected values for result, c, z
    logic c_exp, z_exp;

    logic equalsExpected;

    always begin // On every test, check if the result we got is what we expected. (The $display() does this on Tcl; this gives a waveform.)
        if(result==result_exp) equalsExpected <= 1;
        else equalsExpected <= 0;
        #10;
    end

    // Begin Simulation
    initial begin
    #10;

    $display("TYPE\tGOT\tEXPECTED\n");

    // ADD
    sel=0; // Set sel to ADD
    a=8'hAA; b=8'hAA; cIn=0; // a+b
    result_exp = 8'h54; // Expect result of 54
    c_exp = 1; // Expect carry flag = 1
    z_exp = 0; // Expect z-flag = 0
    #10;
    $display("ADD %h %h %b",a,b,c); // Each test displays: "OPERATION [a] [b] [c]" to show inputs.
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h0A; b=8'hA0; cIn=0;
    result_exp = 8'hAA;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("ADD %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'hFF; b=8'h01; cIn=0;
    result_exp = 8'h00;
    c_exp = 1;
    z_exp = 1;
    #10;
    $display("ADD %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // ADDC
    sel=1;
    a=8'hC8; b=8'h36; cIn=1;
    result_exp = 8'hFF;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("ADDC %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'hC8; b=8'h64; cIn=1;
    result_exp = 8'h2D;
    c_exp = 1;
    z_exp = 0;
    #10;
    $display("ADDC %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // SUB
    sel=2;
    a=8'hC8; b=8'h64; cIn=0;
    result_exp = 8'h64;
    c_exp = 1;
    z_exp = 0;
    #10;
    $display("SUB %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'hC8; b=8'h64; cIn=1;
    result_exp = 8'h64;
    c_exp = 1;
    z_exp = 0;
    #10;
    $display("SUB %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h64; b=8'hC8; cIn=0;
    result_exp = 8'h9C;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("SUB %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // SUBC
    sel=3;
    a=8'hC8; b=8'h64; cIn=0;
    result_exp = 8'h64;
    c_exp = 1;
    z_exp = 0;
    #10;
    $display("SUBC %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'hC8; b=8'h64; cIn=1;
    result_exp = 8'h63;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("SUBC %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h64; b=8'hC8; cIn=0;
    result_exp = 8'h9C;
    c_exp = 1;
    z_exp = 0;
    #10;
    $display("SUBC %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h64; b=8'hC8; cIn=1;
    result_exp = 8'h9B;
    c_exp = 1;
    z_exp = 0;
    #10;
    $display("SUBC %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // CMP
    sel=4;
    a=8'hAA; b=8'hFF; cIn=0;
    result_exp = 8'hAB;
    c_exp = 1;
    z_exp = 0;
    #10;
    $display("CMP %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'hFF; b=8'hAA; cIn=0;
    result_exp = 8'h55;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("CMP %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'hAA; b=8'hAA; cIn=0;
    result_exp = 8'h00;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("CMP %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // AND
    sel=5;
    a=8'hAA; b=8'hAA; cIn=0;
    result_exp = 8'hAA;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("AND %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h03; b=8'hAA; cIn=0;
    result_exp = 8'h02;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("AND %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // OR
    sel=6;
    a=8'hAA; b=8'hAA; cIn=0;
    result_exp = 8'hAA;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("OR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h03; b=8'hAA; cIn=0;
    result_exp = 8'hAB;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("OR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // EXOR
    sel=7;
    a=8'hAA; b=8'hAA; cIn=0;
    result_exp = 8'h00;
    c_exp = 0;
    z_exp = 1;
    #10;
    $display("EXOR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h03; b=8'hAA; cIn=0;
    result_exp = 8'hA9;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("EXOR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // TEST
    sel=8;
    a=8'hAA; b=8'hAA; cIn=0;
    result_exp = 8'hAA;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("TEST %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h55; b=8'hAA; cIn=0;
    result_exp = 8'h00;
    c_exp = 0;
    z_exp = 1;
    #10;
    $display("TEST %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // LSL
    sel=9;
    a=8'h01; b=8'h12; cIn=0;
    result_exp = 8'h02;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("LSL %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // LSR
    sel=10;
    a=8'h80; b=8'h33; cIn=0;
    result_exp = 8'h40;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("LSR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h80; b=8'h43; cIn=1;
    result_exp = 8'hC0;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("LSR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // ROL
    sel=11;
    a=8'h01; b=8'hAB; cIn=1;
    result_exp = 8'h02;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("ROL %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'hAA; b=8'hF2; cIn=0;
    result_exp = 8'h55;
    c_exp = 1;
    z_exp = 0;
    #10;
    $display("ROL %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // ROR
    sel=12;
    a=8'h80; b=8'h3C; cIn=0;
    result_exp = 8'h40;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("ROR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h80; b=8'h98; cIn=1;
    result_exp = 8'h40;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("ROR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // ASR
    sel=13;
    a=8'h80; b=8'h81; cIn=0;
    result_exp = 8'hC0;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("ASR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h40; b=8'hB2; cIn=0;
    result_exp = 8'h20;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("ASR %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    // MOV
    sel=14;
    a=8'h00; b=8'h30; cIn=0;
    result_exp = 8'h30;
    c_exp = 0;
    z_exp = 0;
    #10;
    $display("MOV %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);

    a=8'h43; b=8'h00; cIn=1;
    result_exp = 8'h00;
    c_exp = 1;
    z_exp = 0;
    #10;
    $display("MOV %h %h %b",a,b,c);
    if(result !== result_exp) $display("Res: \t%h \t%h\nC: \t\t%b \t%b\nZ: \t\t%b \t%b \n",
        result, result_exp, c,c_exp, z, z_exp);


    end



endmodule
