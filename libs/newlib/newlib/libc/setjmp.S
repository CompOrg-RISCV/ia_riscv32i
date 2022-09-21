#define STORAGE(i, w) x##i, (i*w) (x10)

#define LD(i) lw STORAGE(i, 4)
#define SD(i) sw STORAGE(i, 4)


    .text

// x10 - 1st argument and return value
setjmp:
    .global setjmp
    
    SD( 1) 
    SD( 2) 
    SD( 3) 
    SD( 4) 
    SD( 5) 
    SD( 6) 
    SD( 7) 
    SD( 8) 
    SD( 9) 
    SD(10) 
    SD(11) 
    SD(12) 
    SD(13) 
    SD(14) 
    SD(15) 
    SD(16) 
    SD(17) 
    SD(18) 
    SD(19) 
    SD(20) 
    SD(21) 
    SD(22) 
    SD(23) 
    SD(24) 
    SD(25) 
    SD(26) 
    SD(27) 
    SD(28) 
    SD(29) 
    SD(30) 
    SD(31) 


    // Return 0 to caller
	addi x10, x0, 0

    jalr x0, 0(x1)

// x10 - first argument and return value
// x11 - second argument
longjmp:
   .global longjmp
   
    LD(31)
    LD(30)
    LD(29)
    LD(28)
    LD(27)
    LD(26)
    LD(25)
    LD(24)
    LD(23)
    LD(22)
    LD(21)
    LD(20)
    LD(19)
    LD(18)
    LD(17)
    LD(16)
    LD(15)
    LD(14)
    LD(13)
    LD(12)
    LD( 9)
    LD( 8)
    LD( 7)
    LD( 6)
    LD( 5)
    LD( 4)
    LD( 3)
    LD( 2)
    LD( 1)


    // swap x10 and x11
    xor x10, x10, x11
    xor x11, x11, x10
    xor x10, x10, x11

    lw x11, 44(x11)


   // if longjmp() was to return 0, return 1 instead

	bne x10, x0, lab_1
   	addi x10, x0, 1

lab_1:

   	jalr x0, 0(x1)
