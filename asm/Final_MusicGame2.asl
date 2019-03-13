

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
(0002)                            ||  ; INPUTS
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
(0014)                       133  || .EQU GameMode_PORT = 0x85
(0015)                            || 
(0016)                       002  || .EQU  LVL2 = 2
(0017)                            || 
(0018)                            || 
(0019)                            || .CSEG
(0020)                       001  || .ORG 0x01
(0021)                            || 
(0022)                            || ; REGISTERS USED:
(0023)                            || ; (Rx81-x8C) = Notes to Test
(0024)                            ||     ; 1:C, 2:C#, 3:D, 4:D#, 5:E, 6:F, 7:F#, 8:G, 9:G#, 10:A, 11:A#, 12:B (2nd octave)
(0025)                            || ; R12: Player level
(0026)                            || ; R14: Score counter
(0027)                            || ; R16: Game mode
(0028)                            || ; R20 = User note guess
(0029)                            || ; R21 = Current Test Note
(0030)                            || ; R22 = Next Test Note
(0031)                            || ; R24 = Top Active Note Address (the highest note that was "1" active)
(0032)                            || ; R29 = Interrupt Flag
(0033)                            || ; R30 = User Score
(0034)                            || ; R31 = Function default return register
(0035)                            || 
(0036)                     0x001  || start:
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08008  0x100  ||              BRN     0x01        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0037)  CS-0x001  0x33085         ||             IN   R16, GameMode_PORT ; Retrieve what game mode player selected
(0038)  CS-0x002  0x31001         ||             CMP  R16, 0x01          ; Check which game mode the player selected
(0039)  CS-0x003  0x0824A         ||             BREQ levelMode
(0040)  CS-0x004  0x08028         ||             BRN  practiceMode
(0041)                            || 
(0042)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0043)                            || ; PRACTICE GAME MODE
(0044)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0045)                            || 
(0046)                     0x005  || practiceMode:
(0047)  CS-0x005  0x1A001         ||             CLI
(0048)  CS-0x006  0x08059         || 			CALL setup
(0049)  CS-0x007  0x08040         ||             BRN  practiceLoop
(0050)                     0x008  || practiceLoop:
(0051)  CS-0x008  0x08471         ||             CALL playNote               ; Sets interrupt and begins random # gen
(0052)  CS-0x009  0x08569         ||             CALL checkNote              ; Waits for Interupt and then checks User's Guess
(0053)  CS-0x00A  0x08040         ||             BRN  practiceLoop           ; Moves on to next round
(0054)                            || 
(0055)                     0x00B  || setup:
(0056)  CS-0x00B  0x08091         ||             CALL readSwitches           ; Read which notes to play.
(0057)                            ||                                         ;       1 --> Test player on note
(0058)                            ||                                         ;       0 --> Don't test
(0059)  CS-0x00C  0x37E00         ||             MOV  R30, 0x00              ; Set score = 0
(0060)  CS-0x00D  0x35E81         ||             OUT  R30, SSEG_PORT         ; Output initial score
(0061)  CS-0x00E  0x37501         ||             MOV  R21, 0x01              ; Set first note to root (C) <-- If adding transpose, do it here.
(0062)  CS-0x00F  0x18002         ||             RET
(0063)                            || 
(0064)                            || ; Set SSEG display value
(0065)  CS-0x010  0x34181  0x010  || ssegSet:    OUT  R1, SSEG_PORT
(0066)  CS-0x011  0x18002         ||             RET
(0067)                            || 
(0068)                            || ; Read in switches to query which notes to test on
(0069)                     0x012  || readSwitches:
(0070)  CS-0x012  0x36280         ||             MOV  R2, 0x80       ; R2 tracks what note we are reading in (starts from 1 before first note address)
(0071)  CS-0x013  0x32191         ||             IN   R1, 0x91       ; Read in the switch 1 (Root note, note 1, "C", etc.) --> [1 or 0]
(0072)  CS-0x014  0x3A181         ||             ST   R1, 0x81       ; Store it in RAM
(0073)  CS-0x015  0x081C1         ||             CALL recHighest     ; Record if this is the highest note position that has a 1
(0074)  CS-0x016  0x32192         ||             IN   R1, 0x92       ; Read the rest of the switches 1-12
(0075)  CS-0x017  0x3A182         ||             ST   R1, 0x82       ; Notes that are active will be tested on. Inactive notes will be skipped over.
(0076)  CS-0x018  0x081C1         ||             CALL recHighest
(0077)  CS-0x019  0x32193         ||             IN   R1, 0x93
(0078)  CS-0x01A  0x3A183         ||             ST   R1, 0x83
(0079)  CS-0x01B  0x081C1         ||             CALL recHighest
(0080)  CS-0x01C  0x32194         ||             IN   R1, 0x94
(0081)  CS-0x01D  0x3A184         ||             ST   R1, 0x84
(0082)  CS-0x01E  0x081C1         ||             CALL recHighest
(0083)  CS-0x01F  0x32195         ||             IN   R1, 0x95
(0084)  CS-0x020  0x3A185         ||             ST   R1, 0x85
(0085)  CS-0x021  0x081C1         ||             CALL recHighest
(0086)  CS-0x022  0x32196         ||             IN   R1, 0x96
(0087)  CS-0x023  0x3A186         ||             ST   R1, 0x86
(0088)  CS-0x024  0x081C1         ||             CALL recHighest
(0089)  CS-0x025  0x32197         ||             IN   R1, 0x97
(0090)  CS-0x026  0x3A187         ||             ST   R1, 0x87
(0091)  CS-0x027  0x081C1         ||             CALL recHighest
(0092)  CS-0x028  0x32198         ||             IN   R1, 0x98
(0093)  CS-0x029  0x3A188         ||             ST   R1, 0x88
(0094)  CS-0x02A  0x081C1         ||             CALL recHighest
(0095)  CS-0x02B  0x32199         ||             IN   R1, 0x99
(0096)  CS-0x02C  0x3A189         ||             ST   R1, 0x89
(0097)  CS-0x02D  0x081C1         ||             CALL recHighest
(0098)  CS-0x02E  0x3219A         ||             IN   R1, 0x9A
(0099)  CS-0x02F  0x3A18A         ||             ST   R1, 0x8A
(0100)  CS-0x030  0x081C1         ||             CALL recHighest
(0101)  CS-0x031  0x3219B         ||             IN   R1, 0x9B
(0102)  CS-0x032  0x3A18B         ||             ST   R1, 0x8B
(0103)  CS-0x033  0x081C1         ||             CALL recHighest
(0104)  CS-0x034  0x3219C         ||             IN   R1, 0x9C
(0105)  CS-0x035  0x3A18C         ||             ST   R1, 0x8C
(0106)  CS-0x036  0x081C1         ||             CALL recHighest
(0107)  CS-0x037  0x18002         ||             RET
(0108)                            || 
(0109)                     0x038  || recHighest:                         ; Tracks the highest note address that has a "1"
(0110)  CS-0x038  0x28201         ||             ADD  R2, 0x01           ; Increment the address
(0111)  CS-0x039  0x30101         ||             CMP  R1, 0x01           ; Is this a 1?
(0112)  CS-0x03A  0x081E2         ||             BREQ isHighest
(0113)  CS-0x03B  0x18002         ||             RET                     ; If 0 --> RET without updating R24 (highest address)
(0114)  CS-0x03C  0x05811  0x03C  || isHighest:  MOV  R24, R2            ; If 1 --> Update R24 with the new highest note address
(0115)  CS-0x03D  0x18002         ||             RET
(0116)                            || 
(0117)                            || 
(0118)                     0x03E  || practiceGuesses:
(0119)  CS-0x03E  0x054A8         ||             CMP  R20, R21               ; Check if user's guess is correct
(0120)  CS-0x03F  0x0820A         ||             BREQ guessCorrect
(0121)  CS-0x040  0x08228         ||             BRN  guessIncorrect
(0122)                     0x041  || guessCorrect:
(0123)  CS-0x041  0x055B1         || 			MOV  R21, R22				; Set new current note
(0124)  CS-0x042  0x29E01         ||             ADD  R30, 0x01              ; Increment user's score
(0125)  CS-0x043  0x35E81         ||             OUT  R30, SSEG_PORT         ; Output initial score
(0126)  CS-0x044  0x18002         ||             RET
(0127)                     0x045  || guessIncorrect:
(0128)  CS-0x045  0x36100         || 			MOV  R1, 0x00
(0129)  CS-0x046  0x34181         ||             OUT  R1, SSEG_PORT          ; Output zero score
(0130)  CS-0x047  0x14100         || 			WSP  R1						; Clear stack pointer when resetting the game
(0131)  CS-0x048  0x08008         ||             BRN  start                  ; Restart the program
(0132)                            || 
(0133)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0134)                            || ; LEVELS GAME MODE
(0135)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0136)                            || 
(0137)                     0x049  || levelMode:
(0138)  CS-0x049  0x36C02         ||             MOV  R12, LVL2        ; Assign initial level
(0139)  CS-0x04A  0x34C81         || 			OUT  R12, SSEG_PORT  ; Output players level to sseg.
(0140)  CS-0x04B  0x36E00         ||             MOV  R14, 0x00        ; Assign initial score counter for correct guesses.
(0141)  CS-0x04C  0x37501         ||             MOV  R21, 0x01        ; Set first note to root (C) <-- If adding transpose, do it here.
(0142)  CS-0x04D  0x08291         || 			CALL levelSet         ; Assign initial scratch ram values
(0143)                            || 
(0144)                     0x04E  || gameMode:
(0145)  CS-0x04E  0x08471         ||             CALL playNote        ; Plays the note during the delay then turns off
(0146)  CS-0x04F  0x08569         ||             CALL checkNote       ; Checks players guess and generates next note
(0147)  CS-0x050  0x34C81         ||             OUT  R12, SSEG_PORT  ; Output players level to sseg.
(0148)  CS-0x051  0x08270         ||             BRN  gameMode        ; Continue game
(0149)                            || 
(0150)                            || 
(0151)                     0x052  || levelSet:                      ; Sets starting scratch ram values
(0152)  CS-0x052  0x36201         ||             MOV  R2, 0x01
(0153)  CS-0x053  0x37880         ||             MOV  R24, 0x80				; Set initial highest note address
(0154)  CS-0x054  0x082A8         ||             BRN  levelSetLoop
(0155)                            || 
(0156)                     0x055  || levelSetLoop:            
(0157)  CS-0x055  0x29801         ||             ADD  R24, 0x01				; Increment highest note address
(0158)  CS-0x056  0x042C3         ||             ST   R2, (R24)				; Move "1" into stack address
(0159)  CS-0x057  0x044C1         ||             MOV  R4, R24
(0160)  CS-0x058  0x2C480         ||             SUB  R4, 0x80
(0161)  CS-0x059  0x04460         ||             CMP  R4, R12				; Compare loop counter to player's level
(0162)  CS-0x05A  0x082AB         ||             BRNE levelSetLoop
(0163)  CS-0x05B  0x18002         ||             RET
(0164)                            || 
(0165)                            || 
(0166)                     0x05C  || levelGuesses:
(0167)  CS-0x05C  0x054A8         ||             CMP  R20, R21               ; Check if user's guess is correct
(0168)  CS-0x05D  0x082FA         ||             BREQ guessCorrect2
(0169)  CS-0x05E  0x08368         ||             BRN  guessIncorrect2
(0170)                            || 
(0171)                     0x05F  || guessCorrect2:
(0172)  CS-0x05F  0x28E01         ||             ADD  R14, 0x01              ; Increment players score
(0173)  CS-0x060  0x36000         ||             MOV  R0, 0x00
(0174)  CS-0x061  0x29580         ||             ADD  R21, 0x80
(0175)  CS-0x062  0x040AB         ||             ST   R0, (R21)
(0176)  CS-0x063  0x055B1         ||             MOV  R21, R22				; Set new current note
(0177)  CS-0x064  0x04C70         ||             CMP  R12, R14               ; Compare players score to players level
(0178)  CS-0x065  0x0833A         ||             BREQ levelUp
(0179)  CS-0x066  0x18002         ||             RET
(0180)                            || 
(0181)                     0x067  || levelUp:
(0182)  CS-0x067  0x28C01         ||             ADD  R12, 0x01              ; Increment players level
(0183)  CS-0x068  0x36E00         ||             MOV  R14, 0x00              ; Reset players score
(0184)  CS-0x069  0x30C0D         ||             CMP  R12, 0x0D				; Check if player is past level 12
(0185)  CS-0x06A  0x08382         ||             BREQ beatGame
(0186)  CS-0x06B  0x08291         ||             CALL levelSet
(0187)  CS-0x06C  0x18002         ||             RET
(0188)                            || 
(0189)                     0x06D  || guessIncorrect2:
(0190)  CS-0x06D  0x36000         || 			MOV  R0, 0x00
(0191)  CS-0x06E  0x14000         ||             WSP  R0						; Reset stack pointer to "0"
(0192)  CS-0x06F  0x08248         ||             BRN  levelMode
(0193)                            || 
(0194)                     0x070  || beatGame:                               ; If player passes level 11, flash level 12 6 times
(0195)                            ||                                         ; then turn off sseg display
(0196)  CS-0x070  0x36000         ||             MOV  R0, 0x00
(0197)  CS-0x071  0x14000         ||             WSP  R0
(0198)  CS-0x072  0x34181         ||             OUT  R1, SSEG_PORT
(0199)  CS-0x073  0x08499         ||             CALL playNoteDelay
(0200)  CS-0x074  0x34C81         ||             OUT  R12, SSEG_PORT
(0201)  CS-0x075  0x08499         ||             CALL playNoteDelay
(0202)  CS-0x076  0x36100         ||             MOV  R1, 0x00
(0203)  CS-0x077  0x34181         ||             OUT  R1, SSEG_PORT
(0204)  CS-0x078  0x08499         ||             CALL playNoteDelay
(0205)  CS-0x079  0x34C81         ||             OUT  R12, SSEG_PORT
(0206)  CS-0x07A  0x08499         ||             CALL playNoteDelay
(0207)  CS-0x07B  0x34181         ||             OUT  R1, SSEG_PORT
(0208)  CS-0x07C  0x08499         ||             CALL playNoteDelay
(0209)  CS-0x07D  0x34C81         ||             OUT  R12, SSEG_PORT
(0210)  CS-0x07E  0x08499         ||             CALL playNoteDelay
(0211)  CS-0x07F  0x34181         ||             OUT  R1, SSEG_PORT
(0212)  CS-0x080  0x08499         ||             CALL playNoteDelay
(0213)  CS-0x081  0x34C81         ||             OUT  R12, SSEG_PORT
(0214)  CS-0x082  0x08499         ||             CALL playNoteDelay
(0215)  CS-0x083  0x34181         ||             OUT  R1, SSEG_PORT
(0216)  CS-0x084  0x08499         ||             CALL playNoteDelay
(0217)  CS-0x085  0x34C81         ||             OUT  R12, SSEG_PORT
(0218)  CS-0x086  0x08499         ||             CALL playNoteDelay
(0219)  CS-0x087  0x34181         ||             OUT  R1, SSEG_PORT
(0220)  CS-0x088  0x08499         ||             CALL playNoteDelay
(0221)  CS-0x089  0x34C81         ||             OUT  R12, SSEG_PORT
(0222)  CS-0x08A  0x08499         ||             CALL playNoteDelay
(0223)  CS-0x08B  0x34181         ||             OUT  R1, SSEG_PORT
(0224)  CS-0x08C  0x08499         ||             CALL playNoteDelay
(0225)  CS-0x08D  0x085C0         ||             BRN  end
(0226)                            || 
(0227)                            || 
(0228)                            || 
(0229)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0230)                            || ; SHARED FUNCTIONS
(0231)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0232)                            || 
(0233)                            || 
(0234)                     0x08E  || playNote:                               ; Assumes R21 holds a value [0,12]
(0235)  CS-0x08E  0x35582         ||             OUT  R21, SPEAKER_PORT      ; Play the test note
(0236)  CS-0x08F  0x08499         ||             CALL playNoteDelay          ; Wait `loopLength` of time
(0237)  CS-0x090  0x36100         || 			MOV  R1, 0x00
(0238)  CS-0x091  0x34182         ||             OUT  R1, SPEAKER_PORT     ; Stop playing the note
(0239)  CS-0x092  0x18002         ||             RET
(0240)                            || 
(0241)                     0x093  || playNoteDelay:
(0242)  CS-0x093  0x36101         ||             MOV  R1, OUTloopLength
(0243)                     0x094  || delayOUTER:
(0244)  CS-0x094  0x36201         ||             MOV  R2, MIDloopLength
(0245)                     0x095  || delayMIDDLE:
(0246)  CS-0x095  0x36301         ||             MOV  R3, INloopLength
(0247)                     0x096  || delayINNER:
(0248)  CS-0x096  0x2C301         ||             SUB  R3, 0x01
(0249)  CS-0x097  0x084B3         ||             BRNE delayINNER
(0250)  CS-0x098  0x2C201         ||             SUB  R2, 0x01
(0251)  CS-0x099  0x084AB         ||             BRNE delayMIDDLE
(0252)  CS-0x09A  0x2C101         ||             SUB  R1, 0x01
(0253)  CS-0x09B  0x084A3         ||             BRNE delayOUTER
(0254)  CS-0x09C  0x18002         ||             RET
(0255)                            || 
(0256)                     0x09D  || RNG2_next:
(0257)  CS-0x09D  0x31D01         ||             CMP  R29, 0x01          ; Check that interrupt has not been called yet (due to user input)
(0258)  CS-0x09E  0x0850B         ||             BRNE RNG_TEST           ; If not, continue the RNG
(0259)  CS-0x09F  0x18002         ||             RET                     ; Else return
(0260)                     0x0A0  || RNG2:
(0261)  CS-0x0A0  0x37680         ||             MOV  R22, 0x80           ; Start looking for new note at 0x80 (1 pos before first note)
(0262)                     0x0A1  || RNG_TEST:
(0263)  CS-0x0A1  0x058B0         ||             CMP  R24, R22           ; Check it isn't past the last valid (active) note
(0264)  CS-0x0A2  0x08502         ||             BREQ RNG2               ; If it is (R22>R24), BRN to restart at 0x80
(0265)  CS-0x0A3  0x29601         ||             ADD  R22, 0x01          ; Otherwise, increment the nextNote value
(0266)  CS-0x0A4  0x084E8         ||             BRN  RNG2_next          ; and keep going! (check interrupt, and increment again)
(0267)                            || 
(0268)                     0x0A5  || noteSelector:
(0269)  CS-0x0A5  0x043B2         ||             LD   R3, (R22)          ; Whatever value R22 got from RNG, load that note address into R3.
(0270)  CS-0x0A6  0x30301         ||             CMP  R3, 0x01           ; If 1, it is a switched "on" note; otherwise, it is "off" and we need a new note
(0271)  CS-0x0A7  0x0858A         ||             BREQ noteChecker        ; 1 --> We have found our next note! Proceed to check current note vs. user guess
(0272)  CS-0x0A8  0x29601         ||             ADD  R22, 0x01          ; 0 --> Increment the note selection until we find a note that is "on" (1).
(0273)  CS-0x0A9  0x3168D         ||             CMP  R22, 0x8D          ; If the address is not an Out-of-Bounds (OOB) value...
(0274)  CS-0x0AA  0x0852B         ||             BRNE noteSelector       ; ... loop to keep searching!
(0275)  CS-0x0AB  0x37680         ||             MOV  R22, 0x80          ; Otherwise, wrap around to the beginning of the addresses
(0276)  CS-0x0AC  0x08528         ||             BRN  noteSelector       ; And then keep searching!
(0277)                            || 
(0278)                     0x0AD  || checkNote:
(0279)  CS-0x0AD  0x1A000         ||             SEI                         ; Set enable interupt
(0280)                     0x0AE  || waitForInt:
(0281)  CS-0x0AE  0x08501         ||             CALL RNG2                   ; Calculate random number
(0282)  CS-0x0AF  0x37D00         || 			MOV  R29, 0x00				; Reset interupt flag register
(0283)                            || 
(0284)  CS-0x0B0  0x08528         ||             BRN  noteSelector           ; Translate random number to random note
(0285)                            || 
(0286)                     0x0B1  || noteChecker:
(0287)  CS-0x0B1  0x2D680         || 			SUB  R22, 0x80				; Get new note value
(0288)  CS-0x0B2  0x31001         ||             CMP  R16, 0x01              ; Check players game mode
(0289)  CS-0x0B3  0x082E2         ||             BREQ levelGuesses
(0290)  CS-0x0B4  0x081F0         ||             BRN  practiceGuesses
(0291)                            || 
(0292)                            || 
(0293)  CS-0x0B5  0x37D01  0x0B5  || ISR:        MOV  R29, 0x01              ; Set flag that interrupt was triggered
(0294)  CS-0x0B6  0x33480         ||             IN   R20, KEYPAD_PORT       ; Read user's guess from port
(0295)  CS-0x0B7  0x1A002         ||             RETID
(0296)                            || 
(0297)                     0x0B8  || end:
(0298)  CS-0x0B8  0x085C0         ||             BRN  end
(0299)                            || 
(0300)                       1023  || .ORG  0x3FF
(0301)  CS-0x3FF  0x085A8         ||             BRN  ISR
(0302)                            || 
(0303)                            || 





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
BEATGAME       0x070   (0194)  ||  0185 
CHECKNOTE      0x0AD   (0278)  ||  0052 0146 
DELAYINNER     0x096   (0247)  ||  0249 
DELAYMIDDLE    0x095   (0245)  ||  0251 
DELAYOUTER     0x094   (0243)  ||  0253 
END            0x0B8   (0297)  ||  0225 0298 
GAMEMODE       0x04E   (0144)  ||  0148 
GUESSCORRECT   0x041   (0122)  ||  0120 
GUESSCORRECT2  0x05F   (0171)  ||  0168 
GUESSINCORRECT 0x045   (0127)  ||  0121 
GUESSINCORRECT2 0x06D   (0189)  ||  0169 
ISHIGHEST      0x03C   (0114)  ||  0112 
ISR            0x0B5   (0293)  ||  0301 
LEVELGUESSES   0x05C   (0166)  ||  0289 
LEVELMODE      0x049   (0137)  ||  0039 0192 
LEVELSET       0x052   (0151)  ||  0142 0186 
LEVELSETLOOP   0x055   (0156)  ||  0154 0162 
LEVELUP        0x067   (0181)  ||  0178 
NOTECHECKER    0x0B1   (0286)  ||  0271 
NOTESELECTOR   0x0A5   (0268)  ||  0274 0276 0284 
PLAYNOTE       0x08E   (0234)  ||  0051 0145 
PLAYNOTEDELAY  0x093   (0241)  ||  0199 0201 0204 0206 0208 0210 0212 0214 0216 0218 
                               ||  0220 0222 0224 0236 
PRACTICEGUESSES 0x03E   (0118)  ||  0290 
PRACTICELOOP   0x008   (0050)  ||  0049 0053 
PRACTICEMODE   0x005   (0046)  ||  0040 
READSWITCHES   0x012   (0069)  ||  0056 
RECHIGHEST     0x038   (0109)  ||  0073 0076 0079 0082 0085 0088 0091 0094 0097 0100 
                               ||  0103 0106 
RNG2           0x0A0   (0260)  ||  0264 0281 
RNG2_NEXT      0x09D   (0256)  ||  0266 
RNG_TEST       0x0A1   (0262)  ||  0258 
SETUP          0x00B   (0055)  ||  0048 
SSEGSET        0x010   (0065)  ||  
START          0x001   (0036)  ||  0131 
WAITFORINT     0x0AE   (0280)  ||  


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
GAMEMODE_PORT  0x085   (0014)  ||  0037 
INLOOPLENGTH   0x001   (0010)  ||  0246 
KEYPAD_PORT    0x080   (0005)  ||  0294 
LVL2           0x002   (0016)  ||  0138 
MIDLOOPLENGTH  0x001   (0011)  ||  0244 
OUTLOOPLENGTH  0x001   (0012)  ||  0242 
SPEAKER_PORT   0x082   (0008)  ||  0235 0238 
SSEG_PORT      0x081   (0007)  ||  0060 0065 0125 0129 0139 0147 0198 0200 0203 0205 
                               ||  0207 0209 0211 0213 0215 0217 0219 0221 0223 
SWITCH_PORT_END 0x09C   (0004)  ||  
SWITCH_PORT_START 0x090   (0003)  ||  


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
