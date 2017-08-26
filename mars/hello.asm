	.data
	# Declara a variável out_string ASCII
out_string: .asciiz "\nAlô Mundo!\n"

	.text
	#Declara a função main:
main:
	li $v0, 4 # Carrega o imediato 4 (serviço de impressão de string) em $v0 (variável de retorno de parêmetro)
	la $a0, out_string # Carrega o endereço de out_string em $a0 (variável de retorno de função)
	syscall # Chamada do sistema para execução