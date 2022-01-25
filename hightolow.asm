.globl multiply                  # expose multiply to adder files 
.globl faculty                   # expose faculty to other files

#main function för testing
main:
li $a0, 10
jal faculty
li $v0, 1
add $a0,$v1,$zero
syscall
li $v0, 10 # Exit the program
syscall

#Multiplies $a1 with $a2 returns in $v1, uses t0,t1
multiply:
	li   $t0, 0       # index counter = 0
	add $t1, $a1,$zero      # Index limit = $a1
	li   $v1, 0
	loop:
  		add $v1, $v1, $a2	
  		addi $t0,$t0,1     # increment loop index
  		bne  $t0,$t1,loop  # if $t0 noteq $t1 do loop again
	jr $ra

# Faculty of $a0 returns in $v1
faculty:
	li $t0, 1	#i
	li $t3, 1	#fac
	
	add   $t0, $a0, $zero    # index counter to $a0
	li	$t1, 1     	 # index limit to 0
	addi $sp, $sp, -20	#allocates 20 bytes to stack
	loops:
		#sets a1 = i & a2 = fac
		add $a1,$t0,$zero
		add $a2,$t3,$zero
		#saves t0 & t1 in s0 & s1
		sw $s0, 0($sp)		#saves s0
		sw $s1, 8($sp)		#saves s1
		sw $ra, 16($sp)		#saves return
		add $s0,$t0,$zero	# s0=t0
		add $s1,$t1,$zero	# s1=t1
		#calls multiply
		jal multiply
		add $t3,$v1,$zero	#sets t3(fac) to v1
		#restores s0,a1,ra
		add $t0,$s0,$zero	# t0=s0
		add $t1,$s1,$zero	# t1=s1 
		lw $s0, 0($sp)		#restores s0
		lw $s1, 8($sp)		#restores s1
		lw $ra, 16($sp)		#restores return
		
  		# stuff...
  		subi $t0,$t0,1     # decrement loop index
  		bne  $t0,$t1,loops  # if $t0 noteq $t1 do loop again
  	add $v1,$t3,$zero
  	jr $ra
	
