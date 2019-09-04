// CPSC 355 Assignment 1a by Adam Berlak, ID: 30008230
fmt:
	.string "Minimum value is y = %d, and x is = %d"
	.balign 4 // ensures instructions are properly aligned
	.global main // makes label main accessable to the linker
main:
	stp	x29, x30, [sp, -16]! // allocates 6 bytes of stack memory
	mov	x29, sp //updates frame pointer to the current stack pointer

	mov	x24, 1000 // initializes minimum y value
	mov	x25, 2 // initializes minimum x value
	mov	x20, -6 // initializes x value for incrementation
	mov 	x19, 0 // initializes loop counter for incrementation

	mov	x26, 5 // initializes constant
	mov	x27, 27 // initializes constant

start:  cmp	x19, 10 // conpares counter with the immediate 10
	b.ge	done // go to done if counter is greater if equal to 10

	mov	x21, x20 // moves x value to register 21
	mul	x22, x21, x21 // calculates second power of x and puts it in register 22
	mul	x23, x22, x21 // calculates third power of x and puts it in register 23

	mul	x21, x21, x27 // multiplies x with constant in register 27
	mul	x22, x22, x27 // multiplies second power of x with constant in register 27
	mul	x23, x23, x26 // multiplies third power of x with constant in register 26

	add	x23, x23, x22 // adds value of first and second elements
	sub	x23, x23, x21 // adds value of third element to the total value
	sub 	x23, x23, 43 // adds immediate 43 to the total value

	add	x19, x19, 1 // increments loop counter by 1

	cmp	x23, x24 // compares total value with minimum
	b.lt	set // go to set if value in register 23 is less than register 24
	add	x20, x20, 1 // if not smaller increment x by 1
	b 	start // go to start

set:
	mov	x24, x23 // moves y value in register 23 into y minimum register 24
	mov	x25, x20 // moves x value in register 20 into x minimum register 25
	add	x20, x20, 1 // increments x by 1
	b	start // go to start

done:
	mov	x1, x24 // move minimum y value into register 1, argument 2 of the string
	mov	x2, x25 // move minimum x value into register 2, argument 3 of the string
	adrp	x0, fmt // specifies argument 1 of the string
	add 	x0, x0, :lo12:fmt // specifies argument 1 of th string
	bl	printf // calls print function

	ldp	x29, x30, [sp], 16 // deallocates 16 bytes of stack memory
	ret // restores control to calling code

