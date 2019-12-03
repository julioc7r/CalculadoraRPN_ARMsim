@projeto final de arquitetura de computadores-2019/2 Calculadora rpn (polonesa inversa)
@Alunos de Bsi turma s73
@ Lucas Matheus dos Santo 2028492
@ Júlio Cezar Rogacheski 2070405
@ https://github.com/julioc7r/CalculadoraRPN_ARMsim 
.text
b start @pula direto para o inicio do programa
.equ SWI_CheckBlue, 0x203 @verificar se algum botao foi pressionado
.equ SWI_CLEAR_DISPLAY,0x206 @limpar lcd
.equ SWI_DRAW_CHAR, 0x207 @printar um char no lcd
.equ SWI_CLEAR_LINE, 0x208 @limpar linha lcd
.equ SWI_EXIT, 0x11 @finaliza o programa
.equ SWI_DRAW_STRING, 0x204 @printar string no lcd
.equ SWI_DRAW_INT, 0x205 @printar inteiro no lcd
.equ SWI_CheckBlack, 0x202 @ verifica se o botão preto foi pressionado
.equ SWI_LED, 0x201 @ led vermelho
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


start: @ inicio do programa
swi SWI_CLEAR_DISPLAY @ limpa a tela ao iniciar
mov r8,#10
ldr r3,= array @ recebe o inicio do vetor
ldr r4,= eoa @ recebe o endereço do fim do vetor
mov r1,#1
b Teclado


            @##     REGISTRADORES              ##
@ r0 -> recebe o botao apertado , e tem a função de contador de colunas (usado para printar no display)
@ r1 -> contador de linha , tem como objetivo apontar em qual linha serão realizado as funções swi
@ r2 -> recebe o numero/operando representado pelo botao| recebe o resultado da operacao
@ r3 -> recebe o inicio do vetor (que armazena a pilha de operando)
@ r4 -> final do vetor
@ r5 -> contador da coluna atual do operando
@ r6 -> operando 1    |Utilizados nas operaçoes 
@ r7 -> operando 2    |
@ r8 -> utilizado para auxiliar na multiplicacao, ao receber um novo numero os numeros antigos sao deslocados para a direita e o ultimo digito recebe o numero digitado
@ r9 -> variavel auxiliar utilizada para guardar algarismos antes de alguma adição de mais numeros
@ r10 -> 
@ r11 ->
@ r12 ->


Teclado:
mov r0,#0
Check_bt: @realiza a verificação se algum botão azul foi pressionado, caso não tenha sido pressionado chama a função para ver se o botão preto foi pressionado.
    swi SWI_CheckBlue   @caso tenha sido pressionado algum botao azul o valor correspondente sera passado para r0 
    cmp r0,#0           @A comparação dara falso caso R0 não seja igual a 0.
beq Check_bt_b   @ caso r0 seja igual a 0 nenhum botão azul foi pressionado, chamando assim a função para verificar o botao preto
add r5,r5,#1    @Conta as casas do operando.
mov r9,r6       @ r9 recebe o valor do operando antes de o ultimo digito pressionado ser adicionado

@verifica qual botão foi pressionado e chama a função correspondente. teclado de 0 a 15.
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

@realiza a verificação se algum botão preto foi pressionado
Check_bt_b: 
swi SWI_CheckBlack
    cmp r0,#0
beq Check_bt
cmp r0,#0x01
beq Clear
swi SWI_EXIT @ caso o botaõ preto direito for pressionado o programa se encerra.

@Desloca o operando em r9 uma casa para a esquerda e adiciona o ultimo numero digitado ao operando. exemplo operando 15 numero digitado 2 = (15*10)+ 2 = 152
MULT: mov r2,#0
loop:add r2,r2,r9 @ loop tem a função de multiplicar o operando por 10 
      sub r8,r8,#1
      cmp r8,#0
      bne loop
add r6,r6,r2 @ ultimo numero digitado é adicionado 
mov r2,#0    
mov r8,#10   @ atribui valor 10 para que seja possivel realizar a proxima adiçao de numero caso nescessario
b Teclado


ZERO: @ numero 1
mov r0,r5
mov r2,#1
swi SWI_DRAW_INT 
mov r6,#1
b MULT


ONE: @ numero 2
mov r0,r5
mov r2,#2
swi SWI_DRAW_INT 
mov r6,#2
b MULT

TWO: @ numero 3
mov r0,r5
mov r2,#3
swi SWI_DRAW_INT 
mov r6,#3
b MULT

THREE: @ operador soma
mov r0,r5
mov r2,#'+'
swi SWI_DRAW_CHAR
b operation

FOUR: @ numero 4
mov r0,r5
mov r2,#4
swi SWI_DRAW_INT 
mov r6,#4
b MULT

FIVE: @ numero 5
mov r0,r5
mov r2,#5
swi SWI_DRAW_INT 
mov r6,#5
b MULT

SIX: @ numero 6
mov r0,r5
mov r2,#6
swi SWI_DRAW_INT 
mov r6,#6
b MULT

SEVEN: @ operador subtracao
mov r0,r5
mov r2,#'-'
swi SWI_DRAW_CHAR
b operation

EIGHT: @ numero 7
mov r0,r5
mov r2,#7
swi SWI_DRAW_INT 
mov r6,#7
b MULT

NINE: @ numero 8
mov r0,r5
mov r2,#8
swi SWI_DRAW_INT 
mov r6,#8
b MULT

TEN: @ numero 9
mov r0,r5
mov r2,#9
swi SWI_DRAW_INT 
mov r6,#9
b MULT

ELEVEN: @ operador multiplicacao
mov r0,r5
mov r2,#'*'
swi SWI_DRAW_CHAR
b operation

TWELVE: @ operador igual
mov r0,r5
mov r2,#','
swi SWI_DRAW_CHAR
b Armazenar

THIRTEEN: @ numero 0
mov r0,r5
mov r2,#0
swi SWI_DRAW_INT 
mov r6,#0
b MULT

FOURTEEN: @ operador resto de divisao
mov r0,r5
mov r2,#'%'
swi SWI_DRAW_CHAR
b operation

 
FIFTEEN: @ operador divisao
mov r0,r5
mov r2,#'/'
swi SWI_DRAW_CHAR
b operation

@ Em caso de operador ser digitado, verifica-se qual operação deve ser realizada e faz sua chamada
operation:
    ldr r6,[r3],#-4 @voltando um indice do vetor antes da operação (ao armazenar um numero o indice avança entao para realizar a leitura realizamos esta alteração)
    cmp r2,#'+'
    beq soma
    cmp r2,#'-'
    beq subt
    cmp r2,#'*'
    beq mult
    cmp r2,#'/'
    beq rest
    cmp r2,#'%'
    beq quoc

@ realizada a soma dos valores no topo da pilha
soma: ldr r6,[r3],#-4 @ pegar o elemento atual salvo na pilha e pular para o indice anterior
    ldr r7,[r3] @ pega o elemento anterior ao ultimo adicionado na pilha
    mov r0,#1
    add r6,r7,r6 @ realiza a soma dos operandos
    strb r2,[r3],#4   @ limpando os elementos da pilha
    strb r2,[r3],#-4
b Armazenar

@ realizada a subtraçao dos valores no topo da pilha
subt: ldr r6,[r3],#-4 @ pegar o elemento atual salvo na pilha e pular para o indice anterior
    ldr r7,[r3] @ pega o elemento anterior ao ultimo adicionado na pilha
    mov r0,#1
    sub r6,r7,r6 @ realiza a subtraçao dos operandos
    @limpa elementos utilizados da pilha.
    strb r2,[r3],#4   @ limpando os elementos da pilha
    strb r2,[r3],#-4
b Armazenar

@ realizada a multiplicação dos valores no topo da pilha
mult:ldr r6,[r3],#-4 @ faz a leitura dos numeros para a operação
    ldr r7,[r3]
    mov r2,#0
    strb r2,[r3],#4   @ limpando os elementos da pilha anteriores a operação
    mov r0,#0     @o registrador r10 vai receber o resultado da multiplicação
    strb r2,[r3],#-4
subtr: add r0,r0,r6 @ enquanto r7 não for igual a 0 soma r6 ao r10
        sub r7,r7,#1  @ ou seja sera somada N vezes o r6 (onde N e definido pelo r7)
        cmp r7,#0
        bne subtr
    mov r6,r0
b Armazenar

@ realizada o modulo dos valores no topo da pilha
rest:ldr r7,[r3],#-4 @ faz a leitura dos numeros para a operação
    ldr r6,[r3]
    cmp r7,#0 @ verifica se o denominador é igual a 0
    beq Value
    mov r2,#0
    strb r2,[r3],#4   @ limpando os elementos da pilha anteriores a operação
    strb r2,[r3],#-4 
    cmp r6,r7
    blt Armazenar @tratamento no caso de r6 ser menor que r7 (r6 já é o resto neste caso)
resto: sub r6,r6,r7
    cmp r6,r7
    bge resto @ enquanto numerador for maior que o denominador continua o loop
b Armazenar

@ realizada a divisão dos valores no topo da pilha
quoc:
ldr r7,[r3],#-4 @ faz a leitura dos numeros para a operação
    ldr r6,[r3]
    cmp r7,#0 @ verifica se o denominador é igual a 0
    beq Value
    mov r2,#0
    strb r2,[r3],#4   @ limpando os elementos da pilha anteriores a operação
    strb r2,[r3],#-4 
    cmp r6,r7
    blt Armazenar @tratamento no caso de r6 ser menor que r7 (r6 já é o resto neste caso)
divisao: sub r6,r6,r7
    add r2,r2,#1
    cmp r6,r7
    bge divisao @ enquanto numerador for maior que o denominador continua o loop
    mov r6,r2
    swi SWI_DRAW_INT
b Armazenar


Clear:
    mov r5,#0
    swi SWI_CLEAR_DISPLAY
    mov r6,#0
    mov r7,#0
    ldr r3,=array @ recebe o inicio do array
looping:    strb r6,[r3],#4  @ percore o vetor mudando todos os valores para 0
            cmp  r3,r4       @ enquanto o vetor não chegar ao fim continua o looping
            bne   looping 
beq start

@ Armazena na pilha de valores o operando fornececido ao pressionar ENTER(,) 
Armazenar:
    cmp r3,r4 @ verifica se esta no final do vetor
    beq TratErro
    str r6,[r3],#4 @ armazena o valor no vetor
    mov r6,r3  @zera o valor do r6.
    ldr r3, = array 
    mov r0,#1
    mov r1,#2
    swi SWI_CLEAR_DISPLAY
    ldr r2,=pilha
    swi SWI_DRAW_STRING
    mov r1,#8
PILHA:ldr r2,[r3],#4
    swi SWI_DRAW_INT
    sub r1,r1,#1
    cmp r3,r6
    bne PILHA
cmp r3,r4 @ verifica se esta no final do vetor
beq TratErro @ avisa que a pilha esta cheia apos a operação.
mov r5,#0
mov r6,#0
mov r1,#1
b Teclado

@ Em caso do denominador igual a zero, operação não e realizada e esta função e chamada
Value:mov r0,#2  
    mov r1,#5 
    ldr r2,=value 
    mov r6,#0
    mov r1,#1
    swi SWI_LED @ acende o led
    swi SWI_DRAW_STRING
    add r1,r1,#1
    ldr r2,=valuec
    mov R0,#0 
    swi SWI_DRAW_STRING
    ldr r2,[r3],#4 @ atualiza o indice novamente para aguardar uma nova operação (os 2 operandos continuam armazenados, pois não foram utilizados)
    ldr r2,[r3],#4 
    mov r1,#1
    swi SWI_CLEAR_LINE
    swi SWI_LED @ apaga led
b Teclado

@ Aviso de pilha cheia.
TratErro: 
    mov r0,#5 @ numero da coluna
    mov r1,#5 @ numero de linha
    ldr r2,=error
    swi SWI_DRAW_STRING
    mov r6,#0 @caso seja digitado algum valor no r6 sera descartado 
    mov r0,#0 
    mov r1,#1
b Teclado

@ string utilizadas no codigo
.data
pilha: .asciz  "PILHA"
value: .asciz "Erro ao realizar operacao denominador"
valuec: .asciz "nao pode ser 0, digite outra operacao"
error: .asciz "pilha ja esta cheia digite um operandor aritmetico"
.end