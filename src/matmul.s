.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t1, 1

    blt a1, t1, error2
    blt a2, t1, error2

    blt a4, t1, error3
    blt a5, t1, error3

    bne a2, a4, error4

    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

init:

    li t0, 0 # index of row in d
    li t1, 0 # index of col in d
    li t2, 4 # save a const 4 to be mul
    mv t3, a2 # length of dot

outer_loop_start:
    bge t0, a1, outer_loop_end
    li t1, 0

inner_loop_start:
    bge t1, a5, inner_loop_end

    # save caller-saved regs
    addi sp, sp, -44
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw t0, 20(sp)
    sw t1, 24(sp)
    sw t2, 28(sp)
    sw t3, 32(sp)
    sw t4, 36(sp)
    sw ra, 40(sp)  # very important, otherwise when return from matmul, it'll crush down !!

    mul s1, a2, t0
    slli s1, s1, 2
    add a0, a0, s1
    # a0 is in right place

    slli s2, t1, 2
    add a1, a3, s2
    # a1 is in right place

    # a2 is in right place
    li a3, 4 # a3 is in right place
    slli a4, a5, 2 # a4 is in right place
    jal ra, dot

    mv s0, a0 # save a0 to s0

    # fetch above regs back
    lw ra, 40(sp)
    lw t4, 36(sp)
    lw t3, 32(sp)
    lw t2, 28(sp)
    lw t1, 24(sp)
    lw t0, 20(sp)
    lw a4, 16(sp)
    lw a3, 12(sp)
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 44

    # now s0 should be put in d[t0][t1]
    mul t4, t0, a5
    add t4, t4, t1
    mul t4, t4, t2
    add t4, t4, a6
    sw s0, 0(t4)

    addi t1, t1, 1
    j inner_loop_start

inner_loop_end:

    addi t0, t0, 1
    j outer_loop_start
    
outer_loop_end:

    # Epilogue
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)

    addi sp, sp, 12
    
    
    ret

error2:
    addi a0, x0, 17
    addi a1, x0, 2
    ecall

error3:
    addi a0, x0, 17
    addi a1, x0, 3
    ecall

error4:
    addi a0, x0, 17
    addi a1, x0, 4
    ecall