    .text
    .globl main

main:
    sub         $sp , $sp , 4           # push stack
    sw          $ra , 0 ( $sp )     # save return address

    addi        $v0 , $0 , 4   
    la          $a0 , str1
    syscall     #printing str1

    addi        $v0 , $0 , 5   
    syscall     #get input

    move        $t0 , $v0               # save input in $t0
    move        $a0 , $v0
    addi        $v0 , $0 , 1
    syscall     #print first input

	.data
str1:.asciiz "\“Please enter the number of rows in the matrix\n"