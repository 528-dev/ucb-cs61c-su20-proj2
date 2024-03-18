.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue

    addi t0, x0, 1
    bge a1, t0, loop_start # check the length of vector
    addi a0, x0, 17
    addi a1, x0, 7
    ecall
loop_start:
    mv t0, a0  # t0 is the pointer to the start of the vector
    mv t1, x0  # index of vector
    mv t2, x0  # the max value in vector currently

loop_continue:
    bge t1, a1, loop_end # index beyond length
    slli t3, t1, 2
    add t4, t0, t3  # the address of which will be load
    lw t5, 0(t4)
    bge t2, t5, no_update
    mv t2, t5
    mv a0, t1
    
no_update:
    addi, t1, t1, 1
    j loop_continue

loop_end:
    

    # Epilogue


    ret