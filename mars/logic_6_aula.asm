.data
.text
main:
	ori $t0, $zero, 0x76543210
	or $t1, $zero, $zero
	ori $t2, $zero, 0xF0000000
	ori $t4, $zero, 28
loop:
	and $t3, $t2, $t0
	srlv $t3, $t3, $t4
	or $t1, $t1, $t3
	srl $t2, $t2, 4
	addi $t4, $t4, -8
	bgez $t4, loop
	
	ori $t4, $zero, 4
	
loop2:
	and $t3, $t2, $t0
	sllv $t3, $t3, $t4
	or $t1, $t1, $t3
	srl $t2, $t2, 4
	addi $t4, $t4, 8
	blt $t4, 0x20, loop2