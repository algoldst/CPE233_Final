`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2019 12:52:37 PM
// Design Name: 
// Module Name: MCU
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


module MCU(
    input clk, interrupt, reset,
    input [7:0] in_port,
    output io_strb, 
    output [7:0] out_port, port_id
    );
    
    logic [9:0] t_scrOut, t_pc_count;
    logic [1:0] t_pc_mux_sel, t_rf_wr_sel;
    logic [3:0] t_alu_sel;
    logic t_pc_ld, t_pc_inc, t_rst, t_rf_wr, t_aluC, t_aluZ,
             t_alu_opy_sel,
            t_flg_c_set,t_flg_c_clr,t_flg_c_ld,t_flg_z_ld,t_flg_ld_sel,t_flg_shad_ld,t_c_flag,t_z_flag,
            t_interruptAnd
            ;
    logic [17:0] t_ir;
    logic [7:0] t_rrMux, t_alu, t_rrXOut, t_rrYOut, t_aluMux;
    
    logic t_sp_ld, t_sp_incr, t_sp_decr;
    logic [7:0] t_spOut;
    
    assign out_port = t_rrXOut;
    assign port_id = t_ir[7:0];
    
    logic t_scr_data_sel;
    logic [9:0] t_scrIn;
    
    logic [1:0] t_scr_addr_sel;
    logic [7:0] t_scrAddr;
    logic t_scr_we;
    
    logic t_i_set, t_i_clr, t_iOut;
    
    ProgCounter pc( .clk(clk), .muxPort0(t_ir[12:3]), .muxPort1(t_scrOut), .muxPort2(10'h3FF), .muxPort3('0),
                    .mux_sel(t_pc_mux_sel), .ld(t_pc_ld), .inc(t_pc_inc), .rst(t_rst), 
                    .pc_count(t_pc_count) );
    
    ProgRom pr( .PROG_CLK(clk), .PROG_ADDR(t_pc_count), .PROG_IR(t_ir) );
    
    RegRam rr( .clk(clk), .dIn(t_rrMux), .adrX(t_ir[12:8]), .adrY(t_ir[7:3]),
                .rf_wr(t_rf_wr), .dX_out(t_rrXOut), .dY_out(t_rrYOut) );
    Mux4_1 #(8) rrMux( .port0(t_alu), .port1(t_scrOut), .port2(t_spOut), .port3(in_port), 
                        .sel(t_rf_wr_sel), .dOut(t_rrMux) );
    
    ALU alu( .sel(t_alu_sel), .a(t_rrXOut), .b(t_aluMux), .cIn(t_c_flag), .result(t_alu),
             .c(t_aluC), .z(t_aluZ) );
    Mux2_1 #(8) aluMux( .port0(t_rrYOut), .port1(t_ir[7:0]), .sel(t_alu_opy_sel), .dOut(t_aluMux) );
                 
    Flags flags( .clk(clk), .c_in(t_aluC), .z_in(t_aluZ), .flg_c_set(t_flg_c_set), .flg_c_clr(t_flg_c_clr), .flg_c_ld(t_flg_c_ld),
              .flg_z_ld(t_flg_z_ld), .flg_ld_sel(t_flg_ld_sel), .flg_shad_ld(t_flg_shad_ld),
              .c_out(t_c_flag), .z_out(t_z_flag) );
    
    CUnit cu( .clk(clk), .c(t_c_flag), .z(t_z_flag), .interrupt(t_interruptAnd), .reset(reset),
           .opcode_hi5(t_ir[17:13]), .opcode_lo2(t_ir[1:0]),
           .rf_wr(t_rf_wr), .rf_wr_sel(t_rf_wr_sel), 
           .sp_ld(t_sp_ld), .sp_incr(t_sp_incr), .sp_decr(t_sp_decr),
           .scr_we(t_scr_we), .scr_data_sel(t_scr_data_sel), .scr_addr_sel(t_scr_addr_sel),
           .pc_ld(t_pc_ld), .pc_inc(t_pc_inc), .pc_mux_sel(t_pc_mux_sel),
           .alu_opy_sel(t_alu_opy_sel), .alu_sel(t_alu_sel),
           .flg_c_set(t_flg_c_set), .flg_c_clr(t_flg_c_clr), .flg_c_ld(t_flg_c_ld),
           .flg_z_ld(t_flg_z_ld), .flg_ld_sel(t_flg_ld_sel), .flg_shad_ld(t_flg_shad_ld),
           .io_strb(io_strb),
           .i_set(t_i_set), .i_clr(t_i_clr),
           .rst(t_rst) );
             
    StackPtr stackP( .clk(clk), .dIn(t_rrXOut), .rst(t_rst), .ld(t_sp_ld), 
                  .incr(t_sp_incr), .decr(t_sp_decr), .dOut(t_spOut));
      
    Mux2_1 #(10) scrDataMux( .port0({2'b0,t_rrXOut}), .port1(t_pc_count), 
                             .sel(t_scr_data_sel), .dOut(t_scrIn));
    Mux4_1 #(8) scrAddrMux( .port0(t_rrYOut), .port1(t_ir[7:0]), .port2(t_spOut), 
                            .port3(t_spOut - 1), .sel(t_scr_addr_sel), .dOut(t_scrAddr));
    ScrRam scratch( .clk(clk), .dIn(t_scrIn), .scr_addr(t_scrAddr), .scr_wr(t_scr_we), 
                    .dOut(t_scrOut));

    FlagReg interruptReg( .clk(clk), .set(t_i_set), .reset(t_i_clr), .dOut(t_iOut) );
    
    assign t_interruptAnd = interrupt & t_iOut;
    
              
endmodule
