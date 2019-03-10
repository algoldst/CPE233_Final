`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2019 05:09:56 PM
// Design Name: 
// Module Name: REG_FileSim
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


module REG_FileSim(
    );
          logic [7:0] DIN = 0;
          logic [4:0] ADRX = 0;
          logic [4:0] ADRY = 0;
          logic RF_WR = 0;
          logic CLK;
          logic [7:0] DX_OUT = 0;
          logic [7:0] DY_OUT = 0;
          REG_File inst(.*);
            
             always 
               begin
               CLK = 0; #5;
               CLK = 1; #5;
           end

    initial begin
    for (int i =0; i < 33; i++)
    begin
        #10
        DIN = 'hFD;
        RF_WR = 1;
        ADRX = i;   
     end
    
    for (int i =0; i < 33; i++)
    begin
        #10
        DIN = 'hFC;
        RF_WR = 0;
        ADRX = i;     
     end
     
    for (int i =0; i < 33; i++)
    begin
     #10
     DIN = 'h35;
     RF_WR = 1;
     ADRY = i;     
    end  
    
    for (int i =0; i < 33; i++)
    begin
     #10
     DIN = 'hFE;
     RF_WR = 0;
     ADRY = i;     
    end
        
      end //initial begin
    endmodule
