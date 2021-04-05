 
#----------------------------------------------------------------------------   
# Data Declarations and Initializing Array

     .data
intarray:   
	.word 1 
	.word -4 
	.word 5 
	.word 6 
	.word 12 
	.word 21 
	.word 18 
	.word 44 
	.word 32 
	.word 9 
	.word 23 
	.word 10 
	.word 11
        .word 23
        .word 7 
	.word 99 

#----------------------------------------------------------------------------------
# text/code section

    .text
    .globl  main
    
    lui $sp 0x8000                 #initializes the stack pointer

main:
    addiu   $sp,$sp,-12            # stack grows by 12 bytes 
    sw      $ra, 8($sp)            # save return address into stack
    sw      $s0, 4($sp)            # store $s0 so it can be used for little index
    sw      $s1, 0($sp)            # store $s1 so it can be used for i

    addi    $s0,$s0,60             # set i to index of last number in array
    addi    $s1,$s1,60             # set little index to index of last number in array

min_loop:                          # loop to find the min value in the array
    beq     $s1,$zero,min_found    # if (index == 0) go to min_found
    addi    $s1,$s1,-4             # subtract 4 from index to move to next number
    

    la      $t0, intarray           # load array to t0
    add     $t1,$t0,$s1             # address of current number in loop to t1
    add     $t2,$t0,$s0             # address of current min to t2
    lw      $t3, 0($t1)             # load value of current number to t3
    lw      $t4, 0($t2)             # load value of current min to t4
    

    slt     $t5,$t3,$t4             # if current value is less than current min
    beq     $t5,$zero,min_loop      # if not, loop again

    add     $s0,$s1,0               # if it is, set new min
    j       min_loop                # loop again

min_found:
    addi    $a0,$s0,0               # pass argument to swap function
    jal     swap                    # jump and link to swap function
    nop                             # breakpoint to show memory
    lw      $s0, 4($sp)             # restore $s0 from stack
    lw      $s1, 0($sp)             # restore $s1 from stack
    lw      $ra, 8($sp)             # restore return address from stack
    addiu   $sp, $sp, 12            # shrink stack
    li      $v0,10                  # exit program
    syscall
  

swap:
    la     $t0, intarray           # load address of array to t0
    add    $t1, $t0, $a0           # add index of min to base address to get min address
    add    $t2, $t0, 60            # add 60 to of base address to get last number address

    lw     $t3, 0($t2)             # load value of last number to t3
    lw     $t4, 0($t1)             # load value of min to t4
    
    sw     $t3, 0($t1)             # store the value of last number in address of min
    sw     $t4, 0($t2)             # store value of min to address of last number
    
    jr $ra                         # return to return address

    

    