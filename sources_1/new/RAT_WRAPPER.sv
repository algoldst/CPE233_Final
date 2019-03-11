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
/////////////////////////////////////////////////////////////////////////

module RAT_WRAPPER(

    input CLK,
    input C, A, E,
    input BTNC, BTNL,
    input [7:0] SWITCHES,
    output logic B, G, F, D,
    output [3:0] ANODES,
    output [7:0] CATHODES,
    output JA
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam SWITCHES_ID = 8'h20;
    localparam KEYPAD_ID   = 8'h80;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam LEDS_ID      = 8'h40;
    localparam SevenSeg     = 8'h81;
    localparam SPEAKER_ID   = 8'h82;    
       
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] s_output_port;
    logic [7:0] s_port_id;
    logic s_load;
    logic s_interrupt;
    logic s_reset;
    logic s_clk_50 = 1'b0;     // 50 MHz clock
    //logic DB_BTN;
    
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   s_input_port;
    logic [7:0]   r_leds = 8'h00;
    logic [15:0]  s_seg = 8'h00;
    logic [15:0]  speaker_o = 8'h00;    
    logic [3:0]   KEYPAD;    

    // Declare RAT_CPU ///////////////////////////////////////////////////////
    Computer inst1 (.IN_PORT(s_input_port), .OUT_PORT(s_output_port),
                .PORT_ID(s_port_id), .IO_STRB(s_load), .RESET(s_reset),
                .INTERRUPTC(s_interrupt), .CLK(s_clk_50));
    
    SevSegDisp inst2 (.CLK(CLK), .MODE(1'b0), .DATA_IN(s_seg), 
                .CATHODES(CATHODES), .ANODES(ANODES));
                
    //debounce_one_shot inst3 (.CLK(CLK), .BTN(BTNL), .DB_BTN(s_interrupt));
    
    KeyPadDriver inst4 (.CLK(CLK), .C(C), .A(A), .E(E), .B(B), .G(G), 
                .F(F), .D(D), .interrupt(s_interrupt), .data(KEYPAD));
                
    FreqSelectorTopLevel inst5 (.CLK(CLK), .SWITCHES(speaker_o), .JA(JA));
    
    // Clock Divider to create 50 MHz Clock //////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end
    
     
    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (s_port_id == SWITCHES_ID)
            s_input_port = SWITCHES;
        else if (s_port_id == KEYPAD_ID)
            s_input_port = KEYPAD; 
        else
            s_input_port = 8'h00;
    end
   
    // MUX for updating output registers /////////////////////////////////////
    // Register updates depend on rising clock edge and asserted load signal
    always_ff @ (posedge CLK) begin
        if (s_load == 1'b1) begin
            if (s_port_id == LEDS_ID)
                r_leds <= s_output_port;
            else if (s_port_id == SevenSeg)
                s_seg <= s_output_port;
            else if (s_port_id == SPEAKER_ID)
                speaker_o <= s_output_port;          
            end
        end
     
    // Connect Signals ///////////////////////////////////////////////////////
    assign s_reset = BTNC;
    //assign s_interrupt = BTNL;  // no interrupt used yet
     
    // Output Assignments ////////////////////////////////////////////////////
    //assign LEDS = r_leds;
    //assign s_interrupt = DB_BTN;
   
    endmodule