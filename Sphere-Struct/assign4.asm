// CPSC 355 Assignment 4 by Adam Berlak, ID: 30008230
fmt:
	.string "Sphere %d origin = (%d, %d, %d) radius = %d\n" // creates string statement
	.global main // makes main visible to linker
	.balign 4 // makes sure everything is properly aligned

	define(sphere1_base,x19) // defines sphere1_base as register 19
	define(sphere2_base,x20) // defines sphere2_base as register 20

	point_x = 0 // assigns the offset of point_x to the value 0
	point_y = 4 // assigns the offset of point_y to the value 4
	point_z = 8 // assigns the offset of point_s to the value 8

	sphere_radius = 0 // assigns the offset of sphere_radius to the value 0
	sphere_point = 4 // assigns the offset of sphere_point to the value 4

	sphere_size = 16 // assigns the size of the sphere to the value 16

	alloc = -(16 + sphere_size + sphere_size + 128) & -16 // calculates the amount of memory needed to be allocated for spheres and stack variables
	dealloc = -alloc // calculates the amount of memory need to be deallocated
	sphere1_s = 16 // assigns the offset of sphere 1 to the value 16
	sphere2_s = 32 // assigns the offset of sphere 2 to the value 32

fmt2:
	.string "\nInitial sphere values: \n" // creates string statment to be printed
fmt3:
	.string "\nChanged sphere values: \n" // creates string statement to be printed

main:
	stp	x29, x30, [sp, alloc]! // allocate memory for main
	mov	x29, sp // save address of sp

	add	sphere1_base, x29, sphere1_s // calculate the base of sphere 1 and put it in register 19
	mov	x0, sphere1_base // move base address of sphere 1 to register 0 to set up argument
	bl	newSphere // call newSphere subroutine with base as argument
	mov	x21, x0 // save s returned from previous function to register 21
	str	x21, [x29, 48] // save register 21 to stack memory as a stack variable

	add	sphere2_base, x29, sphere2_s // calculate the base of sphere 2 and put it in registet 20
	mov	x0, sphere2_base // move base address of sphere 2 to register 0 to set up argument
	bl	newSphere // call newSphere subroutine with base as argument
	mov	x22, x0 // save s returned from previous function to register 22
	str	x22, [x29, 112] // save register 22 to stack memory as a stack variable

	adrp	x0, fmt2 // sets up argument 1 of print
	add	x0, x0, :lo12:fmt2 // sets up argument 1 of print
	bl	printf // calls function print

	mov	w0, 1 // moves 1 into w0 to set argument 1 of printSphere
	add	x1, x29, sphere1_s // set argument 2 as address of sphere 1
	bl	printSphere // calls function printSphere

	mov	w0, 2 // moves 2 into w0 to set argument 1 of printSphere
	add	x1, x29, sphere2_s // sets argument 2 as address of sphere 2
	bl	printSphere

	add	x0, x29, sphere1_s // sets argument 1 as address of sphere 1
	add	x1, x29, sphere2_s // sets argument 2 as address of sphere 2
	bl	equal // calls function equal
	tst	w0, 0x1
	b.eq	else // if the above evaluates to 0, 0 flag is set to 1 and we go to else

	mov	w0, -5 // sets argument 1 as -5
	mov	w1, 3 // sets argument 2 as 3
	mov	w2, 2 // sets argument 3 as 2
	add	x3, x29, sphere1_s // sets argument 4 as base address of sphere 1
	bl	move // call to function move

	add	x0, x29, sphere2_s // sets argument 1 as the base address of sphere 2
	mov	w1, 8 // sets argument 2 as 8
	bl	expand // calls function expand

else:
	adrp	x0, fmt3 // sets up argument 1 of string
	add	x0, x0, :lo12:fmt3 // sets up argument 1 of string
	bl	printf // calls function printf

	mov	w0, 1 // sets argument 1 as 1
	add	x1, x29, sphere1_s // set argument 2 as base address of sphere 1
	bl	printSphere // calls function printSphere

	mov	w0, 2 // sets argument 1 as 2
	add	x1, x29, sphere2_s // set argument 2 as base address of sphere 2
	bl	printSphere // calls function printSphere

	ldp	x29, x30, [sp], dealloc // deallocates memory
	ret // returns

newSphere: // creates subroutine newSphere that initializes values for sphere with base as an argument
	stp	x29, x30, [sp, -16]! // allocates 16 bytes of stack memory
	mov	x29, sp // saves address of sp

	add	sp, sp, -64 // allocates memory for temporary variables

	mov	x9, x0 // moves argument 1 value to register 9
	str	x9, [x29, -64] // saves register 9 to memory

	mov	w10, 1 // moves 1 to register 21
	ldr	x9, [x29, -64] // loads register 9 from memory
	str	w10, [x9, sphere_radius] // initializes radius of sphere

	mov	w10, 0 // moves 0 to register 10
	ldr	x9, [x29, -64] // loads register 9 from memory
	str	w10, [x9, sphere_point + point_x] // initializes x value of sphere

	mov	w10, 0 // moves 0 to register 10
	ldr	x9, [x29, -64] // loads register 9 from memory
	str	w10, [x9, sphere_point + point_y] // initializes y value of sphere

	mov	w10, 0 // moves 0 to register 10
	ldr	x9, [x29, -64] // loads register 9 from memory
	str	w10, [x9, sphere_point + point_z] // initalizes z value of sphere

	ldr	x9, [x29, -64] // loads register 9 from memory
	mov	x0, x9 // moves base address of sphere to x0 to be returned by the function

	add	sp, sp, 64 // deallocate memory allocated for temporary variables

	ldp	x29, x30, [sp], 16 // decrements 16 bytes from stack memory
	ret // returns

printSphere: // creates subroutine printSphere that prints each individual attribute of the sphere
	stp	x29, x30, [sp, -16]! // allocates 16 bytes of stack memory
	mov	x29, sp // saves address of sp

	add	sp, sp, -96 // allocates 96 bytes of memory for temporary variables

	mov	w9, w0 // saves argument 1 to register 9
	str	w9, [x29, -96] // saves register 9 to memory
	mov	x10, x1 // saves argument 2 to register 10
	str	x10, [x29, -64] // save resgister 10 to memory

	adrp	x0, fmt // sets up argument 1 of print
	add	x0, x0, :lo12:fmt // sets up argument 1 of print

	ldr	w9, [x29, -96] // loads register 9 from memory
	mov	w1, w9 // sets up argument 2 of print as argument 1 of function

	ldr	x10, [x29, -64] // loads register 10 from memory
	ldr	w2, [x10, 4] // sets up argument 3 of print

	ldr	x10, [x29, -64] // loads register 10 from memory
	ldr	w3, [x10, 8] // sets up argument 4 of print

	ldr	x10, [x29, -64] // loads register 10 from memory
	ldr	w4, [x10, 12] // sets up argument 5 of print

	ldr	x10, [x29, -64] // loads register 10 from memory
	ldr	w5, [x10] // sets up argument 6 of print

	bl	printf // calls function printf

	add	sp, sp, 96 // deallocates 96 bytes of stack memory

	ldp	x29, x30, [sp], 16 // deallocates 16 bytes of memory
	ret // returns

equal: // creates subroutine equal that compares two spheres and returns a boolean
	stp	x29, x30, [sp, -16]! // allocates 16 bytes of stack memory
	mov	x29, sp // saves address of sp

	add	sp, sp, -192 // allocates 192 bytes of memory for temporary variables

	mov	x11, x0 // saves argument 1 to register 11
	str	x11, [x29, -192] // stores register 11 to memory
	mov	x12, x1 // saves argument 2 to register 12
	str	x12, [x29, -128] // stores register 12 to memory

	ldr	w9, [x11] // loads attribute from sphere 1
	str	w9, [x29, -64] // saves register 9 to memory
	ldr	w10, [x12] // loads attribute from sphere 2
	str	w10, [x29, -32] // saves register 10 to memory
	ldr	w9, [x29, -64] // loads register 9 from memory
	ldr	w10, [x29, -32] // loads register 32 from memory
	cmp	w9, w10 // compares register 9 and 10
	b.ne	else2 // if register 9 and 10 arent the same go to else2

	ldr	w9, [x11, 4] // loads attribute from sphere 1
	str	w9, [x29, -64] // saves register 9 to memory
	ldr	w10, [x12, 4] // loads attribute from sphere 2
	str	w10, [x29, -32] // saves register 10 to memory
	ldr	w9, [x29, -64] // loads register 9 froom memory
	ldr	x10, [x29, -32] // loads register 10 from memory
	cmp	w9, w10 // compares register 9 and 10
	b.ne	else2 // if register 9 and 10 arent the same go to else2

	ldr	w9, [x11, 8] // loads attribute from sphere 1
	str	w9, [x29, -64] // saves register 9 to memory
	ldr	w10, [x12, 8] // loads attribute from sphere 2
	str	w10, [x29, -32] // saves register 10 to memory
	ldr	w9, [x29, -64] // loads register 9 from memory
	ldr	w10, [x29, -32] // loads register 10 from memory
	cmp	w9, w10 // compares register 9 and 10
	b.ne	else2 // if register 9 an 10 arent the same go to else2

	ldr	w9, [x11, 12] // loads attribute from sphere 1
	str	w9, [x29, -64] // saves register 9 to memory
	ldr	w10, [x12, 12] // loads attribute from sphere 2
	str	w10, [x29, -32] // saves register 10 to memory
	ldr	w9, [x29, -64] // loads register 9 from memory
	ldr	w10, [x29, -32] // loads register 10 from memory
	cmp	w9, w10 // compares register 9 and 10
	b.ne	else2 // if register 9 and 10 arent the same go to else2

	add	sp, sp, 192 // deallocates 192 bytes from stack memory

	mov	w0, 1 // if none of the else2 statements where called the spheres are identical so set return to 1
	b	done // go to done

else2: // called if an attribute is not the same between spheres
	mov	w0, 0 // set return value to 0
done:
	ldp	x29, x30, [sp], 16 // deallocate 16 bytes of stack memory
	ret // returns

move: // creates subroutine move that shifts a sphere based on the argumente inputed
	stp	x29, x30, [sp, -16]! // allocates 16 bytes of stack memory
	mov	x29, sp // saves address of sp

	mov	w10, w0 // puts argument 1 into register 10
	mov	w11, w1 // puts argument 2 into register 11
	mov	w12, w2 // puts argument 3 into register 12
	mov	x13, x3 // puts argument 4 into register 13

	ldr	w9, [x13, 4] // loads attribute of sphere
	add	w9, w10, w9 // modifies attribute based on argument
	str	w9, [x13, 4] // updates attribute of sphere by saving it

	ldr	w9, [x13, 8] // loads attribute of sphere
	add	w9, w11, w9 // modifies attribute based on argument
	str	w9, [x13, 8] // updates attribute of sphere by saving it

	ldr	w9, [x13, 12] // loads attribute of sphere
	add	w9, w12, w9 // modifies attribute based on argument
	str	w9, [x13, 12] // updares attrubute of sphere by saving it

	ldp	x29, x30, [sp], 16 // deallocates 16 bytes of stack memory
	ret // returns

expand: // creates subroutine expand that takes sphere as argument and increases radius
	stp	x29, x30, [sp, -16]! // allocates 16 bytes of stack memory
	mov	x29, sp // saves addres of sp

	mov	x10, x0 // puts argument 1 into register 10
	mov	w11, w1 // puts argument 2 ubti reguster 11

	ldr	w9, [x10, 0] // loads radius from sphere
	mul	w9, w9, w11 // updates radius based on argument
	str	w9, [x10, 0] // saves radius of sphere to update it

	ldp	x29, x30, [sp], 16 // deallocates 16 bytes of stack memory
	ret // returns
