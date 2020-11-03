#Elizabeth Clements
.data	
list: .space 100		
str:.asciiz "Please input the number of elements.\n"
str2:.asciiz "Please enter an element and then a return\n"
str3:.asciiz "The sorted list is:" 
		
	    .text 
	    .globl main
main:
	li $v0, 4        #Prompt User for Input
	la $a0, str   
	syscall
	li $v0, 5	
	syscall		 #Read integer from console
	add $14, $v0, $zero #Load number of elements into $14
	li $v0, 4        #Prompt user to input elements
	la $a0, str2  
	syscall
	la $s7, list 	#Load the address of the list into $s7
	add $21, $14, 0	#Duplicate N 
input:	
	addi $21, $21, -1 #subtract one from N
	li $v0, 5
	syscall 	#Read integer from console
	sw $v0, 0($s7)  #Store the integer in list
	addi $s7,4 	#Go to the next word in list
	bnez $21, input	#Loop back to input if there are still ints remaining
	li $s0, 0 #i counter for for loop
	add $s6, $zero, $14 #N
	la $s7, list #store the starting address of list
outloop:
	addi $s0, $s0, 1 #i++
	beq $s0, $s6, endl1 #exit loop if i=N
	add $s1, $14, $zero #set j = N
	
inloop: 
	slt $t2, $s1, $s0	#set $t2 to 1 if j<i
	bnez $t2, outloop	# go to outerloop in j<i
	addi $s1, -1		#decrement j
	mul $t4, $s1, 4		#set $t4 to be offset from start of list 
	addi $t3, $t4, -4	#set $t3 to be the word prior to $t4
	add $a0, $t4, $s7	#$t8 = the address of list[j]
	add $a1, $t3, $s7	#t9 = address of list[j-1]
	jal swap
	j inloop 	
endl1:	la $s7, list		#set $s7 to be start of list
	add $21, $14, $zero		#make $21 a counter = N
exit:
	addi $21, $21, -1	#decrement counter by 1
	lw $a0, 0($s7)		#load element from list to $a0
	li $v0, 1		#Print int to console
	syscall
	addi $s7,4		#go to the next word in list 	
	bnez $21, exit		#repeat loop if there are still elements left to print
	li $v0, 10
	syscall
swap:   
	sub $sp, $sp, 12
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	lw $t5, 0($a0)		#t5 = elements at list[j]
	lw $t7, 0($a1)		#t7 = element at list[j-1]
	bgt $t5,$t7, inloop	#if the next elements is greater than the previous element repeat the inner loop - no swap needed
	sw $t5,0($a1)		#if list[j-1] is > than list[j] then swap them, store $t5 in list[j-1]
	sw $t7,0($a0)		#store $t7 in list[j] 
	lw $ra, 8($sp)
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	add $sp, $sp, 12
	jr $ra
	
	
	
	