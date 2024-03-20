.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:

    # Prologue
    addi t1, x0, 1
check1:
    bge a2, t1, check2
    addi a0, x0, 17
    addi a1, x0, 5
    ecall
check2:
    bge a3, t1, check3
    addi a0, x0, 17
    addi a1, x0, 6
    ecall
check3:
    bge a4, t1, going_on
    addi a0, x0, 17
    addi a1, x0, 6
    ecall
   
going_on:
    addi t0, x0, 0 # t0 is the index of v0 and v1
    addi t1, x0, 0 # sum up to t1

loop_start:
    bge t0, a2, loop_end

    mul t2, t0, a3
    add t3, a0, t2
    lw t4, 0(t3) # v0[i]

    mul t2, t0, a4
    add t3, a1, t2
    lw t5, 0(t3) # v1[i]

    mul t4, t4, t5
    add t1, t1, t4
    
    addi t0, t0, 1
    j loop_start

loop_end:
    mv a0, t1
    ret



    # Epilogue

    
    ret