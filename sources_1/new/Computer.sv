`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 10:33:11 AM
// Design Name: 
// Module Name: Computer
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


module Computer(
    input INTERRUPTC, RESET, CLK, 
    input [7:0] IN_PORT,
    output IO_STRB, 
    output [7:0] OUT_PORT, PORT_ID
    );
          
        logic i_set_s, i_clr_s, pc_ld_s, pc_inc_s, alu_opy_sel_s, rf_wr_s, sp_ld_s, sp_incr_s, sp_decr_s, scr_we_s, scr_data_sel_s, 
                flg_c_set_s, flg_c_clr_s, flg_c_ld_s, flg_z_ld_s, flg_ld_sel_s, flg_shad_ld_s, c_flg_s, z_flg_s, c_in_s, z_in_s, rst_s;
        
        logic t14, t15;
        logic [1:0] pc_mux_sel_s, rf_wr_sel_s, scr_addr_sel_s;
        logic [3:0] alu_sel_s;
        logic [7:0] t5, t6, t7, t8, t9, t11, t13;           
        logic [9:0] t3, t4, t10, t12;        
        logic [17:0] t2;
        
        assign t15 = t14 & INTERRUPTC;
        
        //Interrupt inst1 (.I_SET(i_set_s), .I_CLR(i_clr_s), .CLK(CLK), .OUT(t14));
                
        ControlUnit inst2 (.C(c_flg_s), .Z(z_flg_s), .INTR(t15), .RESET(RESET), .CLK(CLK), 
                .OPCODE_HI_5(t2[17:13]), .OPCODE_LOW_2(t2[1:0]), 
                .I_SET(i_set_s), .I_CLR(i_clr_s), .PC_LD(pc_ld_s), .PC_INC(pc_inc_s), 
                .PC_MUX_SEL(pc_mux_sel_s), .ALU_OPY_SEL(alu_opy_sel_s), 
                .ALU_SEL(alu_sel_s), .RF_WR(rf_wr_s), .RF_WR_SEL(rf_wr_sel_s),
                .SP_LD(sp_ld_s), .SP_INCR(sp_incr_s), .SP_DECR(sp_decr_s), 
                .SCR_WE(scr_we_s), .SCR_ADDR_SEL(scr_addr_sel_s), .SCR_DATA_SEL(scr_data_sel_s),   
                .FLG_C_SET(flg_c_set_s), .FLG_C_CLR(flg_c_clr_s), 
                .FLG_C_LD(flg_c_ld_s), .FLG_Z_LD(flg_z_ld_s), 
                .FLG_LD_SEL(flg_ld_sel_s), .FLG_SHAD_LD(flg_shad_ld_s), .RST(rst_s),  
                .IO_STRB(IO_STRB)); 
        
        ProgRom inst3 (.PROG_CLK(CLK), .PROG_ADDR(t3), .PROG_IR(t2));
        
        ProgramCounter inst4 (.DIN(t4), .RST(rst_s), .PC_LD(pc_ld_s), .PC_INC(pc_inc_s),
                .CLK(CLK), .PC_COUNT(t3));
        
        PC_Mux inst5 (.FROM_IMMED(t2[12:3]), .FROM_STACK(t10), .PC_MUX_SEL(pc_mux_sel_s), .DIN(t4)); 
        
        ALU inst6 (.CIN(c_flg_s), .SEL(alu_sel_s), .A(t5), .B(t7), 
                .RESULT(t9), .Cflag(c_in_s), .Zflag(z_in_s));
                
        ALU_Mux inst7 (.zero(t6), .one(t2[7:0]), .ALU_OPY_SEL(alu_opy_sel_s), 
                .OUT(t7));
        
        REG_File inst8 (.DIN(t8), .RF_WR(rf_wr_s), .ADRX(t2[12:8]), .ADRY(t2[7:3]), 
                .CLK(CLK), .DX_OUT(t5), .DY_OUT(t6));
                
        REG_File_Mux inst9 (.zero(t9), .one(t10), .two(t11), .three(IN_PORT), 
                .RF_WR_SEL(rf_wr_sel_s), .OUT(t8));
        
        Flags inst10 (.clk(CLK), .c_in(c_in_s), .z_in(z_in_s), 
                .flg_c_set(flg_c_set_s), .flg_c_clr(flg_c_clr_s), 
                .flg_c_ld(flg_c_ld_s), .flg_z_ld(flg_z_ld_s),
                .flg_ld_sel(flg_ld_sel_s), .flg_shad_ld(flg_shad_ld_s), 
                .c_flag(c_flg_s), .z_flag(z_flg_s), .intr_set(i_set_s), .intr_clr(i_clr_s), .intr_out(t14));
                
        StackPointer inst11 (.RST(rst_s), .LD(sp_ld_s), .INCR(sp_incr_s), 
                .DECR(sp_decr_s), .DATA_IN(t5), .CLK(CLK), .DATA_OUT(t11));
                
        Scratch_RAM inst12 (.DATA_IN(t12), .SCR_WE(scr_we_s), .SCR_ADDR(t13), .CLK(CLK),
                .DATA_OUT(t10));
                
        SCR_Mux inst13 (.zero(t6), .one(t2[7:0]), .two(t11), .three({t11}-8'b00000001), .SCR_ADDR_SEL(scr_addr_sel_s), .OUT(t13));
        
        SCR_Mux_2 inst14 (.zero(t5), .one(t3), .SCR_DATA_SEL(scr_data_sel_s), .OUT(t12));                 
                
                assign PORT_ID = t2[7:0];
                assign OUT_PORT = t5;

endmodule