	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

bdelay
	movlw	high(0xDEAD)	    ; Load 16 bit number across 2 FRs
	movwf	0x10, ACCESS	    
	movlw	low(0xDEAD)
	movwf	0x11, ACCESS		    
	movlw	0x00		    ; Set W = 0
bdlp	decf	0x11,f		    ; Decrease least significant byte by 1
	subwfb	0x10,f		    ; Subtract W and borrow bit
	bc	bdlp		    ; If carry then branch - Borrow = NOT Carry
	return			    ; Exit subroutine
	
start	;HARDWARE SETUP
	movlw 	0xFF
	movwf	TRISD, ACCESS	    ; Port D all inputs
	movlw 	0x0
	movwf	TRISC, ACCESS	    ; Port C all outputs
	movwf	TRISE, ACCESS	    ; Port E all outputs
	movwf	0x06, ACCESS	    ; Set counter to zero
	bra 	loop
	
loop	;COUNTING LOOP
	movff 	0x06, PORTC	    ; Set Port C value
	call	bdelay
	incf 	0x06, F, ACCESS	    ; Incriment counter and place back in F
	movf	PORTD, W	    ; Read Port D to W
	movwf   PORTE, ACCESS	    ; Port E mirrors D
	cpfsgt 	0x06, ACCESS	    ; Skip next line if F is greater than W
	bra 	loop		    ; If not skipped, branch back to loop start
	goto 	0x0		    ; Re-run program from start
	
	end
