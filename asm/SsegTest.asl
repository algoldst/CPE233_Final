

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


(0001)                            || 
(0002)                       129  || .EQU SSEG = 0x81
(0003)                            || 
(0004)                            || .CSEG
(0005)                       001  || .ORG 0x01
(0006)                            || 
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08008  0x100  ||              BRN     0x01        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0007)  CS-0x001  0x36C01         ||             MOV  R12, 0x01
(0008)                     0x002  || start:
(0009)  CS-0x002  0x34C81         ||             OUT  R12, SSEG
(0010)  CS-0x003  0x08031         ||             CALL delay
(0011)  CS-0x004  0x28C01         ||             ADD  R12, 0x01
(0012)  CS-0x005  0x08010         ||             BRN  start
(0013)                            || 
(0014)                            || 
(0015)                            || 
(0016)                     0x006  || delay:
(0017)  CS-0x006  0x36101         ||             MOV  R1, 0x01
(0018)                     0x007  || delayOUTER:
(0019)  CS-0x007  0x36201         ||             MOV  R2, 0x01
(0020)                     0x008  || delayMIDDLE:
(0021)  CS-0x008  0x36301         ||             MOV  R3, 0x01
(0022)                     0x009  || delayINNER:
(0023)  CS-0x009  0x2C301         ||             SUB  R3, 0x01
(0024)  CS-0x00A  0x0804B         ||             BRNE delayINNER
(0025)  CS-0x00B  0x2C201         ||             SUB  R2, 0x01
(0026)  CS-0x00C  0x08043         ||             BRNE delayMIDDLE
(0027)  CS-0x00D  0x2C101         ||             SUB  R1, 0x01
(0028)  CS-0x00E  0x0803B         ||             BRNE delayOUTER
(0029)  CS-0x00F  0x18002         ||             RET





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
DELAY          0x006   (0016)  ||  0010 
DELAYINNER     0x009   (0022)  ||  0024 
DELAYMIDDLE    0x008   (0020)  ||  0026 
DELAYOUTER     0x007   (0018)  ||  0028 
START          0x002   (0008)  ||  0012 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
SSEG           0x081   (0002)  ||  0009 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
