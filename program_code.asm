RS EQU P2.7
RW EQU P2.6
E  EQU P2.5
BB EQU P2.3

ORG 00H
LJMP GO                                                  ;Skip Vector Table
ORG 0003H                                              ;ISR for EX1
      CLR P2.0
      SETB BB
      ACALL DINT
            ACALL TEXT1                                ;Dynamic Drip
      ACALL LINE2                                      ;Change Line
      ACALL TEXT4                                     ;Tank Empty
      EXIT2:ACALL DELAY1
      RETI
ORG 0013H                                              ;Interrupt Service Routine for EX0
                                                              ;Turn on the PUMP
      SETB P2.0
      ACALL DINT
      ACALL TEXT1                                     ;Dynamic Drip
      ACALL LINE2                                      ;Change Line
      ACALL TEXT3                                     ;[Low} Pump ON
      MOV R0,#100D
      EXIT1:ACALL DELAY
      DJNZ R0,EXIT1
      CLR P2.3
      RETI

ORG 0100H
GO:NOP
SETB P3.3
SETB P3.4
MOV IE,#10000101B
MOV TMOD,#00000001B                           ;Timer 0, Mode 1
MAIN:ACALL DINT
     ACALL TEXT1
     JNB P3.3, NEXT
     ACALL LINE2
     ACALL TEXT2
     CLR P2.0
     SJMP EXIT
NEXT:ACALL LINE2
     ACALL TEXT3
     SETB P2.0
     EXIT:ACALL DELAY1
SJMP MAIN


DELAY:
BACK1: MOV TH0,#0AAH  
       MOV TL0,#00000000B   
       SETB TR0             
HERE2: JNB TF0,HERE2         
       CLR TR0             
       CLR TF0             
       RET


TEXT1: MOV A,#"D"
    ACALL DISPLAY
    MOV A,#"y"
    ACALL DISPLAY
    MOV A,#"n"
    ACALL DISPLAY
    MOV A,#"a"
    ACALL DISPLAY
    MOV A,#"m"
    ACALL DISPLAY
    MOV A,#"i"
    ACALL DISPLAY
    MOV A,#"c"
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
    MOV A,#"D"
    ACALL DISPLAY
    MOV A,#"r"
    ACALL DISPLAY
    MOV A,#"i"
    ACALL DISPLAY
    MOV A,#"p"
    ACALL DISPLAY
    RET 
    
TEXT2: MOV A,#"["
    ACALL DISPLAY
         MOV A,#"M"
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
     MOV A,#"H"
    ACALL DISPLAY
    MOV A,#"i"
    ACALL DISPLAY
    MOV A,#"g"
    ACALL DISPLAY
    MOV A,#"h"
    ACALL DISPLAY
    MOV A,#"]"
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
    MOV A,#"P"
    ACALL DISPLAY
    MOV A,#"u"
    ACALL DISPLAY
    MOV A,#"m"
    ACALL DISPLAY
    MOV A,#"p"
    ACALL DISPLAY
    MOV A,#"O"
    ACALL DISPLAY
    MOV A,#"F"
    ACALL DISPLAY
    MOV A,#"F"
    ACALL DISPLAY
    RET 
    
TEXT3: MOV A,#"["
    ACALL DISPLAY
         MOV A,#"M"
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
    MOV A,#"L"
    ACALL DISPLAY
    MOV A,#"o"
    ACALL DISPLAY
    MOV A,#"w"
    ACALL DISPLAY
    MOV A,#"]"
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
    MOV A,#"P"
    ACALL DISPLAY
    MOV A,#"u"
    ACALL DISPLAY
    MOV A,#"m"
    ACALL DISPLAY
    MOV A,#"p"
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
    MOV A,#"O"
    ACALL DISPLAY
    MOV A,#"N"
    ACALL DISPLAY
    RET    

TEXT4: MOV A,#"T"
    ACALL DISPLAY
    MOV A,#"a"
    ACALL DISPLAY
    MOV A,#"n"
    ACALL DISPLAY
    MOV A,#"k"
    ACALL DISPLAY
    MOV A,#" "
    ACALL DISPLAY
    MOV A,#"E"
    ACALL DISPLAY
    MOV A,#"m"
    ACALL DISPLAY
    MOV A,#"p"
    ACALL DISPLAY
    MOV A,#"t"
    ACALL DISPLAY
    MOV A,#"y"
    ACALL DISPLAY
    MOV A,#"!"
    ACALL DISPLAY
    RET 
        
    

 DINT:MOV A,#0CH                 ;DIsplay ON,Cursor OFF
    ACALL CMD
    MOV A,#01H                       ;Clear Display
    ACALL CMD
    MOV A,#06H                       ;Increment Cursor
    ACALL CMD
    MOV A,#80H                       ;Force cursor to go to first line
    ACALL CMD
    MOV A,#3CH                      ;Activate Second Line
    ACALL CMD
    RET

LINE2:MOV A,#0C0H 
    ACALL CMD
    RET   

CMD: MOV p1,A                     ;Command Register
    CLR RS
    CLR RW
    SETB E
    CLR E
    ACALL DELAY
    RET

DISPLAY:MOV p1,A
    SETB RS
    CLR RW
    SETB E
    CLR E
    ACALL DELAY
    RET

DELAY1: CLR E
    CLR RS
    SETB RW
    MOV p1,#0FFH
    SETB E
    MOV A,p1
    JB ACC.7,DELAY1
    CLR E
    CLR RW
    RET

 END         
