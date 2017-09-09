.data
.text
main:
	ori $at, $zero, 0x76543210
	or $v0, $zero, $at
	or $v1, $zero, $at
	srl $at, $at, 28
	sll $v0, $v0, 4
	srl $v0, $v0, 28
	sll $v0, $v0, 4
	or $at, $v0, $at
	and $v0, $v0, $zero
	or $v0, $v1, $zero
	sll $v0, $v0, 8
	srl $v0, $v0, 28
	sll $v0, $v0, 8
	or $at, $v0, $at
	and $v0, $v0, $zero
	or $v0, $v1, $zero
	sll $v0, $v0, 12
	srl $v0, $v0, 28
	sll $v0, $v0, 12
	or $at, $v0, $at
	and $v0, $v0, $zero
	or $v0, $v1, $zero
	sll $v0, $v0, 16
	srl $v0, $v0, 28
	sll $v0, $v0, 16
	or $at, $v0, $at
	and $v0, $v0, $zero
	or $v0, $v1, $zero
	sll $v0, $v0, 20
	srl $v0, $v0, 28
	sll $v0, $v0, 20
	or $at, $v0, $at
	and $v0, $v0, $zero
	or $v0, $v1, $zero
	sll $v0, $v0, 24
	srl $v0, $v0, 28
	sll $v0, $v0, 24
	or $at, $v0, $at
	and $v0, $zero, $zero
	and $v1, $zero, $zero
	
