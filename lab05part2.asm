.data
	prompt:		.asciiz		"Enter a nonnegative integer: "
	strResult:	.asciiz		"! = "
	invalid:	.asciiz		"Invalid integer; try again.\n"

.text

reset:	
	
	addi $v0, $zero, 4	# syscall 4: print string
	la $a0, prompt		# store string into $a0
	syscall			# print string
	
	addi $v0, $zero, 5	# syscall 5: read integer
	syscall			# read integer
	add $a0, $zero, $v0	# store integer read into $a0
	
	add $t0, $zero, $a0	# $t0 = n
	blt $a0, $zero, retry	# if n < 0, display negative message
	jal _Fac		# call factorial function
	add $v1, $zero, $v0	# store result into $v1
	
	addi $v0, $zero, 1	# syscall 1: print integer
	add $a0, $zero, $t0	# set integer to print (n)
	syscall			# print original integer n
	
	addi $v0, $zero, 4	# Syscall 4: print string
	la $a0, strResult	# store string to $a0
	syscall			# print "! = "
	
	addi $v0, $zero, 1	# syscall 1: print integer
	add $a0, $zero, $v1	# store result in $a0 to print
	syscall			# print integer
	
	addi $v0, $zero, 10
	syscall			# Terminate program
	
retry:	addi $v0, $zero, 4	# Syscall 4: print string
	la $a0, invalid		# store string to $a0
	syscall			# print string
	j reset			# reset program	
	
	
#------------Function------------
#_Fac
# Fac(n) = n x (n-1) x (n-2) x ... x 2 x 1
_Fac:
	addi $sp, $sp, -8	# adjust stack pointer
	sw $ra, 0($sp)		# store return address to stack
	sw $s0, 4($sp)		# store integer (n) to calc _fac to stack
	
	# Base Case
	addi $v0, $zero, 1	# set return to 1
	beq $a0, $zero, done	# if n == 0, j to done
	
	# Else
	add $s0, $zero, $a0	# store n to temp variable $s0
	addi $a0, $a0, -1	# n = n-1
	jal _Fac		# Fac(n-1)
	
	mul $v0, $s0, $v0	# calculation
	
done:	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra