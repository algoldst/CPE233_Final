

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || ;Kadin Stephens CPE 233 Peripheral Assignment One/Example Use Code
(0002)                            || 
(0003)                       130  || .EQU OUT_PORT = 0x82
(0004)                       255  || .EQU OUTloopLength = 0xFF
(0005)                       255  || .EQU MIDloopLength = 0xFF
(0006)                       255  || .EQU INloopLength = 0xFF
(0007)                            || 
(0008)                            || .CSEG
(0009)                       001  || .ORG 0x01
(0010)                            || 
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08008  0x100  ||              BRN     0x01        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0011)  CS-0x001  0x36001  0x001  || Start:		MOV R0,	0x01
(0012)                            || 			
(0013)  CS-0x002  0x34082         || 			OUT R0, OUT_PORT ;Plays note C
(0014)  CS-0x003  0x08049         || 			CALL playNoteDelay
(0015)  CS-0x004  0x08049         || 			CALL playNoteDelay
(0016)  CS-0x005  0x08049         || 			CALL playNoteDelay
(0017)  CS-0x006  0x36000         || 			MOV R0, 0x00
(0018)  CS-0x007  0x34082         || 			OUT R0, OUT_PORT ; Stops playing
(0019)  CS-0x008  0x08008         || 			BRN  Start
(0020)                            || 			
(0021)                     0x009  || playNoteDelay:
(0022)  CS-0x009  0x361FF         ||             MOV  R1, OUTloopLength
(0023)                     0x00A  || delayOUTER:
(0024)  CS-0x00A  0x362FF         ||             MOV  R2, MIDloopLength
(0025)                     0x00B  || delayMIDDLE:
(0026)  CS-0x00B  0x363FF         ||             MOV  R3, INloopLength
(0027)                     0x00C  || delayINNER:
(0028)  CS-0x00C  0x2C301         ||             SUB  R3, 0x01
(0029)  CS-0x00D  0x08063         ||             BRNE delayINNER
(0030)  CS-0x00E  0x2C201         ||             SUB  R2, 0x01
(0031)  CS-0x00F  0x0805B         ||             BRNE delayMIDDLE
(0032)  CS-0x010  0x2C101         ||             SUB  R1, 0x01
(0033)  CS-0x011  0x08053         ||             BRNE delayOUTER
(0034)  CS-0x012  0x18002         ||             RET
(0035)                            || 			
(0036)                            || 			
(0037)  CS-0x013  0x08008         || 			BRN start
(0038)                            || 			
(0039)                            || 			

(0040)                            || 			






Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
DELAYINNER     0x00C   (0027)  ||  0029 
DELAYMIDDLE    0x00B   (0025)  ||  0031 
DELAYOUTER     0x00A   (0023)  ||  0033 
PLAYNOTEDELAY  0x009   (0021)  ||  0014 0015 0016 
START          0x001   (0011)  ||  0019 0037 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
INLOOPLENGTH   0x0FF   (0006)  ||  0026 
MIDLOOPLENGTH  0x0FF   (0005)  ||  0024 
OUTLOOPLENGTH  0x0FF   (0004)  ||  0022 
OUT_PORT       0x082   (0003)  ||  0013 0018 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
