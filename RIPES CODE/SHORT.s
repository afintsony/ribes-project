.data
    array:  .word 5, 0, 8, 2, 0   # Tiny array to process quickly
    size:   .word 5

.text
.globl _start

_start:
    # 1. Initialize Base Registers
    li   x2, 0x7FFFF000      # Initialize stack pointer for function calls
    la   x10, array          # Base address of array
    la   x11, size
    lw   x11, 0(x11)         # Load array size (5)

    # ========================================================
    # PART A: LOOP & CONDITIONAL BRANCHES (Count non-zeros)
    # ========================================================
    li   x12, 0              # Loop index (i = 0)
    li   x13, 0              # Non-zero counter

LOOP:
    bge  x12, x11, END_LOOP  # If i >= 5, exit loop

    # Load array[i]
    slli x14, x12, 2         # i * 4
    add  x15, x10, x14       # address = base + (i*4)
    lw   x16, 0(x15)         # x16 = array[i]

    # Branch test
    beq  x16, x0, SKIP       # If array[i] == 0, skip the counter
    addi x13, x13, 1         # non_zero_count++

SKIP:
    addi x12, x12, 1         # i++
    jal  x0, LOOP            # Loop back

END_LOOP:

    # ========================================================
    # PART B: FUNCTION CALLS (Factorial of 3)
    # ========================================================
    li   x10, 3              # Argument: n = 3
    jal  x1, FACTORIAL       # Call function (JAL)

PROGRAM_END:
    nop
    jal  x0, PROGRAM_END     # Infinite loop to halt program safely

# ============================================================
# FUNCTION: FACTORIAL (Recursive)
# ============================================================
FACTORIAL:
    addi x2, x2, -16         # Allocate stack frame
    sw   x1, 12(x2)          # Save return address
    sw   x10, 8(x2)          # Save n

    li   x5, 1
    bgt  x10, x5, RECURSE    # If n > 1, do recursion

    # Base case (n <= 1)
    li   x10, 1
    jal  x0, RETURN

RECURSE:
    addi x10, x10, -1        # n - 1
    jal  x1, FACTORIAL       # Recursive call

    lw   x5, 8(x2)           # Restore original n
    mul  x10, x5, x10        # n * factorial(n-1)

RETURN:
    lw   x1, 12(x2)          # Restore return address
    addi x2, x2, 16          # Deallocate stack frame
    jalr x0, x1, 0           # Return to caller (JALR)