.data
 buffer: .space 50
 name: .asciiz "Program Penghitung Nilai"
 enter_number: .asciiz "Masukkan nilai:  "
 number_out: .asciiz "Your numbers are:  "
 newline: .asciiz "\n"
 blank: .asciiz " "
 max_print: .asciiz "Nilai tertinggi: "
 min_print:.asciiz "Nilai terendah: "
 av_print: .asciiz "Nilai rata-rata: "
 .text
 .globl main
 getvalues:
# Name:  getvalues
# Input parameters: $a0, address of the array to store values
# Return values:  $v0 = the number of values input by the user
# Description:  This procedure will prompt the user to enter values and store them in an array. 
# All values given will be positive. The procedure will return once eight values have been entered 
#  or if the user inputs a zero. The number of elements input (either 8 or less than 8) will be 
# returned in $v0.
 addi $t2,$a0,0
 addi $t3,$a0,32
 la $a0,name
 li $v0, 4 # print string (address of string already in $a0)
 syscall # do it 
 la $a0,newline
 li $v0, 4 # print string (address of string already in $a0)
 syscall # do it 
loop_in:
 la $a0,enter_number
 li $v0, 4 # print string (address of string already in $a0)
 syscall # do it 
 li $v0, 6 # read float
 syscall # do it
 mfc1 $t1, $f0
 beq $t1,$zero,ret_fr_in
 sw $t1,0($t2)
 addi $t2,$t2,4
 beq $t2,$t3,ret_fr_in
     j loop_in
ret_fr_in: 
 la $a0,buffer
 sub $t2,$t2,$a0
 addi $t1,$zero,4
 div $t2,$t1
 mflo $t2
 addi $v0,$t2,0
 jr $ra # return, result is already in $v0
 print:
# Name:  print
# Input parameters: $a0, address of the array containing input values
# $a1, the number of valid values in the array
# Return values:  none
# Description:  This procedure will print all valid elements entered by the user
 addi $t0,$a0,0
 addi $t1,$zero,4
 mult $a1,$t1
 mflo $a1
 add $t4,$a1,$a0
 la $a0,number_out
 li $v0, 4 # print 
 syscall # do it
 la $a0,newline
 li $v0, 4 # print string (address of string already in $a0)
 syscall # do it 
loop_print:
 lw $t1,0($t0)
 mtc1 $t1, $f12
 li $v0, 2 # print float in $f12
 syscall # do it
 la $a0,blank
 li $v0, 4 # print 
 syscall # do it 
 addi $t0,$t0,4 
 bne $t0,$t4,loop_print
 la $a0,newline
 li $v0, 4 # print string (address of string already in $a0)
 syscall # do it 
 jr $ra # return
 
 
 max:
# Name:  max
# Input parameters: $a0, address of the array containing input values
# $a1, the number of valid values in the array
# Return values:  $f0 = the greatest element input
# Description:  This procedure will return the greatest value input by the user
 addi $t1,$a0,0
 addi $t5,$zero,4
 mult $a1,$t5
 mflo $a1
 add $t4,$a1,$a0
 # $f0 = max
 lw $t0,0($t1) # max = a[0]
 mtc1 $t0,$f0 
next_max: 
 addi $t1,$t1,4 
 beq $t1,$t4,ret_fr_max
 lw $t0,0($t1)
 mtc1 $t0,$f1 
 c.le.s $f0, $f1
 bc1t new_max
 nop
 j next_max
ret_fr_max: 
 jr $ra # return
new_max:  
 mov.s $f0, $f1
 j next_max
min:
# Name:  min
# Input parameters: $a0, address of the array containing input values
# $a1, the number of valid values in the array
# Return values:  $f0 = the smallest element input
# Description:  This procedure will return the smallest value input by the user
 addi $t1,$a0,0
 addi $t5,$zero,4
 mult $a1,$t5
 mflo $a1
 add $t4,$a1,$a0
 # $f0 = min
 lw $t0,0($t1) # min = $f0
 mtc1 $t0,$f0 
next_min: 
 addi $t1,$t1,4 
 beq $t1,$t4,ret_fr_min
 lw $t0,0($t1)
 mtc1 $t0,$f1 
 c.le.s $f1, $f0
 bc1t new_min
 nop
 j next_min
ret_fr_min: 
 jr $ra # return
new_min:  
 mov.s $f0, $f1
 j next_min
average: 
# Name:  average
# Input parameters: $a0, address of the array containing input values
# $a1, the number of valid values in the array
# Return values:  $f0 = the average of all elements input by the user
# Description:  This procedure will return the average of all elements input by the user.
 addi $t1,$a0,0
 addi $t5,$zero,4
 mult $a1,$t5
 mflo $t6
 add $t4,$t6,$a0
 # $f0 = aver
 lw $t0,0($t1) # aver = $f0
 mtc1 $t0,$f0 
next_aver: 
 addi $t1,$t1,4 
 beq $t1,$t4,ret_fr_aver
 lw $t0,0($t1)
 mtc1 $t0,$f1 
 add.s $f0,$f0,$f1
 j next_aver
ret_fr_aver: 
 addi $t0,$a1,0
 mtc1 $t0,$f1 
 cvt.s.w $f2, $f1
 div.s $f0, $f0, $f2
 jr $ra # return 
# MAIN PROGRAM
 main:
 la $a0, buffer
 jal getvalues
 la $a0, buffer
 addi $a1,$v0,0 
 addi $a2,$v0,0 
 jal print
 la $a0,max_print
 li $v0, 4 # print 
 syscall # do it 
 la $a0, buffer
 addi $a1,$a2,0 
 jal max
 mov.s $f12,$f0 
 li $v0,2
 syscall # do it 
 la $a0,newline
 li $v0, 4 # print string (address of string already in $a0)
 syscall # do it 
 la $a0,min_print
 li $v0, 4 # print 
 syscall # do it 
 la $a0, buffer
 addi $a1,$a2,0 
 jal min
 mov.s $f12,$f0 
 li $v0,2
 syscall # do it 
 la $a0,newline
 li $v0, 4 # print string (address of string already in $a0)
 syscall # do it 
 la $a0,av_print
 li $v0, 4 # print 
 syscall # do it 
 la $a0, buffer
 addi $a1,$a2,0 
 jal average
 mov.s $f12,$f0 
 li $v0,2
 syscall # do it 
 ori $v0, $zero, 10 #syscall will exit

 syscall #exit