# Seção para as variáveis estáticas
.data

msg_1: .asciiz "Escreva a String que deseja calcular o CRC32: "
msg_2: .asciiz "String de entrada: "
msg_crc32: .asciiz "CRC32: "
buffer: .space 16
polynomial: .word 0x04C11DB7

# Seção para a execução do processador
.text

le_string:
	la $a0, msg_1                         # Carrega em $a0 a mensagem
	li $v0, 4                                 # Carrega o imediato 4 (print string) no registrador $v0
	syscall
     
	li $v0, 8 # Carrega o imediato 8 (read string) no registrador $v0
	la $a0, buffer # Carrega o tamanho em bytes no endereço
	li $a1, 16 # Atribui o espaço em bytes para a string
	move $t0, $a0 # Salva a string em $t0
	syscall
     
	la $a0, buffer # Carrega em $a0 o endereço do buffer
	move $a0,$t0 # Move para $a0 o valor armazenado em $t0
	li $v0,4 # Carrega o imediato 4 (print string) no registrador $v0
	syscall
     
calc_crc32:
	lw $t1, polynomial
imprime_saida: