.data
.text
main:
	ori $at, $zero, 0x01
	sll $v0, $at, 1
	or $v1, $v0, $at
	sll $a0, $at, 2
	or $a1, $a0, $at
	sll $a2, $v1, 1
	or $a3, $a2, $at
