#ifndef SYSCALLS_H_
#define SYSCALLS_H_

#define SYSCALL_ADDRESS OPTION_BOOT_START + 0x10
#define DO_SYSCALL(addr) \
    __asm__ ( "nop"); \
    *(volatile unsigned int*)(SYSCALL_ADDRESS) = addr; \
    __asm__ ( "nop");

#endif // SYSCALLS_H_
