;===========================================================
; 8051 PROGRAM
; 8-Digit 7-Segment Display
; Message: BE3-uPuC
;
; P0  -> Segment data
; P2  -> Digit selection
; P1  -> 8 Push Buttons
;
; Button:
; P1.0 -> Steady Display
; P1.1 -> Blinking Display
; P1.2 -> Roll Left
; P1.3 -> Roll Right
; P1.4 -> Odd Digit Blink
; P1.5 -> Even Digit Blink
; P1.6 -> Outside to Inside
; P1.7 -> Inside to Outside
;
; Common Anode Display
;===========================================================

            ORG 0000H

;-----------------------------------------------------------
; RAM VARIABLES
;-----------------------------------------------------------

MSG_LOOP2   EQU 30H
SEG_LOOP2   EQU 31H
LOOP_RUNNER EQU 32H

MSG_LOOP21  EQU 33H
SEG_LOOP21  EQU 34H
LOOP_RUNNER1 EQU 35H

;===========================================================
; MAIN INITIALIZATION
;===========================================================

MAIN:
            MOV R3,#00H          ; Display message index
            MOV R4,#07H          ; Segment selector
            MOV R5,#20H          ; Display loop counter
            MOV R6,#10H          ; Rolling counter

            MOV P1,#0FFH         ; Port 1 as input

            LJMP CHECK_BUTTON

;===========================================================
; STEADY DISPLAY
;===========================================================

STEADY:

            MOV DPTR,#SEG_TABN

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            INC R3
            DEC R4

            CJNE R3,#08H,STEADY

            LCALL CHECKER

            MOV R3,#00H
            MOV R4,#07H

            SJMP STEADY

;===========================================================
; BLINKING DISPLAY
;===========================================================

BLINKING:

            MOV DPTR,#SEG_TABN

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            INC R3
            DEC R4

            CJNE R3,#08H,BLINKING

            LCALL CHECKER

            MOV R3,#00H
            MOV R4,#07H

            DJNZ R5,BLINKING

            MOV R5,#20H

            MOV P0,#0FFH
            MOV P2,#0FFH

            LCALL MEDIUM_DELAY

            SJMP BLINKING

;===========================================================
; CHECK FIRST FOUR BUTTONS
;===========================================================

CHECK_BUTTON:

            JNB P1.0,STEADY
            JNB P1.1,BLINKING
            JNB P1.2,ROLL_LEFT_MAIN
            JNB P1.3,ROLL_RIGHT_MAIN

            LJMP CHECK_BUTTON1

;===========================================================
; ROLL LEFT
;===========================================================

ROLL_LEFT_MAIN:

            MOV R3,#10H
            MOV R6,#10H

ROLL_LEFT:

            MOV DPTR,#SEG_TABROLL

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            DJNZ R5,ROLL_LEFT

            MOV R5,#20H

            INC R3
            DEC R4

            CJNE R4,#0FFH,ROLL_LEFT

            LCALL CHECKER

            MOV R4,#07H

            DEC R6

            MOV R3,#06H

            CJNE R6,#0FFH,ROLL_LEFT

            SJMP ROLL_LEFT_MAIN

;===========================================================
; ROLL RIGHT
;===========================================================

ROLL_RIGHT_MAIN:

            MOV R3,#00H
            MOV R6,#00H

ROLL_RIGHT:

            MOV DPTR,#SEG_TABROLL

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            DJNZ R5,ROLL_RIGHT

            MOV R5,#20H

            INC R3
            DEC R4

            CJNE R4,#0FFH,ROLL_RIGHT

            LCALL CHECKER

            MOV R4,#07H

            INC R6

            MOV R3,#06H

            CJNE R6,#10H,ROLL_RIGHT

            SJMP ROLL_RIGHT_MAIN

;===========================================================
; CHECK BUTTONS 4 TO 5
;===========================================================

CHECK_BUTTON1:

            JNB P1.4,ODD_BLINK_MAIN
            JNB P1.5,EVEN_BLINK_MAIN

            LJMP CHECK_BUTTON2

;===========================================================
; ODD DIGIT BLINK
;===========================================================

ODD_BLINK_MAIN:

            MOV R5,#20H
            MOV R3,#00H
            MOV R4,#07H

ODD_BLINK:

            MOV DPTR,#SEG_TABN

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            INC R3
            DEC R4

            CJNE R3,#08H,ODD_BLINK

            LCALL CHECKER

            MOV R3,#00H
            MOV R4,#07H

            DJNZ R5,ODD_BLINK

            MOV R5,#20H

            MOV R3,#01H
            MOV R4,#06H

            SJMP ODD_BLANK

;-----------------------------------------------------------
; ODD BLANK / EVEN DIGITS
;-----------------------------------------------------------

ODD_BLANK:

            MOV DPTR,#SEG_TABN

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            INC R3
            DEC R4

            INC R3
            DEC R4

            CJNE R3,#09H,ODD_BLANK

            LCALL CHECKER

            MOV R3,#01H
            MOV R4,#06H

            DJNZ R5,ODD_BLANK

            MOV R5,#20H

            SJMP ODD_BLINK_MAIN

;===========================================================
; EVEN DIGIT BLINK
;===========================================================

EVEN_BLINK_MAIN:

            MOV R5,#20H

EVEN_BLINK:

            MOV DPTR,#SEG_TABN

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            INC R3
            DEC R4

            CJNE R3,#08H,EVEN_BLINK

            LCALL CHECKER

            MOV R3,#00H
            MOV R4,#07H

            DJNZ R5,EVEN_BLINK

            MOV R5,#20H

            SJMP EVEN_BLANK

;-----------------------------------------------------------
; EVEN BLANK / ODD DIGITS
;-----------------------------------------------------------

EVEN_BLANK:

            MOV DPTR,#SEG_TABN

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            INC R3
            DEC R4

            INC R3
            DEC R4

            CJNE R3,#08H,EVEN_BLANK

            LCALL CHECKER

            MOV R3,#00H
            MOV R4,#07H

            DJNZ R5,EVEN_BLANK

            MOV R5,#20H

            SJMP EVEN_BLINK

;===========================================================
; CHECK BUTTONS 6 AND 7
;===========================================================

CHECK_BUTTON2:

            JNB P1.6,OUT_IN_MAIN
            JNB P1.7,IN_OUT_MAIN

            LJMP CHECK_BUTTON

;===========================================================
; OUTSIDE TO INSIDE
;
; First loop:
; Message rolls from left to right for 4 digits
;
; Second loop:
; Message rolls from right to left for 4 digits
;===========================================================

OUT_IN_MAIN:

            MOV R3,#07H
            MOV R4,#07H
            MOV R6,#07H

            MOV MSG_LOOP2,#0DH
            MOV SEG_LOOP2,#03H
            MOV LOOP_RUNNER,#04H

            MOV R7,#0DH
            MOV R5,#20H

OUT_IN:

            ; First digit

            MOV DPTR,#SEG_TABNO

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            ; Second digit

            MOV DPTR,#SEG_TABNO

            MOV A,MSG_LOOP2
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,SEG_LOOP2
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            DJNZ R5,OUT_IN

            MOV R5,#20H

            INC R3
            DEC R4

            INC MSG_LOOP2
            DEC SEG_LOOP2

            MOV A,SEG_LOOP2

            CJNE A,#0FFH,OUT_IN

            LCALL CHECKER

            MOV R4,#07H

            DEC R6

            MOV R3,#06H

            MOV SEG_LOOP2,#03H

            INC R7

            MOV MSG_LOOP2,#07H

            DJNZ LOOP_RUNNER,OUT_IN

            LJMP STEADY

;===========================================================
; INSIDE TO OUTSIDE
;
; First loop:
; Message rolls from right to left for 4 digits
;
; Second loop:
; Message rolls from left to right for 4 digits
;===========================================================

IN_OUT_MAIN:

            MOV R3,#14H
            MOV R4,#03H
            MOV R6,#14H

            MOV MSG_LOOP21,#01H
            MOV SEG_LOOP21,#07H
            MOV LOOP_RUNNER1,#04H

            MOV R7,#01H
            MOV R5,#20H

IN_OUT:

            ; First digit

            MOV DPTR,#SEG_TABNO

            MOV A,R3
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,R4
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            ; Second digit

            MOV DPTR,#SEG_TABNO

            MOV A,MSG_LOOP21
            MOVC A,@A+DPTR
            MOV P0,A

            MOV DPTR,#SEG_TABS

            MOV A,SEG_LOOP21
            MOVC A,@A+DPTR
            MOV P2,A

            LCALL SMALL_DELAY

            MOV P2,#0FFH

            DJNZ R5,IN_OUT

            MOV R5,#20H

            INC R3
            DEC R4

            INC MSG_LOOP21
            DEC SEG_LOOP21

            MOV A,SEG_LOOP21

            CJNE A,#03H,IN_OUT

            LCALL CHECKER

            MOV R4,#03H

            DEC R6

            MOV R3,#06H

            MOV SEG_LOOP21,#07H

            INC R7

            MOV MSG_LOOP21,#07H

            DJNZ LOOP_RUNNER1,IN_OUT

            LJMP STEADY

;===========================================================
; CHECKER
;
; Checks whether any button has been pressed.
;===========================================================

CHECKER:

            JNB P1.0,CHECK_BUTTONS

            LCALL SMALL_DELAY
            LCALL SMALL_DELAY

            JNB P1.1,CHECK_BUTTONS

            LCALL SMALL_DELAY
            LCALL SMALL_DELAY

            JNB P1.2,CHECK_BUTTONS

            LCALL SMALL_DELAY
            LCALL SMALL_DELAY

            JNB P1.3,CHECK_BUTTONS

            LCALL SMALL_DELAY
            LCALL SMALL_DELAY

            JNB P1.4,CHECK_BUTTONS

            LCALL SMALL_DELAY
            LCALL SMALL_DELAY

            JNB P1.5,CHECK_BUTTONS

            LCALL SMALL_DELAY
            LCALL SMALL_DELAY

            JNB P1.6,CHECK_BUTTONS

            LCALL SMALL_DELAY
            LCALL SMALL_DELAY

            JNB P1.7,CHECK_BUTTONS

            LCALL SMALL_DELAY
            LCALL SMALL_DELAY

            RET

;===========================================================
; BUTTON CONFIRMATION
;===========================================================

CHECK_BUTTONS:

            MOV P0,#0FFH
            MOV P2,#0FFH

            MOV R3,#00H
            MOV R4,#07H

            LJMP MAIN

;===========================================================
; SMALL DELAY
;===========================================================

SMALL_DELAY:

            MOV R0,#0FFH

DEL:

            DJNZ R0,DEL

            RET

;===========================================================
; ONE SECOND DELAY
;===========================================================

DELAY:

            MOV R0,#0FFH
            MOV R1,#0FFH
            MOV R2,#09H

LOOP1:

            DJNZ R0,LOOP1

LOOP2:

            MOV R0,#0FFH
            DJNZ R1,LOOP1

LOOP3:

            MOV R1,#0FFH
            DJNZ R2,LOOP1

            RET

;===========================================================
; MEDIUM DELAY
; Approximately 0.5 Second
;===========================================================

MEDIUM_DELAY:

            MOV R0,#0FFH
            MOV R1,#0FFH
            MOV R2,#04H

LOOP11:

            DJNZ R0,LOOP11

LOOP12:

            MOV R0,#0FFH
            DJNZ R1,LOOP11

LOOP13:

            MOV R1,#0FFH
            DJNZ R2,LOOP11

            RET

;===========================================================
; 7-SEGMENT MESSAGE TABLE
;
; Message:
; B E 3 - u P u C
;
; Common Anode
;===========================================================

SEG_TABN:

            DB 00H
            DB 06H
            DB 30H
            DB 0BFH
            DB 63H
            DB 0CH
            DB 63H
            DB 0C6H

;===========================================================
; ROLLING MESSAGE TABLE
;
; 8 blank digits
; Message
; 8 blank digits
;===========================================================

SEG_TABROLL:

            DB 0FFH,0FFH,0FFH,0FFH
            DB 0FFH,0FFH,0FFH,0FFH

            DB 00H,06H,30H,0BFH
            DB 63H,0CH,63H,0C6H

            DB 0FFH,0FFH,0FFH,0FFH
            DB 0FFH,0FFH,0FFH,0FFH

;===========================================================
; OUT-IN / IN-OUT MESSAGE TABLE
;===========================================================

SEG_TABNO:

            DB 0FFH,0FFH,0FFH,0FFH
            DB 00H,06H,30H,0BFH

            DB 0FFH,0FFH,0FFH,0FFH
            DB 0FFH,0FFH,0FFH,0FFH
            DB 0FFH,63H,0CH,63H
            DB 0C6H

            DB 0FFH,0FFH,0FFH,0FFH

;===========================================================
; DIGIT SELECT TABLE
;
; Active LOW
; Rightmost digit -> Leftmost digit
;===========================================================

SEG_TABS:

            DB 0FEH
            DB 0FDH
            DB 0FBH
            DB 0F7H
            DB 0EFH
            DB 0DFH
            DB 0BFH
            DB 07FH

;===========================================================

            END