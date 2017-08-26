	.data
     buffer: .space 80
     msg:  .asciiz "Escreva a string: "
     out_msg: .asciiz "Você escreveu:\n"
     
     	.text
     la $a0, msg # Carrega em $a0 a mensagem
     li $v0, 4 # Carrega o imediato 4 (print string) no registrador $v0
     syscall
     
     li $v0, 8 # Carrega o imediato 8 (read string) no registrador $v0
     la $a0, buffer # Carrega o tamanho em bytes no endereço
     li $a1, 80 # Atribui o espaço em bytes para a string
     move $t0, $a0 # Salva a string em $t0
     syscall
     
     la $a0, out_msg # Carrega a mensagem de saída em $a0
     li $v0, 4 # Carrega o imediato 4 (print string) no registrador $v0
     syscall
     
     la $a0, buffer # Carrega em $a0 o endereço do buffer
     move $a0,$t0 # Move para $a0 o valor armazenado em $t0
     li $v0,4 # Carrega o imediato 4 (print string) no registrador $v0
     syscall

     li $v0,10 # Carrega o imediato 10 (terminate execution) no registrador $v0
     syscall
     