
.EQU SSEG = 0x81

.CSEG
.ORG 0x01

            MOV  R12, 0x01
start:
            OUT  R12, SSEG
            CALL delay
            ADD  R12, 0x01
            BRN  start



delay:
            MOV  R1, 0x01
delayOUTER:
            MOV  R2, 0x01
delayMIDDLE:
            MOV  R3, 0x01
delayINNER:
            SUB  R3, 0x01
            BRNE delayINNER
            SUB  R2, 0x01
            BRNE delayMIDDLE
            SUB  R1, 0x01
            BRNE delayOUTER
            RET
