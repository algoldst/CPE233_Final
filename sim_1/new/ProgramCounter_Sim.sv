`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2019 02:42:24 PM
// Design Name: 
// Module Name: ProgramCounter_Sim
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


module ProgramCounter_Sim(
    );
    
    logic [9:0] FROM_IMMED;
    logic [9:0] FROM_STACK;
    logic [1:0] PC_MUX_SEL;
    logic PC_LD;
    logic PC_INC;
    logic RST;
    logic CLK;
    logic [9:0] PC_COUNT;
    
    AssignmentTwoTopLevel inst(.*);
            always
    begin
    CLK = 1; #5;
    CLK = 0; #5;
    end
    
    initial 
    begin
    //////Load three possible values
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 0;
    PC_LD = 1;
    PC_INC = 0;
    RST = 0;
    #20
    
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 1;
    PC_LD = 1;
    PC_INC = 0;
    RST = 0;  
    #20
    
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 2;
    PC_LD = 1;
    PC_INC = 0;
    RST = 0;
    #20 
    
    /////Resets
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 0;
    PC_LD = 0;
    PC_INC = 0;
    RST = 1;
    #20
    
    ////Loads in value, then increments
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 2;
    PC_LD = 1;
    PC_INC = 0;
    RST = 0;
    #20
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 2;
    PC_LD = 0;
    PC_INC = 1;
    RST = 0;
    #20
    
    ///Do "nothing"
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 0;
    PC_LD = 0;
    PC_INC = 0;
    RST = 0;
    #20
    
    ///Will Load, even if PC_INC is active high
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 1;
    PC_LD = 1;
    PC_INC = 1;
    RST = 0;
    
    ///Increments
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 2;
    PC_LD = 0;
    PC_INC = 1;
    RST = 0;
    #20
    
    //////Resets whenLD and incrementing are functioning
    FROM_IMMED = 10'h003;
    FROM_STACK = 10'h0B5;
    PC_MUX_SEL = 0;
    PC_LD = 1;
    PC_INC = 1;
    RST = 1;
    
    end
    endmodule