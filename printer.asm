.data
                      #    # " !       ' & % $     + * ) (     / . - ,     3 2 1 0     7 6 5 4     ; : 9 8     ? > = <     C B A @     G F E D     K J I H     O N M L     S R Q P     W V U T     [ Z Y X     _ ^ ] \     c b a `     g f e d     k j i h     0 n m l     s r q p     w v u t     { z y x     | } ~ <-
	line1:	.word	0x50502000, 0x2040c020, 0x00002020, 0x00000000, 0x70702070, 0xf870f810, 0x00007070, 0x70000000,	0x70f07070, 0x70f8f8f0, 0x88087088, 0x70888880, 0x70f070f0, 0x888888f8, 0x70f88888, 0x00207000, 0x00800020, 0x00300008, 0x80102080, 0x00000060, 0x00000000, 0x00000040, 0x10000000, 0x00404020
	line2:	.word	0x50502000, 0x20a0c878, 0x20a81040, 0x08000000, 0x88886088, 0x08888030, 0x00008888, 0x88400010, 0x88888888, 0x88808088, 0x90082088, 0x8888d880, 0x88888888, 0x88888820, 0x40088888, 0x00501080, 0x00800020, 0x00400008, 0x80000080, 0x00000020, 0x00000000, 0x00000040, 0x20000000, 0x00a82020
	line3:	.word	0xf8502000, 0x20a01080, 0x20701040, 0x10000000, 0x08082098, 0x1080f050, 0x20208888, 0x0820f820, 0x80888898, 0x80808088, 0xa0082088, 0x88c8a880, 0x80888888, 0x88888820, 0x40105050, 0x00881040, 0x70f07010, 0x70e07078, 0x903060f0, 0x70f8f020, 0x78b878f0, 0xa88888f0, 0x20f88888, 0x00102020
	line4:	.word	0x50002000, 0x00402070, 0xf8d81040, 0x2000f800, 0x301020a8, 0x20f80890, 0x00007870, 0x30100040, 0x80f088a8, 0x80f0f088, 0xc00820f8, 0x88a88880, 0x70f088f0, 0x88888820, 0x40202020, 0x00001020, 0x88880800, 0x88408888, 0xa0102088, 0x8888a820, 0x80488888, 0xa8888840, 0x40108850, 0x00001020
	line5:	.word	0xf8002000, 0x00a84008, 0x20701040, 0x40000030, 0x082020c8, 0x208808f8, 0x20200888, 0x2020f820, 0x8088f898, 0xb8808088, 0xa0882088, 0x88988880, 0x08a08880, 0xa8888820, 0x40402050, 0x00001010, 0x80887800, 0x8840f888, 0xc0102088, 0x8888a820, 0x70408888, 0xa8508840, 0x20208820, 0x00002020
	line6:	.word	0x50000000, 0x009098f0, 0x20a81040, 0x80000030, 0x88402088, 0x20888810, 0x20008888, 0x00400010, 0x88888880, 0x88808088, 0x90882088, 0x88888880, 0x88909880, 0xd8508820, 0x40802088, 0x00001008, 0x80888800, 0x78408088, 0xa0102088, 0x8888a820, 0x084078f0, 0xa8508840, 0x20407850, 0x00002020
	line7:	.word	0x50002000, 0x00681820, 0x00002020, 0x00200010, 0x70f87070, 0x20707010, 0x00007070, 0x20000000, 0x70f08878, 0x7080f8f0, 0x88707088, 0x708888f8, 0x70887880, 0x88207020, 0x70f82088, 0xf8007000, 0x78f07800, 0x08407878, 0x90907088, 0x7088a870, 0xf0400880, 0x50207830, 0x10f80888, 0x00004020
	line8:	.word	0x00000000, 0x00000000, 0x00000000, 0x00000020, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xf0000000, 0x00600000, 0x00000000, 0x00000880, 0x00000000, 0x00007000, 0x00000000
	
	prompt:		.asciiz	"Enter a filename: "
	buffer: 	.space	80
	fileName:	.space	20
	
.text
	###################################################
	# Prompt and read user input
	addi $v0, $zero, 4	# Syscall 4: print string
	la $a0, prompt		# load prompt into $a0
	syscall			# Print the prompt
	
	la $a0, fileName	# fileName = input
	addi $a1, $zero, 20	# number of characters to type in
	addi $v0, $zero, 8	# Syscall 8: read string
	syscall			# read string
	
	###################################################
	# Remove new line character from filename
	addi $sp, $sp, -8		# Adjust stack
	sw $ra, 0($sp)			# load return address
	sw $a0, 4($sp)			# load $a0 to stack
		
	jal _strLength			# call function string length
		
	lw $a0, 4($sp)			# Restore $a0
	lw $ra, 0($sp)			# Restore $ra
	addi $sp, $sp, 8		# Adjust stack
	
	add $t0, $zero, $a0		# Copy address from $a0 to $t0
	addi $t1, $v0, -1		# set $t1 to length - 1
	add $t0, $t1, $a0		# set address of buffer to (length - 1) + $a0
	addi $t3, $zero, 0		# set byte to use in next instruction to 0
		
	sb $t3, 0($t0)			# Set new line character to 0
	addi $t0, $zero, 0		# clear $t0
	###############################################################
 	 
 	############################################################### 
 	# Open a file	 
 	li   $v0, 13       	# system call for open file
 	la   $a0, fileName     	# file to open
  	li   $a1, 0        	# Open for reading (flags are 0: read, 1: write)
 	li   $a2, 0        	# mode is ignored
 	syscall            	# open a file (file descriptor returned in $v0)
 	move $s6, $v0      	# save the file descriptor 
 	###############################################################
 	
 mLoop:
 	li $t3, 0		# (counter = 0)
 	la $a1, buffer
  	jal _readLine
  	beq $v1, 1, EOF		# if reached end of file
  	la $s0, buffer		# store 80 byte buffer into $s0
  	jal _printBuffer
  	
  	innerLoop:
  		beq $t3, 5, mLoop
  		jal _printSpaces
  		addi $t3, $t3, 1
  	j innerLoop
 j mLoop
  	
  			
  	# Close the file 
EOF:  	li   $v0, 16       	# system call for close file
  	move $a0, $s6      	# file descriptor to close
  	syscall            	# close file

	li $v0, 10
	syscall			# terminate program

# Function returns length of a null-terminated string.
# Arguments: $a0 = address of a null-terminated string.
# Return Value: $v0 = length of specified string.
_strLength: 
			add $t1, $zero, $a0	# $t1 = $a0 
			addi $v0, $zero, 0	# $v0 is string length counter (initialized to zero)
			
		loop:	lbu $t0, 0($t1)		# store character at address $t1 into $t0 (contains character)
			beq $t0, $zero, exit	# if $t0 == 0 go to exit
			addi $v0, $v0, 1	# increment counter by 1
			addi $t1, $t1, 1	# increment address pointer by 1
			j	loop
		exit: 	
			jr $ra			# Go Back to Caller	
	
# Function: _readLine
# Arguments: 
#	- File Descriptor $a0
#	- Address of 80-byte buffer $a1
# Return Values:
#	- return 1 if encoutner E0F
#	- else return 0
# Hint: You should read the file one byte at a time. Each time you read a byte,
# check whether it is an end of file (return value 0 from the syscall). If it is not, check whether
# it is a new line or a regular character. Handle each situation accordingly.
_readLine:
		addi $t0, $zero, 0	# index = 0		
	top_of_loop:	
  		beq $t0, 80, end	# if reached end of line	
 		li   $v0, 14       	# system call for read from file
 		move $a0, $s6      	# set $a0 to file descriptor 
 		li   $a2, 1        	# 1 character to read
 		syscall
 		lbu $t6, ($a1)		# store ascii value into $t6
 		beq $t6, 10, newLine	# if character read is new line (ASCII val:10) Return 1
 		# else if regular character:
 		addi $t0, $t0, 1	# index++
 		addi $a1, $a1, 1	# addressOfBuffer++
 	j top_of_loop
 				
 	newLine: 
 		addi $t7, $zero, 32
 		nlLoop:				# fill up remaining spaces in buffer with blanks
 			beq $t0, 80, return	# if fill up buffer return
 			sb $t7,  ($a1)		# store zero into buffer
 			addi $a1, $a1, 1	# addressOfBuffer++
 			addi $t0, $t0, 1	# index++
 		j nlLoop	
 		return:	addi $v1, $zero, 0	# return 0
 			jr $ra 
  	end:
  		addi $v1, $zero, 1	# return 1
  		jr   $ra
	
# Function printLine: The purpose of this function is to print one line of dots based on the
# 80-byte buffer and the line data. This function should take two arguments; (1) the address
# of 80-byte buffer, and (2) the address of the line data to be used (e.g., the address of labels
# line1 to line8). This function should send data to printer one word (32 bits) at a time for
# 15 words.
_printLine:
	# s0 = address of 80byte buffer
	# a1 = line address
	addi $t4, $zero, 0			# outerCounter = 0
	outerLoop:
		beq $t4, 5, exit1
		addi $t4, $t4, 1
		add $t5, $zero, $zero		# innerCounter = 0
		add  $t8, $zero, $zero		# clear $t8
	top_of_loop1:
		beq $t5, 5, exit1	
		#1
		lbu $t2, ($s0)			# load ascii value into #t2
		addi $t2, $t2, -32		# compute offset
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		sll $t8, $t8, 2			# fill in remaining 2 spots for $t8
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 6			# only want top 2 bits from byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		
		
		li $t9, 1
		wait:
			beq $t9, $zero, two	# wait for $t9 to be 0
		j wait
		
		
		
		#2
two:		addi $t8, $zero, 0		# clear $t8
		lbu $t1, 0($t2)			# reload byte for original 8 bits
		srl $t1, $t1, 2			# get leftover 4 bits on right
		or $t8, $t8, $t1		# send to $t8 ( which should be blank now )
		sll $t8, $t8, 6			# fill in with zeros
		addi $s0, $s0, 1		# increment index by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# or with $t8 to store in $t8
		sll $t8, $t8, 4			# fill in rest of $t8 with zeros for final 4 bits
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 4			# shift right 4 to only get 4 MSB's
		or $t8, $t8, $t1		# send to $t8 (which should be full now)
		addi $s0, $s0, 1
		
		li $t9, 1
		wait1:
			beq $t9, $zero, three		# wait for $t9 to be 0
		j wait1
		
		
		
		#3
	three:	addi $t8, $zero, 0		# clear $t8
		lbu $t1, 0($t2)			# reload byte to get original 8 bits 
		srl $t1, $t1, 2			# shift l twice to get 2 bytes (wanted) on right
		or $t8, $t8, $t1		# send to $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# send to $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# send to $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# send to $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# send to $t8
		sll $t8, $t8, 6			# fill in last six bits with zeros
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		lbu $t2, ($s0)			# load ascii value into $t2
		addi $t2, $t2, -32		# load offset into $t2
		add $t2, $t2, $a1		# store offset into $t2
		lbu $t1, 0($t2)			# load byte from line into $t1
		srl $t1, $t1, 2			# ignore last two bits of byte
		or $t8, $t8, $t1		# send to $t8
		addi $s0, $s0, 1		# increment address of 80 byte buffer by 1
		
		li $t9, 1			# set $t9 to 1
		
		wait2:
			beq $t9, $zero, next
		j wait2
		
		
	next:	addi $t8, $zero, 0		# clear $t8
		addi $t5, $t5, 1		#increment counter
	j	top_of_loop1
	
	exit1:
		jr $ra
	
# Function printBuffer: The purpose of this function is to print 80-byte buffer to printer.
# Therefore, it takes one argument which is the address of the 80-byte buffer and returns no
# value. Note that this function should call the function printLine eight times. 
_printBuffer:

	
	la $a1, line1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $s0, buffer
	jal _printLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $a1, line2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $s0, buffer
	jal _printLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $a1, line3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $s0, buffer
	jal _printLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $a1, line4
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $s0, buffer
	jal _printLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $a1, line5
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $s0, buffer
	jal _printLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $a1, line6
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $s0, buffer
	jal _printLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $a1, line7
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $s0, buffer
	jal _printLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $a1, line8
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $s0, buffer
	jal _printLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	

# Function printSpaces: This purpose of this function is to simply print space
# between lines. Note that the space between two lines of character should be 5-dot high. So,
# you simply have to send five fifteen-word data to printer where each word is simply 0. Recall
# that you can only send one word at a time. This function should take no argument and return
# no value.
_printSpaces:
	li $t8, 0		# set $t8 to 0
	li $t0, 0		# counter = 0
	l:
		beq $t0, 15, return1	# if print one full line of 0's
		li $t9, 1		# set $t9 to 1 for print
		addi $t0, $t0, 1	# counter++
		
		wait3:
			beq $t9, $zero, l
		j wait3
	j l
	
return1: jr $ra
	
