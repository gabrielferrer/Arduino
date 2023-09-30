# Makefile

AS=avr-as
LD=avr-ld
CPY=avr-objcopy
ASFLAGS=-mmcu=atmega328p -g
LDFLAGS=-Tdata 0x800100

all: $(FILE).o
	$(LD) $(LDFLAGS) -o $(FILE).elf $(FILE).o
	$(CPY) -j .text -j .data -O ihex $(FILE).elf $(FILE).hex

%.o: %.s
	$(AS) $(ASFLAGS) -c $< -o $@
 
clean:
	rm -vf $(FILE).elf $(FILE).hex *.o

