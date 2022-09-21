// This is a startup code for the Codasip RISCV32I Instructional Processor
// The main task of the startup code for C language programs
// is to initialize the stack pointer and call the main function.
//
// Also bodies of functions used in tests abort and exit are present here.
//
// Values for a 32-bit RISC machine
#define ADDR_SIZE 			4
#define STACK_ALIGN_VAL 	8
#define ABORT_EXIT_CODE     134
#define NMI_EXIT_CODE       135
#define TRAP_EXIT_CODE      136
#define MAX_REGISTER        x31

#define HALT \
    addi x31, x0, 1; \
    lui t0, (codasip_syscall & 0xfffff000) >> 12; \
    lui x30, (codasip_syscall & 0x00000fff); \
    srli x30, x30, 12; \
    or t0, t0, x30; \
    sw x31, 0 (t0); \
    1: jal x0, 1b

	// The section .crt0 is always put at address 0
	// This section can be changed by modifying the GNU linker script
	.section .crt0, "ax"

	// Symbol start is used to obtain entry point information
_start:
	.global _start

	j _reset_handler    // 0x1000 - reset vector
	nop
	nop
	nop

	 // Syscall must be present at 0x1010 (BASE + 0x10) for Codasip uRISC-V by default (?????????)
codasip_syscall:
    .global codasip_syscall
    .dword 0

_reset_handler:
    .global _reset_handler

	// We first initialize the stack pointer with initial stack pointer address
	// using the combinaton of instructions that is used to emulation a 32-bit load immediate
	lui sp, (_stack & 0xfffff000) >> 12	// using standard RISCV stackpointer register, x2
	lui x30, (_stack & 0x00000fff)
	srli x30, x30, 12
	or sp, sp, x30

	// Run global constructors
	j ctors_init

ctors_initialized:
    j dtors_init

dtors_initialized:

	lui x10, (_codasip_argc_address & 0xfffff000) >> 12	// using standard RISCV stackpointer register, x10
	lui x30, (_codasip_argc_address & 0x00000fff)
	srli x30, x30, 12
	or x10, x10, x30
    lw x10, 0(x10)

	lui x11, (_codasip_argv_pointers & 0xfffff000) >> 12	// using standard RISCV stackpointer register, x11
	lui x30, (_codasip_argv_pointers & 0x00000fff)
	srli x30, x30, 12
	or x11, x11, x30

    // Now we can call the main function.
    call main
    call exit
    HALT

ctors_init:
	// Lost the list of constructors
	// The following symbols are provided by the linker
	lui x13, (__CTOR_LIST__ & 0xfffff000) >> 12
	lui x30, (__CTOR_LIST__ & 0x00000fff)
	srli x30, x30, 12
	or x13, x13, x30

	// reserve space on the stack (8 bytes for a 32-bit instruction machine)
	addi sp, sp, -(STACK_ALIGN_VAL)		// sp = register for the stack pointer

ctors_loop:
	// x14 is restored on each call
	lui x14, (__CTOR_END__ & 0xfffff000) >> 12
	lui x30, (__CTOR_END__ & 0x00000fff)
	srli x30, x30, 12
	or x14, x14, x30
	beq x14, x13, ctors_end

	    // store x13 to stack because it can be overwritten
    sw x13, 0(sp)
    // load called function address
    lw x13, 0(x13)
    // an instruction immediate following a load cannot use the load data due to not available until WB stage
    nop
    jalr x1, 0(x13)
    // restore R13
    lw x13, 0(sp)
    // an instruction immediate following a load cannot use the load data due to not available until WB stage
    nop
    // next initializer
    addi x13, x13, ADDR_SIZE
    j ctors_loop

ctors_end:
    mv x13, x0			// reset x13 = 0
    mv x14, x0			// reset x14 = 0
    // move stack pointer back
    addi sp, sp, +STACK_ALIGN_VAL
    j ctors_initialized

dtors_init:
	// The following symbols are provided by the linker
	lui x13, (__DTOR_LIST__ & 0xfffff000) >> 12
	lui x30, (__DTOR_LIST__ & 0x00000fff)
	srli x30, x30, 12
	or x13, x13, x30

    // reserve space on stack (keep stack aligned)
    addi sp, sp, -(STACK_ALIGN_VAL)

dtors_loop:
	// x14 is restored on each call
	lui x14, (__DTOR_END__ & 0xfffff000) >> 12
	lui x30, (__DTOR_END__ & 0x00000fff)
	srli x30, x30, 12
	or x14, x14, x30
    beq x14, x13, dtors_end
    // store x13 to stack because it can be overwritten
    sw x13, 0(sp)
    // load called function address
    lw x10, 0(x13)
    // an instruction immediate following a load cannot use the load data due to not available until WB stage
    nop
    call atexit
    // restore R13
    lw x13, 0(sp)
    // an instruction immediate following a load cannot use the load data due to not available until WB stage
    nop
    // next initializer
    addi x13, x13, ADDR_SIZE
    j dtors_loop

dtors_end:
    mv x13, x0			// reset x13 = 0
    mv x14, x0			// reset x14 = 0
    // move stack pointer back
    addi sp, sp, +STACK_ALIGN_VAL
    j dtors_initialized

abort:
    .global abort
    // We put exit code value to the register for first integer return value.
    addi x10, x0, ABORT_EXIT_CODE
    HALT

_exit:
    .global _exit
    // move parameter register to return
    HALT

    // the following section holds program arguments
    // maximal count of arguments is 32
    // strings in arguments may have up to 512 bytes
    .section .progargs, "aw"
//    .align STACK_ALIGN_VAL
    .align STACK_ALIGN_VAL
_codasip_argc_address:
    .global _codasip_argc_address
    .word 0 // contains argv value

_codasip_argv_pointers: // this address represents argv pointer value
    .global _codasip_argv_pointers
    .fill 32, 4, 0  // each word contains a pointer to the _codasip_argv_strings field, last pointer has value NULL

_codasip_argv_strings: // this field contains zero-terminated argv[x] strings
    .global _codasip_argv_strings
    .fill 512, 1, 0

    // auxiliary section to handle taken jumps/returns that could have
    // issued invalid instructions from data sections into the instruction decoder
    .section .text_jump_padding, "ax"
    .word 0
    .word 0
    .word 0


    // needed for C++, see http://wiki.osdev.org/C%2B%2B
    .section .data
    .global __dso_handle
    .weak   __dso_handle
__dso_handle:
    .long    0
