#_____________________________________________________________________________________________
# Copyright 2011 Nishchay Mhatre
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
#_____________________________________________________________________________________________ 
#Makefile for SST Integrated  build on ARM7-TDMI based AT91SAM 7X256
#_____________________________________________________________________________________________ 

# Toolchain definition
TC=arm-none-eabi

# Toolchain depedent GNU build sofware
COMPILE=arm-none-eabi-gcc
LOAD=$(TC)-ld
ASSEMBLE=$(TC)-as
DEBUG=$(TC)-gdb
PROFILE=$(TC)-prof
OBJCOPY=$(TC)-objcopy

#Linker script
LDSCRIPT=sst.ld

# Target Machine Specifications
CPU=arm7tdmi
ARCH=armv4t

# Build directories

BLDDIR= .

# Compiler options

DBG=-g
PROF=-pg
OPTIM=-mlow-irq-latency

CFLAGS=	$(DBG)\
	-mcpu=$(CPU) \
	-marm \
	-mabi=aapcs \
	-fomit-frame-pointer\
	-T $(LDSCRIPT)

#Linker flags
LIBS=-Wl,--start-group -lgcc -Wl,--end-group 
LINKER_FLAGS=-nostartfiles -Xlinker -osst.elf -Xlinker -M -Xlinker -Map=sst.map
	
#Asm flags
ASFLAGS=-g -gdwarf2 -mcpu=arm7tdmi #-mthumb-interwork -mapcs-frame

ARM_SOURCE= ./main.c

ARM_OBJS = $(ARM_SOURCE:.c=.o)

NAME=sst

all: $(NAME).bin

$(NAME).bin : sst.elf
	$(OBJCOPY) sst.elf -O binary $(NAME).bin

sst.elf : $(ARM_OBJS) boot.o  Makefile
	$(COMPILE) $(CFLAGS) $(LINKER_FLAGS) $(ARM_OBJS) boot.o

boot.o : ./boot.s
	$(ASSEMBLE) $(ASFLAGS) -o boot.o ./boot.s

$(ARM_OBJS) : %.o : %.c Makefile 
	$(COMPILE) $(CFLAGS) -c $< -o $@ 

clean :
	rm $(ARM_OBJS)
	rm boot.o
	touch Makefile
	rm sst.elf
	
