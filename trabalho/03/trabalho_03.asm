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
  li $v0, 10                 # Carrega em $v0 o imediato 10 (terminar execução)
  syscall                    # Chamada de sistema


intervalo_negativo:
  c.le.s $f8, $f12           # Verifica se 1 negativo ($f8) é menor ou igual ao número lido ($f12)
  bc1f imprime_erro          # Caso a verificação acima seja falsa, o número é menor que -1 e está fora do intervalo, pule para imprime_erro
  li $v0, 4
  la $a0, test_2
  syscall
  li $v0, 10                 # Carrega em $v0 o imediato 10 (terminar execução)
  syscall                    # Chamada de sistema


calc_arcsen:

imprime_saida:

imprime_erro:
  li $v0, 4                 # Carrega o imediato 4 (impressão de string) no registrador $v0
  la $a0, msg_erro          # Carrega em $a0 a mensagem de erro
  syscall                   # Chamada de sistema
