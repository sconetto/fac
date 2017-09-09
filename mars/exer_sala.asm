# Varre vetor sala de bytes e conta a quantidade de bytes com valor 1 no vetor.
      	.data
sala: 	.space	64		# "array" de 64 bytes
lixos: 	.word  0             	# variavel que conta o numero de lixos
tam:	.word	64		# variavel que armazena o comprimento em bytes de sala
string1: .asciiz " \n"
      	.text
main:
	la $t0, sala		# carrega o endereco de sala em $t0
	lw $t1, tam		# carrega o comprimento de sala em $t1
	
	li $t2, 0		# zera $t2 (contador de lixos)

ciclo:
	lbu   $t3, 0($t0)      	# carrega em $t3 o valor de sala[n]
	bne  $t3, 1, nao_zero
	addi $t2, $t2, 1      	# registra lixo encontrado
	
nao_zero:
	addi $t0, $t0, 1	# avanca no vetor sala
	addi $t1, $t1, -1	# decrementa contador ($t1)
	bgtz $t1, ciclo  	# continua ate varrer integralmente o array

continua:

	
Fim:
	sw $t2, lixos
	
	li  $v0, 1           # service 1 is print integer
	add $a0, $t2, $zero  # load desired value into argument register $a0, using pseudo-op
    	syscall
    	
    	li $v0, 4
    	la $a0, string1
    	syscall
    	
    	li  $v0, 5           # service 5 is read integer
    	syscall
    	
    	add $a0, $v0, $zero
    	li  $v0, 1           # service 1 is print integer
    	syscall