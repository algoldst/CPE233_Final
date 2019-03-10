

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
(0002)                            ||                                         ; INPUTS
(0003)                       144  || .EQU SWITCH_PORT_START = 0x90           ; Switches. Port #1,2,3,4,5,6,7,8,....12
(0004)                       156  || .EQU SWITCH_PORT_END = 0x9C             ; Final switch port value (switch 12)
(0005)                       128  || .EQU KEYPAD_PORT = 0x80                 ; Keypad input port
(0006)                            ||                                         ; OUTPUTS
(0007)                       129  || .EQU SSEG_PORT = 0x81                   ; SSEG shows
(0008)                       130  || .EQU SPEAKER_PORT = 0x82
(0009)                            || 
(0010)                       001  || .EQU INloopLength = 0x01
(0011)                       001  || .EQU MIDloopLength = 0x01
(0012)                       001  || .EQU OUTloopLength = 0x01
(0013)                            || 
(0014)                            || .CSEG
(0015)                       001  || .ORG 0x01
(0016)                            || 
(0017)                            || ; REGISTERS USED:
(0018)                            || ; (Rx81-x8C) = Notes to Test
(0019)                            ||     ; 1:C#, 2:D, 3:D#, 4:E, 5:F, 6:F#, 7:G, 8:G#, 9:A, 10:A#, 11:B, 12:C (2nd octave)
(0020)                            || ; R20 = User note guess
(0021)                            || ; R21 = Current Test Note
(0022)                            || ; R22 = Next Test Note
(0023)                            || ; R29 = Interrupt Flag
(0024)                            || ; R30 = User Score
(0025)                            || ; R31 = Function default return register
(0026)                            || 
(0027)                     0x001  || start:
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08008  0x100  ||              BRN     0x01        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0028)  CS-0x001  0x1A001         ||             CLI
(0029)  CS-0x002  0x080B9         || 			CALL setup
(0030)  CS-0x003  0x08020         ||             BRN  practiceLoop
(0031)                     0x004  || practiceLoop:
(0032)  CS-0x004  0x08041         ||             CALL playNote               ; Sets interrupt and begins random # gen
(0033)  CS-0x005  0x08249         ||             CALL checkNote              ; Waits for Interupt and then checks User's Guess
(0034)  CS-0x006  0x08020         ||             BRN  practiceLoop           ; Moves on to next round
(0035)                            || 
(0036)                            ||             ;...
(0037)  CS-0x007  0x082E0         ||             BRN  end
(0038)                            || 
(0039)                     0x008  || playNote:                               ; Assumes R21 holds a value [0,12]
(0040)  CS-0x008  0x35582         ||             OUT  R21, SPEAKER_PORT      ; Play the test note
(0041)  CS-0x009  0x08069         ||             CALL playNoteDelay          ; Wait `loopLength` of time
(0042)  CS-0x00A  0x36100         || 			MOV  R1, 0x00
(0043)  CS-0x00B  0x34182         ||             OUT  R1, SPEAKER_PORT     ; Stop playing the note
(0044)  CS-0x00C  0x18002         ||             RET
(0045)                            || 
(0046)                     0x00D  || playNoteDelay:
(0047)  CS-0x00D  0x36101         ||             MOV  R1, OUTloopLength
(0048)                     0x00E  || delayOUTER:
(0049)  CS-0x00E  0x36201         ||             MOV  R2, MIDloopLength
(0050)                     0x00F  || delayMIDDLE:
(0051)  CS-0x00F  0x36301         ||             MOV  R3, INloopLength
(0052)                     0x010  || delayINNER:
(0053)  CS-0x010  0x2C301         ||             SUB  R3, 0x01
(0054)  CS-0x011  0x08083         ||             BRNE delayINNER
(0055)  CS-0x012  0x2C201         ||             SUB  R2, 0x01
(0056)  CS-0x013  0x0807B         ||             BRNE delayMIDDLE
(0057)  CS-0x014  0x2C101         ||             SUB  R1, 0x01
(0058)  CS-0x015  0x08073         ||             BRNE delayOUTER
(0059)  CS-0x016  0x18002         ||             RET
(0060)                            || 
(0061)                            || 
(0062)                     0x017  || setup:
(0063)  CS-0x017  0x080F1         ||             CALL readSwitches           ; Read which notes to play.
(0064)                            ||                                         ;       1 --> Test player on note
(0065)                            ||                                         ;       0 --> Don't test
(0066)  CS-0x018  0x37E00         ||             MOV  R30, 0x00              ; Set score = 0
(0067)  CS-0x019  0x35E81         ||             OUT  R30, SSEG_PORT         ; Output initial score
(0068)  CS-0x01A  0x37501         ||             MOV  R21, 0x01              ; Set first note to root (C) <-- If adding transpose, do it here.
(0069)  CS-0x01B  0x18002         ||             RET
(0070)                            || 
(0071)                            || ; Set SSEG display value
(0072)  CS-0x01C  0x34181  0x01C  || ssegSet:    OUT  R1, SSEG_PORT
(0073)  CS-0x01D  0x18002         ||             RET
(0074)                            || 
(0075)                            || ; Read in switches to query which notes to test on
(0076)                     0x01E  || readSwitches:
(0077)  CS-0x01E  0x32191         ||             IN   R1, 0x91              
(0078)  CS-0x01F  0x3A181         ||             ST   R1, 0x81               
(0079)  CS-0x020  0x32192         ||             IN   R1, 0x92
(0080)  CS-0x021  0x3A182         ||             ST   R1, 0x82
(0081)  CS-0x022  0x32193         ||             IN   R1, 0x93
(0082)  CS-0x023  0x3A183         ||             ST   R1, 0x83
(0083)  CS-0x024  0x32194         ||             IN   R1, 0x94
(0084)  CS-0x025  0x3A184         ||             ST   R1, 0x84
(0085)  CS-0x026  0x32195         ||             IN   R1, 0x95
(0086)  CS-0x027  0x3A185         ||             ST   R1, 0x85
(0087)  CS-0x028  0x32196         ||             IN   R1, 0x96
(0088)  CS-0x029  0x3A186         ||             ST   R1, 0x86
(0089)  CS-0x02A  0x32197         ||             IN   R1, 0x97
(0090)  CS-0x02B  0x3A187         ||             ST   R1, 0x87
(0091)  CS-0x02C  0x32198         ||             IN   R1, 0x98
(0092)  CS-0x02D  0x3A188         ||             ST   R1, 0x88
(0093)  CS-0x02E  0x32199         ||             IN   R1, 0x99
(0094)  CS-0x02F  0x3A189         ||             ST   R1, 0x89
(0095)  CS-0x030  0x3219A         ||             IN   R1, 0x9A
(0096)  CS-0x031  0x3A18A         ||             ST   R1, 0x8A
(0097)  CS-0x032  0x3219B         ||             IN   R1, 0x9B
(0098)  CS-0x033  0x3A18B         ||             ST   R1, 0x8B
(0099)  CS-0x034  0x3219C         ||             IN   R1, 0x9C
(0100)  CS-0x035  0x3A18C         ||             ST   R1, 0x8C
(0101)  CS-0x036  0x18002         ||             RET
(0102)                            || 
(0103)                     0x037  || RNG2:
(0104)  CS-0x037  0x36180         ||             MOV  R1, 0x80
(0105)  CS-0x038  0x05609         ||             MOV  R22, R1
(0106)  CS-0x039  0x3628C         ||             MOV  R2, 0x8C
(0107)                            || 
(0108)                     0x03A  || RNG2_next:  
(0109)  CS-0x03A  0x31D01         ||             CMP  R29, 0x01
(0110)  CS-0x03B  0x081EB         ||             BRNE RNG_TEST
(0111)  CS-0x03C  0x18002         ||             RET
(0112)                     0x03D  || RNG_TEST:            
(0113)  CS-0x03D  0x29601         ||             ADD  R22, 0x01
(0114)  CS-0x03E  0x05610         ||             CMP  R22, R2
(0115)  CS-0x03F  0x081BA         ||             BREQ RNG2
(0116)  CS-0x040  0x081D0         ||             BRN  RNG2_next
(0117)                            || 
(0118)                     0x041  || noteSelector:
(0119)  CS-0x041  0x043B2         ||             LD   R3, (R22)
(0120)  CS-0x042  0x30301         ||             CMP  R3, 0x01
(0121)  CS-0x043  0x0826A         ||             BREQ noteChecker
(0122)  CS-0x044  0x29601         ||             ADD  R22, 0x01
(0123)  CS-0x045  0x3168D         ||             CMP  R22, 0x8D
(0124)  CS-0x046  0x0820B         ||             BRNE noteSelector
(0125)  CS-0x047  0x37680         ||             MOV  R22, 0x80
(0126)  CS-0x048  0x08208         ||             BRN  noteSelector
(0127)                            || 
(0128)                            || 
(0129)                     0x049  || checkNote:
(0130)  CS-0x049  0x1A000         ||             SEI                         ; Set enable interupt
(0131)                     0x04A  || waitForInt:
(0132)  CS-0x04A  0x081B9         ||             CALL RNG2                   ; Calculate random number
(0133)  CS-0x04B  0x37D00         || 			MOV  R29, 0x00				; Reset interupt flag register
(0134)  CS-0x04C  0x08208         ||             BRN  noteSelector           ; Translate random number to random note
(0135)                            || 
(0136)                     0x04D  || noteChecker:
(0137)  CS-0x04D  0x2D680         || 			SUB  R22, 0x80				; Get new note value
(0138)  CS-0x04E  0x054A8         ||             CMP  R20, R21               ; Check if user's guess is correct
(0139)  CS-0x04F  0x0828A         ||             BREQ guessCorrect
(0140)  CS-0x050  0x082A8         ||             BRN  guessIncorrect
(0141)                     0x051  || guessCorrect:
(0142)  CS-0x051  0x055B1         || 			MOV  R21, R22				; Set new current note
(0143)  CS-0x052  0x29E01         ||             ADD  R30, 0x01              ; Increment user's score
(0144)  CS-0x053  0x35E81         ||             OUT  R30, SSEG_PORT         ; Output initial score
(0145)  CS-0x054  0x18002         ||             RET
(0146)                     0x055  || guessIncorrect:
(0147)  CS-0x055  0x36100         || 			MOV  R1, 0x00
(0148)  CS-0x056  0x34181         ||             OUT  R1, SSEG_PORT          ; Output zero score
(0149)  CS-0x057  0x14100         || 			WSP  R1						; Clear stack pointer when resetting the game
(0150)  CS-0x058  0x08008         ||             BRN  start                  ; Restart the program
(0151)                            || 
(0152)  CS-0x059  0x37D01  0x059  || ISR:        MOV  R29, 0x01              ; Set flag that interrupt was triggered
(0153)  CS-0x05A  0x33480         ||             IN   R20, KEYPAD_PORT       ; Read user's guess from port
(0154)  CS-0x05B  0x1A002         ||             RETID
(0155)                            || 
(0156)                     0x05C  || end:
(0157)  CS-0x05C  0x082E0         ||             BRN  end
(0158)                            || 
(0159)                       1023  || .ORG  0x3FF
(0160)  CS-0x3FF  0x082C8         ||             BRN  ISR
(0161)                            || 
(0162)                            || 
(0163)                            || 
(0164)                            || 
(0165)                            || 
(0166)                            || 
(0167)                            || 
(0168)                            || 
(0169)                            || 
(0170)                            || 
(0171)                            || 
(0172)                            || 
(0173)                            || ; RNG:                                    ; Find the next valid note (eg. next note that has a 1) -- looking in reverse!
(0174)                            || ;                                         ; Why reverse? Because we have comparator for <, but not > (only >=).
(0175)                            || ;             MOV  R1, R21                ; Start looking from the current note (check R21).
(0176)                            || ;             CALL getNoteAddr            ; Get this note's address >> R31
(0177)                            || ;             MOV  R1, R31
(0178)                            || ; RNG_next:   SUB  R1, 0x01               ; Move to previous note to check there
(0179)                            || ;             CMP  R1, SWITCH_PORT_START  ; Check it isn't past the first note
(0180)                            || ;             BRCS RNG_wrap               ; If it is an invalid port, begin again at the final note port
(0181)                            || ;             LD   R2, (R1)               ; If valid, check the note is enabled (=1)
(0182)                            || ;             CMP  R2, 0x01
(0183)                            || ;             BRNE RNG_next               ; If 0, go to next note
(0184)                            || ;             CALL getNote                ; If 1, get that note [1,12]
(0185)                            || ;             MOV  R22, R31                ; ...and store it in R22 (next test note)
(0186)                            || ;             CMP  R29, 0X01              ; Check if the interupt was triggered
(0187)                            || ;             BRNE RNG_next
(0188)                            || ;             RET
(0189)                            || ; RNG_wrap:
(0190)                            || ;             ADD  R20, 0x0E              ; Add 0x0E because we're at -1, need to go +1 past end (bc of sub in RNG_next).
(0191)                            || ;             BRN  RNG_next
(0192)                            || 
(0193)                            || ; getNoteAddr:                            ; Returns note address (0x90+) based on note number.
(0194)                            || ;                                         ; getNoteAddr(R1=[1,12]) >> R31
(0195)                            || ;             SUB  R1, 0x01
(0196)                            || ;             ADD  R1, SWITCH_PORT_START
(0197)                            || ;             MOV  R31, R1
(0198)                            || ;             RET
(0199)                            || 
(0200)                            || ; getNote:                                ; getNote(R1=Address[0x90+]) >> R31
(0201)                            || ;                                         ; Returns note [1,12] from address
(0202)                            || ;             ADD  R1, 0x01
(0203)                            || ;             SUB  R1, SWITCH_PORT_START
(0204)                            || ;             MOV  R31, R1
(0205)                            || ;             RET
(0206)                            || 





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
CHECKNOTE      0x049   (0129)  ||  0033 
DELAYINNER     0x010   (0052)  ||  0054 
DELAYMIDDLE    0x00F   (0050)  ||  0056 
DELAYOUTER     0x00E   (0048)  ||  0058 
END            0x05C   (0156)  ||  0037 0157 
GUESSCORRECT   0x051   (0141)  ||  0139 
GUESSINCORRECT 0x055   (0146)  ||  0140 
ISR            0x059   (0152)  ||  0160 
NOTECHECKER    0x04D   (0136)  ||  0121 
NOTESELECTOR   0x041   (0118)  ||  0124 0126 0134 
PLAYNOTE       0x008   (0039)  ||  0032 
PLAYNOTEDELAY  0x00D   (0046)  ||  0041 
PRACTICELOOP   0x004   (0031)  ||  0030 0034 
READSWITCHES   0x01E   (0076)  ||  0063 
RNG2           0x037   (0103)  ||  0115 0132 
RNG2_NEXT      0x03A   (0108)  ||  0116 
RNG_TEST       0x03D   (0112)  ||  0110 
SETUP          0x017   (0062)  ||  0029 
SSEGSET        0x01C   (0072)  ||  
START          0x001   (0027)  ||  0150 
WAITFORINT     0x04A   (0131)  ||  


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
INLOOPLENGTH   0x001   (0010)  ||  0051 
KEYPAD_PORT    0x080   (0005)  ||  0153 
MIDLOOPLENGTH  0x001   (0011)  ||  0049 
OUTLOOPLENGTH  0x001   (0012)  ||  0047 
SPEAKER_PORT   0x082   (0008)  ||  0040 0043 
SSEG_PORT      0x081   (0007)  ||  0067 0072 0144 0148 
SWITCH_PORT_END 0x09C   (0004)  ||  
SWITCH_PORT_START 0x090   (0003)  ||  


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
