	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

bdelay
	movlw	high(0xFFFF)	    ; Load 16 bit number across 2 FRs
	movwf	0x10, ACCESS	    
	movlw	low(0xFFFF)
	movwf	0x11, ACCESS		    
	movlw	0x00		    ; Set W = 0
bdlp	decf	0x11,f		    ; Decrease least significant byte by 1
	subwfb	0x10,f		    ; Subtract W and borrow bit
	bc	bdlp		    ; If carry then branch - Borrow = NOT Carry
	return			    ; Exit subroutine
	
clock1
	call	bdelay		    ; Setup time
	movlw	0xD		    ; Clock 1 up, outputs off
	movwf	PORTD
	call	bdelay		    ; Hold
	movlw	0x5
	movwf	PORTD		    ; Clock 1 down, outputs off
	return	
	
clock2
	call	bdelay		    ; Setup time
	movlw	0x7		    ; Clock 2 up, outputs off
	movwf	PORTD
	call	bdelay		    ; Hold
	movlw	0x5
	movwf	PORTD		    ; Clock 2 down, outputs off
	return	
	
write
	movwf	0x13		    ; Temp storage
	movlw	0x5	    
	movwf	PORTD		    ; Set chip outputs off
	movlw	0x00		    
	movwf	TRISE, ACCESS	    ; Set TRISE to output
	movf	0x13, W
	movwf	PORTE		    ; Ouput initial W
	return	
	
read1
	movlw	0xFF		    
	movwf	TRISE, ACCESS	    ; Set TRISE to input
	movlw	0x1
	movwf	PORTD		    ; Output enable chip 1
	call	bdelay
	movf	PORTE, W	    ; Load E to W
	movwf	0x12, ACCESS	    ; Temp data storage
	movlw	0x5	    
	movwf	PORTD		    ; Output disable chip 1
	movf	0x12, ACCESS, W	    ; Load E Output back onto W
	
	return	
	
read2
	movlw	0xFF		    
	movwf	TRISE, ACCESS	    ; Set TRISE to input
	movlw	0x4   
	movwf	PORTD		    ; Output enable chip 2
	call	bdelay
	movf	PORTE, W	    ; Load E to W
	movwf	0x12, ACCESS	    ; Temp data storage
	movlw	0x5	    
	movwf	PORTD		    ; Output disable chip 2
	movf	0x12, ACCESS, W	    ; Load E Output back onto W
	
	return	
	
	
start	;HARDWARE SETUP
	movlw	0x00
	movwf	TRISD, ACCESS	    ; PORTD ouput
	movlw	0x5
	movwf	PORTD, ACCESS	    ; Set OE high (disable chip output)
	movlw	0xFF		    
	movwf	TRISE, ACCESS	    ; Set TRISE to input

	movlw	0x00
	movwf	TRISH, ACCESS	    ; PORTH ouput
	movwf	PORTH, ACCESS	    ; PORTH ouput
	
	movlw	0x00
	movwf	TRISJ, ACCESS	    ; PORTJ ouput
	movwf	PORTJ, ACCESS	    ; PORTH ouput

    loop
    
	movlw	0x10
	call	write
	call	bdelay
	call	clock1		    ; Write onto chip 1
	call	bdelay
	
	movlw	0x00		    ; Clear W
	
	movlw	0xFF
	call	write
	call	bdelay
	call	clock2		    ; Write onto chip 2
	call	bdelay
	
	movlw	0x00		    ; Clear W

	call	read1		    ; Read Chip 1 
	movwf	PORTH		    ; Write Chip 1 to H
	call	bdelay
	
	movlw	0x00		    ; Clear W

	call	read2		    ; Read Chip 2
	movwf	PORTJ		    ; Write Chip 2 to J
	call	bdelay
	
	bra	loop
	
	goto 	0x0
	end
	