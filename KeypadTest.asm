
.EQU KEY_PORT = 0x80
.EQU SSEG = 0x81
.CSEG
.ORG 0x01

start:
            SEI
loops:
            BRN  loops

ISR:
            IN   R1, KEY_PORT
            OUT  R1, SSEG
            RETID

.ORG 0x3FF
            BRN  ISR
