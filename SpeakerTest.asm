;Kadin Stephens CPE 233 Peripheral Assignment One/Example Use Code

.EQU OUT_PORT = 0x82
.EQU OUTloopLength = 0xFF
.EQU MIDloopLength = 0xFF
.EQU INloopLength = 0xFF

.CSEG
.ORG 0x01

Start:		MOV R0,	0x01
			
			OUT R0, OUT_PORT ;Plays note C
			CALL playNoteDelay
			CALL playNoteDelay
			CALL playNoteDelay
			MOV R0, 0x00
			OUT R0, OUT_PORT ; Stops playing
			BRN  Start
			
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
			
			
			BRN start
			
			