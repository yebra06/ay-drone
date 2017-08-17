# Programmer: Alfredo Yebra Jr.
# Date: Wednesday August 16, 2017
# Description: Makefile for compiling software for arduino nano.

# -------------------- Target --------------------
TARGET 		= aydrone

# -------------------- Source files --------------------
CSRCS 		= $(wildcard *.c)

# -------------------- Object files --------------------
OBJS 			= $(CSRCS:.c=.o)
OBJCOPY 	= avr-objcopy
OBJDUMP 	= avr-objdump

# -------------------- Arduino Nano Settings --------------------
# Notes: Make sure that you moved the arduino app into your Applications.
ARDUINO 	= /Applications/Arduino.app/Contents/Java/hardware
F_CPU 		= 16000000UL
MCU			= atmega328p
BAUD		= 57600
# PORT 		= /dev/usbmodem3116251
PORT 		= /dev/cu.usbserial-A5047M09

# -------------------- AVR --------------------
# Note: To see full list of programmers enter the following in terminal:
# 	avrdude -c ?
# FLAGS:
# 	-p: microcontroller
# 	-P: Port
# 	-b: Baud rate
# 	-c: Programmer
# 	-D: Disable erase cycle
AVR_TOOLS 			= $(ARDUINO)/tools/avr/bin
AVRDUDE 			= $(AVR_TOOLS)/avrdude
AVRDUDE_PROGRAMMER 	= arduino
AVRDUDE_FLAGS		= -v -v -p $(MCU) -P $(PORT) -b $(BAUD) -c $(AVRDUDE_PROGRAMMER) -D
AVRDUDE_CONF		= -C "$(ARDUINO)/tools/avr/etc/avrdude.conf"

# -------------------- Libs --------------------
INCLUDES 	= -I "$(ARDUINO)/arduino/avr/avr/variants/standard"
INCLUDES	+= -I "$(ARDUINO)/tools/avr/avr/include/avr"

# -------------------- Compiler --------------------
GCC			= avr-gcc
OPTIMIZE 	= -Os
CFLAGS 		= -mmcu=$(MCU) $(OPTIMIZE) -DF_CPU=$(F_CPU) $(INCLUDES)

# -------------------- Linker --------------------
LFLAGS = $(AVRDUDE_FLAGS)

# -------------------- Recipes --------------------
all: 	$(TARGET).hex
	$(AVRDUDE) $(AVRDUDE_CONF) $(LFLAGS) -U flash:w:$(TARGET).hex:i
%.hex:	%.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@
%.elf:	$(OBJS)
	$(GCC) -w -Os -mmcu=$(MCU) -o $@ $^ -lm
%.o:	%.c
	$(GCC) -c $(CFLAGS) $< -o $@
%.lst:	%.elf
	$(OBJDUMP) -d $< > $@
clean:
	rm -rf $(TARGET).hex $(TARGET).elf *.o
