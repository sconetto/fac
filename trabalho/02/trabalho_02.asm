.data

msg_1: .asciiz "\nDigite o primeiro inteiro: \n"
msg_2: .asciiz "\nDigite o segundo inteiro: \n"
msg_erro: .asciiz "\nO modulo nao eh primo!\n"
msg_primo: .asciiz "\nO numero eh primo!\n"

.text

le_inteiro:
	li $v0, 4        # Carrega em $v0 o imediato 4 (impressão no console)
	la $a0, msg_1    # Carrega em $a0 (variável de função) a primeira mensagem
	syscall          # Chamada do sistema
	
	li $v0, 5        # Carrega em $v0 o imediato 5 (leitura de inteiro)
	syscall          # Chamada do sistema
	move $t0, $v0    # Move o valor lido de $v0 em $t0
                         # add $a0, $t0, $zero # Adiciona em $a0 o valor de $t0 + $zero (0)
	
	li $v0, 4        # Carrega em $v0 o imediato 4 (impressão no console)
	la $a0, msg_2    # Carrega em $a0 (variável de função) a segunda mensagem
	syscall          # Chamada do sistema
	
	li $v0, 5        # Carrega em $v0 o imediato 5 (leitura de inteiro)
	syscall          # Chamada do sistema
	move $t1, $v0    # Move o valor lido de $v0 em $t1

eh_primo:
	add $t8, $zero, $t1           # Cópia o valor de $t1 (segundo inteiro) em $t8
	blt $t8, 2, imprime_erro      # Caso $t8 seja menor que 2 imprime erro
	beq $t8, 2, calc_inverso      # Caso $t8 seja 2 pule para o calc_inverso
	li $t9, 2                     # Carrega em $t9 o valor 2
	divu $t8, $t9                 # Divide $t8 por 2 ($t9) -> hi = $t8 % $t9 (operação de módulo)
	mfhi $t7                      # Retira o valor de hi e coloca em $t7
	beqz $t7, imprime_erro        # Caso o módulo seja igual a zero imprime erro
	li $t6, 3                     # Carrega em $t7 o imediato 3
	
loop:				      # Loop para auxiliar a verificação do número (se é ou não primo)
	divu $t8, $t6                 # Divide $t8 por $t6 -> hi = $t8 % $t6 (operação de módulo)
	mfhi $t7                      # Retira o valor de hi e colocar em $t7
	beqz $t7, imprime_erro        # Se $t7 for igual a zero quer dizer que 
	addi $t6, $t6, 1              # Adiciona um ao iterador $t6
	bge  $t6, $t8, calc_inverso   # Se o iterador for maior ou igual ao número em $t8 (valor lido) então já foi percorrido
	                              # todos os números, logo ele é um primo. Pule para calcular inverso
	j loop                        # Enquanto não entrar no caso do erro ou no caso do primo, continue cálculando pelo loop
	

calc_inverso:
	li $v0, 4           # Carrega em $v0 o imediato 4 (impressão no console)
	la $a0, msg_primo   # Carrega em $a0 (variável de função) a mensagem de que é primo
	syscall             # Chamada de sistema
	li $v0, 10          # Carrega em $v0 o imediato 10 (terminar execução)
	syscall             # Chamada de sistema

imprime_erro:
	li $v0, 4          # Carrega em $v0 o imediato 4 (impressão no console)
	la $a0, msg_erro   # Carrega em $a0 (variável de função) a mensagem de erro
	syscall            # Chamada de sistema
	li $v0, 10         # Carrega em $v0 o imediato 10 (terminar execução)
	syscall            # Chamada de sistema
	
imprime_saida:
