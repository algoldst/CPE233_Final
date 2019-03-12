

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


(0001)                            ||                                         ; INPUTS
(0002)                       144  || .EQU SWITCH_PORT_START = 0x90           ; Switches. Port #1,2,3,4,5,6,7,8,....12
(0003)                       156  || .EQU SWITCH_PORT_END = 0x9C             ; Final switch port value (switch 12)
(0004)                       128  || .EQU KEYPAD_PORT = 0x80                 ; Keypad input port
(0005)                            ||                                         ; OUTPUTS
(0006)                       129  || .EQU SSEG_PORT = 0x81                   ; SSEG shows
(0007)                       130  || .EQU SPEAKER_PORT = 0x82
(0008)                            || 
(0009)                       255  || .EQU INloopLength = 0xFF
(0010)                       255  || .EQU MIDloopLength = 0xFF
(0011)                       255  || .EQU OUTloopLength = 0xFF
(0012)                            || 
(0013)                            || .CSEG
(0014)                       001  || .ORG 0x01
(0015)                            || 
(0016)                            || ; REGISTERS USED:
(0017)                            || ; (Rx81-x8C) = Notes to Test
(0018)                            ||     ; 1:C, 2:C#, 3:D, 4:D#, 5:E, 6:F, 7:F#, 8:G, 9:G#, 10:A, 11:A#, 12:B (2nd octave)
(0019)                            || ; R20 = User note guess
(0020)                            || ; R21 = Current Test Note
(0021)                            || ; R22 = Next Test Note
(0022)                            || ; R24 = Top Active Note Address (the highest note that was "1" active)
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
(0033)  CS-0x005  0x082D1         ||             CALL checkNote              ; Waits for Interupt and then checks User's Guess
(0034)  CS-0x006  0x08020         ||             BRN  practiceLoop           ; Moves on to next round
(0035)                            || 
(0036)                            ||             ;...
(0037)  CS-0x007  0x08368         ||             BRN  end
(0038)                            || 
(0039)                     0x008  || playNote:                               ; Assumes R21 holds a value [0,12]
(0040)  CS-0x008  0x35582         ||             OUT  R21, SPEAKER_PORT      ; Play the test note
(0041)  CS-0x009  0x08069         ||             CALL playNoteDelay          ; Wait `loopLength` of time
(0042)  CS-0x00A  0x36100         || 			MOV  R1, 0x00
(0043)  CS-0x00B  0x34182         ||             OUT  R1, SPEAKER_PORT     ; Stop playing the note
(0044)  CS-0x00C  0x18002         ||             RET
(0045)                            || 
(0046)                     0x00D  || playNoteDelay:
(0047)  CS-0x00D  0x361FF         ||             MOV  R1, OUTloopLength
(0048)                     0x00E  || delayOUTER:
(0049)  CS-0x00E  0x362FF         ||             MOV  R2, MIDloopLength
(0050)                     0x00F  || delayMIDDLE:
(0051)  CS-0x00F  0x363FF         ||             MOV  R3, INloopLength
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
(0077)  CS-0x01E  0x36280         ||             MOV  R2, 0x80       ; R2 tracks what note we are reading in (starts from 1 before first note address)
(0078)  CS-0x01F  0x32191         ||             IN   R1, 0x91       ; Read in the switch 1 (Root note, note 1, "C", etc.) --> [1 or 0]
(0079)  CS-0x020  0x3A181         ||             ST   R1, 0x81       ; Store it in RAM
(0080)  CS-0x021  0x08221         ||             CALL recHighest     ; Record if this is the highest note position that has a 1
(0081)  CS-0x022  0x32192         ||             IN   R1, 0x92       ; Read the rest of the switches 1-12
(0082)  CS-0x023  0x3A182         ||             ST   R1, 0x82       ; Notes that are active will be tested on. Inactive notes will be skipped over.
(0083)  CS-0x024  0x08221         ||             CALL recHighest
(0084)  CS-0x025  0x32193         ||             IN   R1, 0x93
(0085)  CS-0x026  0x3A183         ||             ST   R1, 0x83
(0086)  CS-0x027  0x08221         ||             CALL recHighest
(0087)  CS-0x028  0x32194         ||             IN   R1, 0x94
(0088)  CS-0x029  0x3A184         ||             ST   R1, 0x84
(0089)  CS-0x02A  0x08221         ||             CALL recHighest
(0090)  CS-0x02B  0x32195         ||             IN   R1, 0x95
(0091)  CS-0x02C  0x3A185         ||             ST   R1, 0x85
(0092)  CS-0x02D  0x08221         ||             CALL recHighest
(0093)  CS-0x02E  0x32196         ||             IN   R1, 0x96
(0094)  CS-0x02F  0x3A186         ||             ST   R1, 0x86
(0095)  CS-0x030  0x08221         ||             CALL recHighest
(0096)  CS-0x031  0x32197         ||             IN   R1, 0x97
(0097)  CS-0x032  0x3A187         ||             ST   R1, 0x87
(0098)  CS-0x033  0x08221         ||             CALL recHighest
(0099)  CS-0x034  0x32198         ||             IN   R1, 0x98
(0100)  CS-0x035  0x3A188         ||             ST   R1, 0x88
(0101)  CS-0x036  0x08221         ||             CALL recHighest
(0102)  CS-0x037  0x32199         ||             IN   R1, 0x99
(0103)  CS-0x038  0x3A189         ||             ST   R1, 0x89
(0104)  CS-0x039  0x08221         ||             CALL recHighest
(0105)  CS-0x03A  0x3219A         ||             IN   R1, 0x9A
(0106)  CS-0x03B  0x3A18A         ||             ST   R1, 0x8A
(0107)  CS-0x03C  0x08221         ||             CALL recHighest
(0108)  CS-0x03D  0x3219B         ||             IN   R1, 0x9B
(0109)  CS-0x03E  0x3A18B         ||             ST   R1, 0x8B
(0110)  CS-0x03F  0x08221         ||             CALL recHighest
(0111)  CS-0x040  0x3219C         ||             IN   R1, 0x9C
(0112)  CS-0x041  0x3A18C         ||             ST   R1, 0x8C
(0113)  CS-0x042  0x08221         ||             CALL recHighest
(0114)  CS-0x043  0x18002         ||             RET
(0115)                            || 
(0116)                     0x044  || recHighest:                         ; Tracks the highest note address that has a "1"
(0117)  CS-0x044  0x28201         ||             ADD  R2, 0x01           ; Increment the address
(0118)  CS-0x045  0x30101         ||             CMP  R1, 0x01           ; Is this a 1?
(0119)  CS-0x046  0x08242         ||             BREQ isHighest
(0120)  CS-0x047  0x18002         ||             RET                     ; If 0 --> RET without updating R24 (highest address)
(0121)  CS-0x048  0x05811  0x048  || isHighest:  MOV  R24, R2            ; If 1 --> Update R24 with the new highest note address
(0122)  CS-0x049  0x18002         ||             RET
(0123)                            || 
(0124)                     0x04A  || RNG2_next:
(0125)  CS-0x04A  0x31D01         ||             CMP  R29, 0x01          ; Check that interrupt has not been called yet (due to user input)
(0126)  CS-0x04B  0x08273         ||             BRNE RNG_TEST           ; If not, continue the RNG
(0127)  CS-0x04C  0x18002         ||             RET                     ; Else return
(0128)                     0x04D  || RNG2:
(0129)  CS-0x04D  0x37680         ||             MOV  R22, 0x80           ; Start looking for new note at 0x80 (1 pos before first note)
(0130)                     0x04E  || RNG_TEST:
(0131)  CS-0x04E  0x058B0         ||             CMP  R24, R22           ; Check it isn't past the last valid (active) note
(0132)  CS-0x04F  0x0826A         ||             BREQ RNG2               ; If it is (R22>R24), BRN to restart at 0x80
(0133)  CS-0x050  0x29601         ||             ADD  R22, 0x01          ; Otherwise, increment the nextNote value
(0134)  CS-0x051  0x08250         ||             BRN  RNG2_next          ; and keep going! (check interrupt, and increment again)
(0135)                            || 
(0136)                            || 
(0137)                     0x052  || noteSelector:
(0138)  CS-0x052  0x043B2         ||             LD   R3, (R22)          ; Whatever value R22 got from RNG, load that note address into R3.
(0139)  CS-0x053  0x30301         ||             CMP  R3, 0x01           ; If 1, it is a switched "on" note; otherwise, it is "off" and we need a new note
(0140)  CS-0x054  0x082F2         ||             BREQ noteChecker        ; 1 --> We have found our next note! Proceed to check current note vs. user guess
(0141)  CS-0x055  0x29601         ||             ADD  R22, 0x01          ; 0 --> Increment the note selection until we find a note that is "on" (1).
(0142)  CS-0x056  0x3168D         ||             CMP  R22, 0x8D          ; If the address is not an Out-of-Bounds (OOB) value...
(0143)  CS-0x057  0x08293         ||             BRNE noteSelector       ; ... loop to keep searching!
(0144)  CS-0x058  0x37680         ||             MOV  R22, 0x80          ; Otherwise, wrap around to the beginning of the addresses
(0145)  CS-0x059  0x08290         ||             BRN  noteSelector       ; And then keep searching!
(0146)                            || 
(0147)                            || 
(0148)                     0x05A  || checkNote:
(0149)  CS-0x05A  0x1A000         ||             SEI                         ; Set enable interupt
(0150)                     0x05B  || waitForInt:
(0151)  CS-0x05B  0x08269         ||             CALL RNG2                   ; Calculate random number
(0152)  CS-0x05C  0x37D00         || 			MOV  R29, 0x00				; Reset interupt flag register
(0153)  CS-0x05D  0x08290         ||             BRN  noteSelector           ; Translate random number to random note
(0154)                            || 
(0155)                     0x05E  || noteChecker:
(0156)  CS-0x05E  0x2D680         || 			SUB  R22, 0x80				; Get new note value
(0157)  CS-0x05F  0x054A8         ||             CMP  R20, R21               ; Check if user's guess is correct
(0158)  CS-0x060  0x08312         ||             BREQ guessCorrect
(0159)  CS-0x061  0x08330         ||             BRN  guessIncorrect
(0160)                     0x062  || guessCorrect:
(0161)  CS-0x062  0x055B1         || 			MOV  R21, R22				; Set new current note
(0162)  CS-0x063  0x29E01         ||             ADD  R30, 0x01              ; Increment user's score
(0163)  CS-0x064  0x35E81         ||             OUT  R30, SSEG_PORT         ; Output initial score
(0164)  CS-0x065  0x18002         ||             RET
(0165)                     0x066  || guessIncorrect:
(0166)  CS-0x066  0x36100         || 			MOV  R1, 0x00
(0167)  CS-0x067  0x34181         ||             OUT  R1, SSEG_PORT          ; Output zero score
(0168)  CS-0x068  0x14100         || 			WSP  R1						; Clear stack pointer when resetting the game
(0169)  CS-0x069  0x08008         ||             BRN  start                  ; Restart the program
(0170)                            || 
(0171)  CS-0x06A  0x37D01  0x06A  || ISR:        MOV  R29, 0x01              ; Set flag that interrupt was triggered
(0172)  CS-0x06B  0x33480         ||             IN   R20, KEYPAD_PORT       ; Read user's guess from port
(0173)  CS-0x06C  0x1A002         ||             RETID
(0174)                            || 
(0175)                     0x06D  || end:
(0176)  CS-0x06D  0x08368         ||             BRN  end
(0177)                            || 
(0178)                       1023  || .ORG  0x3FF
(0179)  CS-0x3FF  0x08350         ||             BRN  ISR
(0180)                            || 





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
CHECKNOTE      0x05A   (0148)  ||  0033 
DELAYINNER     0x010   (0052)  ||  0054 
DELAYMIDDLE    0x00F   (0050)  ||  0056 
DELAYOUTER     0x00E   (0048)  ||  0058 
END            0x06D   (0175)  ||  0037 0176 
GUESSCORRECT   0x062   (0160)  ||  0158 
GUESSINCORRECT 0x066   (0165)  ||  0159 
ISHIGHEST      0x048   (0121)  ||  0119 
ISR            0x06A   (0171)  ||  0179 
NOTECHECKER    0x05E   (0155)  ||  0140 
NOTESELECTOR   0x052   (0137)  ||  0143 0145 0153 
PLAYNOTE       0x008   (0039)  ||  0032 
PLAYNOTEDELAY  0x00D   (0046)  ||  0041 
PRACTICELOOP   0x004   (0031)  ||  0030 0034 
READSWITCHES   0x01E   (0076)  ||  0063 
RECHIGHEST     0x044   (0116)  ||  0080 0083 0086 0089 0092 0095 0098 0101 0104 0107 
                               ||  0110 0113 
RNG2           0x04D   (0128)  ||  0132 0151 
RNG2_NEXT      0x04A   (0124)  ||  0134 
RNG_TEST       0x04E   (0130)  ||  0126 
SETUP          0x017   (0062)  ||  0029 
SSEGSET        0x01C   (0072)  ||  
START          0x001   (0027)  ||  0169 
WAITFORINT     0x05B   (0150)  ||  


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
INLOOPLENGTH   0x0FF   (0009)  ||  0051 
KEYPAD_PORT    0x080   (0004)  ||  0172 
MIDLOOPLENGTH  0x0FF   (0010)  ||  0049 
OUTLOOPLENGTH  0x0FF   (0011)  ||  0047 
SPEAKER_PORT   0x082   (0007)  ||  0040 0043 
SSEG_PORT      0x081   (0006)  ||  0067 0072 0163 0167 
SWITCH_PORT_END 0x09C   (0003)  ||  
SWITCH_PORT_START 0x090   (0002)  ||  


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
