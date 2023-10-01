; toggle.asm
; 	turns on/off an LED which is connected to PD7 based on timer1 compare match
;   interrupt.
;
; flash with: avrdude -p atmega328p -c arduino -P /dev/ttyACM0 -U flash:w:toggle.hex:i

.include "m328Pdef.inc"

.equ COUNT, 0x85ee

.text
	jmp	reset
.org OC1Aaddr
	jmp	timer1_compA                      ; Timer1 compare match A

reset:
	ldi r16, hi8(RAMEND)                  ; Set stack pointer to top of RAM.
	out SPH, r16
	ldi r16, lo8(RAMEND)
	out SPL, r16

	ldi r16, 1 << PD7                     ; Setup port D, pin 7 as an output.
	out DDRD, r16
	out PORTD, r16

	ldi r16, (1 << WGM12) | (1 << CS12)   ; CTC mode, prescaler = 256.
	sts TCCR1B, r16

	clr r16                               ; Normal port operation. OC1A/OC1B disconnected.
	sts TCCR1A, r16

	ldi r16, hi8(COUNT)                   ; Compare match value.
	sts OCR1AH, r16
	ldi r16, lo8(COUNT)
	sts OCR1AL, r16

	ldi r16, 1 << OCIE1A                  ; Enable timer compare interrupt.                 
	sts TIMSK1, r16

	;clr r16                               ; Initialize timer value.
	;sts TCNT1H, r16
	;sts TCNT1L, r16

	sei                                   ; Enable global interrupts.

loop:
	rjmp loop

timer1_compA:
	push r16
	in r16, SREG
	push r16

	ldi r16, 1 << PD7
	out PIND, r16

	clr r16
	sts TCNT1H, r16
	sts TCNT1L, r16

	pop r16
	out SREG, r16
	pop r16
	reti

