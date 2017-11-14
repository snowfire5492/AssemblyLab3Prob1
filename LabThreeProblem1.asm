########################################################################
# Student: Eric Schenck						Date: 11/14/17
# Description: LabThreeProblem1.asm - Write a search function that
#		takes three parameters ( arrays starting address, array size
#		 , and seed value to be found)
#		returns two results: 1.) index of first location where value
#		is greater than the seed ( return -1 if not found )
#		2.) how many elements in array are greater than seed value
#		Write a main program that calls the search function three 
#		times using the specified data sets and seed values 						
#
# Registers Used:
#	$a0: Used to store address of array for arguments
#	$a1: Used to store size of array and pass as argument to function
#	$a2: Used to store seed value and pass as argument to function
#	$v0: Used to return index of first value greater than seed value
#	$v1: Used to return number of entries greater in value than seed value
#  	$s0 used to store a index counter for array
#	$t0: used to store temporary values 
#
########################################################################
			.data
OneNextIndex:	.asciiz "\nArray {1, 5, 4, 6, 3, 5, 2, 10} with seed 4\nIndex of first greater value: "
OneNumElements:	.asciiz "\nNumber of Elements Larger than seed: "
TwoNextIndex:	.asciiz "\n\nArray {1, -1, 2, -2, 3, -3, 4, -4, 5, -5} with seed 10\nIndex of first greater value: "
TwoNumElements:	.asciiz "\nNumber of Elements Larger than seed: "
ThreeNextIndex:	.asciiz "\n\nArray {28,-17,0,51,-12,11,5,22,-2,-9,13,16,2,1,36,-13,-32,-71,101,30,130,-120,13,11,-91,14,48,53,-50,44} with seed 13\nIndex of first greater value: "
ThreeNumElement:.asciiz "\nNumber of Elements Larger than seed: "
arrayOne:	.word 1, 5, 4, 6, 3, 5, 2, 10				# 8 elements, find 4
arrayTwo:	.word 1, -1, 2, -2, 3, -3, 4, -4, 5, -5		# 10 elements, find 10
arrayThree:	.word 28, -17, 0, 51, -12, 11, 5, 22, -2, -9, 13, 16, 2, 1, 36, -13, -32, -71, 101, 30, 130, -120, 13, 11, -91, 14, 48, 53, -50, 44
														# 30 elements, find 13


			.text
			.globl main
		
main:		 		

			la $a0, arrayOne		# loading address of arrayOne into $a0 
			li $a1, 8				# 8 elements in array 
			li $a2, 4				# seed value to find is 4 
		
			jal SearchFunction		# calling function
			move $t0, $v0			# temporary storing as too us $v0 for I/0 code
		
			la $a0, OneNextIndex	# message for array one larger Index
			li $v0, 4
			syscall
		
			move $a0, $t0			# moving $v0 into register to output 
			li $v0, 1
			syscall
		
			la $a0, OneNumElements		# message for array one number of larger elements
			li $v0, 4
			syscall
		
			move $a0, $v1			# moving $v0 into register to output 
			li $v0, 1
			syscall
		
		
			la $a0, arrayTwo		# loading address of arrayTwo into $a0 
			li $a1, 10				# 10 elements in array 
			li $a2, 10				# seed value to find is 10 
		
			jal SearchFunction		# calling function
			move $t0, $v0			# temporary storing as too us $v0 for I/0 code
		
			la $a0, TwoNextIndex	# message for array two larger Index
			li $v0, 4
			syscall
		
			move $a0, $t0			# moving $v0 into register to output 
			li $v0, 1
			syscall
		
			la $a0, TwoNumElements		# message for array two number of larger elements
			li $v0, 4
			syscall
		
			move $a0, $v1			# moving $v0 into register to output 
			li $v0, 1
			syscall
		
		
			la $a0, arrayThree		# loading address of arrayThree into $a0 
			li $a1, 30				# 30 elements in array 
			li $a2, 13				# seed value to find is 13 
		
			jal SearchFunction		# calling function
			move $t0, $v0			# temporary storing as too us $v0 for I/0 code
		
			la $a0, ThreeNextIndex		# message for array three larger Index
			li $v0, 4
			syscall
		
			move $a0, $t0			# moving $v0 into register to output 
			li $v0, 1
			syscall
		
			la $a0, ThreeNumElement		# message for array three number of larger elements
			li $v0, 4
			syscall
		
			move $a0, $v1			# moving $v0 into register to output 
			li $v0, 1
			syscall
		
		
		  
						
Exit:		li $v0, 10 				# System code to exit
			syscall					# make system call 

########################################################################
		
			.text
SearchFunction:
			move $s0, $zero			# $s0 will be index counter starting at index zero
			move $v1, $zero			# number of elements greater than seed value 
CheckForSeed:	
			lw $t0, 0($a0)			# loading term in array into $t0
			beq $t0, $a2, Reset1		# if( seed value has been found, go to Reset1
			beq $s0, $a1, NotFound		# all array locations have been
		
			addi $s0, $s0, 1		# incrimenting index counter by 1						
			addi $a0, $a0, 4		# adjusting array location
			j CheckForSeed			# continue to check for seed
Reset1:		
			li $t0, 4 			# temporarily holding value 4
			mul $t0, $t0, $s0		# 4 * (index counter) = offset value of index
			sub $a0, $a0, $t0		# ressetting $a0 to first index location
			move $s0, $zero			# resetting index counter to 0
	
FindFirstLarger:
			lw $t0, 0($a0)			# loading term in array into $t0
			bgt $t0, $a2, isFirst		# if array entry is > seed { send to isFirst }	
			beq $s0, $a1, NotFound		# all array locations have been compared and no larger value exists
		
			addi $s0, $s0, 1		# incrimenting index counter by 1
			addi $a0, $a0, 4		# adjusting array location
			j FindFirstLarger		# keep searching for first larger value
		 	
isFirst:	
			move $v0, $s0			# first greater value found, move to return variable $v0
			j Reset2			# resetting values
		
Reset2:		
			li $t0, 4 				# temporarily holding value 4
			mul $t0, $t0, $s0			# 4 * (index counter) = offset value of index
			sub $a0, $a0, $t0		# ressetting $a0 to first index location
			move $s0, $zero			# resetting index counter to 0
	

NumOfLarger:
			lw $t0, 0($a0)			# loading term in array into $t0
			ble $t0, $a2, Skip		# value in array location isnt greater so skip this value
			addi $v1, $v1, 1		# incrimenting number of greater values by 1
		
Skip:		
			beq $s0, $a1, Return		# all array locations have been compared
				
			addi $s0, $s0, 1		# incrimenting index counter by 1
			addi $a0, $a0, 4		# adjusting array location
			j NumOfLarger			# keep searching for number of greater values 

NotFound:	
			li $v0, -1 			# returning -1 since seed value not found
			li $v1, 0			# if no seed the 0 elements are greater 
 								 							 							
Return: 	jr $ra				# return values stored in $v0 and $v1			 							 							
 							 							 							 							 							
		
