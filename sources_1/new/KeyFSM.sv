`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2019 11:53:33 AM
// Design Name: 
// Module Name: Key_FSM
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


module KeyFSM(
    input CLK, 
    input C, A, E,
    
    output logic press,
    output logic [3:0] data,
    output logic B, G, F, D
    );
    
    typedef enum{ST_B, ST_G, ST_F, ST_D} state;
        state NS, PS = ST_B;
        
    always_ff @ (posedge CLK)
            begin  
                PS <= NS;
            end
        
    always_comb 
    begin
        B = 0;
        G = 0;
        F = 0;
        D = 0; 
        press = 0;        
        
        case (PS)
            ST_B: 
            begin                
                B = 1;
                NS = PS;
                if (C ==  1)
                begin
                    data = 1;
                    press = 1;                     
                end
                
                else if (A == 1)
                begin
                    data = 2;
                    press = 1;                    
                end
                
                else if (E == 1) 
                begin 
                    data = 3;
                    press = 1;                    
                end 
                
                else 
                begin
                    data = 13;
                    press = 0;
                    NS = ST_G;
                end               
            end
            
            ST_G:
            begin 
                G = 1;
                NS = PS;                
                if (C ==  1)
                begin
                    data = 4;
                    press = 1;                     
                end
                            
                else if (A == 1)
                begin
                    data = 5;
                    press = 1;                    
                end
                            
                else if (E == 1) 
                begin 
                    data = 6;
                    press = 1;                    
                end 
                            
                else 
                begin
                    data = 13;
                    press = 0;
                    NS = ST_F;
                end
            end
            
            ST_F:
            begin
                F = 1;
                NS = PS;                
                if (C ==  1)
                begin
                    data = 7;
                    press = 1;                     
                end
                            
                else if (A == 1)
                begin
                    data = 8;
                    press = 1;                    
                end
                            
                else if (E == 1) 
                begin 
                    data = 9;
                    press = 1;                    
                end 
                            
                else 
                begin
                    data = 13;
                    press = 0;
                    NS = ST_D;
                end
            end
            
            ST_D:
            begin
                D = 1;
                NS = PS;
                
                if (C ==  1)
                begin
                    data = 10;
                    press = 1;                     
                end
                            
                else if (A == 1)
                begin
                    data = 0;
                    press = 1;                    
                end
                            
                else if (E == 1) 
                begin 
                    data = 11;
                    press = 1;                    
                end 
                            
                else 
                begin
                    data = 13;
                    press = 0;
                    NS = ST_B;
                end
            end
            
            default NS = ST_B;
            
        endcase     
    end 
endmodule