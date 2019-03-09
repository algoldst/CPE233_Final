
.EQU SWITCH_PORT_START = 0x90
.EQU SWITCH_PORT_END = 0x9C
.EQU KEYPAD_PORT = 0x80
.EQU SSEG_PORT = 0x81
.EQU SPEAKER_PORT = 0x82

.EQU loopLength = 0xFF

.CSEG
.ORG 0x01

; (Rx80-x8C) = Notes to Test
        ; 0:C, 1:C#, 2:D, 3:D#, 4:E, 5:F, 6:F#, 7:G, 8:G#, 9:A, 10:A#, 11:B, 12:C (2nd octave)
; R21 = Current Test Note
; R22 = Next Test Note
; R

start:
            CLI
            CALL setup
            CALL playNote               ; Sets interrupt and begins random # gen

playNote:
            OUT  R21, SPEAKER_PORT      ; Play the test note
            CALL playNoteDelay          ; Wait `loopLength` of time
            OUT  0x00, SPEAKER_PORT     ; Stop playing the note
            RET

playNoteDelay:
            MOV  R1, loopLength
delay_loop: SUB  R1, 0x01
            BRNE delay_loop
            RET


setup:
            CALL readSwitches           ; Read which notes to play.
                                        ;       1 --> Test player on note
                                        ;       0 --> Don't test
            OUT  0x00, SSEG_PORT        ; Set score = 0
            MOV  R22, 0x01              ; Set first note to root (C) <-- If adding transpose, do it here.
            RET

RNG:
            ADD  R20, 0x01
            CMP  R20, 0x0B
            BRCS RNG_modulus
RNG_modulus:
            SUB  R20, 0x0C
            BRN  RNG


; Set SSEG display value
ssegSet:    OUT  R1, SSEG_PORT
            RET

; Read in switches to query which notes to test on
readSwitches:
            MOV  R0, SWITCH_PORT_START  ; R0 tracks which switch to read
            IN   R1, (R0)               ; Hold switch value (1 or 0) in R1
            MOV  R2, 0x80               ; Start storing at 0x80
            ST   R1, (R2)
readNextSwitch:
            ADD  R0, 0x01               ; Increment the switch to read
            ADD  R2, 0x01               ; Increment the storage location
            IN   R1, (R0)               ; Read the next switch
            ST   R1, (R2)               ; Store its value in 0x80-0x8C
            CMP  R0, SWITCH_PORT_END    ; Have we reached the 12th switch?
            BRCC readNextSwitch         ; If not, keep reading...
            RET





