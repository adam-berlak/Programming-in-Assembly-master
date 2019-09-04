// CPSC 355 Assignment 1b by Adam Berlak, ID: 30008230
fmt:
	.string "Minimum value is y = %d, and x is = %d" // string will be printed at end
	.balign 4 // insures instructions are properly aligned
	.global main // makes label main visible to linker
main:
	stp	x29, x30, [sp, -16]! // allocates 6 bytes of stack memory
	mov	x29, sp //updates frame pointer to the current stack pointer

	define(power_1, x21) // assigns the keyword 'power 1' to register 21
	define(power_2, x22) // assigns the keyword 'power 2' to register 22
	define(total, x23) // assigns the keyword 'total' to register 23
	define(minimum_y, x24) // assigns the keyword 'minimum_y' to register 24
	define(minimum_x, x25) // assigns the keyword 'minimum_x' to register 25
	define(coefficient_1, x26) // assigns the keyword 'coefficient_1' to register 26
	define(coefficient_2, x27) // assigns the keyword 'coefficient_2' to register 27
	define(coefficient_3, x28) // assigns the keyword 'coefficient_3' to register 28

	mov	minimum_y, 1000 // initializes minimum y value
	mov	minimum_x, 0 // initializes minimum x value
	mov	x20, -6 // initializes starting x value
	mov 	x19, 0 // initializes loop counter

	mov	coefficient_1, 5 // initializes coefficient 1
	mov	coefficient_2, 27 // initializes coefficient 2
	mov	coefficient_3, -27 // initializes coefficient 3
	b	test // calls test
start:

	mov	power_1, x20 // calculates first power of x and puts it in register 21
	mul	power_2, power_1, power_1 // calculates second power of x and puts it in register 22
	mul	total, power_2, power_1 // calculates third power of x and puts it in register 23

	mul	total, total, coefficient_1 // multiplies coefficient 1 with third power of x and adds it to total
	madd    total, power_2, coefficient_2, total // multiplies coefficient 2 with second power and adds it to total
	madd	total, power_1, coefficient_3, total // mutiplies coefficient 3 with first power and adds it to total
	add 	total, total, -43 // adds -43 to total

	add	x19, x19, 1 // increments loop counter by 1

	cmp	total, minimum_y // compares total value with minimum y value
	b.lt	set // go to set if total value is less than minimym y value
	add	x20, x20, 1 //  increments x by 1
	b 	test // go to test

set:
	mov	minimum_y, total // moves y value in register 23 into y minimum register 24
	mov	minimum_x, x20 // moves x value in register 20 into x minimum register 25
	add	x20, x20, 1 // increments x by 1
	b	test // go to test

test:   cmp	x19, 10 // compares loop counter with the immediate 10
	b.lt	start // calls start if less than is true

done:
	mov	x1, minimum_y // move minimum y value into register 1, sets argument 2 of string
	mov	x2, minimum_x // move minimum x value into register 2, sets argument 3 of string
	adrp	x0, fmt // sets argument one of string
	add 	x0, x0, :lo12:fmt // sets argument 1 of string
	bl	printf // function call to print

	ldp	x29, x30, [sp], 16 // deallocates 16 bytes of stack memory
	ret // returns control to calling code

