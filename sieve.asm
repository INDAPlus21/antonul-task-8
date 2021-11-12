### Data Declaration Section ###

.data

primes:		.space  4128            # reserves a block of 4128 bytes in application memory
err_msg:	.asciiz "Invalid input! Expected integer n, where 1 < n < 1001.\n"

### Executable Code Section ###

.text

main:
    # get input
    li      $v0,5                   # set system call code to "read integer"
    syscall                         # read integer from standard input stream to $v0
    add $s0,$v0,$zero	#saves given integer in s0

    # validate input
    li 	    $t0,1001                # $t0 = 1001
    slt	    $t1,$v0,$t0		        # $t1 = input < 1001
    beq     $t1,$zero,invalid_input # if !(input < 1001), jump to invalid_input
    nop
    li	    $t0,1                   # $t0 = 1
    slt     $t1,$t0,$v0		        # $t1 = 1 < input
    beq     $t1,$zero,invalid_input # if !(1 < input), jump to invalid_input
    nop
  
    # initialise primes array
    la	    	$t0,primes              # $s1 = address of the first element in the array
    addi	$t1,$zero,0
    add 	$t1,$v0,$zero
    li		$t2,2
init_loop:
    sw	    $t2, ($t0)              # primes[i] = 1
    addi    $t0, $t0, 4             # increment pointer
    addi    $t2, $t2, 1             # increment counter
    bne	    $t2, $t1, init_loop     # loop if counter != number given
    
   
   
   ### Continue implementation of Sieve of Eratosthenes ###
   
   add $a0,$v0,$zero
   jal isqrt #v0 = result
   
   #Clear Registers
   addi $t0,$zero,0
   addi $t1,$zero,0
   addi $t2,$zero,0
   
   #prepares some registers
   addi $a0,$zero,4
   la $t0,primes,
   li $t8,2
   add $t9,$v0,$zero

prime_loop:
	lb $t3, ($t0)	#current num
	beq $t3,$zero,skip	#skips if current num is zero
	add $t1,$s0,$zero	#end delete loop
	add $t2,$t3,$zero	#Start delete loop
	delete_loop:
		mult	$t2,$a0
		mflo $t4	# t2 * 4
		add $t5,$t0,$t4	# t5 = delete position
		sw $zero,($t5)	#sets current postion to zero
		add    $t2, $t2, $t3             # increases t2 with current num
    		ble	$t2, $t1,delete_loop     #loops untill given number
    	skip:
    	addi $t0,$t0,4	
    	addi	$t8,$t8,1
    	ble	$t8,$t9, prime_loop
    ### Print nicely to output stream ###
    #Clear Registers
   addi $t0,$zero,0
   addi $t1,$zero,0
   addi $t2,$zero,0
   addi $t3,$zero,0
   
   la $t0,primes
   li $t2,0
   add $t3,$s0,$zero
   print_loop:
   	lbu $a0,($t0)
   	beq $a0,$zero,donotprint
   	li $v0,1
   	syscall
   	li $a0, 32
	li $v0, 11
	syscall
   	donotprint:
   	addi $t0,$t0,4
   	addi $t2,$t2,1
   	bne $t2,$t3,print_loop
   
   
      
    # exit program
    j       exit_program
    nop

  isqrt:
   #square root shoutout stack overflow
   addi $t0,$zero,0
   addi $t1,$zero,0
   addi $t2,$zero,0
   addi $t3,$zero,0
  # v0 - return / root
  # t0 - bit
  # t1 - num
  # t2,t3 - temps
  move  $v0, $zero        # initalize return
  move  $t1, $a0          # move a0 to t1

  addi  $t0, $zero, 1
  sll   $t0, $t0, 30      # shift to second-to-top bit

isqrt_bit:
  slt   $t2, $t1, $t0     # num < bit
  beq   $t2, $zero, isqrt_loop

  srl   $t0, $t0, 2       # bit >> 2
  j     isqrt_bit

isqrt_loop:
  beq   $t0, $zero, isqrt_return

  add   $t3, $v0, $t0     # t3 = return + bit
  slt   $t2, $t1, $t3
  beq   $t2, $zero, isqrt_else

  srl   $v0, $v0, 1       # return >> 1
  j     isqrt_loop_end

isqrt_else:
  sub   $t1, $t1, $t3     # num -= return + bit
  srl   $v0, $v0, 1       # return >> 1
  add   $v0, $v0, $t0     # return + bit

isqrt_loop_end:
  srl   $t0, $t0, 2       # bit >> 2
  j     isqrt_loop

isqrt_return:
  jr  $ra
    

invalid_input:
    # print error message
    li      $v0, 4                  # set system call code "print string"
    la      $a0, err_msg            # load address of string err_msg into the system call argument registry
    syscall                         # print the message to standard output stream

exit_program:
    # exit program
    li $v0, 10                      # set system call code to "terminate program"
    syscall                         # exit program
    
