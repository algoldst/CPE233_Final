`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/31/2019 09:21:02 AM
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
    input [3:0] sel,
    input [7:0] a, b,
    input cIn,
    output [7:0] result,
    output logic c, z
    );

    logic [8:0] resultC = 0; // result with carry as MSB, 9 bits

    always_comb begin

        case(sel)
            4'h0: begin // ADD
                resultC = a+b;
                c = resultC[8];
            end

            4'h1: begin // ADDC (a+b+carry)
                resultC = a+b+cIn;
                c = resultC[8];
            end

            4'h2, 4'h4: begin // SUB, CMP
                resultC = a-b;
                c = resultC[8];
            end

            4'h3: begin // SUBC (a-b-c)
                resultC = a-b-cIn;
                c = resultC[8];
            end

            // 4'h4: CMP --> bundled with 4'h2: SUB

            4'h5, 4'h8: begin // AND, TEST
                resultC = a & b;
                c = 0;
            end

            4'h6: begin // OR
                resultC = a | b;
                c = 0;
            end

            4'h7: begin // EXOR
                resultC = a ^ b;
                c = 0;
            end

            // 4'h8: TEST --> Bundled with 4'h5: AND

            4'h9: begin // LSL
                resultC = { a[6:0], cIn };
                c = a[7];
            end

            4'hA: begin // LSR
                resultC = { cIn, a[7:1] };
                c = a[0];
            end

            4'hB: begin // ROL
                resultC = { a[6:0], a[7] };
                c = a[7];
            end

            4'hC: begin // ROR
                resultC = { a[0], a[7:1] };
                c = a[0];
            end

            4'hD: begin // ASR
                resultC = { a[7], a[7:1] };
                c = a[0];
            end

            4'hE: begin // MOV
                resultC = b;
            end

            default: resultC = resultC; // sel==0xF.
        endcase

    if(resultC[7:0] == 0) z = 1;
    else z = 0;
    end

    assign result = resultC[7:0];

endmodule
