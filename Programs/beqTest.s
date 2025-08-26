main:
    addi    $t0,        $zero,  4       # Load 4 into $t0
    addi    $t1,        $zero,  5       # Load 5 into $t1
    jal     increment                   # Call increment function
    beq     $t0,        $t1,    success # Branch if equal
    j       exit                        # Jump to exit

increment:
    addi    $t0,        $t0,    1       # Increment $t0
    jr      $ra                         # Return

success:
    addi    $v0,        $zero,  1       # Set success flag

exit:
    nop
