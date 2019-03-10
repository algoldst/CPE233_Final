                                        ; INPUTS
.EQU SWITCH_PORT_START = 0x90           ; Switches. Port #1,2,3,4,5,6,7,8,....12
.EQU SWITCH_PORT_END = 0x9C             ; Final switch port value (switch 12)
.EQU KEYPAD_PORT = 0x80                 ; Keypad input port
                                        ; OUTPUTS
.EQU SSEG_PORT = 0x81                   ; SSEG shows
.EQU SPEAKER_PORT = 0x82

.EQU INloopLength = 0x01
.EQU MIDloopLength = 0x01
.EQU OUTloopLength = 0x01

.CSEG
.ORG 0x01

; REGISTERS USED:
; (Rx81-x8C) = Notes to Test
    ; 1:C#, 2:D, 3:D#, 4:E, 5:F, 6:F#, 7:G, 8:G#, 9:A, 10:A#, 11:B, 12:C (2nd octave)
; R20 = User note guess
; R21 = Current Test Note
; R22 = Next Test Note
; R29 = Interrupt Flag
; R30 = User Score
; R31 = Function default return register

start:
            CLI
			CALL setup
            BRN  practiceLoop
practiceLoop:
            CALL playNote               ; Sets interrupt and begins random # gen
            CALL checkNote              ; Waits for Interupt and then checks User's Guess
            BRN  practiceLoop           ; Moves on to next round

            ;...
            BRN  end

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
            IN   R1, 0x91              
            ST   R1, 0x81               
            IN   R1, 0x92
            ST   R1, 0x82
            IN   R1, 0x93
            ST   R1, 0x83
            IN   R1, 0x94
            ST   R1, 0x84
            IN   R1, 0x95
            ST   R1, 0x85
            IN   R1, 0x96
            ST   R1, 0x86
            IN   R1, 0x97
            ST   R1, 0x87
            IN   R1, 0x98
            ST   R1, 0x88
            IN   R1, 0x99
            ST   R1, 0x89
            IN   R1, 0x9A
            ST   R1, 0x8A
            IN   R1, 0x9B
            ST   R1, 0x8B
            IN   R1, 0x9C
            ST   R1, 0x8C
            RET

RNG2:
            MOV  R1, 0x80
            MOV  R22, R1
            MOV  R2, 0x8C

RNG2_next:  
            CMP  R29, 0x01
            BRNE RNG_TEST
            RET
RNG_TEST:            
            ADD  R22, 0x01
            CMP  R22, R2
            BREQ RNG2
            BRN  RNG2_next

noteSelector:
            LD   R3, (R22)
            CMP  R3, 0x01
            BREQ noteChecker
            ADD  R22, 0x01
            CMP  R22, 0x8D
            BRNE noteSelector
            MOV  R22, 0x80
            BRN  noteSelector


checkNote:
            SEI                         ; Set enable interupt
waitForInt:
            CALL RNG2                   ; Calculate random number
			MOV  R29, 0x00				; Reset interupt flag register
            BRN  noteSelector           ; Translate random number to random note

noteChecker:
			SUB  R22, 0x80				; Get new note value
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

ISR:        MOV  R29, 0x01              ; Set flag that interrupt was triggered
            IN   R20, KEYPAD_PORT       ; Read user's guess from port
            RETID

end:
            BRN  end

.ORG  0x3FF
            BRN  ISR












; RNG:                                    ; Find the next valid note (eg. next note that has a 1) -- looking in reverse!
;                                         ; Why reverse? Because we have comparator for <, but not > (only >=).
;             MOV  R1, R21                ; Start looking from the current note (check R21).
;             CALL getNoteAddr            ; Get this note's address >> R31
;             MOV  R1, R31
; RNG_next:   SUB  R1, 0x01               ; Move to previous note to check there
;             CMP  R1, SWITCH_PORT_START  ; Check it isn't past the first note
;             BRCS RNG_wrap               ; If it is an invalid port, begin again at the final note port
;             LD   R2, (R1)               ; If valid, check the note is enabled (=1)
;             CMP  R2, 0x01
;             BRNE RNG_next               ; If 0, go to next note
;             CALL getNote                ; If 1, get that note [1,12]
;             MOV  R22, R31                ; ...and store it in R22 (next test note)
;             CMP  R29, 0X01              ; Check if the interupt was triggered
;             BRNE RNG_next
;             RET
; RNG_wrap:
;             ADD  R20, 0x0E              ; Add 0x0E because we're at -1, need to go +1 past end (bc of sub in RNG_next).
;             BRN  RNG_next

; getNoteAddr:                            ; Returns note address (0x90+) based on note number.
;                                         ; getNoteAddr(R1=[1,12]) >> R31
;             SUB  R1, 0x01
;             ADD  R1, SWITCH_PORT_START
;             MOV  R31, R1
;             RET

; getNote:                                ; getNote(R1=Address[0x90+]) >> R31
;                                         ; Returns note [1,12] from address
;             ADD  R1, 0x01
;             SUB  R1, SWITCH_PORT_START
;             MOV  R31, R1
;             RET

