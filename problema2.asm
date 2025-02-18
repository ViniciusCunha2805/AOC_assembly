name "problema2"

org 100h

;-------------------------Input--------------------------------------------;
 
;-------------------------Imprime msg1-------------------------------------;    
lea dx, msg1
mov ah, 09h
int 21h

;Input do valor da quilometragem X
call scan_num
mov [kmx], cx

;Pula Linha
putc 0Dh
putc 0Ah

;-------------------------Imprime msg2-------------------------------------;  
lea dx, msg2
mov ah, 9
int 21h
            
;Input do valor da velocidade X             
call scan_num
mov  [vx], cx

;Pula Linha
putc 0Dh
putc 0Ah 

;-------------------------Imprime msg3-------------------------------------;  
lea dx, msg3
mov ah, 9
int 21h
            
;Input do valor da quilometragem Y            
call scan_num
mov  [kmy], cx

;Pula Linha
putc 0Dh
putc 0Ah  

;-------------------------Imprime msg4-------------------------------------;  
lea dx, msg4
mov ah, 9
int 21h
            
;Input do valor da velocidade Y             
call scan_num
mov  [vy], cx

;Pula Linha
putc 0Dh
putc 0Ah 

;-------------------------Condicional--------------------------------------;  

; Move valor de kmx para ax
mov ax, [kmx] 
mov bx, [kmy]

;Compara se kmx = kmy 
cmp ax, bx   
                    
;Se forem iguais, pule para p_igual (stop)
je p_igual
 
;Se nao forem iguais, pule para add_loop
jmp add_loop

;-------------------------Loop--------------------------------------------;
;Loop para adicionar horas, quilometros e velocidades  
add_loop: 

    ;Print da mensagem 5 (msg5)     
    LEA dx, msg5
    mov ah, 09h
    int 21h
    
    ;Move kmx para ax
    mov ax, [kmx]  
    
    ;Chama print_num
    call print_num
    
    
    ;Print da mensagem 6 (msg6) 
    LEA dx, msg6
    mov ah, 09h
    int 21h
     
    ;Move vx para ax 
    mov ax, [vx]
    
    ;Chama print_num
    call print_num
    
    ;Move kmx para ax
    mov ax, [kmx]
    
    ;Print da mensagem 7 (msg7)
    LEA dx, msg7
    mov ah, 09h
    int 21h
    
    ;Move kmy para ax
    mov ax, [kmy]
    
    ;Chama print_num
    call print_num
    
    ;Move kmx para ax
    mov ax, [kmx]
      
    ;Print da mensagem 8 (msg8) 
    LEA dx, msg8
    mov ah, 09h
    int 21h
     
    ;Move vy para ax 
    mov ax, [vy]
    
    ;Chama print_num
    call print_num
    
    ;Move kmx para ax
    mov ax, [kmx]  
    
    ;Compara kmx com kmy (AX eh maior que BX)
    cmp ax, bx              
    
    ;Se kmx > kmy, pula para loop que adiciona vy no kmy e vx no kmx ate kmy alcancar kmx.
    jg cy_alcanca_cx        
    

;Loop que adiciona vx no kmx e vy no kmy ate kmx alcancar kmy.
cx_alcanca_cy:              
             
    ;Pula Linha
    putc 0Dh
    putc 0Ah 
    
    ;Move ax para menor          
    mov [menor], ax
        
    ;Move bx para maior     
    mov [maior], bx         
    
    
    ;Print do hora 1 (hora1) 
    lea dx, hora1
    mov ah, 09h
    int 21h
    
    ;Move si para ax
    mov ax, si 
    
    ;Chama print_num
    call print_num  
    
    ;Move menor para ax
    mov ax, [menor]
    
    ;Incrementa 1 a si
    inc si 
    
    ;Move vx para ax
    add ax, [vx]
    
    ;Move vy para bx
    add bx, [vy]
    
    ;Compara ax com bx
    cmp bx, ax
    
    ;Caso bx nao seja maior que ax, vem para esse jump
    jng p_final_carrox
    
    ;Caso bx seja maior que ax, vem para esse jump
    jmp p_carrox

;Loop que adiciona vx no kmx e vy no kmy ate kmy alcancar kmx.
cy_alcanca_cx:

    ;Pula Linha
    putc 0Dh
    putc 0Ah
     
    ;Move ax para maior 
    mov [maior], ax
    
    ;Move bx para menor         
    mov [menor], bx  
           
    ;Print do hora 1 (hora1)
    lea dx, hora1
    mov ah, 09h
    int 21h 
    
    ;Move si para ax
    mov ax, si 
    
    ;Chama print_num
    call print_num  
    
    ;Move maior para ax
    mov ax, [maior]
     
    ;Incrementa 1 a si 
    inc si            
    
    ;Move vx para ax
    add ax, [vx]    
    
    ;Move vy para bx
    add bx, [vy]    
    
    ;Compara bx com ax
    cmp ax, bx 
    
    ;Caso ax nao seja maior que bx, vem para esse jump
    jng p_final_carroy
    
    ;Caso ax seja maior que bx, vem para esse jump
    jmp p_carroy
                
                
;-------------------------Encaminha para printar---------------------------;  

  
;-----------Printa a msg: "Hora x: Carro X em __ e Carro Y em __ ----------;
p_carrox: 
     
    ;Move ax para aux    
    mov [aux], ax    
    
    ;Print do carro 1 (carro1)
    lea dx, carro1
    mov ah, 09h
    int 21h
    
    ;Move menor para ax
    mov ax, [menor]
    
    ;Chama print_num
    call print_num
     
    ;Print do carro 2 (carro2) 
    lea dx, carro2
    mov ah, 09h
    int 21h
           
    ;Move maior para ax       
    mov ax, [maior]
    
    ;Chama print_num
    call print_num
     
    ;Move aux para ax   
    mov ax, [aux]
     
    ;Volta pro cx_alcanca_cy
    jmp cx_alcanca_cy
    
;-----------Printa a msg: "Hora x: Carro X em __ e Carro Y em __ ----------;
p_carroy: 

    ;Move ax para aux
    mov [aux], ax
    
    ;Print do carro 1 (carro1)
    lea dx, carro1
    mov ah, 09h
    int 21h
    
    ;Move maior para ax
    mov ax, [maior]
    
    ;Chama print_num
    call print_num
    
    ;Print do carro 2 (carro2)
    lea dx, carro2
    mov ah, 09h
    int 21h
    
    ;Move menor para ax
    mov ax, [menor]
    
    ;Chama print_num
    call print_num
    
    ;Move aux para ax
    mov ax, [aux]
               
    ;Volta pro cy_alcanca_cx
    jmp cy_alcanca_cx  

;---------------Printa a msg FINAL: carro X ultrapassa o Y---------------;
p_final_carrox:


    ;Move bx para aux
    mov [aux], bx
    
    ;Print do carro 1 (carro1)
    lea dx, carro1
    mov ah, 09h
    int 21h
    
    ;Move menor para ax
    mov ax, [menor]
    
    ;Chama print_num
    call print_num
    
    ;Print do carro 2 (carro2)
    lea dx, carro2
    mov ah, 09h
    int 21h
    
    ;Move maior para ax
    mov ax, [maior]
    
    ;Chama print_num
    call print_num
    
    ;Pula Linha
    putc 0Dh
    putc 0Ah
    
    ;Print da mensagem 9 (msg9)
    lea dx, msg9
    mov ah, 09h
    int 21h
    
    ;Move si para ax
    mov ax, si
    
    ;Chama print_num
    call print_num
    
    ;Print da mensagem 11 (msg11)
    lea dx, msg11
    mov ah, 09h
    int 21h
    
    ;Move aux para ax
    mov ax, [aux]
    
    ;Chama print_num
    call print_num
    
    ;Pula para stop, para encerrar o programa assim que imprime
    jmp stop 
    
        
;---------------Printa a msg FINAL: carro X ultrapassa o Y---------------;
p_final_carroy:

    ;Move ax para aux
    mov [aux], ax
    
    ;Print do carro 1 (carro1)
    lea dx, carro1
    mov ah, 09h
    int 21h
    
    ;Move maior para ax
    mov ax, [maior]
    
    ;Chama print_num
    call print_num
    
    ;Print do carro 2 (carro2)
    lea dx, carro2
    mov ah, 09h
    int 21h
    
    ;Move menor para ax
    mov ax, [menor]
    
    ;Chama print_num
    call print_num
    
    ;Move aux para ax
    mov ax, [aux]
    
    ;Pula Linha
    putc 0Dh
    putc 0Ah
    
    ;Print da mensagem 10 (msg10)
    lea dx, msg10
    mov ah, 09h
    int 21h
    
    ;Move si para ax
    mov ax, si
    
    ;Chama print_num
    call print_num
    
    ;Print da mensagem 11 (msg11)
    lea dx, msg11
    mov ah, 09h
    int 21h
    
    ;Move aux para ax
    mov ax, [aux]
    
    ;Chama print_num
    call print_num
    
    ;Pula para stop, para encerrar o programa assim que imprime
    jmp stop


;---------------Printa a msg: os carros estao juntos---------------------;
p_igual:
    ; Carrega o endereco da string eq para dx
    LEA dx, igual
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
msg1 db "Digite a quilometragem do carro X: $"
msg2 db "Digite a velocidade do carro X: $"
msg3 db "Digite a quilometragem do carro Y: $" 
msg4 db "Digite a velocidade do carro Y: $"  
msg5 db "kmx = $"
msg6 db " | vx = $"
msg7 db " | kmy = $" 
msg8 db " | vy = $"
msg9 db "Carro X ultrapassou o Carro Y na hora $"
msg10 db "Carro Y ultrapassou o Carro X na hora $"
msg11 db " apos o KM $"

hora1 db "Hora $"
carro1 db " : Carro X em $"
carro2 db " e Carro Y em  $"

igual db "Os carros estao na mesma quilometragem$"

;-------------------------Variaveis-----------------------------------------;
vx dw ?
kmx dw ?
vy dw ? 
kmy dw ? 
hora dw 0
maior dw ?
menor dw ?
aux dw ?  



; NAO TOCAR DAQUI PARA BAIXO!!!   


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