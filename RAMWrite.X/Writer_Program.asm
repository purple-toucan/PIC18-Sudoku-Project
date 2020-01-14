	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100
	
start	
	movlb	0x2		    ; Set to RAM Bank 2
	movlw	0x09
	movwf	0xA0, 1		    ; Set highest value to write
	lfsr	FSR0, 0x2C0	    ; Load FSR0 with RAM adress
	movlw	0x00		    ; Initilise W
	
loop	
	movwf	POSTINC0	    ; Write W onto pointer location of FSR0 
	cpfsgt	0xA0, 1		    ; Skip next if W < highest value to write
	goto 	0x0		    ; Re-run program from start
	addlw	0x01		    ; Increase W by 1
	bra	loop
	
	end
