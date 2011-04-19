OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_entry)

MEMORY
{
	FLASH (rx) : ORIGIN = 0x00100000, LENGTH = 256K
	RAM (rwx) : ORIGIN = 0x00200000, LENGTH = 64K
}

C_STACK_SIZE = 512;	

__stack_end__ = 0x00200000 + 64K - 4;

SECTIONS

{
 .reset : { 			/*Ze bootup code*/
	*(.text)
      	. = ALIGN(0x4);
      	} >FLASH

 .stack : {			/*Arranging stacks in what is expected to be decreasing order of size*/
 	__ram_start__ = .;
	. += C_STACK_SIZE;
	. = ALIGN(0x4);
	__c_stack_top__ = .;

 	} >RAM AT>RAM		/*redundant looking AT>RAM is required due to a code sourcery bug*/

 _end = .;
}
