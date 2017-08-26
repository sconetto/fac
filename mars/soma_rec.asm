	.data

	.text
	
soma_recursiva:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	slti $t0, $a0, 1
	beq $t0, $zero, L1
	add $v0, $zero, $zero
	jr $ra
	
L1:
	addi $a0, $a0, -1
	jal soma_recursiva
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	add $v0, $a0, $v0
	jr $ra

main:
	