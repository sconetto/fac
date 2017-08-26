.data
.text
main:
	ori $at, $zero, 0x01
	sll $v0, $at, 1
	addi $v1, $v0, 1
	addi $a0, $v1, 1
	addi $a1, $a0, 1
	addi $a2, $a1, 1
	addi $a3, $a2, 1