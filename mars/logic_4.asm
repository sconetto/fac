.data
.text
	addi $at, $zero, 1431655765
	sll $v0, $at, 1
	or $v1, $at, $v0
	and $a0, $at, $v0
	xor $a1, $at, $v0