.data
	character: .space 4
	buffer: .space 80
	msg: .asciiz "Digite a string: \n"
	final_msg: .asciiz "Espaços na string: "
	space_char: .asciiz " "

.text
.globl main
main:
	# Declarando alguns valores nos registradores temporários
	li $t0, 80 # Vezes máximas da execução do loop
	li $t1, 0 # Início do loop
	li $t2, 0 # Número de espaços em branco (0x20)

	la $a0, msg # Carregando a mensagem para digitar a string
	li $v0, 4 # Carrega o imediato 4 (print string) no registrador $v0
	syscall
	
	la $a0, buffer # Carrega um endereço com espaço 80 para string
	li $a1, 80 # Carrega em $a1 80 para o tamanho da string
	li $v0, 8 # Carrega o imediato 8 (read string) no registrador $v0
	syscall
		
	la $s0, space_char
	lb $s1, ($s0)
	la $t3, buffer
	lb $a2, ($t3)
	
loop:
    beq $a2, $zero, end     #once reach end of char array, prints result
    beq $a2, $s1, something #if the char within sentence == comparing char
    addi $t3, $t3, 1
    lb $a2, 0($t3)        
    j loop

something:
    addi $t2, $t2, 1
end:
    la $a0, final_msg
    li $v0, 4
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall

	
	