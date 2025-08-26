main:
    addi    $a0,            $zero,              10000
    jal     divide
    j       exit
    # Division Subroutine
divide:
    move    $t0,            $a0                     # Load dividend into $t0
    li      $t1,            2
    li      $t2,            0                       # Initialize quotient to 0

    # Loop for division
dloop:
    sub     $t0,            $t0,                $t1 # Subtract divisor from dividend
    # slt     $t3,            $t0,                $zero
    # beq     $t3,            $zero,              increment_quotient  # If dividend >= divisor, increment quotient
    bgez    $t0,            increment_quotient      # If dividend >= divisor, increment quotient
    j       end_division

increment_quotient:
    addi    $t2,            $t2,                1   # Increment quotient
    j       dloop

end_division:
    move    $v0,            $t2
    jr      $ra

exit:
    nop