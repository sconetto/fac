# Program Alô Mundo!

	.data

out_string: .asciiz "\nAlo Mundo!\n"

	.text

main:
	li $v0, 4
	la $a0, out_string
	syscall