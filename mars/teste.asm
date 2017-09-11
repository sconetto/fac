.data
 numero: .float 3.4
.text
main:
	li $v0, 2
	l.s $f1, numero
	mov.s $f12, $f1
	syscall
