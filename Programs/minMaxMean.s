.data
array:  .word   324, 435, 123, 567, 789, 234, 678, 890, 111, 555
length: .word   10


.text
main:
    la      $s0,            array
    la      $t0,            length
    lw      $s1,            0($t0)
    jal     min
    sw      $s4,            60($s0)
    jal     max
    sw      $s3,            64($s0)
    jal     mean
    move    $s2,            $v0
    sw      $s2,            68($s0)
    j       exit

    # ----- MIN ----- #
min:
    lw      $t0,            0($s0)
    li      $t1,            0
min_loop:
    beq     $t1,            $s1,                min_done
    sll     $t2,            $t1,                2
    add     $t2,            $s0,                $t2
    lw      $t3,            0($t2)
    slt     $t4,            $t3,                $t0
    beq     $t4,            $zero,              next_element
    move    $t0,            $t3
next_element:
    addi    $t1,            $t1,                1
    j       min_loop
min_done:
    move    $s4,            $t0
    jr      $ra

    # ----- MAX ----- #
max:
    lw      $t0,            0($s0)
    li      $t1,            0
max_loop:
    beq     $t1,            $s1,                max_done
    sll     $t2,            $t1,                2
    add     $t2,            $s0,                $t2
    lw      $t3,            0($t2)
    slt     $t4,            $t0,                $t3
    beq     $t4,            $zero,              max_next
    move    $t0,            $t3
max_next:
    addi    $t1,            $t1,                1
    j       max_loop
max_done:
    move    $s3,            $t0
    jr      $ra


    # ----- MEAN ----- #
mean:
    j       calculate_sum

calculate_sum:
    li      $t0,            0
    li      $t1,            0
sum_loop:
    beq     $t1,            $s1,                sum_done
    sll     $t2,            $t1,                2
    add     $t2,            $t2,                $s0
    lw      $t2,            0($t2)
    add     $t0,            $t0,                $t2
    addi    $t1,            $t1,                1
    j       sum_loop
sum_done:
    move    $a0,            $t0
    j       divide

    # Division Subroutine
divide:
    move    $t0,            $a0
    li      $t1,            10
    li      $t2,            0
dloop:
    sub     $t0,            $t0,                $t1
    bgez    $t0,            increment_quotient
    j       end_division
increment_quotient:
    addi    $t2,            $t2,                1
    j       dloop
end_division:
    move    $v0,            $t2
    jr      $ra
exit:
    nop