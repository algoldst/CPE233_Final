
                                        ; INPUTS
.EQU SWITCH_PORT_START = 0x90           ; Switches. Port #1,2,3,4,5,6,7,8,....12
.EQU SWITCH_PORT_END = 0x9C             ; Final switch port value (switch 12)
.EQU KEYPAD_PORT = 0x80                 ; Keypad input port
                                        ; OUTPUTS
.EQU SSEG_PORT = 0x81                   ; SSEG shows
.EQU SPEAKER_PORT = 0x82

.EQU INloopLength = 0xFF
.EQU MIDloopLength = 0xFF
.EQU OUTloopLength = 0xFF

.CSEG
.ORG 0x01

; REGISTERS USED:
; (Rx80-x8C) = Notes to Test
    ; 0:C, 1:C#, 2:D, 3:D#, 4:E, 5:F, 6:F#, 7:G, 8:G#, 9:A, 10:A#, 11:B, 12:C (2nd octave)
; R21 = Current Test Note
; R22 = Next Test Note
; R29 = Interrupt Flag
; R30 = User Score
; R31 = Function default return register

start:
            CLI
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
            OUT  0x00, SPEAKER_PORT     ; Stop playing the note
            RET

delay:
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
            MOV  R22, 0x01              ; Set first note to root (C) <-- If adding transpose, do it here.
            RET

RNG:                                    ; Find the next valid note (eg. next note that has a 1) -- looking in reverse!
                                            ; Why reverse? Because we have comparator for <, but not > (only >=).
            MOV  R1, R21                ; Start looking from the current note (check R21).
            CALL getNoteAddr            ; Get this note's address >> R31
            MOV  R1, R31
RNG_next:   SUB  R1, 0x01               ; Move to previous note to check there
            CMP  R1, SWITCH_PORT_START  ; Check it isn't past the first note
            BRCS RNG_wrap               ; If it is an invalid port, begin again at the final note port
            LD   R2, (R1)               ; If valid, check the note is enabled (=1)
            CMP  R2, 0x01
            BRNE RNG_next               ; If 0, go to next note
            CALL getNote                ; If 1, get that note [1,12]
            MOV  R22, R31                ; ...and store it in R22 (next test note)
            CMP  R29, 0X01              ; Check if the interupt was triggered
            BRNE RNG_next
            RET
RNG_wrap:
            ADD  R20, 0x0E              ; Add 0x0E because we're at -1, need to go +1 past end (bc of sub in RNG_next).
            BRN  RNG_next

getNoteAddr:                            ; Returns note address (0x90+) based on note number.
                                        ; getNoteAddr(R1=[1,12]) >> R31
            SUB  R1, 0x01
            ADD  R1, SWITCH_PORT_START
            MOV  R31, R1
            RET

getNote:                                ; getNote(R1=Address[0x90+]) >> R31
                                        ; Returns note [1,12] from address
            ADD  R1, 0x01
            SUB  R1, SWITCH_PORT_START
            MOV  R31, R1
            RET

; Set SSEG display value
ssegSet:    OUT  R1, SSEG_PORT
            RET

; Read in switches to query which notes to test on
readSwitches:
            MOV  R0, SWITCH_PORT_START  ; R0 tracks which switch to read
            IN   R1, R0               ; Hold switch value (1 or 0) in R1
            MOV  R2, 0x80               ; Start storing at 0x80
            ST   R1, (R2)
readNextSwitch:
            ADD  R0, 0x01               ; Increment the switch to read
            ADD  R2, 0x01               ; Increment the storage location
            IN   R1, (R0)               ; Read the next switch
            ST   R1, (R2)               ; Store its value in 0x80-0x8C
            CMP  R0, SWITCH_PORT_END    ; Have we reached the 12th switch?
            BREQ readNextSwitch         ; If not, keep reading...
            RET


checkNote:
            SEI                         ; Set enable interupt
waitForInt:
            CALL RNG                    ; Calculate next note while waiting for interupt

noteChecker:
            MOV  R2, R20                ; Duplicate the note value
            CMP  R2, R1                 ; Check if user's guess is correct
            BREQ guessCorrect
            BRN  reset
guessCorrect:
            ADD  R30, 0x01              ; Increment user's score
            OUT  R30, SSEG_PORT         ; Output initial score
            RET
guessIncorrect:
            OUT  0x00, SSEG_PORT        ; Output zero score
            BRN  start                  ; Restart the program

ISR:        MOV  R29, 0x01              ; Set flag that interrupt was triggered
            IN   R20, KEYPAD_PORT       ; Read user's guess from port
            RETID

.ORG  0x3FF
            BRN  ISR
