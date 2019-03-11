`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 09:28:17 AM
// Design Name: 
// Module Name: CUnit
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


module CUnit(
    input clk,
    input c, z, interrupt, reset,
    input [4:0] opcode_hi5, 
    input [1:0] opcode_lo2,
    
    output logic rf_wr,
    output logic [1:0] rf_wr_sel,
    
    output logic sp_ld, sp_incr, sp_decr,
    
    output logic scr_we, scr_data_sel, 
    output logic [1:0] scr_addr_sel,
    
    output logic pc_ld, pc_inc,
    output logic [1:0] pc_mux_sel,
    
    output logic alu_opy_sel,
    output logic [3:0] alu_sel,
    
    output logic flg_c_set, flg_c_clr, flg_c_ld,
    output logic flg_z_ld,
    output logic flg_ld_sel, flg_shad_ld,
    
    output logic i_set, i_clr,
    
    output logic io_strb,
    
    output logic rst
    );
    
    typedef enum {ST_INIT, ST_FETCH, ST_EXEC, ST_INTER} State;
    State NS, PS = ST_INIT;
    
    logic [6:0] opcode;
    assign opcode = {opcode_hi5, opcode_lo2};
    
    always_ff @(posedge clk) begin
        if (reset == 1)
            PS <= ST_INIT;
        
        else
            PS <= NS;
    end
    
    always_comb begin
        // Make all outputs = 0.
        rf_wr = 0; rf_wr_sel = 0;
        pc_ld = 0; pc_inc = 0; pc_mux_sel = 0;
        alu_opy_sel = 0; alu_sel = 0;
        flg_c_set = 0; flg_c_clr = 0; flg_c_ld = 0;
        flg_z_ld = 0;
        flg_ld_sel = 0; flg_shad_ld = 0;
        i_set = 0; i_clr = 0;
        io_strb = 0;
        rst = 0;
        
        sp_ld = 0; sp_incr = 0; sp_decr = 0;
        scr_we = 0; scr_data_sel = 0; 
        scr_addr_sel = 0;
            
        case(PS)
            ST_INIT: begin
                rst = 1;
                NS = ST_FETCH;
            end
            ST_FETCH: begin
                pc_inc = 1;
                NS = ST_EXEC;
            end
            ST_INTER: begin
                NS = ST_FETCH;
                pc_mux_sel = 2;
                pc_ld = 1;
                
                scr_data_sel = 1;
                scr_addr_sel = 3;
                scr_we = 1;
                sp_decr = 1;
                
                flg_shad_ld = 1;
                
                i_clr = 1;
            end
            ST_EXEC: begin
                if (interrupt == 1)
                    NS <= ST_INTER;
                else
                    NS <= ST_FETCH;
                case(opcode) // Select operation for this opcode
                    // opcode AND
                    7'b00000_00, //reg,reg
                    7'b10000_00, //reg,imm
                    7'b10000_01,
                    7'b10000_10,
                    7'b10000_11: begin
                        if(opcode == 7'b0) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 5;
                        
                        rf_wr = 1;   
                        rf_wr_sel = 0;

                        flg_c_clr = 1;
                        flg_z_ld = 1;
                    end
                    
                    // OR
                    7'b00000_01, //reg,reg
                    7'b10001_00, //reg,imm
                    7'b10001_01,
                    7'b10001_10,
                    7'b10001_11: begin
                        if(opcode == 7'b1) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 6;
                        
                        rf_wr = 1;
                        rf_wr_sel = 0;
                        
                        flg_c_clr = 1;
                        flg_z_ld = 1;
                    end
                    
                     // opcode EXOR
                    7'b0000010, //reg,reg
                    7'b1001000, //reg,imm
                    7'b1001001,
                    7'b1001010,
                    7'b1001011: begin
                        if(opcode == 7'b10) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 4'b0111;
                        
                        rf_wr = 1;
                        rf_wr_sel = 0;
                        
                        flg_c_clr = 1;
                        flg_z_ld = 1;
                    end
                    
                    // TEST
                    7'b00000_11, //reg,reg
                    7'b10011_00, //reg,imm
                    7'b10011_01,
                    7'b10011_10,
                    7'b10011_11: begin
                        if(opcode == 7'b11) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 8;
                        
                        rf_wr = 0;
                        rf_wr_sel = 0;
                        
                        flg_c_clr = 1;
                        flg_z_ld = 1;
                    end
                    
                    // ADD
                    7'b00001_00, //reg,reg
                    7'b10100_00, //reg,imm
                    7'b10100_01,
                    7'b10100_10,
                    7'b10100_11: begin
                        if(opcode == 7'b1_00) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 0;
                        
                        rf_wr = 1;
                        rf_wr_sel = 0;
                        
                        flg_c_ld = 1;
                        flg_z_ld = 1;
                    end
                    
                    // ADDC
                    7'b00001_01, //reg,reg
                    7'b10101_00,
                    7'b10101_01,
                    7'b10101_10,
                    7'b10101_11: begin
                        if(opcode == 7'b1_01) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 1;
                        
                        rf_wr = 1;
                        rf_wr_sel = 0;
                        
                        flg_c_ld = 1;
                        flg_z_ld = 1;
                    end
                    
                    // SUB
                    7'b00001_10, //reg,reg
                    7'b10110_00, //reg,imm
                    7'b10110_01,
                    7'b10110_10,
                    7'b10110_11: begin
                        if(opcode == 7'b1_10) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 2;
                        
                        rf_wr = 1;
                        rf_wr_sel = 0;
                        
                        flg_c_ld = 1;
                        flg_z_ld = 1;
                    end
                    
                    // SUBC
                    7'b00001_11, //reg,reg
                    7'b10111_00, //reg,imm
                    7'b10111_01,
                    7'b10111_10,
                    7'b10111_11: begin
                        if(opcode == 7'b1_11) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 3;
                        
                        rf_wr = 1;
                        rf_wr_sel = 0;
                        
                        flg_c_ld = 1;
                        flg_z_ld = 1;
                    end
                    
                    // CMP
                    7'b00010_00, //reg,reg
                    7'b11000_00, //reg,imm
                    7'b11000_01,
                    7'b11000_10,
                    7'b11000_11: begin
                        if(opcode == 7'b10_00) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 4;
                        
                        rf_wr = 0;
                        rf_wr_sel = 0;
                        
                        flg_c_ld = 1;
                        flg_z_ld = 1;
                    end
                    
                    // IN
                    7'b1100100, //reg,imm 
                    7'b1100101, 
                    7'b1100110, 
                    7'b1100111: begin
                        rf_wr_sel = 3;
                        rf_wr = 1;
                    end
                    
                    // OUT
                    7'b1101000, //reg,imm
                    7'b1101001,
                    7'b1101010,
                    7'b1101011: begin
                        io_strb = 1;
                    end
                    
                    // MOV
                    7'b00010_01, //reg,reg
                    7'b11011_00, //reg,imm
                    7'b11011_01,
                    7'b11011_10,
                    7'b11011_11: begin
                        if(opcode == 7'b10_01) alu_opy_sel = 0;
                        else alu_opy_sel = 1;
                        alu_sel = 14;
                        
                        rf_wr_sel = 0;
                        rf_wr = 1;
                    end
                    
                    // LD
                    7'b00010_10, //reg,reg
                    7'b11100_00, //reg,imm
                    7'b11100_01,
                    7'b11100_10,
                    7'b11100_11: begin
                        if(opcode == 7'b10_10) scr_addr_sel = 0;
                        else scr_addr_sel = 1;
                        
                        rf_wr = 1;
                        rf_wr_sel = 1;
                    end
                    
                    // ST
                    7'b00010_11, //reg,reg
                    7'b11101_00, //reg,imm
                    7'b11101_01,
                    7'b11101_10,
                    7'b11101_11: begin
                        if(opcode == 7'b10_11) scr_addr_sel = 0;
                        else scr_addr_sel = 1;
                        scr_data_sel = 0;
                        
                        scr_we = 1;
                    end
                    
                    // BRANCHES
                    7'b00100_00, // BRN
                    7'b00100_10, // BREQ, z=1
                    7'b00100_11, // BRNE, z=0
                    7'b00101_00, // BRCS, c=1
                    7'b00101_01: // BRCC, c=0
                    begin
                        if((opcode == 7'b100_00) || 
                        (opcode == 7'b100_10 && z) || (opcode == 7'b100_11 && !z) || 
                        (opcode == 7'b101_00 && c) || (opcode == 7'b101_01 && !c)) 
                        begin
                            pc_ld = 1;
                            pc_mux_sel = 0;
                        end
                        else begin end
                    end
                    
                    // CALL
                    7'b00100_01: begin
                        pc_ld = 1;
                        pc_mux_sel = 0;
                        
                        scr_data_sel = 1;
                        scr_we = 1;
                        scr_addr_sel = 3; // pushing onto stack --> use address [ptr-1]
                        
                        sp_decr = 1;
                    end
                    
                    // BITSHIFTS
                    7'b01000_00, //LSL
                    7'b01000_01, //LSR
                    7'b01000_10, //ROL
                    7'b01000_11, //ROR
                    7'b01001_00: //ASR
                    begin
                        if(opcode == 7'b1000_00) alu_sel = 9;       //LSL
                        else if(opcode == 7'b1000_01) alu_sel = 10; //LSR
                        else if(opcode == 7'b1000_10) alu_sel = 11; //ROL
                        else if(opcode == 7'b1000_11) alu_sel = 12; //ROR
                        else if(opcode == 7'b1001_00) alu_sel = 13; //ASR
                        else begin end
                        
                        rf_wr = 1;
                        rf_wr_sel = 0;
                        
                        flg_c_ld = 1;
                        flg_z_ld = 1;
                    end
                    
                    // PUSH
                    7'b01001_01: begin
                        scr_data_sel = 0;
                        scr_we = 1;
                        scr_addr_sel = 3;
                        
                        sp_decr = 1;
                    end
                    
                    // POP
                    7'b01001_10: begin
                        scr_addr_sel = 2;
                        
                        sp_incr = 1;
                        
                        rf_wr_sel = 1;
                        rf_wr = 1;
                    end
                    
                    // WSP
                    7'b01010_00: begin
                        sp_ld = 1;
                    end
                    
                    // RSP
                    7'b01010_01: begin
                        rf_wr_sel = 2;
                        rf_wr = 1;
                    end
                    
                    // CLC
                    7'b01100_00: begin
                        flg_c_clr = 1;
                    end
                    
                    // SEC
                    7'b01100_01: begin
                        flg_c_set = 1;
                    end
                    
                    // RET
                    7'b01100_10: begin
                        sp_incr = 1;
                        scr_addr_sel = 2;
                        pc_ld = 1;
                        pc_mux_sel = 1;
                    end
                    
                    // Interrupts
                    // SEI
                    7'b01101_00: begin
                        i_set = 1;
                    end
                    // CLI
                    7'b01101_01: begin
                        i_clr = 1;
                    end
                    // RETID
                    7'b0110110: begin
                        pc_ld = 1;
                        pc_mux_sel = 1;
                        sp_incr = 1;
                        scr_addr_sel = 2;
                        i_clr = 1;
                        flg_ld_sel = 1;
                        flg_z_ld = 1;
                        flg_c_ld = 1;
                    end
                    // RETIE
                    7'b01101_11: begin
                        pc_ld = 1;
                        pc_mux_sel = 1;
                        
                        sp_incr = 1;
                        scr_addr_sel = 2;
                        i_set = 1;
                        
                        flg_ld_sel = 1;
                        flg_z_ld = 1;
                        flg_c_ld = 1;
                    end
                    
                    default: begin
                        $display("ERROR: DEFAULT --> DIDN'T WRITE THIS OPCODE: %b", opcode);
                    end
                endcase
            end
        endcase
    
    end
    
endmodule
