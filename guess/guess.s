        .TITLE Guess the Number!
        TKS = 177560
        TKB = 177562
        TPS = 177564
        TPB = 177566
        LKS = 777546
        STACK = 2000

        .ASECT
.=1000
start:   
        MOV     #STACK, SP 
        MOV     #HELLO, R0
        CALL    PRINT
        CALL    GETC
        BIC     #177400, R3
        MOV     R3, @#RND
LOOP:   MOV     #PROMPT, R0
        CALL    PRINT
       
        CALL    RDNUM
        CMP     @#RND, R0
        BEQ     1$
        BLT     0$
        MOV     #HIGHER, R0
        CALL    PRINT
        JMP     LOOP
0$:     MOV     #LOWER, R0
        CALL    PRINT
        JMP     LOOP
1$:     MOV     #WELLD, R0
        CALL    PRINT
        HALT

; read a decimal number from TTI
; returns: number in r0
RDNUM:  CLR     R1 
NXTDIG: CALL    GETC
        CMP     #15, R0
        BEQ     0$
        CALL    PUTC
        SUB     #60,R0
        ASL     R1
        MOV     R1,R2
        ASL     R1
        ASL     R1
        ADD     R2,R1
        ADD     R0,R1
        JMP     NXTDIG
0$:     MOV     #NEWLINE, R0
        CALL    PRINT
        MOV     R1,R0 
        RTS     PC

; read a char from TTI 
; returns: char in R0 
; side-effect: increment R3 while waiting to generate "random" number
GETC:   
0$:     INC     R3 
        TSTB    @#TKS
        BPL     0$
        MOVB    @#TKB, R0
        RTS     PC

; put a char to TTO
; R0: the char
PUTC:   MOV     R0, @#TPB
1$:     TSTB    @#TPS
        BPL     1$
        RTS     PC        

; print a NULL terminated string to TTO
; R0: Address of String
PRINT:  MOVB    (R0)+, @#TPB
        BEQ     0$
1$:     TSTB    @#TPS
        BPL     1$
        JMP     PRINT
0$:     RTS     PC

        .PSECT  DATA, REL, RW
RND:    .WORD   0
HELLO:  .ASCIZ  /=============================================/<15><12>/| Guess the Number (0-255) - PDP11 Edition. |/<15><12>/=============================================/<15><12>/
PROMPT: .ASCIZ  /> /
WELLD:  .ASCIZ  /You guessed it! Well done!/<15><12>/
HIGHER: .ASCIZ  /Higher.../<15><12>/
LOWER:  .ASCIZ  /Lower.../<15><12>/
NEWLINE:.ASCIZ  //<15><12>/
