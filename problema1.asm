name "problema1"

;O Problema 1 envolve as seguintes competências: Ler 3 valores (A, B e C)
;representando as medidas dos lados de um triângulo e imprimir se formam ou não
;um triângulo e qual tipo de triângulo é. Se os três valores forem iguais, o triângulo é
;equilátero. Caso dois lados sejam iguais, isósceles. E se todos os lados forem
;diferentes, o triângulo é escaleno.

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


;-------------------------Condicional--------------------------------------------; 
; Move valor da variavel lado1 para ax
mov ax, [lado1] 
;print_num

; Compara se lado1 eh igual ao lado 2
cmp [lado2], ax                      
; Se forem iguais, pule para verifica_equilatero
je v_eq

 
;Se nao forem iguais, pule para verifica_isosceles
jmp v_is
    
; Verifica se o lado 3 eh igual ao lado 1, pulando para print_equilatero se forem, e para print_isosceles se nao forem.
v_eq:
    cmp [lado3], ax
    je p_eq
    jmp p_is
    

; Verifica se o lado 3 eh igual ao lado 1 e se o lado 2 eh igual ao lado 3.    
v_is:
    ; Compara lado1 com lado3
    cmp [lado3], ax
    ; Pula para print_isosceles se forem iguais
    je p_is
            
    ; se acima for falso, move o valor do lado3 para ax e verifica se lado2 eh igual ao lado 3 
    mov ax, [lado3]   
    cmp [lado2], ax
    ; Se forem iguais, pula para o print_isosceles
    je p_is
    
    ; Se nenhuma verificacao acima for igual, pula para o print_escaleno, ja que todos os lados sao diferentes...
    jmp p_esc

; Printa a msg informando ao usuario que o triangulo eh do tipo equilatero (todos os lados iguais)
p_eq:
    ; Carrega o endereco da string eq para dx
    LEA dx, eq
    ; Sub-funcao de impressao de string
    mov ah, 09h
    ; Interrupcao para imprimir uma string
    int 21h
    ; Pula para stop, para encerrar o programa assim que imprime.
    jmp stop

; Printa a msg informando ao usuario que o triangulo eh do tipo isosceles (apenas 2 lados iguais)
p_is:
      ; Carrega o endereco da string is para dx 
      LEA dx, is
      ; Sub-funcao de impressao de string
      mov ah, 09h
      ; Interrupcao para imprimir uma string
      int 21h
      ; Pula para stop, para encerrar o programa assim que imprime.
      jmp stop

; Printa a msg informando ao usuario que o triangulo eh do tipo escaleno (nenhum lado igual)
p_esc:
      ; Carrega o endereco da string esc para dx
      LEA dx, esc
      ; Sub-funcao de impressao de string
      mov ah, 09h
      ; Interrupcao para imprimir uma string
      int 21h
      ; Pula para stop, para encerrar o programa assim que imprime.
      jmp stop

; Retorna o controle para o sistema operacional (para onde o programa foi chamado).
stop:
    RET




;-------------------------Prints--------------------------------------------;
msg1 db "Digite o valor inteiro do lado 1: $"
msg2 db "Digite o valor inteiro do lado 2: $"
msg3 db "Digite o valor inteiro do lado 3: $"
eq db "Este eh um triangulo equilatero.$"
esc db "Este eh um triangulo escaleno.$"
is db "Este eh um trianglo isosceles.$"

;-------------------------Variaveis--------------------------------------------;
lado1 dw ?
lado2 dw ?
lado3 dw ?    


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
