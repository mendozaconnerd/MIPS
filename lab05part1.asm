.data
				# 0	   1	     2	       3       4
	names:		.asciiz	"steve", "john", "chelsea", "julia", "ryan"
	ages:		.byte	20, 25, 22, 21, 23
	strEnter:	.asciiz	"Please enter a name: "
	strAge:		.asciiz	"Age is: "
	strNot:		.asciiz	"Not found!"
	strFound:	.asciiz "Found!"
	buffer:		.space	20
	
.text
	addi $v0, $zero, 4	# Syscall 4: print string
	la $a0, strEnter	# "please enter a name: "
	syscall			# print string
	
	addi $v0, $zero, 8	# Syscall 8: read string
	la $a0, buffer		# load byte space into address
	addi $a1, $zero, 20	# allot byte space for string
	syscall			# Read string
	
				
	la $a0, names		# $a0 points to first element in user input
	la $a1, buffer		# $a1 points to first element in names
	
	addi $s0, $zero, 0	# index ($s1) = 0

top_of_loop:	
	beq $s0, 5, exit	# while(index < 5)
	
	addi $v0, $zero, 0	# match = 0
	
	addi $sp, $sp, -12	# adjust stack pointer
	sw $ra, 0($sp)		# store return address to stack
	sw $a0, 4($sp)		# store names pointer to stack
	sw $a1, 8($sp)		# store input pointer to stack
	
	jal _StrEqual		# _strEqual($a0=(input), $a1=(names[index]))
	
	lw $a1, 8($sp)		# restore from stack
	lw $a2, 4($sp)		# restore from stack
	lw $ra, 0($sp)		# restore from stack
	addi $sp, $sp, 12	# readjust stack pointer

	beq $v0, 1, match	# if function strEqual returns 1, j match and exit ******* change after to next func
	
	# Else get string length and add to offset
	# increment index
	addi $sp, $sp, -4	# adjust stack pointer
	sw $ra, 0($sp)		# store return address to the stack
	add $s5, $zero, $a0	# set argument to $a0
	jal _strLength		# returns $v0 length of specified string
	add $a0, $zero, $s5	# reset $a0 to new address
	lw $ra, 0($sp)		# restore return address
	addi $sp, $sp, 4	# readjust stack pointer
	
	addi $v0, $v0, 1	# increment length by 1
	add $a0, $a0, $v0	# $a0 points to next name in array
	addi $s0, $s0, 1	# index++
	
	j top_of_loop
	
exit:	addi $v0, $zero, 4	# syscall 4: print string	
	la $a0, strNot		# load string into address $a0
	syscall			# print string
	
	addi $v0, $zero, 10
	syscall			# terminate program
	
match:	addi $v0, $zero, 4	# sysacall 4: print string
	la $a0, strFound	# load string into address $a0
	syscall			# print string
	
	addi $v0, $zero, 10
	syscall			# terminate program	
	

	
# Function StrEqual	
# Arguments:
#	- addresses of two strings
# Return Values:
#	- return 1 if strings are match, else return 0

# Load byte from $a0 string = $t0 (user input)
# Load byte from $a1 string = $t1 (names)
# Beq $t0, $t1, moveNext
# $v0 = 0
# j end
# moveNext:
#	beq $t0, $zero, end
#	increment address of $a0 & $a1
# end:
#	jr $ra
_StrEqual:
	
	# First set new line character to 0
	add $s5, $zero, $a1	# set argument to $s5
	addi $sp, $sp, -4	# adjust stack pointer
	sw $ra, 0($sp)		# store $ra
	jal _strLength		# returns length of sepcified string ($v0)
	lw $ra, 0($sp)		# restore $ra
	addi $sp, $sp, 4	# adjust stack pointer
	
	add $a1, $zero, $s5	# Copy address from $s5 to $a1
	addi $s2, $v0, -1	# set $s2 to length - 1
	add $s1, $s2, $a1	# set address of buffer to (length + 1) + $a1
	addi $s3, $zero, 0	# set byte to use in next instruction to 0
	sb $s3, 0($s1)		# Set new line character to 0
	
	
	
	# Next, check if characters from user input match array characters
	
loop:	lb $t3, 0($a0)		# store character from names array into $t3
	lb $t4, 0($a1)		# store character from user input into $t4
	beq $t3, $zero, return	# if reach end of a name, j to return
	beq $t3, $t4, moveNext	# if two characters are equal move to next char
	add $v0, $zero, 0	# else set return val to 0
	jr $ra			# return

moveNext:
	addi $a0, $a0, 1	# increment pointer by 1
	addi $a1, $a1, 1	# increment pointer by 1
	j	loop		# move to check next char
	
return:	addi $v0, $zero, 1	# Set return value to 1
	jr $ra			# return	
	

	
# Function returns length of a null-terminated string.
# Arguments: $s5 = address of a null-terminated string.
# Return Value: $v0 = length of specified string.
_strLength: 
		add $t1, $zero, $s5	# Copy address to $t1 (tempVar)
		addi $v0, $zero, 0	# $v0 is string length counter (initialized to zero)
			
	loop1:	lbu $t0, 0($t1)		# store character at address $t1 into $t0 (contains character)
		beq $t0, $zero, exit1	# if $t0 == 0 go to exit
		addi $v0, $v0, 1	# increment counter by 1
		addi $t1, $t1, 1	# increment address pointer by 1
		j	loop1
	exit1: 	jr $ra			# Go Back to Caller	

