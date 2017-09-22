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

# Seção para a execução do processador
.text

le_float:
  li $v0, 4
  la $a0, msg_1
  syscall

  lwc1 $f8, zero
  lwc1 $f9, positivo
  lwc1 $f10, negativo
  lwc1 $f11, pi
  li $v0, 6
  syscall

  add.s $f12, $f0, $f8
  li $v0, 2
  syscall
  
verifica_intervalo:
  c.lt.s $f12, $f8
  bc1t intervalo_negativo
  c.lt.s $f8, $f12
  bc1t intervalo_positivo
  
intervalo_positivo:
  c.le.s $f12, $f9
  bc1f imprime_erro
  li $v0, 4
  la $a0, test_1
  syscall
  li $v0, 10         # Carrega em $v0 o imediato 10 (terminar execução)
  syscall            # Chamada de sistema


intervalo_negativo:
  c.le.s $f10, $f12
  bc1f imprime_erro
  li $v0, 4
  la $a0, test_2
  syscall
  li $v0, 10         # Carrega em $v0 o imediato 10 (terminar execução)
  syscall            # Chamada de sistema


calc_arcsen:

imprime_saida:

imprime_erro:
  li $v0, 4
  la $a0, msg_erro
  syscall
