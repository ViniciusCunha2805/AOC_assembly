name "problema3"

org 100h

;-------------------------Input--------------------------------------------;
 
;Imprime msg1    
mov dx, offset msg1
mov ah, 9
int 21h

;Input do valor lado 1
call scan_num
mov [lado1], cx

;Pula Linha
putc 0Dh
putc 0Ah

;Imprime msg2    
LEA dx, msg2
mov ah, 9
int 21h
            
; Recebe o input do lado 2             
call scan_num
mov  [lado2], cx

;Pula Linha
putc 0Dh
putc 0Ah

; Imprime msg 3
LEA dx, msg3
mov ah, 09h
int 21h

; Recebe o input do valor do lado 3 e atribui a variavel lado 3 
call scan_num
mov [lado3], cx 

; Pula linha
putc 0Dh
putc 0Ah

call maiorLado ; Chama o procedimento Maior Lado
call formaTriangulo; Chama o procedimento Forma Triangulo
                                                          
mov ax, [lado1]
call print_num
 
lea dx, t1
mov ah, 09h
int 21h

mov ax, [lado2]
call print_num

lea dx, t3
mov ah, 09h
int 21h

mov ax, [lado3]
call print_num
                                                          
cmp bx, 0 ; Compara se bx eh igual a zero
jz pNotTriangulo; Pula para printNotTriangulo se for falso (0)

; Print triangulo se for verdade.


lea dx, triangulo
mov ah, 09h
int 21h
ret
   
; Not triangulo part.
pNotTriangulo:
lea dx, notTriangulo
mov ah,09h
int 21h
ret

;mov ax, [maior]

;call print_num


;-------------------------Procedimentos--------------------------------------------; 

maiorLado PROC
    
    mov ax, [lado1]
    cmp [lado2], ax
    
    jge vMaiorLado23
    
    jmp vMaiorLado13
    
    vMaiorLado23:
    mov ax, [lado2]
    cmp [lado3], ax   
    
    jge atribuiMaiorLado3
    
    jmp atribuiMaiorLado2
    
    
    atribuiMaiorLado3:
    mov ax, [lado3]
    mov [maior], ax
    jmp stop
    
    atribuiMaiorLado2:
    mov ax, [lado2]
    mov [maior], ax
    jmp stop
    
    atribuiMaiorLado1:
    mov ax, [lado1] 
    mov [maior], ax
    jmp stop 
    
    
    vMaiorLado13:
    mov ax, [lado1]
    cmp [lado3], ax 
    
    jge atribuiMaiorLado3
    
    jmp atribuiMaiorLado1 
    

stop:
maiorLado ENDP
RET

formaTriangulo PROC
    
    mov ax, [lado1]
    cmp ax, [maior]
    jz somaLado23
     
    mov ax, [lado2]
    cmp ax, [maior]
    jz somaLado13
    
    mov ax, [lado3]
    cmp ax, [maior]
    jz somaLado12
    
    somaLado23:
    mov bx, [lado2]
    add bx, [lado3]
    cmp [maior], bx
    jl iTriangulo
    jmp iNotTriangulo
    
    somaLado13:
    mov bx, [lado1]
    add bx, [lado3]
    cmp [maior], bx
    jl iTriangulo 
    jmp iNotTriangulo
    
    somaLado12:
    mov bx, [lado1]
    add bx, [lado2]
    cmp [maior], bx
    jl iTriangulo
    jmp iNotTriangulo
    
    iTriangulo:
    mov bx, 1
    jmp stop2  
    
    
    iNotTriangulo: 
    mov bx, 0
    jmp stop2
      
    
    

stop2:
formaTriangulo ENDP
ret
    
   



;-------------------------Prints--------------------------------------------;
msg1 db "Digite o valor inteiro do lado 1: $"
msg2 db "Digite o valor inteiro do lado 2: $"
msg3 db "Digite o valor inteiro do lado 3: $"

t1 db ",$"
t3 db " e $"

triangulo db " formam um triangulo$"

notTriangulo db " nao formam um triangulo$"

;-------------------------Variaveis--------------------------------------------;
lado1 dw ?
lado2 dw ?
lado3 dw ?
maior dw ?    


; NAO TOCAR DAQUI P BAIXO!!!   




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; these functions are copied from emu8086.inc ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; this macro prints a char in AL and advances
; the current cursor position:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

; gets the multi-digit SIGNED number from the keyboard,
; and stores the result in CX register:
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 0Dh  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:


        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP                             

; this procedure prints number in AX,
; used with PRINT_NUM_UNS to print signed numbers:
PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP

; this procedure prints out an unsigned
; number in AX (not just a single digit)
; allowed values are from 0 to 65535 (FFFF)
PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        ; flag to prevent printing zeros before number:
        MOV     CX, 1

        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.

        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print

        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).

        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL


        MOV     AX, DX  ; get remainder from last div.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP



ten             DW      10      ; used as multiplier/divider by SCAN_NUM & PRINT_NUM_UNS.