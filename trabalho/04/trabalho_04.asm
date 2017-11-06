# Seção para as variáveis estáticas
.data

msg_1: .asciiz "Escreva a String que deseja calcular o CRC32: "
msg_2: .asciiz "String de entrada: "
msg_crc32: .asciiz "CRC32: "
buffer: .space 16
polynomial: .word 0xEDB88320

# Seção para a execução do processador
.text

le_string:
	la $a0, msg_1  # Carrega em $a0 a mensagem
	li $v0, 4  # Carrega o imediato 4 (print string) no registrador $v0
	syscall
     
	li $v0, 8  # Carrega o imediato 8 (read string) no registrador $v0
	la $a0, buffer  # Carrega o tamanho em bytes no endereço
	li $a1, 16  # Atribui o espaço em bytes para a string
	move $t0, $a0  # Salva a string em $t0
	syscall

calc_crc32:
	lw $t1, polynomial  # Carrega o polinomio do CRC32 no registrador $t1
	add $t3, $zero, $zero  # Inicio o valor de $t3 com zero (Contador da string)
	addi $t4, $zero, 8 #Inicio o valor de $t4 com zero (Auxiliar no cálculo do CRC32)
	add $t6, $zero, 0xFFFFFFFF # Inicio o valor do CRC32 com 0xFFFFFFFF
	
loop_crc:
	lb $t2, 0($t0) #Carrego byte atual da mensagem
	beqz $t2, imprime_saida #Caso o byte seja zero (não tem conteúdo/final da string) pulo para o imprime_saida
	beq $t2, 0x0a, imprime_saida  # Caso o byte seja um linefeed pule para o imprimir saída
	xor $t6, $t6, $t2 # CRC = CRC ^ Byte (XOR do CRC com o Byte)
	jal loop_aux # Pulo para o loop auxiliar de cálculo do CRC32
	add $t0, $t0, 1 # Incremeto o endereço
	add $t3, $t3, 1 # Incremeto o contador da string
	addi $t4, $zero, 8 # Reinicio o valor de $t4 com zero (Auxiliar no cálculo do CRC32
	j loop_crc # Pulo para o inicio do loop
	
loop_aux:
	and $t5, $t6, 1 # mask = crc and 1
	add $t9, $zero, -1 # Auxiliar
	mul $t5, $t5, $t9 # mask = -mask
	mflo $t5 # Pego o resultado da operação anterior
	srl $t8, $t6, 1 # aux_crc = crc >> 1
	and $t7, $t1, $t5 # aux = polynomial and mask
	xor $t6, $t8, $t7 # crc = (crc >> 1) ^ ( Polynomial & mask)
	addi $t4, $t4, -1 # Decremento o contador auxiliar
	beqz $t4, retorna_pc # Caso o contador auxiliar zere eu retorno para o PC
	j loop_aux # Pulo para o inicio do loop
	
retorna_pc:
	jr $ra # Retorno para o contador de programa
	
imprime_saida:
	nor $t6, $t6, $zero # Nego o CRC32 calculado (a negação terá o valor correto do CRC32)
	la $a0, msg_crc32 # carrego a mensagem da exibição do resultado
	li $v0, 4 # Carrego o imediato 4 (print string) em $v0
	syscall 
	
	add $a0, $t6, $zero # coloco em $a0 o valor do CRC calculado
	li $v0, 34 # Carrego o imediato 34 (print int in hex) em $v0
	syscall
	
	li $v0, 10 # Carrego o imedito 10 (exit) em $v0
	syscall
