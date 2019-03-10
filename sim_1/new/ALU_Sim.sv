`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:
// Create Date: 01/31/2019 01:38:01 PM
// Module Name: ALUsim
// Description:
//////////////////////////////////////////////////////////////////////////////////

module ALU_Sim();
	logic [3:0] SEL;
	logic [7:0] A, B;
	logic CIN;
	logic [7:0] RESULT;
	logic Cflag;
	logic Zflag;
	
	ALU ALU_inst(.*);
      	
  initial
  begin
  	//ADD
  	SEL = 4'b0000;
  	A = 8'hAA;
  	B = 8'hAA;
  	CIN = 0;
  	#10;
  	
  	SEL = 4'b0000;
  	A = 8'h0A;
  	B = 8'hA0;
  	CIN = 1;
  	#10;
  	
  	SEL = 4'b0000;
  	A = 8'hFF;
  	B = 8'h01;
  	CIN = 1;
  	#10;
  	
  	//ADDC
  	SEL = 4'b0001;
  	A = 8'hC8;
  	B = 8'h36;
  	CIN = 1;
  	#10;
  	
  	SEL = 4'b0001;
  	A = 8'hC8;
  	B = 8'h64;
  	CIN = 1;
  	#10;
  	
  	//SUB
  	SEL = 4'b0010;
  	A = 8'hC8;
  	B = 8'h64;
  	CIN = 0;
  	#10;
  	
  	SEL = 4'b0010;
  	A = 8'hC8;
  	B = 8'h64;
  	CIN = 1;
  	#10;
              	
  	SEL = 4'b0010;
  	A = 8'h64;
  	B = 8'hC8;
  	CIN = 0;
  	#10;
  	
  	//SUBC
  	SEL = 4'b0011;
  	A = 8'hC8;
  	B = 8'h64;
  	CIN = 0;
  	#10;
  	
  	SEL = 4'b0011;
  	A = 8'hC8;
  	B = 8'h64;
  	CIN = 1;
  	#10;
              	
  	SEL = 4'b0011;
  	A = 8'h64;
  	B = 8'hC8;
  	CIN = 0;
  	#10;
  	
  	SEL = 4'b0011;
  	A = 8'h64;
  	B = 8'hC8;
  	CIN = 1;
  	#10;
  	
  	//CMP
   	SEL = 4'b0100;
   	A = 8'hAA;
   	B = 8'hFF;
   	CIN = 0;
   	#10;
               	
   	SEL = 4'b0100;
   	A = 8'hFF;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	SEL = 4'b0100;
   	A = 8'hAA;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	//AND
   	SEL = 4'b0101;
   	A = 8'hAA;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	SEL = 4'b0101;
   	A = 8'h03;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	//OR
   	SEL = 4'b0110;
   	A = 8'hAA;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	SEL = 4'b0110;
   	A = 8'h03;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	//EXOR
   	SEL = 4'b0111;
   	A = 8'hAA;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	SEL = 4'b0111;
   	A = 8'h03;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	//TEST
   	SEL = 4'b1000;
   	A = 8'hAA;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	SEL = 4'b1000;
   	A = 8'h55;
   	B = 8'hAA;
   	CIN = 0;
   	#10;
   	
   	//LSL
   	SEL = 4'b1001;
   	A = 8'h01;
   	B = 8'h12;
   	CIN = 0;
   	#10;
   	
   	//LSR
   	SEL = 4'b1010;
   	A = 8'h80;
   	B = 8'h33;
   	CIN = 0;
   	#10;
   	
   	SEL = 4'b1010;
   	A = 8'h80;
   	B = 8'h43;
   	CIN = 1;
   	#10;
   	
   	//ROL
   	SEL = 4'b1011;
   	A = 8'h01;
   	B = 8'hAB;
   	CIN = 1;
   	#10;
   	
   	SEL = 4'b1011;
   	A = 8'hAA;
   	B = 8'hF2;
   	CIN = 0;
   	#10;
   	
   	//ROR
   	SEL = 4'b1100;
   	A = 8'h80;
   	B = 8'h3C;
   	CIN = 0;
   	#10;
   	
   	SEL = 4'b1100;
   	A = 8'h80;
   	B = 8'h98;
   	CIN = 1;
   	#10;
   	
   	//ASR
   	SEL = 4'b1101;
   	A = 8'h80;
   	B = 8'h81;
   	CIN = 0;
   	#10;
   	
   	SEL = 4'b1101;
   	A = 8'h40;
   	B = 8'hB2;
   	CIN = 0;
   	#10;
   	
   	//MOV
   	SEL = 4'b1110;
   	A = 8'h00;
   	B = 8'h30;
   	CIN = 0;
   	#10;
   	
   	SEL = 4'b1110;
   	A = 8'h43;
   	B = 8'h00;
   	CIN = 1;
   	#10;
         	
  end
    	
endmodule