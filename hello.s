; hello.asm
; 	turns on an LED which is connected to PB5 (digital out 13)
;
; flash with: avrdude -p atmega328p -c arduino -P /dev/ttyACM0 -U flash:w:hello.hex:i

.include "m328Pdef.inc"

.text
	ldi r16, 1 << PB5
	out DDRB, r16
	out PORTB, r16
start:
	rjmp start

