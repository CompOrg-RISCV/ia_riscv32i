/* Generated linker script from xml */
/* Memory source file is 'default_memory.xml' */
/* Sections source file is 'default_section.xml' */

OUTPUT_FORMAT ("elf32-codasip-le")

/*
MEMORY
 {
	if_fetch_if_ldst (awx) : org = 0x0000000000000000, len = 0x0000000100000000, as = "as_all"
 }
*/

_start = OPTION_BOOT_START;

ENTRY (_start)

__HEAP_SIZE = DEFINED(_HEAP_SIZE) ? _HEAP_SIZE : 0x0;
__SCS_SIZE = DEFINED(_SCS_SIZE) ? _SCS_SIZE : 0x0;
__TEXT_START_ADDR = DEFINED(_TEXT_START_ADDR) ? _TEXT_START_ADDR : OPTION_BOOT_START;
__STACK_SIZE = DEFINED(_STACK_SIZE) ? _STACK_SIZE : 0x4000;

#define ALIGN_VAL 4
#define STACK_ALIGN_VAL 8


MEMORY
{
    if_fetch_if_ldst : org = 0, len = OPTION_MEMORY_SIZE, as = "as_all"
}

SECTIONS
{
  .text __TEXT_START_ADDR : {
    _ftext = .;
    KEEP (*(SORT(.crt*)));
    *(.text);
    *(.text.*);
    *(.gnu.linkonce.t.*);
    *(.text_jump_padding);
    _etext = .;
  } > if_fetch_if_ldst

  .init_location : {
  } > if_fetch_if_ldst
  . = ADDR(.init_location);

  .init ALIGN(4) : {
    KEEP (*(.init));
  } > if_fetch_if_ldst =0

  .fini_location : {
  } > if_fetch_if_ldst
  . = ADDR(.fini_location);

  .fini ALIGN(4) : {
    KEEP (*(.fini));
  } > if_fetch_if_ldst =0

  .ctors_location : {
  } > if_fetch_if_ldst
  . = ADDR(.ctors_location);

  .ctors ALIGN(4) : {
    PROVIDE (__CTOR_LIST__ = .);
    PROVIDE (___CTOR_LIST__ = .);
    KEEP (*(.ctors));
    KEEP (*(SORT(.ctors.*)));
    PROVIDE (__CTOR_END__ = .);
    PROVIDE (___CTOR_END__ = .);
  } > if_fetch_if_ldst

  .dtors_location : {
  } > if_fetch_if_ldst
  . = ADDR(.dtors_location);

  .dtors ALIGN(4) : {
    PROVIDE (__DTOR_LIST__ = .);
    PROVIDE (___DTOR_LIST__ = .);
    KEEP (*(.dtors));
    KEEP (*(SORT(.dtors.*)));
    PROVIDE (__DTOR_END__ = .);
    PROVIDE (___DTOR_END__ = .);
  } > if_fetch_if_ldst

  .eh_frame_location : {
  } > if_fetch_if_ldst
  . = ADDR(.eh_frame_location);

  .eh_frame ALIGN(4) : {
    __eh_frame_start = .;
    KEEP (*(.eh_frame));
    __eh_frame_end = .;
  } > if_fetch_if_ldst

  .eh_frame_hdr_location : {
  } > if_fetch_if_ldst
  . = ADDR(.eh_frame_hdr_location);

  .eh_frame_hdr ALIGN(4) : {
    KEEP (*(.eh_frame_hdr));
  } > if_fetch_if_ldst

  .gcc_except_table_location : {
  } > if_fetch_if_ldst
  . = ADDR(.gcc_except_table_location);

  .gcc_except_table ALIGN(4) : {
  } > if_fetch_if_ldst

  .rodata_location : {
  } > if_fetch_if_ldst
  . = ADDR(.rodata_location);

  .rodata ALIGN(4) : {
    _frodata = .;
    *(.rodata);
    *(.rodata.*);
    *(.gnu.linkonce.r.*);
    _erodata = .;
  } > if_fetch_if_ldst

  .data_location : {
  } > if_fetch_if_ldst
  . = ADDR(.data_location);

  .data ALIGN(4) : {
    _fdata = .;
    *(.data);
    *(.data.*);
    *(.gnu.linkonce.d.*);
    _edata = .;
  } > if_fetch_if_ldst

  .sdata_location : {
  } > if_fetch_if_ldst
  . = ADDR(.sdata_location);

  .sdata ALIGN(4) : {
    *(.sdata);
    *(.sdata.*);
    *(.gnu.linkonce.s.*);
  } > if_fetch_if_ldst

  .sbss_location : {
  } > if_fetch_if_ldst
  . = ADDR(.sbss_location);

  .sbss ALIGN(4) : {
    PROVIDE (__sbss_start = .);
    *(.sbss);
    *(.sbss.*);
    *(.gnu.linkonce.sb.*);
    PROVIDE (__sbss_end = .);
  } > if_fetch_if_ldst

  .bss_location : {
  } > if_fetch_if_ldst
  . = ADDR(.bss_location);

  .bss ALIGN(4) : {
    PROVIDE (__bss_start = .);
    *(.bss);
    *(.bss.*);
    *(.gnu.linkonce.b.*);
    *(COMMON);
    . = ALIGN(4);
    PROVIDE (__bss_end = .);
  } > if_fetch_if_ldst

  .scs_location : {
  } > if_fetch_if_ldst
  . = ADDR(.scs_location);

  .scs ALIGN(8) (NOLOAD) : {
    . += __SCS_SIZE;
  } > if_fetch_if_ldst

  .heap_location : {
  } > if_fetch_if_ldst
  . = ADDR(.heap_location);

  .heap ALIGN(4) (NOLOAD) : {
    _heap = .;
    . += __HEAP_SIZE;
    _heap_end = .;
  } > if_fetch_if_ldst

  .stack_location : {
  } > if_fetch_if_ldst
  . = ADDR(.stack_location);

  .stack ALIGN(8) (NOLOAD) : {
    _stack_end = .;
    . += __STACK_SIZE;
    . = ALIGN(8);
    _stack = .;
  } > if_fetch_if_ldst

  _scs = SIZEOF(.scs) > 0 ? ADDR(.scs) + SIZEOF(.scs) : 0;
  __eh_frame_hdr_start = SIZEOF(.eh_frame_hdr) > 0 ? ADDR(.eh_frame_hdr) : 0;
  __eh_frame_hdr_end = SIZEOF(.eh_frame_hdr) > 0 ? . : 0;
}
