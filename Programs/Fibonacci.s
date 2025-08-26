.data
fib_n:      .word   10          # Calculate 10th Fibonacci number
fib_result: .word   0

.text
main:
    la      $t0,            fib_n
    lw      $a0,            0($t0)
    jal     fibonacci
    la      $t0,            fib_result
    sw      $v0,            0($t0)
    j       exit

    # ----- FIBONACCI ----- #
fibonacci:
    # Base cases: fib(0) = 0, fib(1) = 1
    beq     $a0,            $zero,              fib_zero
    li      $t0,            1
    beq     $a0,            $t0,                fib_one
    
    # For n >= 2, use iterative approach
    li      $t1,            0               # fib(0)
    li      $t2,            1               # fib(1)
    li      $t3,            2               # counter starts at 2
    
fib_loop:
    beq     $t3,            $a0,                fib_calculate_last
    bgt     $t3,            $a0,                fib_done
    
    add     $t4,            $t1,                $t2     # fib(n) = fib(n-1) + fib(n-2)
    move    $t1,            $t2                         # shift values
    move    $t2,            $t4
    addi    $t3,            $t3,                1       # increment counter
    j       fib_loop

fib_calculate_last:
    add     $t2,            $t1,                $t2     # final calculation
    j       fib_done

fib_zero:
    li      $v0,            0
    jr      $ra

fib_one:
    li      $v0,            1
    jr      $ra

fib_done:
    move    $v0,            $t2
    jr      $ra

exit:
    nop
