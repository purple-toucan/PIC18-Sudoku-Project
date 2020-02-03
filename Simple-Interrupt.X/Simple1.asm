	#include p18f87k22.inc

	extern	DAC_Setup
	
rst	code	0x0000	; reset vector
	goto	start

main	code
	
bdelay
	movlw	high(0xDEAD)	    ; Load 16 bit number across 2 FRs
	movwf	0x50, ACCESS	    
	movlw	low(0xDEAD)
	movwf	0x51, ACCESS		    
	movlw	0x00		    ; Set W = 0
bdlp	decf	0x51,f		    ; Decrease least significant byte by 1
	subwfb	0x50,f		    ; Subtract W and borrow bit
 	bc	bdlp		    ; If carry then branch - Borrow = NOT Carry
	return	
	
start	call	DAC_Setup
	
	clrf	TRISJ
	setf	LATJ		; WR* High
	setf	TRISD
	
loop	
	call	bdelay
	clrf	LATJ		; Set WR* low
	call	bdelay
	setf	LATJ
;	goto	$		; Sit in infinite loop
	bra	loop

	end
