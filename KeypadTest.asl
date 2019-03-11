

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
(0002)                       128  || .EQU KEY_PORT = 0x80
(0003)                       129  || .EQU SSEG = 0x81
(0004)                            || .CSEG
(0005)                       001  || .ORG 0x01
(0006)                            || 
(0007)                     0x001  || start:
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08008  0x100  ||              BRN     0x01        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0008)  CS-0x001  0x1A000         ||             SEI
(0009)                     0x002  || loops:
(0010)  CS-0x002  0x08010         ||             BRN  loops
(0011)                            || 
(0012)                     0x003  || ISR:
(0013)  CS-0x003  0x32180         ||             IN   R1, KEY_PORT
(0014)  CS-0x004  0x34181         ||             OUT  R1, SSEG
(0015)  CS-0x005  0x1A002         ||             RETID
(0016)                            || 
(0017)                       1023  || .ORG 0x3FF
(0018)  CS-0x3FF  0x08018         ||             BRN  ISR





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
ISR            0x003   (0012)  ||  0018 
LOOPS          0x002   (0009)  ||  0010 
START          0x001   (0007)  ||  


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
KEY_PORT       0x080   (0002)  ||  0013 
SSEG           0x081   (0003)  ||  0014 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
