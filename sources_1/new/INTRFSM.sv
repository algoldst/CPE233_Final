`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2019 02:03:29 PM
// Design Name: 
// Module Name: KeyFSM
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


module INTRFSM(
    input CLK,
    input press,
    output logic interrupt = 0
    );
    
    typedef enum {ST_INIT, ST_INTR1, ST_INTR2, ST_INTR3, ST_INTR4, 
                    ST_INTR5, ST_INTR6, ST_DONE} STATE;
        STATE NS, PS = ST_INIT;
            
    always_ff @ (posedge CLK)
        begin
                PS <= NS;
        end
        
    always_comb
        begin
               
        interrupt = 0;
        
            case(PS)
                ST_INIT: begin
                    interrupt = 0;
                    begin
                    if (press == 1)
                        begin
                        NS = ST_INTR1;
                        end
                    else
                        begin
                        NS = ST_INIT;
                        end
                    end
                end
                
                ST_INTR1: begin
                    interrupt = 1;
                    NS = ST_INTR2;
                end                    
                    
                ST_INTR2: begin
                    interrupt = 1;                   
                    NS = ST_INTR3;
                end
                
                ST_INTR3: begin
                    interrupt = 1;
                    NS = ST_INTR4;
                end
                
                ST_INTR4: begin
                    interrupt = 1;
                    NS = ST_INTR5;
                end
                
                ST_INTR5: begin
                    interrupt  = 1;
                    NS = ST_INTR6;
                end
                
                ST_INTR6: begin
                    interrupt = 1;
                    NS = ST_DONE;
                end
                
                ST_DONE: begin
                    interrupt = 0;
                    begin
                    if (press == 1)
                        begin
                        NS = ST_DONE;
                        end
                    else
                        begin
                        NS = ST_INIT;
                        end
                    end
                end                
                default:
                begin
                NS = ST_INIT;
                interrupt = 0;
                end
            endcase
         end     
endmodule