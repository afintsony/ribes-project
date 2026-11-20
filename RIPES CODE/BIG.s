.data
    array:      .word 9, 3, 7, 1, 8, 2, 6, 4, 5, 0
    msg_size:   .word 10
    result:     .word 0
    max_val:    .word 0
    min_val:    .word 0
    sum_val:    .word 0

.text
.globl _start

_start:
    li   x2, 0x7FFFF000
    la   x10, array
    la   x11, msg_size
    lw   x11, 0(x11)
    li   x12, 0
    li   x13, 0
    li   x14, 0
    li   x15, 0x7FFFFFFF

    li   x16, 0
    li   x17, 0
    li   x18, 0

BEQ_BNE_LOOP:
    bge  x18, x11, BEQ_BNE_END
    
    slli x19, x18, 2
    add  x20, x10, x19
    lw   x21, 0(x20)

    beq  x21, x0, IS_ZERO
    
    addi x17, x17, 1
    jal  x0, CONTINUE_BEQ

IS_ZERO:
    addi x16, x16, 1

CONTINUE_BEQ:
    add  x13, x13, x21
    addi x18, x18, 1
    jal  x0, BEQ_BNE_LOOP

BEQ_BNE_END:
    la   x5, sum_val
    sw   x13, 0(x5)

    li   x18, 0
    lw   x22, 0(x10)
    lw   x23, 0(x10)

MINMAX_LOOP:
    bge  x18, x11, MINMAX_END

    slli x19, x18, 2
    add  x20, x10, x19
    lw   x21, 0(x20)

    bge  x21, x23, CHECK_MAX
    add  x23, x21, x0
    jal  x0, INCR_MINMAX

CHECK_MAX:
    blt  x21, x22, INCR_MINMAX
    add  x22, x21, x0

INCR_MINMAX:
    addi x18, x18, 1
    jal  x0, MINMAX_LOOP

MINMAX_END:
    la   x5, max_val
    sw   x22, 0(x5)
    la   x5, min_val
    sw   x23, 0(x5)

    li   x18, 0

OUTER_LOOP:
    addi x24, x11, -1
    bge  x18, x24, SORT_END

    li   x25, 0

INNER_LOOP:
    sub  x26, x24, x18
    bge  x25, x26, INNER_END

    slli x19, x25, 2
    add  x20, x10, x19
    lw   x27, 0(x20)
    lw   x28, 4(x20)

    bgt  x27, x28, DO_SWAP
    jal  x0, NO_SWAP

DO_SWAP:
    sw   x28, 0(x20)
    sw   x27, 4(x20)

NO_SWAP:
    addi x25, x25, 1
    jal  x0, INNER_LOOP

INNER_END:
    addi x18, x18, 1
    jal  x0, OUTER_LOOP

SORT_END:
    nop

    lw   x29, 0(x10)
    li   x30, 0

    beq  x29, x0, CAT_ZERO

    li   x5, 1
    blt  x29, x5, CAT_NEGATIVE
    li   x5, 4
    blt  x29, x5, CAT_LOW

    li   x5, 7
    blt  x29, x5, CAT_MID

    li   x5, 10
    blt  x29, x5, CAT_HIGH

    li   x30, 4
    jal  x0, CLASSIFY_END

CAT_NEGATIVE:
    li   x30, -1
    jal  x0, CLASSIFY_END

CAT_ZERO:
    li   x30, 0
    jal  x0, CLASSIFY_END

CAT_LOW:
    li   x30, 1
    jal  x0, CLASSIFY_END

CAT_MID:
    li   x30, 2
    jal  x0, CLASSIFY_END

CAT_HIGH:
    li   x30, 3

CLASSIFY_END:
    la   x5, result
    sw   x30, 0(x5)

    li   x10, 5
    jal  x1, FACTORIAL
    nop
    nop

    li   x10, 7
    jal  x1, FIBONACCI
    nop
    nop

    li   x10, 0xFFFFFFFF
    li   x11, 1

    bltu x10, x11, UNSIGNED_LESS
    bgeu x10, x11, UNSIGNED_GTE
    nop

UNSIGNED_LESS:
    li   x12, 0
    jal  x0, UNSIGNED_END

UNSIGNED_GTE:
    li   x12, 1

UNSIGNED_END:
    nop

    la   x10, array
    la   x11, msg_size
    lw   x11, 0(x11)
    li   x13, 0
    li   x18, 0

LOOP_A:
    bge  x18, x11, LOOP_A_END
    slli x19, x18, 2
    add  x20, x10, x19
    lw   x21, 0(x20)
    add  x13, x13, x21
    addi x18, x18, 1
    jal  x0, LOOP_A

LOOP_A_END:
    add  x22, x13, x0

    la   x10, array
    li   x13, 0

    lw   x21, 0(x10)
    add  x13, x13, x21

    lw   x21, 4(x10)
    add  x13, x13, x21

    lw   x21, 8(x10)
    add  x13, x13, x21

    lw   x21, 12(x10)
    add  x13, x13, x21

    lw   x21, 16(x10)
    add  x13, x13, x21

    lw   x21, 20(x10)
    add  x13, x13, x21

    lw   x21, 24(x10)
    add  x13, x13, x21

    lw   x21, 28(x10)
    add  x13, x13, x21

    lw   x21, 32(x10)
    add  x13, x13, x21

    lw   x21, 36(x10)
    add  x13, x13, x21

    add  x23, x13, x0

    jal  x0, PROGRAM_END

FACTORIAL:
    addi x2,  x2, -16
    sw   x1,  12(x2)
    sw   x10,  8(x2)

    li   x5, 1
    bgt  x10, x5, FACT_RECURSE

    li   x10, 1
    lw   x1, 12(x2)
    addi x2, x2, 16
    jalr x0, x1, 0

FACT_RECURSE:
    addi x10, x10, -1
    jal  x1, FACTORIAL

    lw   x5,  8(x2)
    mul  x10, x5, x10

    lw   x1, 12(x2)
    addi x2, x2, 16
    jalr x0, x1, 0

FIBONACCI:
    addi x2, x2, -8
    sw   x1, 4(x2)

    li   x5, 0
    li   x6, 1
    li   x7, 2

    beq  x10, x0, FIB_ZERO
    li   x28, 1
    beq  x10, x28, FIB_ONE

FIB_LOOP:
    bgt  x7, x10, FIB_DONE
    add  x29, x5, x6
    add  x5, x6, x0
    add  x6, x29, x0
    addi x7, x7, 1
    jal  x0, FIB_LOOP

FIB_ZERO:
    li   x10, 0
    jal  x0, FIB_RETURN

FIB_ONE:
    li   x10, 1
    jal  x0, FIB_RETURN

FIB_DONE:
    add  x10, x6, x0

FIB_RETURN:
    lw   x1, 4(x2)
    addi x2, x2, 8
    jalr x0, x1, 0

PROGRAM_END:
    nop
    nop
    nop
    jal  x0, PROGRAM_END