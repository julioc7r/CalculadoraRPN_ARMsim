.text
b start @pula direto para o inicio do codigo
.equ SWI_CheckBlue, 0x203 @faz a checagem se algum botao azul foi precionado
.equ SWI_CLEAR_DISPLAY,0x206 @limpar lcd
.equ SWI_DRAW_CHAR, 0x207 @printar um char
.equ SWI_CLEAR_LINE, 0x208 @limpar linha no lcd
.equ SWI_EXIT, 0x11 @finalizacao do programa
.equ SWI_DRAW_STRING, 0x204 @printar string no lcd
.equ SWI_DRAW_INT, 0x205 @printar inteiro no lcd
.equ SWI_CheckBlack, 0x202 @ checar botao esquerdo 
.equ SWI_Led, 0x201 @ led vermelho
.equ Button_00, 0x01 @botoes(0)
.equ Button_01, 0x02 @botoes(1)
.equ Button_02, 0x04 @botoes(2)
.equ Button_03, 0x08 @botoes(3)
.equ Button_04, 0x10 @botoes(4)
.equ Button_05, 0x20 @botoes(5)
.equ Button_06, 0x40 @botoes(6)
.equ Button_07, 0x80 @botoes(7)
.equ Button_08, 1<<8 @botoes(8)
.equ Button_09, 1<<9 @botoes(9)
.equ Button_10, 1<<10 @botoes(10)
.equ Button_11, 1<<11 @botoes(11)
.equ Button_12, 1<<12 @botoes(12)
.equ Button_13, 1<<13 @botoes(13)
.equ Button_14, 1<<14 @botoes(14)
.equ Button_15, 1<<15 @botoes(15)
array: .space 24 @ array(24bytes para armazenar 6 numeros)
eoa: @indica o fim do array
.align

start:
swi SWI_CLEAR_DISPLAY @ limpa a tela ao iniciar
mov r8,#10
ldr r3,= array
ldr r13,= eoa
mov r14,#0
b Teclado

@ r0 -> recebe o botao apertado
@ r1 ->
@ r2 -> recebe o numero/operando representado pelo botao| recebe o resultado da operacao
@ r3 -> recebe o vetor
@ r4 ->
@ r5 ->
@ r6 ->
@ r7 -> recebe o valor do vetor para fazer operação
@ r8 ->
@ r9 ->
@ r10 ->
@ r11 ->
@ r13 -> recebe o fim do vetor

Teclado:
mov r0,#0
add r14,r14,#1 
Check_bt:
    swi SWI_CheckBlue   @get button press into R0
    cmp r0,#0
beq Check_bt    @ if zero, no button pressed
add r5,r5,#1    @column counter
cmp r14,#7
beq Erro
mov r9,r6
cmp r0,#Button_00
beq ZERO        @ numero 1
cmp r0,#Button_01
beq ONE         @ numero 2
cmp r0,#Button_02
beq TWO         @ numero 3
cmp r0,#Button_03
beq THREE       @ soma
cmp r0,#Button_04
beq FOUR        @ numero 4
cmp r0,#Button_05
beq FIVE        @ numero 5
cmp r0,#Button_06
beq SIX         @ numero 6
cmp r0,#Button_07
beq SEVEN       @ subtracao
cmp r0,#Button_08
beq EIGHT       @ numero 7
cmp r0,#Button_09
beq NINE        @ numero 8
cmp r0,#Button_10
beq TEN         @ numero 9
cmp r0,#Button_11
beq ELEVEN      @ multiplicacao
cmp r0,#Button_12
beq TWELVE      @ igual
cmp r0,#Button_13
beq THIRTEEN    @ numero 0
cmp r0,#Button_14
beq FOURTEEN    @ resto de divisao
cmp r0,#Button_15
beq FIFTEEN     @ divisao


swi SWI_CheckBlack
cmp r0,#0x02
beq Clear


ZERO: @ numero 1
mov r0,r5
mov r1,#4
mov r2,#1
@add r3,#1 somar o inicio do vetor??
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#1
b Teclado


ONE: @ numero 2
mov r0,r5
mov r1,#4
mov r2,#2
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#2
b Teclado

TWO: @ numero 3
mov r0,r5
mov r1,#4
mov r2,#3
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#3
b Teclado

THREE: @ operador soma
mov r0,r5
mov r1,#4
mov r2,#'+'
swi SWI_DRAW_CHAR
b operation

FOUR: @ numero 4
mov r0,r5
mov r1,#4
mov r2,#4
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#4
b Teclado

FIVE: @ numero 5
mov r0,r5
mov r1,#4
mov r2,#5
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#5
b Teclado

SIX: @ numero 6
mov r0,r5
mov r1,#4
mov r2,#6
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#6
b Teclado

SEVEN: @ operador subtracao
mov r0,r5
mov r1,#4
mov r2,#'-'
swi SWI_DRAW_CHAR
b operation

EIGHT: @ numero 7
mov r0,r5
mov r1,#4
mov r2,#7
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#7
b Teclado

NINE: @ numero 8
mov r0,r5
mov r1,#4
mov r2,#8
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#8
b Teclado

TEN: @ numero 9
mov r0,r5
mov r1,#4
mov r2,#9
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#9
b Teclado

ELEVEN: @ operador multiplicacao
mov r0,r5
mov r1,#4
mov r2,#'*'
swi SWI_DRAW_CHAR
b operation

TWELVE: @ operador igual
mov r0,r5
mov r1,#4
mov r2,#'='
swi SWI_DRAW_CHAR
b Armazenar

THIRTEEN: @ numero 0
mov r0,r5
mov r1,#4
mov r2,#0
swi SWI_DRAW_INT
MUL r6,r9,r8
add r6,r6,#0
b Teclado

FOURTEEN: @ operador resto de divisao
mov r0,r5
mov r1,#4
mov r2,#'%'
swi SWI_DRAW_CHAR
b operation

 
FIFTEEN: @ operador divisao
mov r0,r5
mov r1,#4
mov r2,#'/'
swi SWI_DRAW_CHAR
b operation


operation:
cmp r4,#'+'
beq soma
cmp r4,#'-'
beq subt
cmp r4,#'*'
beq mult
cmp r4,#'/'
beq rest
cmp r4,#'%'
beq quoc


soma: ldr r7,[r3],#-4
    mov r0,r5
    mov r1,#4
    add r6,r7,r6
    mov r2,r6
    swi SWI_DRAW_INT
b Armazenar


subt: ldr r7,[r3],#-4
    mov r0,r5
    mov r1,#4
    sub r6,r7,r6
    mov r2,r6
    swi SWI_DRAW_INT
b Armazenar


mult:ldr r7,[r3],#-4
subtr:  add r6,r6,r6
        sub r7,r7,#1
        cmp r7,#0
        bne subtr
    mov r0,r5
    mov r1,#4
    mov r2,r6
    swi SWI_DRAW_INT
b Armazenar


rest:
b Armazenar
quoc:
b Armazenar

Clear:
swi SWI_CLEAR_DISPLAY
mov r6,#0
mov r7,#0
mov r14,#0
ldr r3,=array
looping:    strb r6,[r3],#4
            cmp  r3,r13
            bne   looping 
beq   start


Armazenar:
strb r6,[r3],#4 @ armazena o valor no vetor
mov r6,#0  @zera o valor do r6.
mov r14,#0 @zera o contador 
b Teclado


Erro:
    swi SWI_CLEAR_DISPLAY
    mov r0,#2 @ column number
    mov r1,#4 @ row number
    ldr r2,=error @ pointer to string
    swi SWI_DRAW_STRING @ draw to the LCD screen
    swi SWI_EXIT

.data
error: .asciz "numero digitado maior que o suportado"

.end
