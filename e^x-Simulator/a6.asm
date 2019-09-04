//	CPSC 355: Assignment 6 by Adam Berlak, ID: 30008230
fmt:	.string "Error reading file" // string called with error reading file
fmt2:	.string	"\nInput number is: %f, e^x Output Number is: %f\n" // print statement
fmt3:	.string "\nInput number is: %f, e^-x Output Number is: %f\n"
	.balign 4 // makes sure everything is quad-word aligned
	.data
pn:	.string	"input.bin" // specifies file name
a_m:	.double	0r1.0e-10 // creates double constant

	.text
	define(x_variable, d19) // defines d19 as x_variable
	define(power, d20) // defines d20 as power
	define(new_term, d22) // defines d22 as new_term
	define(total, d24) // defines d24 as total
	define(limit, d25) // defines d25 as limit
	buf_size = 8 // sets buf size to 0
	alloc = -(16 + buf_size) & -16 // specifies memory amount to be allocated
	dealloc = -alloc // specifies memory amount to be deallocated
	buf_s = 16 // sets offset of buf to 16

	.balign	4
	.global main // makes main visible to linker
main:	stp	x29, x30, [sp, alloc]! // allocates bytes for main
	mov	x29, sp // saves sp to x29

	mov	w0, -100 // sets up argument 1 of svc (Use cwd)
	adrp	x1, pn // sets up argument 2 of svc (pathname)
	add	x1, x1, :lo12:pn // gets low order bits of pathname
	mov	w2, 0 // sets up argument 3 of svc (read only)
	mov	w3, 0 // sets up argument 4 of svc (not used)
	mov	x8, 56 // specfies //openat I/O request
	svc	0 // call system function

	cmp	w0, 0 // check if w0 is negative
	b.ge	open_ok // if not go to open_ok

	adrp	x0, fmt // sets up argument 1 of print statement
	add	x0, x0, :lo12:fmt2 // gets low order bits of argument 1
	bl	printf // call to printf function

open_ok:
	mov	w19, w0 // puts output of cvs in w19
start3:
	add	x20, x29, buf_s // calculates address of buf_s
	ldr	d0, [x20] // sets argument 1 as contents of buf_s
	bl	positivePower // call to positivePower function that calculates e^x
	add	x20, x29, buf_s // caclualtes address of buf_s
	ldr	d0, [x20] // sets argument 1 as contents of buf_s
	bl	negativePower // call to negativePower functin that calculates e^-x
test3:
	mov	w0, w19 // first argument set as file discriptor
	add	x1, x29, buf_s // second argument address of buf_s
	mov	x2, 8 // third argument, size of buf
	mov	x8, 63 // read I/O request
	svc	0 // call to svc function

	cmp	x0, 0 // compare n_read to 0
	b.ne	start3 // if not equal to 0 go to start3, otherwise file has been read

	ldp	x29, x30, [sp], dealloc // deallocate memory
	ret // return

positivePower:
	stp	x29, x30, [sp, -16]! // allocates bytes for positivePower
	mov	x29, sp // saves sp to x29

	fmov	x_variable, d0 // saves argument 1 to x_variable
	fmov	power, x_variable // gets first power of x_variable and puts it in power
	fmov	d21, 1.0 // puts immediate 1 in d21
	fmov	total, 1.0 // adds 1 to total
	fmov	new_term, 1.0
	b	test // go to test
start: // start of for loop
	fmov	d0, d21 // set argument 1 as d21
	bl	factorial // function call to factorial/
	fmov	new_term, d0 // put the output of factorial into new_term

	fdiv	new_term, power, new_term // divides power by the resulting factorial and saves to new_term
	fadd	total, total, new_term // adds new_term to total

	fmov	d23, 1.0 // puts immediate 1 in d23
	fadd	d21, d21, d23 // increments d21 by 1
	fmul	power, power, x_variable // increases power of x by 1
test:
	adrp	x20, a_m // calculating address of a_m
	add	x20, x20, :lo12:a_m // calculating low order bits of address of a_m
	ldr	limit, [x20] // loading a_m from address calculated above

	fcmp	new_term, limit // compare the most recently added term to the limit loaded above
	b.ge	start // if greater than go to start

	adrp	x0, fmt2 // set up argument 1 of string
	add	x0, x0, :lo12:fmt2 // get low order bits of argument 1 of string
	fmov	d0, x_variable // set up argument 2 of string
	fmov	d1, total // set up argument 3 of string
	bl	printf // call to printf function

	nop // no operations left

	ldp	x29, x30, [sp], 16 // deallocate 16 bytes of stack memory
	ret // return

negativePower:
	stp	x29, x30, [sp, -16]! // allocates bytes for negativePower
	mov	x29, sp // saves sp to x29

	mov	x22, 1 // set negative truth value to 1
	fmov	x_variable, d0 // saves argument 1 to x_variable
	fmov	power, x_variable // gets first power of x_variable and puts it in power
	fmov	d21, 1.0 // puts immediate 1 in d21
	fmov	total, 1.0 // adds 1 to total
	fmov	new_term, 1.0
	b	test4 // go to test
start4: // start of for loop
	fmov	d0, d21 // set argument 1 as d21
	bl	factorial // function call to factorial
	fmov	new_term, d0 // put the output of factorial into new_term

	fdiv	new_term, power, new_term // divides power by the resulting factorial and saves to new_term
	cmp	x22, 0 // compare negative value to 0
	b.eq	add // if negative is 0, i.e. false go to add
	fsub	total, total, new_term // subtracts new_term from total
	mov	x22, 0 // set x22 to 0, false
	b	skip // skip the next line
add:
	fadd	total, total, new_term // adds new_term to total
	mov	x22, 1 // set x22 to 1, true
skip:
	fmov	d23, 1.0 // puts immediate 1 in d23
	fadd	d21, d21, d23 // increments d21 by 1
	fmul	power, power, x_variable // increases power of x by 1
test4:
	adrp	x20, a_m // calculating address of a_m
	add	x20, x20, :lo12:a_m // calculating low order bits of address of a_m
	ldr	limit, [x20] // load limit from addres calculated above

	fcmp	new_term, 0.0 // compare the most recently added term to 0
	b.ge	skip2 // if it is greater than, skip the next line

	fmov	d28, -1.0 // move the immediate -1 into d28
	fmul	new_term, new_term, d28 // multiply the new term by -1 to get absolute value
skip2:
	fcmp	new_term, limit // compare the new term to the limit
	b.ge	start4 // if greater than go to start

	adrp	x0, fmt3 // set up argument 1 of string
	add	x0, x0, :lo12:fmt3 // get low order bits of argument 1 of string
	fmov	d0, x_variable // set up argument 2 of string
	fmov	d1, total // set up argument 3 of string
	bl	printf // call to printf function

	nop // no operations

	ldp	x29, x30, [sp], 16 // deallocate 16 bytes of stack memory
	ret // return

factorial:
	stp	x29, x30, [sp, -16]! // allocates bytes for factorial
	mov	x29, sp // save sp to x29

	fmov	d26, d0 // d26 contains d21 and is decremented by 1 each loop
	fmov	d27, d26 // d27 contains the value of factorial
	b	test2 // call to test2
start2:
	fmul	d27, d27, d28 // multiply total by d28

	fmov	d28, 1.0 // put 1 in d28
	fsub	d26, d26, d28 // decrement d26 by 1
test2:
	fmov	d28, 1.0 // put 1 in d28
	fsub	d28, d26, d28 // decrement d26 by 1 and put it in d28
	fcmp	d28, 0.0 // compare d28 and 0
	b.gt	start2 // if greater than 0 go to start

	fmov	d0, d27 // set return value as the total


	ldp	x29, x30, [sp], 16 // deallocate 16 bytes of stack memory
	ret // return

