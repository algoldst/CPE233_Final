`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Paul Hummel
//
// Create Date: 06/28/2018 05:21:01 AM
// Module Name: RAT_WRAPPER
// Target Devices: RAT MCU on Basys3
// Description: Basic RAT_WRAPPER
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////

module Rat_Wrapper(
    input CLK,
    input BTNC,
    input BTNL,
    input [7:0] SWITCHES,
    input A, C, E,
    output B, D, F, G,
    output [7:0] LEDS,
    output [7:0] SSEG, // SSEG segments
    output [3:0] DISP_EN // SSEG on/off
    , output interruptPMOD, 
    output [2:0] statePMOD
    //, output debouncePmod, interruptPmod // for debugging / seeing interrupt on scope
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_ID = 8'h20;
    localparam KEYPAD_ID   = 8'h80;
    logic [3:0]   r_keypad;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam LEDS_ID      = 8'h40;
    localparam SSEG_ID      = 8'h81;
    localparam SPEAKER_ID   = 8'h82;
       
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] s_output_port;
    logic [7:0] s_port_id;
    logic s_load;
    logic s_interrupt;
    logic s_reset;
    logic s_clk_50 = 1'b0;     // 50 MHz clock
    logic btn_debounce;
    
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   s_input_port;
    logic [7:0]   r_leds = 8'h00;
    logic [15:0]   r_sseg = 8'h00;
    logic [5:0]   r_speaker = 8'h00;


    // Declare RAT_CPU ///////////////////////////////////////////////////////
    MCU MCU(.in_port(s_input_port), .out_port(s_output_port),
                .port_id(s_port_id), .io_strb(s_load), .reset(s_reset),
                .interrupt(s_interrupt /*BTNL*/), .clk(s_clk_50)); //BTNL for bypassing Debounce (do this in Sim!)
    
    // Clock Divider to create 50 MHz Clock //////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end
    
     
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (s_port_id == SWITCHES_ID)
            s_input_port = SWITCHES;
        else if (s_port_id == KEYPAD_ID)
            s_input_port = r_keypad;
        else
            s_input_port = 8'h00;
    end
   
    // MUX for updating output registers /////////////////////////////////////
    // Register updates depend on rising clock edge and asserted load signal
    always_ff @ (posedge CLK) begin
        if (s_load == 1'b1) begin
            if (s_port_id == LEDS_ID)
                r_leds <= s_output_port;
            else if (s_port_id == SSEG_ID)
                r_sseg <= s_output_port;
            else if (s_port_id == SPEAKER_ID)
                r_speaker <= s_output_port;
        end
    end
     
    // Connect Signals ///////////////////////////////////////////////////////
    assign s_reset = BTNC;
    //assign s_interrupt = 1'b0;  // no interrupt used yet
     
    // Output Assignments ////////////////////////////////////////////////////
    //assign LEDS = r_leds;
    assign LEDS = r_keypad;
    
    // SSEG Display    ////////////////////////////////////////////////////
    SevSegDisp sseg(.CLK(CLK), .MODE(1), .DATA_IN(r_sseg), .CATHODES(SSEG), 
                    .ANODES(DISP_EN) );  
    
    KeyPadDriver keypad_driver( .clk(CLK), .C(C), .A(A), .E(E), .B(B), .G(G), 
                                .F(F), .D(D), .interrupt(s_interrupt), .data(r_keypad), .statePMOD(statePMOD) );
    assign interruptPMOD = s_interrupt;
    // Debounce Circuit
    //logic t_btnL = BTNL;                  // for debug
    //Debounce debounce(.CLK(s_clk_50), .BTN(BTNL), .DB_BTN(s_interrupt));
    
    //assign interruptPmod = t_btnL;        // for debug
    //assign debouncePmod = s_interrupt;    // for debug
    endmodule
