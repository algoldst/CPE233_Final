`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Alex Goldstein
//
// Create Date: 01/24/2019 09:11:40 AM
// Design Name:
// Module Name: RegRam_Sim
// Project Name: CPE 233 Lab Rat 3.1
// Target Devices:
// Tool Versions:
// Description: 32 x 8-bit register memory
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module RegRam_tb(
    );

    // Init Testbench
    logic [7:0] dIn = 0;            // 8-bit register
    logic [4:0] adrX = 0, adrY = 0; // 32 registers
    logic rf_wr = 0, clk = 0;
    logic [7:0] dX_out = 0, dY_out = 0;
    RegRam RegRam_tb (.*);


    // Simulate clk signal
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end


    // Test!
    initial begin
        #10;
        dIn <= 8'hAA; // Give dIn a non-zero value so we can verify when it is read


        // Loop through to show all addresses are zero at init.
        for(int i = 0; i < 32; i++) begin
            adrX <= i;
            adrY <= i;
            #10;
        end
        // Verify: dX_out, dY_out = 0.


        // Loop to set all addresses
        for(int i = 0; i < 32; i++) begin
            rf_wr <= !rf_wr; // enable writing (change to rf_wr <= #5 !rf_wr; to see that it uses the previous value if enabled on a rising clk edge)
            dIn <= i*2; // writing 2*[address] to each adrX reg

            adrX <= i;
            adrY <= i;

            #10;
        end
        // Verify: dX_out = 2*[address] for all rf_wr=1


        // Loop to check all addresses
        for(int i = 0; i < 32; i++) begin
            rf_wr <= 0; // disable writing
            dIn <= 0;  // this zero should not set any reg values

            adrX <= i;
            adrY <= i;

            #10;
        end
        // Verify: dX_out = 2*[address]  <-- no change from previous loop status


    end


endmodule
