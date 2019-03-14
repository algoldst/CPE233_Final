
 ; INPUTS
.EQU SWITCH_PORT_START = 0x90           ; Switches. Port #1,2,3,4,5,6,7,8,....12
.EQU SWITCH_PORT_END = 0x9C             ; Final switch port value (switch 12)
.EQU KEYPAD_PORT = 0x80                 ; Keypad input port
                                        ; OUTPUTS
.EQU SSEG_PORT = 0x81                   ; SSEG shows
.EQU SPEAKER_PORT = 0x82

.EQU INloopLength = 0xFF
.EQU MIDloopLength = 0xFF
.EQU OUTloopLength = 0x80

.EQU INsecloopLength = 0xB4
.EQU MIDsecloopLength = 0xCA
.EQU OUTsecloopLength = 0xAA

.EQU GameMode_PORT = 0x85

.EQU  LVL2 = 2
.EQU  TIMED = 15


.CSEG
.ORG 0x01

; REGISTERS USED:
; (Rx81-x8C) = Notes to Test
    ; 1:C, 2:C#, 3:D, 4:D#, 5:E, 6:F, 7:F#, 8:G, 9:G#, 10:A, 11:A#, 12:B (2nd octave)
; R12: Player level
; R14: Score counter
; R15: Time counter
; R16: Game mode
; R17: Second delay value
; R20 = User note guess
; R21 = Current Test Note
; R22 = Next Test Note
; R24 = Top Active Note Address (the highest note that was "1" active)
; R29 = Interrupt Flag
; R30 = User Score
; R31 = Function default return register

start:
            IN   R16, GameMode_PORT ; Retrieve what game mode player selected
            CMP  R16, 0x01          ; Check if player selected Level Mode
            BREQ levelMode
			CMP  R16, 0x02			;Check if player selected Time Mode
			BREQ playMode
            BRN  practiceMode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRACTICE GAME MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

practiceMode:
            CLI
			CALL setup
            BRN  practiceLoop
practiceLoop:
            CALL playNote               ; Sets interrupt and begins random # gen
            CALL checkNote              ; Waits for Interupt and then checks User's Guess
            BRN  practiceLoop           ; Moves on to next round

setup:
            CALL readSwitches           ; Read which notes to play.
                                        ;       1 --> Test player on note
                                        ;       0 --> Don't test
            MOV  R30, 0x00              ; Set score = 0
            OUT  R30, SSEG_PORT         ; Output initial score
            MOV  R21, 0x01              ; Set first note to root (C) <-- If adding transpose, do it here.
            RET

; Set SSEG display value
ssegSet:    OUT  R1, SSEG_PORT
            RET

; Read in switches to query which notes to test on
readSwitches:
            MOV  R2, 0x80       ; R2 tracks what note we are reading in (starts from 1 before first note address)
            IN   R1, 0x91       ; Read in the switch 1 (Root note, note 1, "C", etc.) --> [1 or 0]
            ST   R1, 0x81       ; Store it in RAM
            CALL recHighest     ; Record if this is the highest note position that has a 1
            IN   R1, 0x92       ; Read the rest of the switches 1-12
            ST   R1, 0x82       ; Notes that are active will be tested on. Inactive notes will be skipped over.
            CALL recHighest
            IN   R1, 0x93
            ST   R1, 0x83
            CALL recHighest
            IN   R1, 0x94
            ST   R1, 0x84
            CALL recHighest
            IN   R1, 0x95
            ST   R1, 0x85
            CALL recHighest
            IN   R1, 0x96
            ST   R1, 0x86
            CALL recHighest
            IN   R1, 0x97
            ST   R1, 0x87
            CALL recHighest
            IN   R1, 0x98
            ST   R1, 0x88
            CALL recHighest
            IN   R1, 0x99
            ST   R1, 0x89
            CALL recHighest
            IN   R1, 0x9A
            ST   R1, 0x8A
            CALL recHighest
            IN   R1, 0x9B
            ST   R1, 0x8B
            CALL recHighest
            IN   R1, 0x9C
            ST   R1, 0x8C
            CALL recHighest
            RET

recHighest:                         ; Tracks the highest note address that has a "1"
            ADD  R2, 0x01           ; Increment the address
            CMP  R1, 0x01           ; Is this a 1?
            BREQ isHighest
            RET                     ; If 0 --> RET without updating R24 (highest address)
isHighest:  MOV  R24, R2            ; If 1 --> Update R24 with the new highest note address
            RET


practiceGuesses:
            CMP  R20, R21               ; Check if user's guess is correct
            BREQ guessCorrect
            BRN  guessIncorrect
guessCorrect:
			MOV  R21, R22				; Set new current note
            ADD  R30, 0x01              ; Increment user's score
            OUT  R30, SSEG_PORT         ; Output initial score
            RET
guessIncorrect:
			MOV  R1, 0x00
            OUT  R1, SSEG_PORT          ; Output zero score
			WSP  R1						; Clear stack pointer when resetting the game
            BRN  start                  ; Restart the program

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LEVELS GAME MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

levelMode:
            MOV  R12, LVL2        ; Assign initial level
			OUT  R12, SSEG_PORT   ; Output players level to sseg.
            MOV  R14, 0x00        ; Assign initial score counter for correct guesses.
            MOV  R21, 0x01        ; Set first note to root (C) <-- If adding transpose, do it here.
			CALL levelSet         ; Assign initial scratch ram values

gameMode:
            CALL playNote        ; Plays the note during the delay then turns off
            CALL checkNote       ; Checks players guess and generates next note
            OUT  R12, SSEG_PORT  ; Output players level to sseg.
            BRN  gameMode        ; Continue game


levelSet:                      			; Sets starting scratch ram values
            MOV  R2, 0x01
            MOV  R24, 0x80				; Set initial highest note address
            BRN  levelSetLoop

levelSetLoop:            
            ADD  R24, 0x01				; Increment highest note address
            ST   R2, (R24)				; Move "1" into stack address
            MOV  R4, R24
            SUB  R4, 0x80
            CMP  R4, R12				; Compare loop counter to player's level
            BRNE levelSetLoop
            RET


levelGuesses:
            CMP  R20, R21               ; Check if user's guess is correct
            BREQ guessCorrect2
            BRN  guessIncorrect2

guessCorrect2:
            ADD  R14, 0x01              ; Increment players score
            MOV  R0,  0x00
            ADD  R21, 0x80
            ST   R0,  (R21)
            MOV  R21, R22				; Set new current note
            CMP  R12, R14               ; Compare players score to players level
            BREQ levelUp
            RET

levelUp:
            ADD  R12, 0x01              ; Increment players level
            MOV  R14, 0x00              ; Reset players score
            CMP  R12, 0x0D				; Check if player is past level 12
            BREQ beatGame
            CALL levelSet
            RET

guessIncorrect2:
			MOV  R0, 0x00
            WSP  R0						; Reset stack pointer to "0"
            BRN  levelMode

beatGame:                               ; If player passes level 11, flash level 12 6 times
                                        ; then turn off sseg display
            MOV  R0, 0x00
            WSP  R0
            OUT  R1, SSEG_PORT
            CALL playNoteDelay
            OUT  R12, SSEG_PORT
            CALL playNoteDelay
            MOV  R1, 0x00
            OUT  R1, SSEG_PORT
            CALL playNoteDelay
            OUT  R12, SSEG_PORT
            CALL playNoteDelay
            OUT  R1, SSEG_PORT
            CALL playNoteDelay
            OUT  R12, SSEG_PORT
            CALL playNoteDelay
            OUT  R1, SSEG_PORT
            CALL playNoteDelay
            OUT  R12, SSEG_PORT
            CALL playNoteDelay
            OUT  R1, SSEG_PORT
            CALL playNoteDelay
            OUT  R12, SSEG_PORT
            CALL playNoteDelay
            OUT  R1, SSEG_PORT
            CALL playNoteDelay
            OUT  R12, SSEG_PORT
            CALL playNoteDelay
            OUT  R1, SSEG_PORT
            CALL playNoteDelay
            BRN  end

			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PLAY GAME MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
playMode:
					
			CALL listenforInput ;Loop playing '0'
			CALL playNote
			CMP  R29, 0x01
			BREQ outputplay	
			BRN  playMode			
			
listenforInput: 
			MOV  R21, 0x00
			CMP  R29, 0x01
			BREQ returner
			SEI
returner:					 		
			RET
			
outputplay:
			MOV  R21, R20 
			CALL playNote
			MOV  R29, 0x00 
			BRN  playMode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SHARED FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


playNote:                               ; Assumes R21 holds a value [0,12]
            OUT  R21, SPEAKER_PORT      ; Play the test note
            CALL playNoteDelay          ; Wait `loopLength` of time
			MOV  R1, 0x00
            OUT  R1, SPEAKER_PORT     ; Stop playing the note
            RET

playNoteDelay:
            MOV  R1, OUTloopLength
delayOUTER:
            MOV  R2, MIDloopLength
delayMIDDLE:
            MOV  R3, INloopLength
delayINNER:
            SUB  R3, 0x01
            BRNE delayINNER
            SUB  R2, 0x01
            BRNE delayMIDDLE
            SUB  R1, 0x01
            BRNE delayOUTER
            RET

RNG2_next:
            CMP  R29, 0x01          ; Check that interrupt has not been called yet (due to user input)
            BRNE RNG_TEST           ; If not, continue the RNG
            RET                     ; Else return
RNG2:
            MOV  R22, 0x80           ; Start looking for new note at 0x80 (1 pos before first note)
RNG_TEST:
            CMP  R24, R22           ; Check it isn't past the last valid (active) note
            BREQ RNG2               ; If it is (R22>R24), BRN to restart at 0x80
            ADD  R22, 0x01          ; Otherwise, increment the nextNote value
            BRN  RNG2_next          ; and keep going! (check interrupt, and increment again)

noteSelector:
            LD   R3, (R22)          ; Whatever value R22 got from RNG, load that note address into R3.
            CMP  R3, 0x01           ; If 1, it is a switched "on" note; otherwise, it is "off" and we need a new note
            BREQ noteChecker        ; 1 --> We have found our next note! Proceed to check current note vs. user guess
            ADD  R22, 0x01          ; 0 --> Increment the note selection until we find a note that is "on" (1).
            CMP  R22, 0x8D          ; If the address is not an Out-of-Bounds (OOB) value...
            BRNE noteSelector       ; ... loop to keep searching!
            MOV  R22, 0x80          ; Otherwise, wrap around to the beginning of the addresses
            BRN  noteSelector       ; And then keep searching!

checkNote:
            SEI                         ; Set enable interupt
waitForInt:
            CALL RNG2                   ; Calculate random number
			MOV  R29, 0x00				; Reset interupt flag register

            BRN  noteSelector           ; Translate random number to random note

noteChecker:
			SUB  R22, 0x80				; Get new note value
            CMP  R16, 0x01              ; Check players game mode
            BREQ levelGuesses
            BRN  practiceGuesses


ISR:        MOV  R29, 0x01              ; Set flag that interrupt was triggered
            IN   R20, KEYPAD_PORT       ; Read user's guess from port
            RETID

end:
            BRN  end

.ORG  0x3FF
            BRN  ISR


