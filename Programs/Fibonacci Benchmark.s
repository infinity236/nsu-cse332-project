.data
    fib_array:  .space  44      # Array to store first 51 Fibonacci numbers (0-10)

.text
main:
    li      $a0,    10          # Example: calculate 10th Fibonacci number
    jal     fibonacci
    # Result will be in $v0
    
    j       end

fibonacci:
    # Input: $a0 = n (which Fibonacci number to calculate)
    # Output: $v0 = nth Fibonacci number
    
    # Store input n on stack
    addi    $sp,    $sp,    -4
    sw      $a0,    0($sp)
    
    # Handle base cases
    beq     $a0,    $zero,  fib_zero    # if n == 0, return 0
    li      $t0,    1
    beq     $a0,    $t0,    fib_one     # if n == 1, return 1
    
    # Initialize for iteration
    li      $t1,    0           # fib(0) = 0
    li      $t2,    1           # fib(1) = 1
    li      $t3,    2           # counter = 2
    
    # Store initial values in array
    la      $t5,    fib_array
    sw      $t1,    0($t5)      # fib_array[0] = 0
    sw      $t2,    4($t5)      # fib_array[1] = 1
    
fib_loop:
    # Check if counter > n using core instructions
    slt     $t6,    $a0,    $t3         # $t6 = 1 if n < counter
    bne     $t6,    $zero,  fib_done    # if n < counter, we're done
    
    add     $t4,    $t1,    $t2         # temp = fib(i-2) + fib(i-1)
    
    # Store current fibonacci number in array
    sll     $t7,    $t3,    2           # $t7 = counter * 4 (word offset)
    add     $t7,    $t5,    $t7         # $t7 = address of fib_array[counter]
    sw      $t4,    0($t7)              # store fib(counter)
    
    move    $t1,    $t2                 # fib(i-2) = fib(i-1)
    move    $t2,    $t4                 # fib(i-1) = temp
    addi    $t3,    $t3,    1           # counter++
    j       fib_loop
    
fib_done:
    # Load result from array
    lw      $a0,    0($sp)              # restore original n
    sll     $t7,    $a0,    2           # $t7 = n * 4
    add     $t7,    $t5,    $t7         # $t7 = address of fib_array[n]
    lw      $v0,    0($t7)              # load fib(n)
    addi    $sp,    $sp,    4           # restore stack
    jr      $ra
    
fib_zero:
    li      $v0,    0
    addi    $sp,    $sp,    4           # restore stack
    jr      $ra
    
fib_one:
    li      $v0,    1
    addi    $sp,    $sp,    4           # restore stack
    jr      $ra

end:
    nop