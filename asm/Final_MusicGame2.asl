

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
(0010)                       255  || .EQU INloopLength = 0xFF
(0011)                       255  || .EQU MIDloopLength = 0xFF
(0012)                       128  || .EQU OUTloopLength = 0x80
(0013)                            || 
(0014)                       180  || .EQU INsecloopLength = 0xB4
(0015)                       202  || .EQU MIDsecloopLength = 0xCA
(0016)                       170  || .EQU OUTsecloopLength = 0xAA
(0017)                            || 
(0018)                       133  || .EQU GameMode_PORT = 0x85
(0019)                            || 
(0020)                       002  || .EQU  LVL2 = 2
(0021)                       015  || .EQU  TIMED = 15
(0022)                            || 
(0023)                            || 
(0024)                            || .CSEG
(0025)                       001  || .ORG 0x01
(0026)                            || 
(0027)                            || ; REGISTERS USED:
(0028)                            || ; (Rx81-x8C) = Notes to Test
(0029)                            ||     ; 1:C, 2:C#, 3:D, 4:D#, 5:E, 6:F, 7:F#, 8:G, 9:G#, 10:A, 11:A#, 12:B (2nd octave)
(0030)                            || ; R12: Player level
(0031)                            || ; R14: Score counter
(0032)                            || ; R15: Time counter
(0033)                            || ; R16: Game mode
(0034)                            || ; R17: Second delay value
(0035)                            || ; R20 = User note guess
(0036)                            || ; R21 = Current Test Note
(0037)                            || ; R22 = Next Test Note
(0038)                            || ; R24 = Top Active Note Address (the highest note that was "1" active)
(0039)                            || ; R29 = Interrupt Flag
(0040)                            || ; R30 = User Score
(0041)                            || ; R31 = Function default return register
(0042)                            || 
(0043)                     0x001  || start:
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x08008  0x100  ||              BRN     0x01        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0044)  CS-0x001  0x33085         ||             IN   R16, GameMode_PORT ; Retrieve what game mode player selected
(0045)  CS-0x002  0x31001         ||             CMP  R16, 0x01          ; Check if player selected Level Mode
(0046)  CS-0x003  0x0825A         ||             BREQ levelMode
(0047)  CS-0x004  0x31002         || 			CMP  R16, 0x02			;Check if player selected Time Mode
(0048)  CS-0x005  0x08482         || 			BREQ playMode
(0049)  CS-0x006  0x08038         ||             BRN  practiceMode
(0050)                            || 
(0051)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0052)                            || ; PRACTICE GAME MODE
(0053)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0054)                            || 
(0055)                     0x007  || practiceMode:
(0056)  CS-0x007  0x1A001         ||             CLI
(0057)  CS-0x008  0x08069         || 			CALL setup
(0058)  CS-0x009  0x08050         ||             BRN  practiceLoop
(0059)                     0x00A  || practiceLoop:
(0060)  CS-0x00A  0x084F1         ||             CALL playNote               ; Sets interrupt and begins random # gen
(0061)  CS-0x00B  0x085E9         ||             CALL checkNote              ; Waits for Interupt and then checks User's Guess
(0062)  CS-0x00C  0x08050         ||             BRN  practiceLoop           ; Moves on to next round
(0063)                            || 
(0064)                     0x00D  || setup:
(0065)  CS-0x00D  0x080A1         ||             CALL readSwitches           ; Read which notes to play.
(0066)                            ||                                         ;       1 --> Test player on note
(0067)                            ||                                         ;       0 --> Don't test
(0068)  CS-0x00E  0x37E00         ||             MOV  R30, 0x00              ; Set score = 0
(0069)  CS-0x00F  0x35E81         ||             OUT  R30, SSEG_PORT         ; Output initial score
(0070)  CS-0x010  0x37501         ||             MOV  R21, 0x01              ; Set first note to root (C) <-- If adding transpose, do it here.
(0071)  CS-0x011  0x18002         ||             RET
(0072)                            || 
(0073)                            || ; Set SSEG display value
(0074)  CS-0x012  0x34181  0x012  || ssegSet:    OUT  R1, SSEG_PORT
(0075)  CS-0x013  0x18002         ||             RET
(0076)                            || 
(0077)                            || ; Read in switches to query which notes to test on
(0078)                     0x014  || readSwitches:
(0079)  CS-0x014  0x36280         ||             MOV  R2, 0x80       ; R2 tracks what note we are reading in (starts from 1 before first note address)
(0080)  CS-0x015  0x32191         ||             IN   R1, 0x91       ; Read in the switch 1 (Root note, note 1, "C", etc.) --> [1 or 0]
(0081)  CS-0x016  0x3A181         ||             ST   R1, 0x81       ; Store it in RAM
(0082)  CS-0x017  0x081D1         ||             CALL recHighest     ; Record if this is the highest note position that has a 1
(0083)  CS-0x018  0x32192         ||             IN   R1, 0x92       ; Read the rest of the switches 1-12
(0084)  CS-0x019  0x3A182         ||             ST   R1, 0x82       ; Notes that are active will be tested on. Inactive notes will be skipped over.
(0085)  CS-0x01A  0x081D1         ||             CALL recHighest
(0086)  CS-0x01B  0x32193         ||             IN   R1, 0x93
(0087)  CS-0x01C  0x3A183         ||             ST   R1, 0x83
(0088)  CS-0x01D  0x081D1         ||             CALL recHighest
(0089)  CS-0x01E  0x32194         ||             IN   R1, 0x94
(0090)  CS-0x01F  0x3A184         ||             ST   R1, 0x84
(0091)  CS-0x020  0x081D1         ||             CALL recHighest
(0092)  CS-0x021  0x32195         ||             IN   R1, 0x95
(0093)  CS-0x022  0x3A185         ||             ST   R1, 0x85
(0094)  CS-0x023  0x081D1         ||             CALL recHighest
(0095)  CS-0x024  0x32196         ||             IN   R1, 0x96
(0096)  CS-0x025  0x3A186         ||             ST   R1, 0x86
(0097)  CS-0x026  0x081D1         ||             CALL recHighest
(0098)  CS-0x027  0x32197         ||             IN   R1, 0x97
(0099)  CS-0x028  0x3A187         ||             ST   R1, 0x87
(0100)  CS-0x029  0x081D1         ||             CALL recHighest
(0101)  CS-0x02A  0x32198         ||             IN   R1, 0x98
(0102)  CS-0x02B  0x3A188         ||             ST   R1, 0x88
(0103)  CS-0x02C  0x081D1         ||             CALL recHighest
(0104)  CS-0x02D  0x32199         ||             IN   R1, 0x99
(0105)  CS-0x02E  0x3A189         ||             ST   R1, 0x89
(0106)  CS-0x02F  0x081D1         ||             CALL recHighest
(0107)  CS-0x030  0x3219A         ||             IN   R1, 0x9A
(0108)  CS-0x031  0x3A18A         ||             ST   R1, 0x8A
(0109)  CS-0x032  0x081D1         ||             CALL recHighest
(0110)  CS-0x033  0x3219B         ||             IN   R1, 0x9B
(0111)  CS-0x034  0x3A18B         ||             ST   R1, 0x8B
(0112)  CS-0x035  0x081D1         ||             CALL recHighest
(0113)  CS-0x036  0x3219C         ||             IN   R1, 0x9C
(0114)  CS-0x037  0x3A18C         ||             ST   R1, 0x8C
(0115)  CS-0x038  0x081D1         ||             CALL recHighest
(0116)  CS-0x039  0x18002         ||             RET
(0117)                            || 
(0118)                     0x03A  || recHighest:                         ; Tracks the highest note address that has a "1"
(0119)  CS-0x03A  0x28201         ||             ADD  R2, 0x01           ; Increment the address
(0120)  CS-0x03B  0x30101         ||             CMP  R1, 0x01           ; Is this a 1?
(0121)  CS-0x03C  0x081F2         ||             BREQ isHighest
(0122)  CS-0x03D  0x18002         ||             RET                     ; If 0 --> RET without updating R24 (highest address)
(0123)  CS-0x03E  0x05811  0x03E  || isHighest:  MOV  R24, R2            ; If 1 --> Update R24 with the new highest note address
(0124)  CS-0x03F  0x18002         ||             RET
(0125)                            || 
(0126)                            || 
(0127)                     0x040  || practiceGuesses:
(0128)  CS-0x040  0x054A8         ||             CMP  R20, R21               ; Check if user's guess is correct
(0129)  CS-0x041  0x0821A         ||             BREQ guessCorrect
(0130)  CS-0x042  0x08238         ||             BRN  guessIncorrect
(0131)                     0x043  || guessCorrect:
(0132)  CS-0x043  0x055B1         || 			MOV  R21, R22				; Set new current note
(0133)  CS-0x044  0x29E01         ||             ADD  R30, 0x01              ; Increment user's score
(0134)  CS-0x045  0x35E81         ||             OUT  R30, SSEG_PORT         ; Output initial score
(0135)  CS-0x046  0x18002         ||             RET
(0136)                     0x047  || guessIncorrect:
(0137)  CS-0x047  0x36100         || 			MOV  R1, 0x00
(0138)  CS-0x048  0x34181         ||             OUT  R1, SSEG_PORT          ; Output zero score
(0139)  CS-0x049  0x14100         || 			WSP  R1						; Clear stack pointer when resetting the game
(0140)  CS-0x04A  0x08008         ||             BRN  start                  ; Restart the program
(0141)                            || 
(0142)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0143)                            || ; LEVELS GAME MODE
(0144)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0145)                            || 
(0146)                     0x04B  || levelMode:
(0147)  CS-0x04B  0x36C02         ||             MOV  R12, LVL2        ; Assign initial level
(0148)  CS-0x04C  0x34C81         || 			OUT  R12, SSEG_PORT   ; Output players level to sseg.
(0149)  CS-0x04D  0x36E00         ||             MOV  R14, 0x00        ; Assign initial score counter for correct guesses.
(0150)  CS-0x04E  0x37501         ||             MOV  R21, 0x01        ; Set first note to root (C) <-- If adding transpose, do it here.
(0151)  CS-0x04F  0x082A1         || 			CALL levelSet         ; Assign initial scratch ram values
(0152)                            || 
(0153)                     0x050  || gameMode:
(0154)  CS-0x050  0x084F1         ||             CALL playNote        ; Plays the note during the delay then turns off
(0155)  CS-0x051  0x085E9         ||             CALL checkNote       ; Checks players guess and generates next note
(0156)  CS-0x052  0x34C81         ||             OUT  R12, SSEG_PORT  ; Output players level to sseg.
(0157)  CS-0x053  0x08280         ||             BRN  gameMode        ; Continue game
(0158)                            || 
(0159)                            || 
(0160)                     0x054  || levelSet:                      			; Sets starting scratch ram values
(0161)  CS-0x054  0x36201         ||             MOV  R2, 0x01
(0162)  CS-0x055  0x37880         ||             MOV  R24, 0x80				; Set initial highest note address
(0163)  CS-0x056  0x082B8         ||             BRN  levelSetLoop
(0164)                            || 
(0165)                     0x057  || levelSetLoop:            
(0166)  CS-0x057  0x29801         ||             ADD  R24, 0x01				; Increment highest note address
(0167)  CS-0x058  0x042C3         ||             ST   R2, (R24)				; Move "1" into stack address
(0168)  CS-0x059  0x044C1         ||             MOV  R4, R24
(0169)  CS-0x05A  0x2C480         ||             SUB  R4, 0x80
(0170)  CS-0x05B  0x04460         ||             CMP  R4, R12				; Compare loop counter to player's level
(0171)  CS-0x05C  0x082BB         ||             BRNE levelSetLoop
(0172)  CS-0x05D  0x18002         ||             RET
(0173)                            || 
(0174)                            || 
(0175)                     0x05E  || levelGuesses:
(0176)  CS-0x05E  0x054A8         ||             CMP  R20, R21               ; Check if user's guess is correct
(0177)  CS-0x05F  0x0830A         ||             BREQ guessCorrect2
(0178)  CS-0x060  0x08378         ||             BRN  guessIncorrect2
(0179)                            || 
(0180)                     0x061  || guessCorrect2:
(0181)  CS-0x061  0x28E01         ||             ADD  R14, 0x01              ; Increment players score
(0182)  CS-0x062  0x36000         ||             MOV  R0,  0x00
(0183)  CS-0x063  0x29580         ||             ADD  R21, 0x80
(0184)  CS-0x064  0x040AB         ||             ST   R0,  (R21)
(0185)  CS-0x065  0x055B1         ||             MOV  R21, R22				; Set new current note
(0186)  CS-0x066  0x04C70         ||             CMP  R12, R14               ; Compare players score to players level
(0187)  CS-0x067  0x0834A         ||             BREQ levelUp
(0188)  CS-0x068  0x18002         ||             RET
(0189)                            || 
(0190)                     0x069  || levelUp:
(0191)  CS-0x069  0x28C01         ||             ADD  R12, 0x01              ; Increment players level
(0192)  CS-0x06A  0x36E00         ||             MOV  R14, 0x00              ; Reset players score
(0193)  CS-0x06B  0x30C0D         ||             CMP  R12, 0x0D				; Check if player is past level 12
(0194)  CS-0x06C  0x08392         ||             BREQ beatGame
(0195)  CS-0x06D  0x082A1         ||             CALL levelSet
(0196)  CS-0x06E  0x18002         ||             RET
(0197)                            || 
(0198)                     0x06F  || guessIncorrect2:
(0199)  CS-0x06F  0x36000         || 			MOV  R0, 0x00
(0200)  CS-0x070  0x14000         ||             WSP  R0						; Reset stack pointer to "0"
(0201)  CS-0x071  0x08258         ||             BRN  levelMode
(0202)                            || 
(0203)                     0x072  || beatGame:                               ; If player passes level 11, flash level 12 6 times
(0204)                            ||                                         ; then turn off sseg display
(0205)  CS-0x072  0x36000         ||             MOV  R0, 0x00
(0206)  CS-0x073  0x14000         ||             WSP  R0
(0207)  CS-0x074  0x34181         ||             OUT  R1, SSEG_PORT
(0208)  CS-0x075  0x08519         ||             CALL playNoteDelay
(0209)  CS-0x076  0x34C81         ||             OUT  R12, SSEG_PORT
(0210)  CS-0x077  0x08519         ||             CALL playNoteDelay
(0211)  CS-0x078  0x36100         ||             MOV  R1, 0x00
(0212)  CS-0x079  0x34181         ||             OUT  R1, SSEG_PORT
(0213)  CS-0x07A  0x08519         ||             CALL playNoteDelay
(0214)  CS-0x07B  0x34C81         ||             OUT  R12, SSEG_PORT
(0215)  CS-0x07C  0x08519         ||             CALL playNoteDelay
(0216)  CS-0x07D  0x34181         ||             OUT  R1, SSEG_PORT
(0217)  CS-0x07E  0x08519         ||             CALL playNoteDelay
(0218)  CS-0x07F  0x34C81         ||             OUT  R12, SSEG_PORT
(0219)  CS-0x080  0x08519         ||             CALL playNoteDelay
(0220)  CS-0x081  0x34181         ||             OUT  R1, SSEG_PORT
(0221)  CS-0x082  0x08519         ||             CALL playNoteDelay
(0222)  CS-0x083  0x34C81         ||             OUT  R12, SSEG_PORT
(0223)  CS-0x084  0x08519         ||             CALL playNoteDelay
(0224)  CS-0x085  0x34181         ||             OUT  R1, SSEG_PORT
(0225)  CS-0x086  0x08519         ||             CALL playNoteDelay
(0226)  CS-0x087  0x34C81         ||             OUT  R12, SSEG_PORT
(0227)  CS-0x088  0x08519         ||             CALL playNoteDelay
(0228)  CS-0x089  0x34181         ||             OUT  R1, SSEG_PORT
(0229)  CS-0x08A  0x08519         ||             CALL playNoteDelay
(0230)  CS-0x08B  0x34C81         ||             OUT  R12, SSEG_PORT
(0231)  CS-0x08C  0x08519         ||             CALL playNoteDelay
(0232)  CS-0x08D  0x34181         ||             OUT  R1, SSEG_PORT
(0233)  CS-0x08E  0x08519         ||             CALL playNoteDelay
(0234)  CS-0x08F  0x08640         ||             BRN  end
(0235)                            || 
(0236)                            || 			
(0237)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0238)                            || ; PLAY GAME MODE
(0239)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
(0240)                     0x090  || playMode:
(0241)                            || 					
(0242)  CS-0x090  0x084A9         || 			CALL listenforInput ;Loop playing '0'
(0243)  CS-0x091  0x084F1         || 			CALL playNote
(0244)  CS-0x092  0x31D01         || 			CMP  R29, 0x01
(0245)  CS-0x093  0x084D2         || 			BREQ outputplay	
(0246)  CS-0x094  0x08480         || 			BRN  playMode			
(0247)                            || 			
(0248)                     0x095  || listenforInput: 
(0249)  CS-0x095  0x37500         || 			MOV  R21, 0x00
(0250)  CS-0x096  0x31D01         || 			CMP  R29, 0x01
(0251)  CS-0x097  0x084CA         || 			BREQ returner
(0252)  CS-0x098  0x1A000         || 			SEI
(0253)                     0x099  || returner:					 		
(0254)  CS-0x099  0x18002         || 			RET
(0255)                            || 			
(0256)                     0x09A  || outputplay:
(0257)  CS-0x09A  0x055A1         || 			MOV  R21, R20 
(0258)  CS-0x09B  0x084F1         || 			CALL playNote
(0259)  CS-0x09C  0x37D00         || 			MOV  R29, 0x00 
(0260)  CS-0x09D  0x08480         || 			BRN  playMode
(0261)                            || 
(0262)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0263)                            || ; SHARED FUNCTIONS
(0264)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0265)                            || 
(0266)                            || 
(0267)                     0x09E  || playNote:                               ; Assumes R21 holds a value [0,12]
(0268)  CS-0x09E  0x35582         ||             OUT  R21, SPEAKER_PORT      ; Play the test note
(0269)  CS-0x09F  0x08519         ||             CALL playNoteDelay          ; Wait `loopLength` of time
(0270)  CS-0x0A0  0x36100         || 			MOV  R1, 0x00
(0271)  CS-0x0A1  0x34182         ||             OUT  R1, SPEAKER_PORT     ; Stop playing the note
(0272)  CS-0x0A2  0x18002         ||             RET
(0273)                            || 
(0274)                     0x0A3  || playNoteDelay:
(0275)  CS-0x0A3  0x36180         ||             MOV  R1, OUTloopLength
(0276)                     0x0A4  || delayOUTER:
(0277)  CS-0x0A4  0x362FF         ||             MOV  R2, MIDloopLength
(0278)                     0x0A5  || delayMIDDLE:
(0279)  CS-0x0A5  0x363FF         ||             MOV  R3, INloopLength
(0280)                     0x0A6  || delayINNER:
(0281)  CS-0x0A6  0x2C301         ||             SUB  R3, 0x01
(0282)  CS-0x0A7  0x08533         ||             BRNE delayINNER
(0283)  CS-0x0A8  0x2C201         ||             SUB  R2, 0x01
(0284)  CS-0x0A9  0x0852B         ||             BRNE delayMIDDLE
(0285)  CS-0x0AA  0x2C101         ||             SUB  R1, 0x01
(0286)  CS-0x0AB  0x08523         ||             BRNE delayOUTER
(0287)  CS-0x0AC  0x18002         ||             RET
(0288)                            || 
(0289)                     0x0AD  || RNG2_next:
(0290)  CS-0x0AD  0x31D01         ||             CMP  R29, 0x01          ; Check that interrupt has not been called yet (due to user input)
(0291)  CS-0x0AE  0x0858B         ||             BRNE RNG_TEST           ; If not, continue the RNG
(0292)  CS-0x0AF  0x18002         ||             RET                     ; Else return
(0293)                     0x0B0  || RNG2:
(0294)  CS-0x0B0  0x37680         ||             MOV  R22, 0x80           ; Start looking for new note at 0x80 (1 pos before first note)
(0295)                     0x0B1  || RNG_TEST:
(0296)  CS-0x0B1  0x058B0         ||             CMP  R24, R22           ; Check it isn't past the last valid (active) note
(0297)  CS-0x0B2  0x08582         ||             BREQ RNG2               ; If it is (R22>R24), BRN to restart at 0x80
(0298)  CS-0x0B3  0x29601         ||             ADD  R22, 0x01          ; Otherwise, increment the nextNote value
(0299)  CS-0x0B4  0x08568         ||             BRN  RNG2_next          ; and keep going! (check interrupt, and increment again)
(0300)                            || 
(0301)                     0x0B5  || noteSelector:
(0302)  CS-0x0B5  0x043B2         ||             LD   R3, (R22)          ; Whatever value R22 got from RNG, load that note address into R3.
(0303)  CS-0x0B6  0x30301         ||             CMP  R3, 0x01           ; If 1, it is a switched "on" note; otherwise, it is "off" and we need a new note
(0304)  CS-0x0B7  0x0860A         ||             BREQ noteChecker        ; 1 --> We have found our next note! Proceed to check current note vs. user guess
(0305)  CS-0x0B8  0x29601         ||             ADD  R22, 0x01          ; 0 --> Increment the note selection until we find a note that is "on" (1).
(0306)  CS-0x0B9  0x3168D         ||             CMP  R22, 0x8D          ; If the address is not an Out-of-Bounds (OOB) value...
(0307)  CS-0x0BA  0x085AB         ||             BRNE noteSelector       ; ... loop to keep searching!
(0308)  CS-0x0BB  0x37680         ||             MOV  R22, 0x80          ; Otherwise, wrap around to the beginning of the addresses
(0309)  CS-0x0BC  0x085A8         ||             BRN  noteSelector       ; And then keep searching!
(0310)                            || 
(0311)                     0x0BD  || checkNote:
(0312)  CS-0x0BD  0x1A000         ||             SEI                         ; Set enable interupt
(0313)                     0x0BE  || waitForInt:
(0314)  CS-0x0BE  0x08581         ||             CALL RNG2                   ; Calculate random number
(0315)  CS-0x0BF  0x37D00         || 			MOV  R29, 0x00				; Reset interupt flag register
(0316)                            || 
(0317)  CS-0x0C0  0x085A8         ||             BRN  noteSelector           ; Translate random number to random note
(0318)                            || 
(0319)                     0x0C1  || noteChecker:
(0320)  CS-0x0C1  0x2D680         || 			SUB  R22, 0x80				; Get new note value
(0321)  CS-0x0C2  0x31001         ||             CMP  R16, 0x01              ; Check players game mode
(0322)  CS-0x0C3  0x082F2         ||             BREQ levelGuesses
(0323)  CS-0x0C4  0x08200         ||             BRN  practiceGuesses
(0324)                            || 
(0325)                            || 
(0326)  CS-0x0C5  0x37D01  0x0C5  || ISR:        MOV  R29, 0x01              ; Set flag that interrupt was triggered
(0327)  CS-0x0C6  0x33480         ||             IN   R20, KEYPAD_PORT       ; Read user's guess from port
(0328)  CS-0x0C7  0x1A002         ||             RETID
(0329)                            || 
(0330)                     0x0C8  || end:
(0331)  CS-0x0C8  0x08640         ||             BRN  end
(0332)                            || 
(0333)                       1023  || .ORG  0x3FF
(0334)  CS-0x3FF  0x08628         ||             BRN  ISR
(0335)                            || 
(0336)                            || 





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
BEATGAME       0x072   (0203)  ||  0194 
CHECKNOTE      0x0BD   (0311)  ||  0061 0155 
DELAYINNER     0x0A6   (0280)  ||  0282 
DELAYMIDDLE    0x0A5   (0278)  ||  0284 
DELAYOUTER     0x0A4   (0276)  ||  0286 
END            0x0C8   (0330)  ||  0234 0331 
GAMEMODE       0x050   (0153)  ||  0157 
GUESSCORRECT   0x043   (0131)  ||  0129 
GUESSCORRECT2  0x061   (0180)  ||  0177 
GUESSINCORRECT 0x047   (0136)  ||  0130 
GUESSINCORRECT2 0x06F   (0198)  ||  0178 
ISHIGHEST      0x03E   (0123)  ||  0121 
ISR            0x0C5   (0326)  ||  0334 
LEVELGUESSES   0x05E   (0175)  ||  0322 
LEVELMODE      0x04B   (0146)  ||  0046 0201 
LEVELSET       0x054   (0160)  ||  0151 0195 
LEVELSETLOOP   0x057   (0165)  ||  0163 0171 
LEVELUP        0x069   (0190)  ||  0187 
LISTENFORINPUT 0x095   (0248)  ||  0242 
NOTECHECKER    0x0C1   (0319)  ||  0304 
NOTESELECTOR   0x0B5   (0301)  ||  0307 0309 0317 
OUTPUTPLAY     0x09A   (0256)  ||  0245 
PLAYMODE       0x090   (0240)  ||  0048 0246 0260 
PLAYNOTE       0x09E   (0267)  ||  0060 0154 0243 0258 
PLAYNOTEDELAY  0x0A3   (0274)  ||  0208 0210 0213 0215 0217 0219 0221 0223 0225 0227 
                               ||  0229 0231 0233 0269 
PRACTICEGUESSES 0x040   (0127)  ||  0323 
PRACTICELOOP   0x00A   (0059)  ||  0058 0062 
PRACTICEMODE   0x007   (0055)  ||  0049 
READSWITCHES   0x014   (0078)  ||  0065 
RECHIGHEST     0x03A   (0118)  ||  0082 0085 0088 0091 0094 0097 0100 0103 0106 0109 
                               ||  0112 0115 
RETURNER       0x099   (0253)  ||  0251 
RNG2           0x0B0   (0293)  ||  0297 0314 
RNG2_NEXT      0x0AD   (0289)  ||  0299 
RNG_TEST       0x0B1   (0295)  ||  0291 
SETUP          0x00D   (0064)  ||  0057 
SSEGSET        0x012   (0074)  ||  
START          0x001   (0043)  ||  0140 
WAITFORINT     0x0BE   (0313)  ||  


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
GAMEMODE_PORT  0x085   (0018)  ||  0044 
INLOOPLENGTH   0x0FF   (0010)  ||  0279 
INSECLOOPLENGTH 0x0B4   (0014)  ||  
KEYPAD_PORT    0x080   (0005)  ||  0327 
LVL2           0x002   (0020)  ||  0147 
MIDLOOPLENGTH  0x0FF   (0011)  ||  0277 
MIDSECLOOPLENGTH 0x0CA   (0015)  ||  
OUTLOOPLENGTH  0x080   (0012)  ||  0275 
OUTSECLOOPLENGTH 0x0AA   (0016)  ||  
SPEAKER_PORT   0x082   (0008)  ||  0268 0271 
SSEG_PORT      0x081   (0007)  ||  0069 0074 0134 0138 0148 0156 0207 0209 0212 0214 
                               ||  0216 0218 0220 0222 0224 0226 0228 0230 0232 
SWITCH_PORT_END 0x09C   (0004)  ||  
SWITCH_PORT_START 0x090   (0003)  ||  
TIMED          0x00F   (0021)  ||  


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
