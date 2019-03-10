`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2019 04:47:23 PM
// Design Name: 
// Module Name: ScratchRAM_Sim
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


module ScratchRAM_Sim(
    );
    
          logic [9:0] DATA_IN = 0;
          logic [7:0] SCR_ADDR = 0;
          logic SCR_WE = 0;
          logic CLK;
          logic [9:0] DATA_OUT = 0;
          Scratch_RAM inst(.*);
        
             always 
               begin
               CLK = 0; #5;
               CLK = 1; #5;
           end
  
    initial 
    begin
    for (int i =0; i < 256; i++)
    begin
        #10
        DATA_IN = 'hFC;
        SCR_WE = 1;
        SCR_ADDR = i;   
     end
    
    for (int i =0; i < 256; i++)
    begin
        #10
        DATA_IN = 'hFD;
        SCR_WE = 0;
        SCR_ADDR = i;     
     end    
      end 
    endmodule
