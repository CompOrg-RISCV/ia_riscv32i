#ifndef SETJMP_BUF_H_
#define SETJMP_BUF_H_

// jump buffer to store 32 registers
//#if OPTION_XLEN == 64
//    #define SETJMP_BUF long long jmp_buf[32];
//#else
//    #define SETJMP_BUF int jmp_buf[32];
//#endif
//work around as the OPTION_ are not being passed down here
    #define SETJMP_BUF long long jmp_buf[32];
#endif // SETJMP_BUF_H_
