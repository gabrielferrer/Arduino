; beacon.asm
; 	turns on/off an LED which is connected to PD7 based on timer1 overflow interrupt.
;
; flash with: avrdude -p atmega328p -c arduino -P /dev/ttyACM0 -U flash:w:beacon.hex:i

.include "m328Pdef.inc"

.equ COUNT, 0x85ee                     ; 16Mhz / 256 (prescaler) = 62.5Khz
                                       ; 1 / 62.5Khz = 16 us (tick duration)
                                       ; 500 ms / 16 us = 31250 ticks
                                       ; 65536 - 31250 = 34286 (0x85ee) starting
                                       ; counter value to have required ticks.

.text
	jmp reset                          ; Reset Handler
.org OVF1addr
	jmp timer1_overflow                ; Timer1 Overflow Handler

.org Start
reset:
	ldi r16, hi8(RAMEND)               ; Set stack pointer to top of RAM.
	out SPH, r16
	ldi r16, lo8(RAMEND)
	out SPL, r16

	ldi r16, 1 << PD7                  ; Setup port D, pin 7 as an output.
	out DDRD, r16
	out PORTD, r16

	ldi r16, 1 << CS12                 ; Prescaler = 256
	sts TCCR1B,	r16

	ldi r16, hi8(COUNT)                ; Set counter.
	sts TCNT1H, r16
	ldi r16, lo8(COUNT)
	sts TCNT1L, r16

	ldi r16, 1 << TOIE1                ; Enable interrupts for timer1 overflow.
	sts TIMSK1, r16

	sei                                ; Enable global interrupts.

loop:
	sleep
	rjmp loop

timer1_overflow:
	push r16
	in r16, SREG
	push r16

	ldi r16, hi8(COUNT)
	sts TCNT1H, r16
	ldi r16, lo8(COUNT)
	sts TCNT1L, r16

	ldi r16, (1 << PD7)
	out PIND, r16

	pop r16
	out SREG, r16
	pop r16
	reti

