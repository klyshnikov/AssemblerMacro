.data

array: .space 40
msj_1: .asciz "Введите размер массива\n"
error_1: .asciz "Неверный размер!\n"
msj_2: .asciz "Введите все элементы массива\n"
error_2: .asciz "Произошло переполнение. Сумма была посчитана досрочно\n"
msj_3: .asciz "Сумма:\n"


.text

.macro set_array_size
	li a7, 5
	ecall
	li t0, 10

	blez a0, ERROR_wrong_array_size
	bgt a0, t0, ERROR_wrong_array_size

	mv a1, a0
	j end_macro_1

	ERROR_wrong_array_size:
	j end
	
	end_macro_1:
.end_macro

.macro fill_array (%x)
	la t0, array
	mv t1, %x
	
	loop_fill_array:
	beqz t1, end_loop_fill_array
	li a7, 5
	ecall
	sw a0, (t0)
	addi t0, t0, 4
	addi t1, t1, -1
	j loop_fill_array
	end_loop_fill_array:
.end_macro

.macro count_sum (%x)
	la t0, array
	mv t1, %x
	li t2, 2147483647
	li t3, -2147483648
	li t5, 0
	
	loop_count_sum:
	beqz t1, end_loop_count_sum
	lw t4, (t0)
	
	bgtz t4, check_max
	bltz t4, check_min
	
	continue:
	
	add t5, t5, t4
	addi t0, t0, 4
	addi t1, t1, -1
	
	j loop_count_sum
	
	check_max:
	li t6, 2147483647
	sub t6, t6, t4
	bgt t5, t6, ERROR_wrong_sum
	j continue
	
	check_min:
	li t6, -2147483648
	sub t6, t6, t4
	bgt t6, t5, ERROR_wrong_sum
	j continue
	
	ERROR_wrong_sum:
	li a7, 4
	la a0, error_2
	ecall
	j end
	
	end_loop_count_sum:
	
.end_macro


li a7, 4
la a0, msj_1
ecall
set_array_size

li a7, 4
la a0, msj_2
ecall
fill_array(a1)

count_sum(a1)


end:
li a7, 4
la a0, msj_3
ecall
mv a0, t5
li a7, 1
ecall

