`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2019 01:31:00 PM
// Design Name: Kadin Stephens and Adela Zamora
// Module Name: ControlUnit
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


module ControlUnit(
    input C, Z, INTR, RESET, CLK,
    input [4:0] OPCODE_HI_5,
    input [1:0] OPCODE_LOW_2,
    
    output logic I_SET, I_CLR,
    
    output logic PC_LD, PC_INC,
    output logic [1:0] PC_MUX_SEL,
    
    output logic ALU_OPY_SEL,
    output logic [3:0] ALU_SEL,
    
    output logic RF_WR,
    output logic [1:0] RF_WR_SEL,
    
    output logic SP_LD, SP_INCR, SP_DECR,
    
    output logic SCR_WE, SCR_DATA_SEL,
    output logic [1:0] SCR_ADDR_SEL,
    
    output logic FLG_C_SET, FLG_C_CLR, FLG_C_LD, FLG_Z_LD,
                    FLG_LD_SEL, FLG_SHAD_LD,
    
    output logic RST, IO_STRB 
    );
        
    typedef enum {ST_INIT, ST_FETCH, ST_INTERRUPT, ST_EXEC} STATE;
    STATE NS, PS = ST_INIT;
    logic [6:0] opcode;
    assign opcode = {OPCODE_HI_5, OPCODE_LOW_2};    
    
    always_ff @(posedge CLK)
        begin
            if (RESET == 1)
                PS <= ST_INIT;
            else
                PS <= NS;
        end
        
        always_comb
            begin
            
            I_SET = 0;
            I_CLR = 0;
            PC_LD = 0; 
            PC_INC = 0;
            PC_MUX_SEL = 0; 
            ALU_OPY_SEL = 0;
            ALU_SEL = 0; 
            RF_WR = 0;
            RF_WR_SEL = 0;
            SP_LD = 0;
            SP_INCR = 0;
            SP_DECR = 0;
            SCR_WE = 0;
            SCR_ADDR_SEL = 0;
            SCR_DATA_SEL = 0;           
            FLG_C_SET = 0; 
            FLG_C_CLR = 0; 
            FLG_C_LD = 0;
            FLG_Z_LD = 0;
            FLG_LD_SEL = 0;
            FLG_SHAD_LD = 0; 
            IO_STRB = 0;            
            RST = 0;    
                     
                case (PS)
                    ST_INIT: begin
                        RST = 1;
                        NS = ST_FETCH;
                    end
            
                    ST_FETCH: begin
                        PC_INC = 1;
                        NS = ST_EXEC;
                    end
                    
                    ST_INTERRUPT: begin
                        PC_MUX_SEL = 2;
                        PC_LD = 1;
                        SCR_DATA_SEL = 1;
                        SCR_WE = 1;
                        SCR_ADDR_SEL = 3;
                        SP_DECR = 1;
                        FLG_SHAD_LD = 1;
                        I_CLR = 1;
                        NS = ST_FETCH;
                    end
                
                    ST_EXEC: begin
                        if(INTR == 1)
                            NS = ST_INTERRUPT;
                        else
                            NS = ST_FETCH;                            
                        case (opcode)
                            //ADD, R-R
                            7'b0000100: begin
                                ALU_SEL = 0;
                                RF_WR = 1;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //ADD, R-I
                            7'b1010000, 7'b1010001, 7'b1010010, 7'b1010011: begin
                                ALU_SEL = 0;
                                RF_WR = 1;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                ALU_OPY_SEL = 1;
                                end                                
                            //ADDC, R-R
                            7'b0000101: begin
                                RF_WR = 1;
                                ALU_SEL = 1;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //ADDC, R-I
                            7'b1010100, 7'b1010101, 7'b1010110, 7'b1010111: begin
                                RF_WR = 1;
                                ALU_SEL = 1;
                                ALU_OPY_SEL = 1;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //AND, R-R
                            7'b0000000: begin
                                RF_WR = 1;
                                ALU_SEL = 5;
                                FLG_C_CLR = 1;
                                FLG_Z_LD = 1;
                                end
                            //AND, R-I
                            7'b1000000, 7'b1000001, 7'b1000010, 7'b1000011: begin
                                RF_WR = 1;
                                ALU_SEL = 5;
                                ALU_OPY_SEL = 1;
                                FLG_C_CLR = 1;
                                FLG_Z_LD = 1;                                
                                end
                            //ASR
                            7'b0100100: begin
                                RF_WR = 1;
                                ALU_SEL = 13;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //BRCC
                            7'b0010101: begin
                                if (C == 0)
                                    PC_LD = 1;
                                else
                                    PC_LD = 0;
                                end
                            //BRCS
                            7'b0010100: begin
                                if (C == 1)
                                    PC_LD = 1;
                                else
                                    PC_LD = 0;
                                end
                            //BREQ 
                            7'b0010010: begin
                                if (Z == 1)
                                    PC_LD = 1;
                                else
                                    PC_LD = 0;
                                end  
                            //BRN
                            7'b0010000: begin                                
                                PC_LD = 1;                                
                            end
                            //BRNE
                            7'b0010011: begin
                                if (Z == 0)
                                    PC_LD = 1;
                                else
                                    PC_LD = 0;
                                end
                            //CALL
                            7'b0010001: begin
                               PC_LD = 1;                                                            
                               SP_DECR = 1;
                               SCR_ADDR_SEL = 3;
                               SCR_WE = 1;
                               SCR_DATA_SEL = 1; 
                               end
                            //CLI
                            7'b0110101: begin
                                I_CLR = 1;
                               end
                            //CLC
                            7'b0110000: begin
                                FLG_C_CLR = 1;
                                end
                            //CMP, R-R
                            7'b0001000: begin
                                ALU_SEL = 4;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //CMP, R-I
                            7'b1100000, 7'b1100001, 7'b1100010, 7'b1100011: begin
                                ALU_SEL = 4;
                                ALU_OPY_SEL = 1;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end                            
                            //EXOR, R-R
                            7'b0000010: begin                                
                                RF_WR = 1;
                                ALU_SEL = 7;                                
                                FLG_C_CLR = 1;
                                FLG_Z_LD = 1;
                            end
                            //EXOR, R-I
                            7'b1001000, 7'b1001001, 7'b1001010, 7'b1001011: begin
                                RF_WR = 1;
                                ALU_SEL = 7;
                                ALU_OPY_SEL = 1;                                
                                FLG_C_CLR = 1;
                                FLG_Z_LD = 1;
                                end                                                    
                            //IN
                            7'b1100100, 7'b1100101, 7'b1100110, 7'b1100111: begin
                                RF_WR_SEL = 3;
                                RF_WR = 1;
                            end
                            //LD, R-R
                            7'b0001010: begin
                                RF_WR = 1;
                                RF_WR_SEL = 1;
                                SCR_ADDR_SEL = 0;   
                            end
                            //LD, R-I
                            7'b1110000, 7'b1110001, 7'b1110010, 7'b1110011: begin
                                RF_WR = 1;
                                RF_WR_SEL = 1;
                                SCR_ADDR_SEL = 1;
                            end
                            //LSL
                            7'b0100000: begin
                                RF_WR = 1;
                                ALU_SEL = 9;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //LSR
                            7'b0100001: begin
                                RF_WR = 1;
                                ALU_SEL = 10;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;                            
                                end
                            //MOV, R-R
                            7'b0001001: begin
                                ALU_SEL = 14;
                                RF_WR = 1;
                            end
                            //MOV, R-I
                            7'b1101100, 7'b1101101, 7'b1101110, 7'b1101111: begin
                                ALU_SEL = 14;
                                ALU_OPY_SEL = 1;                                
                                RF_WR = 1;                            
                                end
                            //OR, R-R
                            7'b0000001: begin
                                RF_WR = 1;
                                ALU_SEL = 6;
                                FLG_C_CLR = 1;
                                FLG_Z_LD = 1;
                                end
                            //OR, R-I
                            7'b1000100, 7'b1000101, 7'b1000110, 7'b1000111: begin
                                RF_WR = 1;
                                ALU_SEL = 6;
                                ALU_OPY_SEL = 1;
                                FLG_C_CLR = 1;
                                FLG_Z_LD = 1;                            
                                end
                            //OUT, R-R
                            7'b1101000, 7'b1101001, 7'b1101010, 7'b1101011: begin
                                IO_STRB = 1;
                            end
                            //POP
                            7'b0100110: begin
                                SP_INCR = 1;
                                SCR_ADDR_SEL = 2;                                          
                                RF_WR = 1;
                                RF_WR_SEL = 1; 
                            end
                            //PUSH
                            7'b0100101: begin
                                SP_DECR = 1;
                                SCR_ADDR_SEL = 3;
                                SCR_WE = 1;   
                            end
                            //RET
                            7'b0110010: begin
                                SP_INCR = 1;
                                SCR_ADDR_SEL = 2;
                                PC_MUX_SEL = 1;
                                PC_LD = 1;
                            end
                            //RETID
                            7'b0110110: begin
                                PC_LD = 1;
                                PC_MUX_SEL = 1;
                                SCR_ADDR_SEL = 2;
                                SP_INCR = 1;
                                I_CLR = 1;
                                FLG_LD_SEL = 1;
                                FLG_Z_LD = 1;
                                FLG_C_LD = 1;
                                end
                            //RETIE
                            7'b0110111: begin
                                PC_LD = 1;
                                PC_MUX_SEL = 1;
                                SCR_ADDR_SEL = 2;
                                SP_INCR = 1;
                                I_SET = 1;
                                FLG_LD_SEL = 1;
                                FLG_Z_LD = 1;
                                FLG_C_LD = 1;
                                end                            
                            //ROL
                            7'b0100010: begin
                                RF_WR = 1;
                                ALU_SEL = 11;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //ROR
                            7'b0100011: begin
                                RF_WR = 1;
                                ALU_SEL = 12;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //SEC
                            7'b0110001: begin
                                FLG_C_SET = 1;
                                end
                            //SEI
                            7'b0110100: begin
                                I_SET = 1;
                                end
                            //ST, R-R
                            7'b0001011: begin
                               SCR_WE = 1;  
                            end
                            //ST, R-I
                            7'b1110100, 7'b1110101, 7'b1110110, 7'b1110111: begin
                                SCR_ADDR_SEL = 1;
                                SCR_WE = 1;
                            end
                            //SUB, R-R
                            7'b0000110: begin
                                RF_WR = 1;
                                ALU_SEL = 2;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //SUB, R-I
                            7'b1011000, 7'b1011001, 7'b1011010, 7'b1011011: begin
                                RF_WR = 1;
                                ALU_SEL = 2;
                                ALU_OPY_SEL = 1;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;                               
                                end
                            //SUBC, R-R
                            7'b0000111: begin
                                RF_WR = 1;
                                ALU_SEL = 3;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end 
                            //SUBC, R-I
                            7'b1011100, 7'b1011101, 7'b1011110, 7'b1011111: begin
                                RF_WR = 1;
                                ALU_SEL = 3;
                                ALU_OPY_SEL = 1;
                                FLG_C_LD = 1;
                                FLG_Z_LD = 1;
                                end
                            //TEST, R-R
                            7'b0000011: begin
                                ALU_SEL = 8;
                                FLG_C_CLR = 1;
                                FLG_Z_LD = 1;
                                end
                            //TEST, R-I
                            7'b1001100, 7'b1001101, 7'b1001110, 7'b1001111: begin
                                ALU_SEL = 8;
                                ALU_OPY_SEL = 1;
                                FLG_C_CLR = 1;
                                FLG_Z_LD = 1;                            
                                end
                            //WSP
                            7'b0101000: begin
                            SP_LD = 1;
                            end
//                            //ZERO
//                            7'b0000000:begin
//                                RST = 0;
//                            end
                            default:
                                RST = 1;
                     endcase
                     end
                     default: NS = ST_INIT;
                     endcase
                     end
endmodule
