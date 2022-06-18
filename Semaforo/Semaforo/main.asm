.def temp = r16
.def saida = r17 
.def count = r18

.cseg

jmp reset
.org OC1Aaddr
jmp OCI1A_Interrupt

OCI1A_Interrupt:
		push r16
		in r16, SREG
		push r16
	
		subi count, 1

		pop r16
		out SREG, r16
		pop r16
		reti

.equ ClockMHz = 16
.equ DelayMs = 5
Delay:
		ldi r22, byte3(ClockMHz * 1000 * DelayMs / 5)
		ldi r21, high(ClockMHz * 1000 * DelayMs / 5)
		ldi r20, low(ClockMHz * 1000 * DelayMs / 5)

		subi r20, 1
		sbci r21, 0
		sbci r22, 0
		brcc pc-3
			
		ret

reset:

		ldi temp, low(RAMEND)
		out SPL, temp
		ldi temp, high(RAMEND)
		out SPH, temp
	
		ldi temp, 0b11111111
		out DDRD, temp

		#define CLOCK 16.0e6 
		#define DELAY 1 

		.equ PRESCALE = 0b100
		.equ PRESCALE_DIV = 256
		.equ WGM = 0b0100
		.equ TOP = int(0.5 + ((CLOCK/PRESCALE_DIV)*DELAY))
		.if TOP > 65535
		.error "TOP is out of range"
		.endif

		ldi temp, high(TOP)
		sts OCR1AH, temp
		ldi temp, low(TOP)
		sts OCR1AL, temp
		ldi temp, ((WGM&0b11) << WGM10) 
		sts TCCR1A, temp
		ldi temp, ((WGM>> 2) << WGM12)|(PRESCALE << CS10)

		sts TCCR1B, temp 
		lds r16, TIMSK1
		sbr r16, 1 <<OCIE1A
		sts TIMSK1, r16

		sei


	s1:	
		ldi count, 18

		s1_routine:

			cpi count, 0
			breq s2   
			 
			ldi saida, 0b10000001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b01000001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00100001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00010001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00001100
			out PORTD, saida
			rcall Delay

			rjmp s1_routine		
		
	s2:	
		ldi count, 5

		s2_routine:
			cpi count, 0
			breq s3   
			 
			ldi saida, 0b10000001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b01000001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00100001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00010001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00001001
			out PORTD, saida
			rcall Delay

			rjmp s2_routine
	
	s3:	
		ldi count, 20

		s3_routine:
			cpi count, 0
			breq s4   
			 
			ldi saida, 0b10000001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b01000100
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00100100 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00010001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00001001
			out PORTD, saida
			rcall Delay

			rjmp s3_routine
		
	s4:	
		ldi count, 4

		s4_routine:
			cpi count, 0
			breq s5   
			 
			ldi saida, 0b10000001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b01000010
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00100100 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00010001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00001001
			out PORTD, saida
			rcall Delay

			rjmp s4_routine

	s5:	
		ldi count, 53

		s5_routine:
			cpi count, 0
			breq s6   
			 
			ldi saida, 0b10000001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b01000001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00100100 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00010100
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00001001
			out PORTD, saida
			rcall Delay

			rjmp s5_routine
			
	s6:	
		ldi count, 4

		s6_routine:
			cpi count, 0
			breq s7   
			 
			ldi saida, 0b10000001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b01000001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00100010 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00010010
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00001001
			out PORTD, saida
			rcall Delay

			rjmp s6_routine
		
	s7:	
		ldi count, 19

		s7_routine:
			cpi count, 0
			breq s8   
			 
			ldi saida, 0b10000100 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b01000001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00100001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00010001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00001001
			out PORTD, saida
			rcall Delay

			rjmp s7_routine

	aux:
		jmp s1
			
	s8:	
		ldi count, 4

		s8_routine:
			cpi count, 0
			breq aux   
			 
			ldi saida, 0b10000010 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b01000001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00100001 
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00010001
			out PORTD, saida
			rcall Delay

			ldi saida, 0b00001001
			out PORTD, saida
			rcall Delay

			rjmp s8_routine	
