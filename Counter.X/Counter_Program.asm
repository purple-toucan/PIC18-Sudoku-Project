	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

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
	incf 	0x06, F, ACCESS	    ; Incriment counter and place back in F
	movf	PORTD, W	    ; Read Port D to W
	movwf   PORTE, ACCESS	    ; Port E mirrors D
	cpfsgt 	0x06, ACCESS	    ; Skip next line if F is greater than W
	bra 	loop		    ; If not skipped, branch back to loop start
	goto 	0x0		    ; Re-run program from start
	
	end
