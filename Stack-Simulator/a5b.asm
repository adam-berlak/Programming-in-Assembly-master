define(day_r, w19) // sets up macro day_r
define(month_r, w20) // sets up macro month_r
define(year_r, w21) // sets up macro year_r
define(suffix_r, x23) // sets up macro suffix_r
define(argv_r, x25) // sets up argv_r day_r
define(i_r, w26) // sets up macro i_r
	.text
fmt:	.string "\n %s %d%s, %d \n" // sets up string
fmt2:	.string "\n not a valid date \n" // sets up string

jan_m:	.string	"January" // sets up string jan_m
feb_m:	.string	"February" // sets up string feb_m
mar_m:	.string	"March" // sets up string mar_m
apr_m:	.string	"April" // sets up string apr_m
may_m:	.string	"May" // sets up string may_m
june_m:	.string	"June" // sets up string jun_m
july_m:	.string	"July" // sets up string july_m
aug_m:	.string	"August" // sets up string aug_m
sept_m:	.string	"September" // sets up string sept_m
oct_m:	.string	"October" // sets up string oct_m
nov_m:	.string	"November" // sets up string nov_m
dec_m:	.string	"December" // sets up string dec_m
st_m:	.string "st" // sets up string st_m
nd_m:	.string "nd" // sets up string nd_m
rd_m:	.string "rd" // sets up string rd_m
th_m:	.string "th" // sets up string th_m

	.data
	//.balign	8 // makes sure everything is properly aligned
month_m:.dword	jan_m, feb_m, mar_m, apr_m, may_m, june_m, july_m, aug_m, sept_m, oct_m, nov_m, dec_m // creates array of strings representing months
days_m:	.word	31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 // creates an array of month lengths based on their corresponding place in the year
	.text
	.balign	4 // makes sure everything is properly aligned
	.global	main // makes main visible to linker
main:	stp	x29, x30, [sp, -16]! // allocates 16 bytes of stack memory
	mov	x29, sp // saves so

	mov	i_r, 2 // i = 2
	mov	argv_r, x1 // loads argument 2 of input args
	ldr	x20, [argv_r, i_r, SXTW 3] // loads first argument from argument array

	mov	i_r, 3 // i = 3
	ldr	x19, [argv_r, i_r, SXTW 3] // loads second argument from argument array
	mov	i_r, 4 // i = 4
	ldr	x21, [argv_r, i_r, SXTW 3] // loads third argument from argument array

	mov	x0, x19 // sets up first arg of atoi
	bl	atoi // calls atoi
	mov	day_r, w0 // saves return of atoi

	mov	x0, x20 // sets up first arg of atoi
	bl	atoi // calls atoi
	mov	month_r, w0 // saves return of atoi

	mov	x0, x21 // sets up first arg of atoi
	bl	atoi // calls atoi
	mov	year_r, w0 // saves return of atoi

dateCheck: // checks if date is valid
	cmp	month_r, 12 // compare month and 12
	b.gt	print // if greater than print error
	cmp	month_r, 0 // compare month and 0
	b.lt	print // if greater than print error
	cmp	year_r, 0 // compare year and 0
	b.lt	print // if less than print error

	adrp	x22, days_m // calculate address of days_m
	add	x22, x22, :lo12:days_m // calculate low order bits of address of days_m
	sub	w27, month_r, 1 // subtract month by 1 and save it to register 27
	ldr	w22, [x22, w27, SXTW 2] //  load integer at index w27 and save to x22
	cmp	day_r, w22 // compare loaded number and day inputed
	b.gt	print // if day is greater than max print error
	cmp	day_r, 0 // compare input day with 0
	b.lt	print // if less than 0 print error
	b	skip // skip print
print: // prints error
	adrp	x0, fmt2 // sets up argument 1 of string
	add	x0, x0, :lo12:fmt2 // sets up argument 1 of string
	bl	printf // calls printf
	b	end // skip everything and go to end
skip:

	mov	w24, day_r // move day inputed to register 24

	cmp	w24, 10 // compare day and 10
	b.lt	test // if less than 10 go to test

	cmp	w24, 20 // compare day and 20
	b.ge	test // if greater than or equal to 20 go to test

	adrp	x22, th_m // calculate address of th_m
	add	suffix_r, x22, :lo12:th_m // calculate low order bits of address of th_m
	//ldr	suffix_r, [x22] // loads suffix from address at x22

	b	done // go to done as suffix is determined
start: // loop that finds the righmost digit of the number
	sub	x24, x24, 10 // decrement x24 by 10
test:
	cmp	x24, 0 // compare x24 and 0
	b.ge	start // if x24 is greater than or equal to 0 go to start

	add	x24, x24, 10 // add ten to get right most digit of number

	cmp	x24, 1 // compare digit and 1
	b.eq	setST // if digit is 1 go to setST
	cmp	x24, 2 // compare digit and 2
	b.eq	setND // if digit is 1 go to setND
	cmp	x24, 3 // compare digit and 3
	b.eq	setRD // if digit is 1 go to setRD

	adrp	x22, th_m // calculate address of th_m
	add	suffix_r, x22, :lo12:th_m // calculate low order bits of address of th_m
	//ldr	suffix_r, [x22] // loads suffix from address at x22
	b	done // go to done
setST: // sets suffix as st
	adrp	x22, st_m // calculate address of st_m
	add	suffix_r, x22, :lo12:st_m // calculate low order bits of address of st_m
	//ldr	suffix_r, [x22] // loads suffix from address at x22
	b	done
setND: // sets suffix as nd
	adrp	x22, nd_m // calculate address of nd_m
	add	suffix_r, x22, :lo12:nd_m // calculate low order bits of address of nd_m
	//ldr	suffix_r, [x22] // loads suffix from address at x22
	b	done
setRD: // sets suffix as rd
	adrp	x22, rd_m // calculate address of rd_m
	add	suffix_r, x22, :lo12:rd_m // calculate low order bits of address of rd_m
	//ldr	suffix_r, [x22] // loads suffix from address at x22
	b	done
done:
	adrp	x22, month_m // calculates address of month stack
	add	x22, x22, :lo12:month_m // calculates low order bits of address of month stack
	sub	w25, month_r, 1 // subtracts month by 1 and puts result in w25
	ldr	x25, [x22, w25, SXTW 3] // loads address at offset register 25 from base of month

	adrp	x0, fmt // sets up argument 1 of string
	add	x0, x0, :lo12:fmt // sets up argument 1 of string
	mov	x1, x25 // sets up argument 2 of string
	mov	w2, day_r // sets up argument 3 of string
	mov	x3, suffix_r // sets up argument 4 of string
	mov	w4, year_r // sets up argument 5 of string
	bl	printf // calls printf
end:
	ldp	x29, x30, [sp], 16 // deallocates 16 bytes of memory
	ret // returns
