# Seção para as variáveis estáticas
.data

msg_1: .asciiz "\nDigite o valor a ser calculado o arcoseno: \n"
msg_2: .asciiz "\nO arcoseno de "
msg_3: .asciiz " é "
msg_4: .asciiz ". Usamos "
msg_5: .asciiz " termos da serie.\n"
msg_erro: .asciiz "\nEste numero nao pertence ao intervalo de -1 a 1.\n"
test_1: .asciiz "\nIntervalo positivo\n"
test_2: .asciiz "\nIntervalo negativo\n"
pi: .float 3.1415926
zero: .float 0.0
positivo: .float 1.0
negativo: .float -1.0
precisao: .float 0.00000000001

# Seção para a execução do processador
.text

le_float:
  li $v0, 4                  # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_1              # Carrega em $a0 a primeira mensagem
  syscall                    # Chamada de sistema

  lwc1 $f4, zero             # Carrega para o coproc 1 o valor de zero (no registrador $f4)
  lwc1 $f6, positivo         # Carrega para o coproc 1 o valor de positivo (no registrador $f6)
  lwc1 $f8, negativo         # Carrega para o coproc 1 o valor de negativo (no registrador $f8)
  lwc1 $f10, pi              # Carrega para o coproc 1 o valor de pi  (no registrador $f10)
  lwc1 $f26, precisao        # Carrega para o coproc 1 o valor da precisão desejada (no registrador $f26)
  li $v0, 6                  # Carrega o imediato 6 (leitura de float) no registrador $v0
  syscall                    # Chamada de sistema (o float lido será colocado em $f0)


  add.s $f12, $f0, $f4       # Adiciona o valor lido que está em $f0 em $f12, pois $f4 é zero
#  li $v0, 2                 # Carrega o imediato 2 (impressão de float) no registrador $v0
#  syscall                   # Chamada de sistema
  
verifica_intervalo:
  c.lt.s $f12, $f4           # Verifica se o número lido que está em $f12 é menor que zero ($f4)
  bc1t intervalo_negativo    # Caso a verificação acima seja verdadeira pule para intervalo negativo
  c.lt.s $f4, $f12           # Verifica se zero ($f4) é menor que o número lido ($f12) 
  bc1t intervalo_positivo    # Caso a verificação acima seja verdadeira pule para intervalo positivo
  
intervalo_positivo:
  c.le.s $f12, $f6           # Verifica se o número lido ($f12) é menor ou igual a 1 positivo ($f6)
  bc1f imprime_erro          # Caso a verificação acima seja falsa, o número é maior que 1 e está fora do intervalo, pule para imprime_erro
  j calc_arcsen              # O número é válido, inicia o cálculo de arcsen
#  li $v0, 4
#  la $a0, test_1
#  syscall
#  li $v0, 10                 # Carrega em $v0 o imediato 10 (terminar execução)
#  syscall                    # Chamada de sistema


intervalo_negativo:
  c.le.s $f8, $f12           # Verifica se 1 negativo ($f8) é menor ou igual ao número lido ($f12)
  bc1f imprime_erro          # Caso a verificação acima seja falsa, o número é menor que -1 e está fora do intervalo, pule para imprime_erro
  j calc_arcsen              # O número é válido, inicia o cálculo de arcsen
#  li $v0, 4
#  la $a0, test_2
#  syscall
#  li $v0, 10                 # Carrega em $v0 o imediato 10 (terminar execução)
#  syscall                    # Chamada de sistema


calc_arcsen:
  # t0 = contador de iteração (número de temos - n)
  add $t0, $zero, $zero      # Inicializando o registrador $t0 (os termos da série começam em zero e vão até inf)
  # t1 = dividendo
  # t2 = divisor
  addi $t2, $zero, 1         # Inicializando o registrador $t1 (o divisor receberá uma série de multiplicações, logo inicializo com 1)
  # t3 = reservado para calcular fatoriais
  addi $t3, $zero, 1         # Inicializando o registrador $t3 (o fatorial receberá uma série de multiplicações, logo inicializo com 1)
  # t4 = reservado para calcular potencias
  addi $t4, $zero, 1         # Inicializando o registrador $t4 (a potência receberá uma série de multiplicações, logo inicializo com 1)
  # t5 = auxiliar 1
  # t6 = auxiliar 2
  # t7 = auxiliar 3
  # f2 = reservado para calcular potencias
  add.s $f2, $f4, $f6        # Inicializando o registrador $f2 (a potência receberá uma série de multiplicações, logo inicializo com 1)
  
  add.s $f14, $f4, $f12      # Copiando o valor lido de $f12 para $f14
  
loop_calc_arcsen:
  mul $t5, $t0, 2            # Calculo o valor de 2n 
  jal fatorial               # Pula para calcular o fatorial de 2n
  add $t1, $zero, $t3        # Adiciona a $t1 o resultado do cálculo de fatorial
  addi $t3, $zero, 1         # Reinicializo a auxiliar $t3 de calcular fatoriais
  add $t5, $t0, $zero        # Calcula o valor de n
  jal fatorial               # Pula para calcular o fatorial de n
  mul $t2, $t2, $t3          # Multiplico no divisor o calculo de n!
  mul $t2, $t2, $t2          # Como o meu divisor só tem n!, calculo o valor de (n!)^2
  mul $t5, $t0, 2            # Volto a calcular o valor de 2n
  addi $t5, $t5, 1           # Calculo o valor de 2n + 1
  mul $t2, $t2, $t5          # Calculo no meu divisor a equação ((n!)^2)*(2n+1)
  jal potencia_inteiro       # Para completar o meu divisor devo calcular 4^n, logo irei pular para a função potência e registrar em PC a chamada
  mul $t2, $t2, $t4          # Calcula o resultado do divisor completo (((n!)^2)*(2n+1))*(4^n)
  mul $t5, $t0, 2            # Volto a calcular o valor de 2n
  addi $t5, $t5, 1           # Calculo o valor de 2n + 1
  mtc1 $t1, $f16             # Movendo o dividendo de $t1 para $f16
  cvt.s.w $f16, $f16         # Convertendo para float o valor de $f16
  mtc1 $t2, $f18             # Movendo o divisor de $t2 para $f18
  cvt.s.w $f18, $f18         # Convertendo para float o valor de $f18
  jal potencia_x             # Para calcular o valor de x ^ (2n + 1)
  add.s $f20, $f4, $f2       # Copiando para o registrador $f20 o valor calculado na potencia_x
  # A partir de agora irei calcular o termo an da minha série e adicionar a soma final
  add.s $f22, $f4, $f16      # Adiciono ao registrador $f22 (termo an) o valor do dividendo
  div.s $f22, $f22, $f18     # Divido o meu registrador $f22 (termo an que contém o dividendo) o valor do divisor
  mul.s $f22, $f22, $f20     # Multiplico o meu registrador $f22 (termo an que contem o resultado da divisão) o valor de x ^ (2n + 1)
  add.s $f24, $f24, $f22     # Adiciono ao meu registrador $f24 o valor dele com o do termo an.
  c.le.s $f22, $f26          # Verifica se o termo an é menor que a precisão desejada
  bc1t imprime_saida         # Caso o termo seja menor que a precisão, termina a execução e imprime a saída
  addi $t0, $t0, 1           # Adiciona um ao iterador
  addi $t1, $zero, 1         # Reinicializo a auxiliar $t1 de calcular o dividendo
  addi $t2, $zero, 1         # Reinicializo a auxiliar $t2 de calcular o divisor
  addi $t3, $zero, 1         # Reinicializo a auxiliar $t3 de calcular fatoriais
  addi $t4, $zero, 1         # Reinicializo a auxiliar $t4 de calcular potencias de 4 ^ n
  j loop_calc_arcsen         # Volto para o início do loop do cálculo do arcsens

fatorial:
  blez $t0, retorna_pc       # Verifico na chamada do fatorial se o meu termo é zero, caso sim eu retorno pois 0! = 1 e o registrador $t3 já terá 1 inicializado

loop_fatorial:
  mul $t3, $t3, $t5          # Multiplica o resultado pelo termo
  addi $t5, $t5, -1          # Decrementa o termo para a próxima iteração
  blez $t5, retorna_pc       # Caso $t5 seja zero ou menor volta pula para a função de retornar ao cálculo
  j loop_fatorial            # Itera até a condição de parada
  
retorna_pc:
  jr $ra                     # Retorna para onde o contador de programa (PC) estiver apontando 

potencia_inteiro:
  add $t6, $t0, $zero        # Copio em $t6 o expoente que é igual a n da iteração 
  blez $t0, retorna_pc       # Verifico na chamada do potencia_inteiro se o meu termo é zero, caso sim eu retorno pois x^0 = 1 e o registrador $t4 já terá 1 inicializado

loop_potencia_inteiro:
  addi $t5, $zero, 4         # Coloco na minha auxiliar $t5 o valor 4
  mul $t4, $t4, $t5          # $t4 vai receber o seu valor atual vezes 4 a fim de calcular a potência
  addi $t6, $t6, -1          # Decremento o termo da potência
  blez $t6, retorna_pc       # Caso o expoente seja zero pula para a função de retornar ao cálculo
  j loop_potencia_inteiro    # Retorno ao loop
  
potencia_x:
  add $t6, $t5, $zero        # Copio em $t6 o expoente que é igual a (2n + 1) da iteração
  blez $t6, retorna_pc       # Verifico na chamada do potencia_x se o meu termo é zero, caso sim eu retorno pois x^0 = 1 e o registrador $f2 já terá 1 inicializado

loop_potencia_x:
  mul.s $f2, $f2, $f14       # #$f2 = $f2 * x - cada iteração o $f2 será multiplicado por x.
  addi $t6, $t6, -1          # Decremento o termo da potência
  blez $t6, retorna_pc       # Caso o expoente seja zero pula para a função de retornar ao cálculo
  j loop_potencia_x          # Retorno ao loop
  

imprime_saida:
  li $v0, 4                  # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_2              # Carrega em $a0 o início da mensagem de saída
  syscall                    # Chamada de sistema
  add.s $f12, $f12, $f4      # Adiciona o valor lido que está em $f14 em $f12, pois $f4 é zero
  li $v0, 2                  # Carrega o imediato 2 (impressão de float) no registrador $v0
  syscall                    # Chamada de sistema
  li $v0, 4                  # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_3              # Carrega em $a0 o meio da mensagem de saída
  syscall                    # Chamada de sistema
  add.s $f12, $f24, $f4      # Adiciona o valor da soma que está em $f24 em $f12, pois $f4 é zero
  li $v0, 2                  # Carrega o imediato 2 (impressão de float) no registrador $v0
  syscall                    # Chamada de sistema
  li $v0, 4                  # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_4              # Carrega em $a0 o meio da mensagem de saída
  syscall                    # Chamada de sistema
  add $a0, $t0, $zero        # Adiciona o valor do n ao registrador $a0
  li $v0, 1                  # Carrega o imediato 2 (impressão de float) no registrador $v0
  syscall                    # Chamada de sistema
  li $v0, 4                  # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_5              # Carrega em $a0 o fim da mensagem de saída
  syscall                    # Chamada de sistema
  li $v0, 10                 # Carrega em $v0 o imediato 10 (terminar execução)
  syscall                    # Chamada de sistema
  
  
imprime_erro:
  li $v0, 4                 # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_erro          # Carrega em $a0 a mensagem de erro
  syscall                   # Chamada de sistema
  li $v0, 10                 # Carrega em $v0 o imediato 10 (terminar execução)
  syscall                    # Chamada de sistema
