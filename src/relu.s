.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
check:
    addi t0, x0, 1
    bge a1, t0, loop_prepare # check a1 >= 1

    addi a1, x0, 8 # exit
    j exit2
loop_prepare:
    add s0, a0, x0 # s0 array address
    add s1, a1, x0 # s1 # of array
    add t0, x0, x0 # t0 from 0 to #
loop:
    beq t0, s1, end
    slli t1, t0, 2
    add t2, s0, t1 # t2 is element address
    lw t3, 0(t2)
    bge t3, x0, L1
    add t3, x0, x0
L1:
    sw t3, 0(t2)
    addi t0, t0, 1
    j loop
end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8

    
	ret