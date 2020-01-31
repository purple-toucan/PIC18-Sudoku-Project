#include p18f87k22.inc

    global  PadSetup, ReadPad
	
;acs0    udata_acs   ; named variables in access ram
;LCD_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
;LCD_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
;LCD_cnt_ms  res 1   ; reserve 1 byte for ms counter
;LCD_tmp	    res 1   ; reserve 1 byte for temporary use
;LCD_counter res 1   ; reserve 1 byte for counting through nessage
;
;	constant    LCD_E=5	; LCD enable bit
;	
    
PMCodeTable code
keypad_codes db 0xFF,0xBE,0x77,0xB7,0xD7,0x7B,0xBB,0xDB,0x7D,0xBD,0xDD,0x7E,0xDE,0xEE,0xED,0xEB,0xE7, ' ','0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
;row and colum codes for keypad: None, 0, 1, ... E, F		
;corrosponding ASCII values
;			
	    
PadLoc	 udata_acs	; reserve data anywhere in access RAM
counter  res 1		; reserve one byte for a counter variable
Temprd	 res 1		; reserve one byte for a counter variable
PadCodes res	0x22	; reserve 34 bytes 
			; 17 bytes of row and colum data 
			; and 17 corrosponding ascii bytes
			

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
	return			    ; Exit subroutine
	
PadSetup
;	; Setting up PORTE
	setf	TRISE			; Tristates on
	banksel PADCFG1
	bsf	PADCFG1, REPU, BANKED   ; set REPU bit of given byte to 1 ;
					; E pull ups on
	clrf	LATE			; clear LATE
	
	; Read code data form PM to RAM
	lfsr	FSR0, PadCodes		; Load FSR0 with address in RAM	
	movlw	upper(keypad_codes)	; address of data in PM
	movwf	TBLPTRU			; load upper bits to TBLPTRU
	movlw	high(keypad_codes)	; address of data in PM
	movwf	TBLPTRH			; load high byte to TBLPTRH
	movlw	low(keypad_codes)	; address of data in PM
	movwf	TBLPTRL			; load low byte to TBLPTRL
	movlw	0x22			; bytes to read
	movwf 	counter			; our counter register
loop 	tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter			; count down to zero
	bra	loop			; keep going until finished
	
	return
	
	
	
ReadPad
	movlw	0x0F		    ; Drive columns low
	movwf	TRISE
	call	bdelay		    ; Wait
	movf	PORTE, W	    ; Read Rows
	movwf	Temprd		    ; Overwrite tmeporary storage
	
	movlw	0xF0		    ; Drive rows low
	movwf	TRISE		
	call	bdelay		    ; Wait
	movf	PORTE, W	    ; Read columns
	addwf	Temprd, F	    ; Combine with row data
	
	movff	Temprd, PORTH
	
	movlw	0x00		    ; Setting counter to zero
	movwf	counter
	
	lfsr	FSR0, PadCodes
	
libloop	movlw	0x10		    
	cpfsgt	counter		    ; If counter is > than 16, no code matches
	bra	Lib1
	movlw	0xFF		    ; Error code and exit
	return
	
Lib1	movf	POSTINC0, W	    ; Load keypad input code to w
	cpfseq	Temprd		    ; Compair to input
	bra	Lib2
	movlw	0x10		    ; Offset by 17 to find ACSII
	movf	PLUSW0, W	    ; Load ASCII to W
	return
	
Lib2	incf	counter		    ; Current position not a match
	bra	libloop
	
	return
;	
	

	
    end


