fmt:
	.string "\nStack overflow! Cannot push value onto stack.\n" // creates string statement
fmt2:
	.string "\nStack underflow! Cannot pop an empty stack.\n" // creates string statement
fmt3:
	.string "\nEmpty stack\n" // creates a string statment
fmt4:
	.string "\nCurrent stack contents:\n" // creates a string statment
fmt5:
	.string "%d" // creates a string statement
fmt6:
	.string "<-- top of stack" // creates a string statement
fmt7:
	.string "\n" // creates a string statment
	.balign 4 // makes sure everything is properly aligned
	.global stack_m // makes stack_m visible to linker
	.bss // indicates the following should be made empty
stack_m:.skip	5 * 4 // creates empty integer stack of size 5, with 20 bytes
	.balign 4 // makes sure everything is properly aligned
	.global	top_m // makes top_m visible to linker
	.data // indicates that the following is data
top_m:	.word	-1 // creates integer top_m initializes to 01
	.balign	4 // makes sure everything is properly aligned
	.text // indicates the following is text
	.global push // makes push visible to linker
	.global pop // makes pop visible to linker
	.global stackFull // makes stackFull visible to linker
	.global	stackEmpty // makes stackEmpty visible to linker
	.global display // makes disblay visible to linker
	.balign	4 // makes sure everything is properly aligned
push:
	stp	x29, x30, [sp, -16]! // allocates 16 bytes of stack memory
	mov	x29, sp // saves sp

	mov	w14, w0 // saves argument to w14

	bl	stackFull // call to stack full method
	mov	w10, w0 // move return of stackFull to w10

	tst	w10, 0x1 // compare return to 1
	b.eq	else // if return is 0 skip the next lines and fo to else, otherwise execute the following

	adrp	x0, fmt // set up arg 1 of string
	add	x0, x0, :lo12:fmt // set up arg 1 of string
	bl	printf // call to printf

	b	end // skip the next else statment
else:
	adrp	x19, top_m // calculate address of top
	add	x19, x19, :lo12:top_m // calculate low order bits of address of top
	ldr	w11, [x19] // load top from address in x19
	add	w11, w11, 1 // increment top by 1
	str	w11, [x19] // save top to address in x19

	adrp	x19, stack_m // calculate address of stack
	add	x19, x19, :lo12:stack_m // calcuate low order bits of address of stack
	str	w14, [x19, w11, SXTW 2] // load integer in stack array at position w11

end:
	ldp	x29, x30, [sp], 16 // deallocate 16 bytes of stack memory
	ret // return

pop:
	stp	x29, x30, [sp, -16]! // allocate 16 bytes of stack memory
	mov	x29, sp // saves sp

	bl	stackEmpty // call to stack empty function
	mov	w9, w0 // save return of stackEmpty to w9

	tst	w9, 0x1 // compare w9 and 1
	b.eq	else1 // if w9 is 0 go to else otherwise execute the following

	adrp	x0, fmt2 // sets up argument 1 of print
	add	x0, x0, :lo12:fmt2 // sets up argument 1 of print
	bl	printf // call to print

	b	end1 // skip the next else statment and go to end1
else1:
	adrp	x19, top_m // calculate address of top
	add	x19, x19, :lo12:top_m // caclulate low order bits of address of top
	ldr	w10, [x19] // load top from address in x19

	adrp	x20, stack_m // calculate address of stack
	add	x20, x20, :lo12:stack_m // calculate low order bits of address of stack
	ldr	w11, [x20, w10, SXTW 2] // load integer from stack at w10
	sub	w10, w10, 1 // increment w10 by 1
	str	w10, [x19] // save w10 to address in x19, update top

	mov	w0, w11 //  set up return to integer at w10 in stack
end1:
	ldp	x29, x30, [sp], 16 // deallocate 16 bytes of stack memory
	ret // return

stackFull:
	stp	x29, x30, [sp, -16]! // allocate 16 bytes of stack memory
	mov	x29, sp // saves sp

	adrp	x19, top_m // calculate address of top
	add	x19, x19, :lo12:top_m // calculate low order bits of address of top
	ldr	w9, [x19] // load top and save it to w9

	mov	w10, 5 // put 5 in register 10
	sub	w10, w10, 1 // decrement w10

	cmp	w9, w10 // compare 5 to top of stack
	b.ne	else2 // if not the same skip the next line and go to else2

	mov	w11, 1 // put 1 in register w11
	b	end2 // skip else and go to end2
else2:
	mov	w11, 0 // put 0 in register w11
end2:
	mov	w0, w11 // set return as contents of w11
	ldp	x29, x30, [sp], 16 // deallocate 16 bytes of stack memory
	ret // return

stackEmpty:
	stp	x29, x30, [sp, -16]! // allocate 16 bytes of stack memory
	mov	x29, sp // save sp

	adrp	x19, top_m // calculate address of top
	add	x19, x19, :lo12:top_m // calculate low order bits of address of top
	ldr	w9, [x19] // load top into w9

	mov	w10, -1 // put -1 into register w10

	cmp	w9, w10 // compare -1 and top
	b.ne	else3 // if they arent the same go to else3

	mov	w11, 1 // put 1 in registter w11
	b	end3 // skip else3 and go to end
else3:
	mov	w11, 0 // put 0 in register w11
end3:
	mov	w0, w11 // set return as contents of w11
	ldp	x29, x30, [sp], 16 // deallocate 16 bytes of stack memory
	ret // return

display:
	stp	x29, x30, [sp, -16]! // allocate 16 bytes of stack memory
	mov	x29, sp // save sp

	bl	stackEmpty // call to stackEmpty function
	tst	w0, 0x1 // compare return of stackEmpty to 1
	b.eq	else4 // if stackEmpty returns 0 skip the following and go to else4

	adrp	x0, fmt3 // sets up argument 1 of print
	add	x0, x0, :lo12:fmt3 // sets up argument 1 of print
	bl	printf // calls printf

	b	end4 // skips else4 and goes to end4
else4:
	adrp	x0, fmt4 // set up argument 1 of print
	add	x0, x0, :lo12:fmt4 // set up argument 1 of print
	bl	printf // calls printf

	adrp	x19, top_m // calculates address of top
	add	x19, x19, :lo12:top_m // calculates low order bits of address of top
	ldr	w14, [x19] // loads top into w14

	b	test // go to test
start:
	adrp	x20, stack_m // calculate address of stack
	add	x20, x20, :lo12:stack_m // calculate low order bits of address of stack
	ldr	w10, [x20, w14, SXTW 2] // load integer in stack at w14 into w10

	adrp	x0, fmt5 // set up argument 1 of print
	add	x0, x0, :lo12:fmt5 // set up argument 1 of print
	mov	w1, w10 // set up argument 2 of print
	bl	printf // calls printf

	adrp	x19, top_m // calculates address of top
	add	x19, x19, :lo12:top_m // calculates low order bits of address of top
	ldr	w11, [x19] // 
	cmp	w14, w11
	b.ne	end5

	adrp	x0, fmt6
	add	x0, x0, :lo12:fmt6
	bl	printf
end5:
	adrp	x0, fmt7
	add	x0, x0, :lo12:fmt7
	bl	printf

	sub	w14, w14, 1
test:
	cmp	w14, 0
	b.ge	start
end4:
	ldp	x29, x30, [sp], 16
	ret
