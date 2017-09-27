# Seção para as variáveis estáticas
.data

msg_1: .asciiz "\nDigite o valor a ser calculado o arcoseno: \n"
msg_2: .asciiz "\nO arcoseno de "
msg_3: .asciiz "é "
msg_4: .asciiz ". Usamos"
msg_5: .asciiz "termos da serie.\n"
msg_erro: .asciiz "\nEste numero nao pertence ao intervalo de -1 a 1.\n"
test_1: .asciiz "\nIntervalo positivo\n"
test_2: .asciiz "\nIntervalo negativo\n"
pi: .float 3.1415926
zero: .float 0.0
positivo: .float 1.0
negativo: .float -1.0
precisao: .float 0.0000000001

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
  li $v0, 6                  # Carrega o imediato 6 (leitura de float) no registrador $v0
  syscall                    # Chamada de sistema (o float lido será colocado em $f0)


  add.s $f12, $f0, $f4       # Adiciona o valor lido que está em $f0 em $f12, pois $f4 é zero
  li $v0, 2                  # Carrega o imediato 2 (impressão de float) no registrador $v0
  syscall                    # Chamada de sistema
  
verifica_intervalo:
  c.lt.s $f12, $f4           # Verifica se o número lido que está em $f12 é menor que zero ($f4)
  bc1t intervalo_negativo    # Caso a verificação acima seja verdadeira pule para intervalo negativo
  c.lt.s $f4, $f12           # Verifica se zero ($f4) é menor que o número lido ($f12) 
  bc1t intervalo_positivo    # Caso a verificação acima seja verdadeira pule para intervalo positivo
  
intervalo_positivo:
  c.le.s $f12, $f6           # Verifica se o número lido ($f12) é menor ou igual a 1 positivo ($f6)
  bc1f imprime_erro          # Caso a verificação acima seja falsa, o número é maior que 1 e está fora do intervalo, pule para imprime_erro
  li $v0, 4
  la $a0, test_1
  syscall
#  li $v0, 10                 # Carrega em $v0 o imediato 10 (terminar execução)
#  syscall                    # Chamada de sistema


intervalo_negativo:
  c.le.s $f8, $f12           # Verifica se 1 negativo ($f8) é menor ou igual ao número lido ($f12)
  bc1f imprime_erro          # Caso a verificação acima seja falsa, o número é menor que -1 e está fora do intervalo, pule para imprime_erro
  li $v0, 4
  la $a0, test_2
  syscall
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
  
  add.s $f14, $f4, $f12      # Copiando o valor lido de $f12 para $f14
  addi $t0, $zero, $t0       # Criando um contador de iterações
  mul $t5, $t0, 2            # Calculo o valor de 2n 
  jal fatorial               # Pula para calcular o fatorial de 2n
  add $t1, $zero, $t3        # Adiciona a $t1 o resultado do cálculo de fatorial
  add $t5, $t0, $zero        # Calcula o valor de n
  jal fatorial               # Pula para calcular o fatorial de n
  mul $t2, $t2, $t5          # Multiplico no divisor o calculo de n!
  mul $t2, $t2, $t2          # Como o meu divisor só tem n!, calculo o valor de (n!)^2
  mul $t5, $t0, 2            # Volto a calcular o valor de 2n
  addi $t5, $t5, 1           # Calculo o valor de 2n + 1
  mul $t2, $t2, $t5          # Calculo no meu divisor a equação ((n!)^2)*(2n+1)
  jal potencia_inteiro       # Para completar o meu divisor devo calcular 4^n, logo irei pular para a função potência e registrar em PC a chamada
  mul $t2, $t2, $t4          # Calcula o resultado do divisor completo (((n!)^2)*(2n+1))*(4^n)
  mul $t5, $t0, 2            # Volto a calcular o valor de 2n
  addi $t5, $t5, 1           # Calculo o valor de 2n + 1
  # TODO -> Calcular o valor de x ^ (2n + 1)
  # TODO -> Calcular a divisão do dividendo com o divisor em ponto flutuante ($t1 e $t2)
  # TODO -> Calcular o termo An a partir do resultado da divisão multiplicado por x ^ (2n + 1)
  

fatorial:
  blez $t0, retorna_pc       # Verifico na chamada do fatorial se o meu termo é zero, caso sim eu retorno pois 0! = 1 e o registrador $t3 já terá 1 inicializado
  mul $t3, $t3, $t5          # Multiplica o resultado pelo termo
  addi $t5, $t5, -1          # Decrementa o termo para a próxima iteração
  blez $t5, retorna_pc       # Caso $t5 seja zero ou menor volta pula para a função de retornar ao cálculo
  j fatorial                 # Itera até a condição de parada
  
retorna_pc:
  jr $ra                     # Retorna para onde o contador de programa (PC) estiver apontando 

potencia_inteiro:
  add $t6, $t0, $zero        # Copio em $t6 o expoente que é igual a n da iteração 
  blez $t0, retorna_pc       # Verifico na chamada do potencial_inteiro se o meu termo é zero, caso sim eu retorno pois x^0 = 1 e o registrador $t4 já terá 1 inicializado

loop_potencia_inteiro:
  addi $t5, $zero, 4         # Coloco na minha auxiliar $t5 o valor 4
  mul $t4, $t4, $t5          # $t4 vai receber o seu valor atual vezes 4 a fim de calcular a potência
  addi $t6, $t6, -1          # Decremento o termo da potência
  blez $t6, retorna_pc       # Caso o expoente seja zero pula para a função de retornar ao cálculo
  j loop_potencia_inteiro    # Retorno ao loop
  

imprime_saida:

imprime_erro:
  li $v0, 4                 # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_erro          # Carrega em $a0 a mensagem de erro
  syscall                   # Chamada de sistema
