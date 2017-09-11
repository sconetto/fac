# Seção para as variáveis estáticas
.data

msg_1: .asciiz "\nDigite o primeiro inteiro: \n"
msg_2: .asciiz "\nDigite o segundo inteiro: \n"
msg_erro: .asciiz "\nO modulo nao eh primo!\n"
msg_erro2: .asciiz "\nOs dois inteiros sao identicos!\n"
msg_primo: .asciiz "\nO numero eh primo!\n"
msg_saida: .asciiz "\nO inverso multiplicativo é "

# Seção para a execução do processador
.text

le_inteiro:
	li $v0, 4        # Carrega em $v0 o imediato 4 (impressão no console)
	la $a0, msg_1    # Carrega em $a0 (variável de função) a primeira mensagem
	syscall          # Chamada do sistema

	li $v0, 5        # Carrega em $v0 o imediato 5 (leitura de inteiro)
	syscall          # Chamada do sistema
	move $t0, $v0    # Move o valor lido de $v0 em $t0
	
	li $v0, 4        # Carrega em $v0 o imediato 4 (impressão no console)
	la $a0, msg_2    # Carrega em $a0 (variável de função) a segunda mensagem
	syscall          # Chamada do sistema

	li $v0, 5        # Carrega em $v0 o imediato 5 (leitura de inteiro)
	syscall          # Chamada do sistema
	move $t1, $v0    # Move o valor lido de $v0 em $t1

eh_primo:
	add $t8, $zero, $t0           # Cópia o valor de $t0 (primeiro inteiro) em $t8
	blt $t8, 2, imprime_erro      # Caso $t8 seja menor que 2 imprime erro
	beq $t8, 2, calc_inverso      # Caso $t8 seja 2 pule para o calc_inverso
	li $t9, 2                     # Carrega em $t9 o valor 2
	divu $t8, $t9                 # Divide $t8 por 2 ($t9) -> hi = $t8 % $t9 (operação de módulo)
	mfhi $t7                      # Retira o valor de hi e coloca em $t7
	beqz $t7, imprime_erro        # Caso o módulo seja igual a zero imprime erro
	move $t9, $t1                 # Copia o valor de $t1 (segundo inteiro) em $t9
	divu $t8, $t9                 # Divide o primeiro inteiro pelo segundo inteiro -> hi = $t8 % $t9 (operação de módulo)
	mfhi $t7                      # Retura o valor de hi e coloca em $t7
	beqz $t7, imprime_erro2       # Caso o módulo seja igual a zero imprime erro
	li $t6, 4                     # Carrega em $t7 o imediato 4

loop:				      # Loop para auxiliar a verificação do número (se é ou não primo)
	divu $t8, $t6                 # Divide $t8 por $t6 -> hi = $t8 % $t6 (operação de módulo)
	mfhi $t7                      # Retira o valor de hi e coloca em $t7
	beqz $t7, imprime_erro        # Se $t7 for igual a zero quer dizer que
	addi $t6, $t6, 1              # Adiciona um ao iterador $t6
	bge  $t6, $t8, calc_inverso   # Se o iterador for maior ou igual ao número em $t8 (valor lido) então já foi percorrido
	                              # todos os números, logo ele é um primo. Pule para calcular inverso
	j loop                        # Enquanto não entrar no caso do erro ou no caso do primo, continue cálculando pelo loop

calc_inverso:
	li $t6, 1                 # Carrega em $t6 o número um que irá ser usado como iterador
	add $t8, $zero, $t0       # Carrega em $t8 o primeiro inteiro (módulo)
	add $t9, $zero, $t1       # Carrega em $t9 o segundo inteiro

loop_2:
	mul $t7, $t6, $t9            # Multiplica $t7 = $t6 (iterador) * $t9 (segundo inteiro)
	divu $t7, $t8		     # Divide $t7 por $t8 -> hi = $t7 % $t8
	mfhi $t5                     # Retira o valor de hi e coloca em $t5
	beq  $t5, 1, imprime_saida   # Se o módulo for igual a 1 o contador é inverso multiplicativo
	addi $t6, $t6, 1             # Se não, adicione um ao iterador e continue o loop
	j loop_2

imprime_erro:
	li $v0, 4          # Carrega em $v0 o imediato 4 (impressão no console)
	la $a0, msg_erro   # Carrega em $a0 (variável de função) a mensagem de erro
	syscall            # Chamada de sistema
	li $v0, 10         # Carrega em $v0 o imediato 10 (terminar execução)
	syscall            # Chamada de sistema
	

imprime_erro2:
	li $v0, 4          # Carrega em $v0 o imediato 4 (impressão no console)
	la $a0, msg_erro2  # Carrega em $a0 (variável de função) a mensagem de erro
	syscall            # Chamada de sistema
	li $v0, 10         # Carrega em $v0 o imediato 10 (terminar execução)
	syscall            # Chamada de sistema

imprime_saida:
	li $v0, 4           # Carrega em $v0 o imediato 4 (impressão no console)
	la $a0, msg_saida   # Carrega em $a0 (variável de função) a mensagem de que é primo
	syscall             # Chamada de sistema

	li $v0, 1           # Carrega em $v0 o imediato 1 (impressão de inteiro no console)
	add $a0, $t6, $zero # Adiciona em $a0 o valor do iterador $t6 que foi usado no calc_inverso
	syscall             # Chamada de sistema

	li $v0, 10          # Carrega em $v0 o imediato 10 (terminar execução)
	syscall             # Chamada de sistema
