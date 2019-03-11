`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Alex Goldstein
//
// Create Date: 01/24/2019 10:11:09 AM
// Design Name:
// Module Name: ScrRam_tb
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


module ScrRam_tb(
    );


    // Initialize testbench
    logic [9:0] dIn = 0;         // 10-bit register data
    logic [7:0] scr_addr = 0;    //256 registers
    logic scr_wr = 0, clk = 0;
    logic [9:0] dOut = 0;
    ScrRam ScrRam_tb (.*);


    // Simulate clk signal
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end


    // Test
    initial begin
        #10;
        dIn <= 8'hA1; // Give dIn a non-zero value so we can verify when it is read


        // Loop through to show all addresses are zero at init.
        for(int i = 0; i < 256; i++) begin
            scr_addr <= i;
            #10;
        end
        // Verify: dOut = 0 for all addresses


        // Loop to set all addresses
        for(int i = 0; i < 256; i++) begin
            scr_wr <= !scr_wr; // enable writing (change to rf_wr <= #5 !rf_wr; to see that it uses the previous value if enabled on a rising clk edge)
            dIn <= i*2; // writing 2*[address] to each adrX reg

            scr_addr <= i;

            #10;
        end
        // Verify: dOut = 2*[address] for all scr_wr=1


        // Loop to check all addresses
        for(int i = 0; i < 32; i++) begin
            scr_wr <= 0; // disable writing
            dIn <= 0;  // this zero should not set any reg values

            scr_addr <= i;

            #10;
        end
        // Verify: dOut = 2*[address]  <-- no change from previous loop status


    end

endmodule
