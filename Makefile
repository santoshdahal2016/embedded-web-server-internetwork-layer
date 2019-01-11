# makefile, written by guido socher
MCU=atmega32
DUDECPUTYPE=m32
#MCU=atmega88
#DUDECPUTYPE=m88
#MCU=atmega328p
#DUDECPUTYPE=m328
#
LOADCMD=avrdude
LOADARG=-c usbasp -p m32 -P /db/ty.usbmodemfd121 -U flash:w:
#
#
CC=avr-gcc
OBJCOPY=avr-objcopy
# optimize for size:
CFLAGS=-g -mmcu=$(MCU) -Wall -Wstrict-prototypes -Os -mcall-prologues
#-------------------
.PHONY:  all
#
all:  program.hex
	@echo "done"
#-------------------
help: 
	@echo "Usage: make all|load"
	@echo "or"
	@echo "Usage: make clean"
	@echo " "
	@echo "For new hardware with clock from enc38j60 (all new boards): make fuse"
#-------------------
program.hex : program.out 
	$(OBJCOPY) -R .eeprom -O ihex program.out program.hex 
	avr-size program.out
	@echo " "
	@echo "Expl.: data=initialized data, bss=uninitialized data, text=code"
	@echo " "

program.out : main.o ip_arp.o enc28j60.o 
	$(CC) $(CFLAGS) -o program.out -Wl,-Map,program.map main.o ip_arp.o enc28j60.o 
enc28j60.o : enc28j60.c avr_compat.h enc28j60.h
	$(CC) $(CFLAGS) -Os -c enc28j60.c
ip_arp.o : ip_arp.c avr_compat.h net.h enc28j60.h
	$(CC) $(CFLAGS) -Os -c ip_arp.c
main.o : main.c ip_arp.h avr_compat.h enc28j60.h  net.h
	$(CC) $(CFLAGS) -Os -c main.c

#------------------
load: program.hex
	$(LOADCMD) $(LOADARG)program.hex
#
#-------------------
# Check this with make rdfuses
rdfuses:
	avrdude -p $(DUDECPUTYPE) -c stk500v2 -v -q
#
fuse:
	@echo "warning: run this command only if you have an external clock on xtal1"
	@echo "The is the last chance to stop. Press crtl-C to abort"
	@sleep 2
	avrdude -p  $(DUDECPUTYPE) -c stk500v2 -u -v -U lfuse:w:0x60:m
#-------------------
clean:
	rm -f *.o *.map *.out test*.hex program.hex
#-------------------
