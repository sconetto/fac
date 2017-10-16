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
precisao: .float 0.00000000000000000001
const: .float 4.0

# Seção para a execução do processador
.text

le_float:
  li $v0, 4                    # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_1                # Carrega em $a0 a primeira mensagem
  syscall                      # Chamada de sistema

  lwc1 $f2, zero               # Carrega para o coproc 1 o valor de zero (no registrador $f4)
  lwc1 $f3, positivo           # Carrega para o coproc 1 o valor de positivo (no registrador $f6)
  lwc1 $f4, negativo           # Carrega para o coproc 1 o valor de negativo (no registrador $f8)
  lwc1 $f5, pi                 # Carrega para o coproc 1 o valor de pi  (no registrador $f10)
  lwc1 $f6, precisao           # Carrega para o coproc 1 o valor da precisão desejada (no registrador $f26)
  li $v0, 6                    # Carrega o imediato 6 (leitura de float) no registrador $v0
  syscall                      # Chamada de sistema (o float lido será colocado em $f0)

  add.s $f1, $f0, $f2          # Adiciona o valor lido que está em $f0 em $f1, pois $f2 é zero
  
verifica_intervalo:
  c.lt.s $f1, $f2              # Verifica se o número lido que está em $f1 é menor que zero ($f2)
  bc1t intervalo_negativo      # Caso a verificação acima seja verdadeira pule para intervalo negativo
  c.lt.s $f2, $f1              # Verifica se zero ($f2) é menor que o número lido ($f1) 
  bc1t intervalo_positivo      # Caso a verificação acima seja verdadeira pule para intervalo positivo
  
intervalo_positivo:
  c.le.s $f1, $f3              # Verifica se o número lido ($f1) é menor ou igual a 1 positivo ($f3)
  bc1f imprime_erro            # Caso a verificação acima seja falsa, o número é maior que 1 e está fora do intervalo, pule para imprime_erro
  j calc_arcsen                # O número é válido, inicia o cálculo de arcsen
  
intervalo_negativo:
  c.le.s $f4, $f1              # Verifica se 1 negativo ($f4) é menor ou igual ao número lido ($f1)
  mul.s $f6, $f6, $f4          # Caso o número seja negativo inverte a precisão para negativa, caso contrário no primeiro termo o An já será menor que a precisão
  bc1f imprime_erro            # Caso a verificação acima seja falsa, o número é menor que -1 e está fora do intervalo, pule para imprime_erro
  j calc_arcsen                # O número é válido, inicia o cálculo de arcsen
 
calc_arcsen:
  # t0 = contador de iteração (número de temos - n)
  add $t0, $zero, $zero        # Inicializando o registrador $t0 (os termos da série começam em zero e vão até inf)
  # t1 = auxiliar para potências
  addi $t1, $zero, 1           # Inicializando o registrador $t1 (com 1 para o cálculo de potências)
  # t2 = auxiliar para fatoriais
  addi $t2, $zero, 1           # Inicializando o registrador $t2 (com 1 para o cálculo de fatorias)
  add.s $f7, $f2, $f3          # Inicializando o meu registrador do dividendo (com 1)
  add.s $f8, $f2, $f3          # Inicializando o meu registrador do divisor (com 1)
  add.s $f10, $f2, $f2         # Inicializando o meu registrador do termo An (com 0)
  add.s $f11, $f2, $f2         # Inicializando o meu registrador da soma total (com 0)
  add.s $f13, $f2, $f3         # Inicializando o meu registrador auxiliar de cálculo de fatorial (com 1)
  add.s $f14, $f2, $f3         # Inicializando o meu registrador auxiliar de cálculo de potências (com 1)
  # $f31 = x (valor lido)
  add.s $f31, $f1, $f2         # Cópia do valor lido x
  
  
loop_calc_arcsen:
  mul $t3, $t0, 2              # Calculo o valor de 2n
  jal fatorial                 # Calcula o fatorial de 2n, o resultado estará no registrador $f13
  mul.s	$f7, $f7, $f13         # Coloco no meu dividendo o valor de 2n!
  add.s $f13, $f2, $f3         # Reinicializo meu auxiliar de fatoriais
  add $t3, $zero, $t0          # Calculo o valor de n
  jal fatorial                 # Calcula o fatorial de n, o resultado estará no registrador $f13
  mul.s $f8, $f8, $f13         # Coloco no meu divisor n!
  add.s $f13, $f2, $f3         # Reinicializo meu auxiliar de fatoriais
  mul.s $f8, $f8, $f8          # Como o meu divisor só tem n!, calculo o valor de (n!)^2
  mul $t3, $t0, 2              # Volto a calcular o valor de 2n
  addi $t3, $t3, 1             # Calculo o valor de 2n + 1
  mtc1 $t3, $f15               # Movendo o valor de 2n + 1 para o coproc 1
  cvt.s.w $f15, $f15           # Convertendo para float o valor de $f15
  mul.s $f8, $f8, $f15         # Calculo no meu divisor a equação ((n!)^2)*(2n+1)
  add $t3, $zero, $t0          # Volto a calcular o valor de n
  jal potencia                 # Para completar o meu divisor devo calcular 4^n, logo irei pular para a função potência e registrar em PC a chamada, o resultado está em $f14
  mul.s $f8, $f8, $f14         # Calcula o resultado do divisor completo (((n!)^2)*(2n+1))*(4^n)
  add.s $f14, $f2, $f3         # Reinicializo meu auxiliar de potências
  mul $t3, $t0, 2              # Volto a calcular o valor de 2n
  addi $t3, $t3, 1             # Volto a calcular o valor de 2n + 1
  jal potencia_x               # Para calcular o valor de x ^ (2n + 1), o resultado estará em $f14
  # A partir de agora irei calcular o termo An da minha série e adicionar a soma final
  add.s $f10, $f2, $f7         # Adiciono no An o meu dividendo
  div.s $f10, $f10, $f8        # Agora divido o dividendo pelo divisor
  mul.s $f10, $f10, $f14       # Agora multiplico pelo resultado da potência de x ^ (2n+1)
  # Temos então em $f10 ((2n!)\((4^n)*(n!^2)*(2n+1)))*(x^(2n+1)) que é o termo An da minha série
  add.s $f11, $f11, $f10       # Minha soma (registrador $f11) vai receber o que já tem acumulado mais o termo An
  jal compara_precisao        # Verifico agora se o meu termo An ainda é maior que a minha precisão desejada, caso sim, continue iterando
  bc1t imprime_saida           # Caso o termo seja menor que a precisão, termina a execução e imprime a saída
  addi $t0, $t0, 1             # Adiciona 1 ao iterador
  addi $t1, $zero, 1           # Reinicializo a auxiliar $t1 de auxiliar a potência
  addi $t2, $zero, 1           # Reinicializo a auxiliar $t2 de auxililar fatorial
  addi $t3, $zero, 1           # Reinicializo a auxiliar $t3 de auxiliar geral 1
  addi $t4, $zero, 1           # Reinicializo a auxiliar $t4 de calcular potências de 4 ^ n
  add.s $f7, $f2, $f3          # Reinicializo meu dividendo
  add.s $f8, $f2, $f3          # Reincializo meu divisor
  add.s $f10, $f2, $f2         # Reinicializo meu termo An 
  add.s $f13, $f2, $f3         # Reinicializo meu axuliar de fatorial
  add.s $f14, $f2, $f3         # Reinicializo meu auxiliar de potênias
  j loop_calc_arcsen           # Volto para o início do loop do cálculo de arcsen
    
fatorial:
  blez $t0, retorna_pc         # Verifico na chamada do fatorial se o meu termo é zero, caso sim eu retorno a execução por 0! = 1 e $f13 que é a auxiliar de fatoriais já é 1
  mtc1 $t3, $f15               # Movendo o valor de 2n para o auxiliar geral $f15
  cvt.s.w $f15, $f15           # Convertendo o valor de $f15 para float
  
loop_fatorial:
  mul.s $f13, $f15, $f15       # Multiplica o fatorial pelo termo
  add.s $f15, $f15, $f4        # Decrementa o termo para a próxima iteração
  addi $t3, $t3, -1            # Decrementa o termo para verificação
  blez $t3, retorna_pc         # Caso $t3 seja zero ou menor volta para a função de calcular arcsen
  j loop_fatorial              # Itera até a condição de parada  

potencia:
  blez $t0, retorna_pc         # Verifico na chamada do fatorial se o meu termo é zero, caso sim eu retorno a execução por 0! = 1 e $f13 que é a auxiliar de fatoriais já é 1
  lwc1 $f16, const             # Carrego no meu auxiliar a constante 4
  
loop_potencia:
  mul.s $f14, $f14, $f16       # $f14 vai receber o seu valor atual vezes 4 a fim de calcular a potência
  addi $t3, $t3, -1            # Decremento o o valor de n
  blez $t3, retorna_pc         # Caso o expoente seja zero pula para a função de retornar o cálculo
  j loop_potencia              # Retorna ao loop
  
potencia_x:
  add $t4, $t3, $zero          # Copio em $t4 o expoente que é igual a (2n + 1) da iteração
  blez $t4, retorna_pc         # Verifico na chamada do potencia_x se o meu termo é zero, caso sim eu retorno pois x^0 = 1 e o registrador $f14 já terá 1 inicializado

loop_potencia_x:
  mul.s $f14, $f14, $f1        # #$f2 = $f2 * x - cada iteração o $f2 será multiplicado por x.
  addi $t4, $t4, -1            # Decremento o termo da potência
  blez $t4, retorna_pc         # Caso o expoente seja zero pula para a função de retornar ao cálculo
  j loop_potencia_x            # Retorno ao loop

compara_precisao:
  c.le.s $f6, $f2              # Se minha precisão for negativa eu seto a flag true, se não eu seto false
  bc1t compara_negativo        # Se a flag for true comparo negativo
  bc1f compara_positivo        # Se a flag for false comparo positivo
 
compara_negativo:
  c.le.s $f6, $f10             # Verifica se o termo an é menor que a precisão desejada
  j retorna_pc                 # Retorna a chamada da função

compara_positivo:
  c.le.s $f10, $f6             # Verifica se o termo an é menor que a precisão desejada
  j retorna_pc                 # Retorna a chamada da função

retorna_pc:
  jr $ra                       # Retorna para onde o contador de programa (PC) estiver apontando
  
imprime_saida:
  li $v0, 4                    # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_2                # Carrega em $a0 o início da mensagem de saída
  syscall                      # Chamada de sistema
  add.s $f12, $f1, $f2         # Adiciona o valor lido que está em $f1 em $f12, pois $f2 é zero
  li $v0, 2                    # Carrega o imediato 2 (impressão de float) no registrador $v0
  syscall                      # Chamada de sistema
  li $v0, 4                    # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_3                # Carrega em $a0 o meio da mensagem de saída
  syscall                      # Chamada de sistema
  add.s $f12, $f11, $f2        # Adiciona o valor da soma que está em $f11 em $f12, pois $f2 é zero
  li $v0, 2                    # Carrega o imediato 2 (impressão de float) no registrador $v0
  syscall                      # Chamada de sistema
  li $v0, 4                    # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_4                # Carrega em $a0 o meio da mensagem de saída
  syscall                      # Chamada de sistema
  add $a0, $t0, $zero          # Adiciona o valor do n ao registrador $a0
  li $v0, 1                    # Carrega o imediato 2 (impressão de float) no registrador $v0
  syscall                      # Chamada de sistema
  li $v0, 4                    # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_5                # Carrega em $a0 o fim da mensagem de saída
  syscall                      # Chamada de sistema
  li $v0, 10                   # Carrega em $v0 o imediato 10 (terminar execução)
  syscall                      # Chamada de sistema
  
imprime_erro:
  li $v0, 4                    # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_erro             # Carrega em $a0 a mensagem de erro
  syscall                      # Chamada de sistema
  li $v0, 10                   # Carrega em $v0 o imediato 10 (terminar execução)
  syscall                      # Chamada de sistema
