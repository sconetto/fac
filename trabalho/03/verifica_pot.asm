.text
  addi $t0, $t0, 4
  addi $t4, $t4, 1
  
potencia_inteiro:
  add $t6, $t0, $zero        # Copio em $t6 o expoente que é igual a n da iteração 
  blez $t0, retorna_pc       # Verifico na chamada do potencial_inteiro se o meu termo é zero, caso sim eu retorno pois x^0 = 1 e o registrador $t4 já terá 1 inicializado

loop_potencia_inteiro:
  addi $t5, $zero, 4         # Coloco na minha auxiliar $t5 o valor 4
  mul $t4, $t4, $t5          # $t4 vai receber o seu valor atual vezes 4 a fim de calcular a potência
  addi $t6, $t6, -1          # Decremento o termo da potência
  blez $t6, retorna_pc       # Caso o expoente seja zero pula para a função de retornar ao cálculo
  j loop_potencia_inteiro    # Retorno ao loop
  
retorna_pc:
  jr $ra                     # Retorna para onde o contador de programa (PC) estiver apontando 
