	# Nenhuma variável estática a ser declarada
	.data
	.text
	# Declarando a função main.
main:
	li $v0, 5 # Carrega em $v0 o imediato 5 (leitura de inteiro)
	syscall # Chamada do sistema
	move $t0, $v0 # Move o valor lido de $v0 em $t0
	add $a0, $t0, $zero # Adiciona em $a0 o valor de $t0 + $zero (0)
	li $v0, 1 # Carrega em $v0 o imediato 1 (imprimir no console um inteiro)
	syscall # Chamada do sistema