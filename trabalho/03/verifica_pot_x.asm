.data
pi: .float 0.9
zero: .float 0.0
positivo: .float 1.0
negativo: .float -1.0
precisao: .float 0.0000000001

.text
  
  addi $t5, $zero, 3
  lwc1 $f4, zero             # Carrega para o coproc 1 o valor de zero (no registrador $f4)
  lwc1 $f6, positivo         # Carrega para o coproc 1 o valor de positivo (no registrador $f6)
  lwc1 $f8, negativo         # Carrega para o coproc 1 o valor de negativo (no registrador $f8)
  add.s $f2, $f4, $f6        # Inicializando o registrador $f2 (a potência receberá uma série de multiplicações, logo inicializo com 1)
  lwc1 $f14, pi
  
potencia_x:
  add $t6, $t5, $zero        # Copio em $t6 o expoente que é igual a (2n + 1) da iteração
  blez $t5, retorna_pc       # Verifico na chamada do potencia_x se o meu termo é zero, caso sim eu retorno pois x^0 = 1 e o registrador $f2 já terá 1 inicializado

loop_potencia_x:
  mul.s $f2, $f2, $f14       # #$f2 = $f2 * x - cada iteração o $f2 será multiplicado por x.
  addi $t6, $t6, -1          # Decremento o termo da potência
  blez $t6, retorna_pc       # Caso o expoente seja zero pula para a função de retornar ao cálculo
  j loop_potencia_x          # Retorno ao loop
  
retorna_pc:
  li $v0, 10                 # Carrega em $v0 o imediato 10 (terminar execução)
  syscall                    # Chamada de sistema
