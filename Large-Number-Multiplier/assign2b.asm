// CPSC355 Assignment 2, by Adam Berlak ID: 30008230
fmt:
	.string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d) \n \n" // string that is printed
	.balign 4 // insures instructions are properly aligned
	.global main // makes label main visible to linker
fmt2:	.string "product = 0x%08x  multiplier = 0x%08x \n" // string that is printed
fmt3:	.string "64-bit result = 0x%016lx (%ld)\n" // string that is printed
main:
	stp	x29, x30, [sp, -16]! // allocates 6 bytes of stack memory
	mov	x29, sp // updates frame pointer to current stack pointer

	define(multiplier, w19) // assigns the keyword 'multiplier' to  32 bit register 19
	define(multiplier64, x19)
	define(multiplicand, w20) // assigns the keyword 'multiplicand' to 32 bit register 20
	define(product, w21) // assings the keyword product to 32 bit register 21
	define(product64, x21)
	define(i, w22) // assings keyword i to register 22
	define(negative, w23) // assings keyword negative to register 23
	define(result, x24) // assings keyword result to 64 bit register 24
	define(temp1, x25) // assings keyword temp1 to 64 bit register 25
	define(temp2, x26) // assings keyword temp2 to 64 bit register 26

	mov	multiplicand, 268435455 // initializes multiplicand
	mov	multiplier, 100 // initializes multiplier
	mov	product, 0 // initializes product
	mov	i, 0 // initializes i

	adrp	x0, fmt //sets argument 1 one string
	add	x0, x0, :lo12:fmt // sets argument 1 of string
	mov	w1, multiplicand // sets argument 2 of string
	mov	w2, multiplier // sets argument 3 of string
	bl	printf // function call to print

	cmp	multiplier, 0 // compares multiplier and the immediate 0
	b.lt	setNeg // if less than flag is set go to setNeg
	mov	negative, 0 // move the immediate 0 into the negative register, if multiplier is not less than 0
	b	test // go to start of test

setNeg:
	mov	negative, 1 // move the immediate 1 into the negative register, if multiplier is less than 0
	b	test // call to test
start:
	tst	multiplier, 0x1 // compare the first bit of both numbers with bitwise and, and put result in zero register
	b.eq	ifTest2 // if result of above is zero, Z flag is set to 1 so we skip the next line, if result is 1, zero flag set to 0
	add	product, product, multiplicand // add multiplicand to the product and save it to product

ifTest2:
	asr	multiplier, multiplier, 1 // do an arithmetic shift right by one bit for multiplier, and save it to multiplier
	tst	product, 0x1 // compare the first bit of both numbers with bitwise and, and put result in zero register
	b.eq 	else1 // if Z flag is 1, meaning the above evaluated to false, skip the next two lines and go to else1
	orr	multiplier, multiplier, 0x80000000 // compare multiplier and number with bitwise or and put result in multiplier
	b	ifTest3 // go to next if test

else1:
	and	multiplier, multiplier, 0x7FFFFFFF // compare multiplier and number with bitwise and, and puts result in multiplier

ifTest3:
	asr	product, product, 1 // arithmetic shifr right in the product by 1
	add	i, i, 1 // increment i by 1

test:	cmp	i, 32 // compares i with 32 and sets flags
	b.lt	start // go to start if i is less than 32
done:
	tst	negative, 1 // compare negative and 1 with bitwise and
	b.eq	end // if Z flag is 0, the above evaluated to true, skip the next line and go to end
	sub	product, product, multiplicand // subtract product by multiplicand
end:
	adrp	x0, fmt2 // sets argument 1 of string
	add	x0, x0, :lo12:fmt2 // sets argument 1 of string
	mov	w1, product // moves product in register 1, sets argument 2 of string
	mov	w2, multiplier // moves multiplier into register 2, sets argument 3 of string
	bl	printf

	sxtw	product64, product // put product into a 64 bit register with signed extend word
	and	temp1, product64, 0xFFFFFFFF // compare product and 0xFFFFFFFF with bitwise and, and put result in register 27
	lsl	temp1, temp1, 32 // do a logical shift left by 32 bits for temp1 and put it in temp1 register
	sxtw	multiplier64, multiplier // put multiplier into a 64 bit register with signed extend word
	and	temp2, multiplier64, 0xFFFFFFFF // compare multiplier and 0xFFFFFFFF with bitwise and, and put result in register 27
	add	result, temp1, temp2; // add values in temp1 and temp2 register and put result in result register

	adrp	x0, fmt3 // sets first argument of the string
	add	x0, x0, :lo12:fmt3 // sets first argument of the string
	mov	x1, result // sets second argument of the string
	bl	printf // calls print

	ldp	x29, x30, [sp], 16 // deallocates 16 bytes of stack memory
	ret // returns control to the calling code
