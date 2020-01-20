	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100
	
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
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
	

	movlw	0x00
	movwf	TRISH, ACCESS	    ; PORTH ouput
	movwf	PORTH, ACCESS	    ; PORTH ouput
	
	movlw	0x00
	movwf	TRISJ, ACCESS	    ; PORTJ ouput
	movwf	PORTJ, ACCESS	    ; PORTH ouput

SPI_MasterInit ; Set Clock edge to negative
	bcf	SSP2STAT, CKE
	; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
	movlw	(1<<SSPEN)|(1<<CKP)|(0x02)
	movwf	 SSP2CON1
	; SDO2 output; SCK2 output
	bcf	TRISD, SDO2
	bcf	TRISD, SCK2
	return
	
SPI_MasterTransmit ; Start transmission of data (held in W)
	movwf	 SSP2BUF
	return
	
Wait_Transmit ; Wait for transmission to complete
	btfss	PIR2, SSP2IF
	bra	Wait_Transmit
	bcf	PIR2, SSP2IF ; clear interrupt flag
	return	

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
start
	call	SPI_MasterInit
loop
	movlw	0xFF
	call	SPI_MasterTransmit
	call	Wait_Transmit
	
	bra	loop
	
	goto 	0x0
	end
	