	# Nenhuma variável estática será declarada
	.data
	# Parte com as linhas de comando
	.text
	li $t1, 1 #Carrega o imediato 1 para o $t1
	addi $t0, $t1, 2 #Adiciona em $t0 $t1 + 2
	li $v0, 1 #Carrega na variável de retorno $v0 o serviço 1 (imprimir no console)
	add $a0, $t0, $zero #Adiciona na variável de retorno de função $a0 $t0 + 0
	addi $a1, $t0, 4 #Adiciona na variável de retorno de função $a1 $t0 + 1	
	syscall #Chama a função do sistema
	la  $a0, ($a1)
	syscall #Chama a função do sistema