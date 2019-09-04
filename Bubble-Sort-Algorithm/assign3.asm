// CPSC 355 Assignment 3 by Adam Berlak, ID: 30008230
fmt:
	.string "v[%d]: %d\n" // string created that is called
	.balign 4 // makes sure everything is quadword aligned
	.global main // makes main visible to linker
	define(i, w19) // define register 19 by i
	define(j, w20) // define register 20 by j
	define(ia_base, x21) // define register 21 by ia_base
	define(index2, w22) // define register 22 by index 2
	define(char1, w23) // define register 23 by char1
	define(char2, w24) // define register 24 by char2
	define(temp, w25) // define register 25 by temp

	i_size = 4 // initialize i_size to 4 with assembly equates
	j_size = 4 // initalizes j_size to 5 with assembly equates
	ia_size = 160 // initialize ia_size to 160 with assembly equates
	alloc = -(16 + i_size + j_size + ia_size) & -16 // calculate and set alloc
	dealloc = -alloc // calculate and set dealloc
	i_s = 16 // sets offset of i to 16
	j_s = 20 // sets offset of j to 20
	ia_s = 24 // sets offset of array to 24
main:
	stp	x29, x30, [sp, alloc]! // allocate memory calculated above for main
	mov	x29, sp // move sp to x29

	mov	i, 0 // set i to 0
	str	i, [x29, i_s] // stores inital value of i to memory
	b	test1 // call to test1 to check if loop should execute
start1:
	bl	rand // generate random number and put it in x0
	mov	char1, w0 // set char1 as the randomly generated number
	and	char1, char1, 0xFF // compare char1 and 0xFF with bitwise and and put result in char1
	add	ia_base, x29, ia_s // calculate base of array
	ldr	i, [x29, i_s] // loads i from memory
	str	char1, [ia_base, i, SXTW 2] // multiply i by 4 and use it as offset, then store char1 at the index

	adrp	x0, fmt // sets argument 1 of string
	add	x0, x0, :lo12:fmt // sets argument 1 of string
	ldr	i, [x29, i_s] // loads i from memory
	mov	w1, i // sets argument 2 of string as i
	ldr	w2, [ia_base, i, SXTW 2]  // sets argument 3 of string as char at index i
	bl	printf // calls print function

	ldr	i, [x29, i_s] // loads i from memory
	add	i, i, 1 // increment i by 1
	str	i, [x29, i_s] // saves i to memory
test1:
	ldr	i, [x29, i_s] // loads i from memory
	cmp	i, 40 // compare 0 with 40 and set flags
	b.lt	start1 // call start1 if i is less than 40

	mov	i, 40 // put 40 into i
	str	i, [x29, i_s] // saves i to memory
	b	test2 // call test2 to see if loop should execute
start2:
	mov	j, 1 // set j to 1
	str	j, [x29, j_s] // saves initial value of j to memory
	b	test3 // call to test3 to see if loop should execute
start3:
	ldr	j, [x29, j_s] // loads j from memory
	ldr	char1, [ia_base, j, SXTW 2]

	ldr	j, [x29, j_s] // loads j from memory
	sub	index2, j, 1 // subtract index by 1 and temporarily put it in register 25
	ldr	char2, [ia_base, index2, SXTW 2] // load integer at index j - 1 and put it in x24

	cmp	char1, char2 // compare char1 and char2
	b.le	else // if char1 is less than or equal to char2 skip the following if statement and go to else
if:
	add	sp, sp, -4 & -16 // allocate 16 bytes of temporary stack memory
	str	char2, [x29, -4] // save char2 in that temporary stack memory
	str	char1, [ia_base, index2, SXTW 2] // store char1 at index j - 1 of array
	ldr	temp, [x29, -4] // load data from temporary memory and save it to temp
	ldr	j, [x29, j_s] // loads j from memory
	str	temp, [ia_base, j, SXTW 2] // store temp at index j of array
	add	sp, sp, 16 // deallocate the 16 bytes of stack memory added previously
else:
	ldr	j, [x29, j_s] // loads j from memory
	add	j, j, 1 // increment j by 1
	str	j, [x29, j_s] // save j to memory
test3:
	ldr	j, [x29, j_s] // loads j from memory
	ldr	i, [x29, i_s] // loads i from memory
	cmp	j, i // compare j and i
	b.le	start3 // if j is less than or equal to i go to start3

	ldr	i, [x29, i_s] // loads i from memory
	sub	i, i, 1 // decrement i by 1
	str	i, [x29, i_s] // save i to memory
test2:
	ldr	i, [x29, i_s] // loads i from memory
	cmp	i, 0 // compare i and 0
	b.ge	start2 // of i is greater than or equal to 0 go to start2

	ldr	i, [x29, i_s] //loads i from memory
	mov	i, 0 // sets initial value of i to be 0
	str	i, [x29, i_s] // saves i to memory
	b	test4 // call test4 to check if loop should execute
start4:
	adrp	x0, fmt // set argument 1 of string
	add	x0, x0, :lo12:fmt // set argument 1 of string
	ldr	i, [x29, i_s] // loads i from memory
	mov	w1, i // set arfument 2 of string as i
	ldr	w2, [ia_base, i, SXTW 2] // set argument 3 of string is the character at index i
	bl	printf // call to print function

	ldr	i, [x29, i_s] // loads i from memory
	add	i, i, 1 // increment i by 1
	str	i, [x29, i_s] // saves i to memory
test4:
	ldr	i, [x29, i_s] // loads i from memory
	cmp	i, 40 // compare i and 40
	b.lt	start4 // if i is less than 40 go to start

	ldp	x29, x30, [sp], dealloc // deallocate the memory allocated for main
	ret
