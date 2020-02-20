#include p18f87k22.inc

    global  PadSetup, Give_Input
	

PMCodeTable code
;keypad_codes db 0xFF,0xBE,0x77,0xB7,0xD7,0x7B,0xBB,0xDB,0x7D,0xBD,0xDD,0x7E,0xDE,0xEE,0xED,0xEB,0xE7, ' ','0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
keypad_codes db 0x77,0xB7,0xD7,0x7B,0xBB,0xDB,0x7D,0xBD,0xDD, 0xE7,0xDE,0xED,0x7E, 0xEE, 0xAA
desired_outputs db .1,.2,.3,.4,.5,.6,.7,.8,.9,0x41,0x42,0x43,0x44,0x00,0xFE
	constant keypad_bytes = .15
	constant output_bytes = .15
			
	    
PadLoc	 udata_acs	; reserve data anywhere in access RAM
counter  res 1		; reserve one byte for a counter variable
Temprd	 res 1		; reserve one byte for a counter variable
delay_count res 1
previous_input	res 1	; Key pad code of pervious input

			
Tables	udata	0x700    ; reserve data anywhere in RAM (here at 0x400)
PadCodes res	keypad_bytes + output_bytes
	
main	code
	
Delay	
	movlw	b'00010000'	;   3.4 us Delay
	movwf	delay_count
dllp1	decfsz	delay_count
	bra	dllp1
	
	return
	
PadSetup
;	; Setting up PORTE
	setf	TRISE			; Tristates on
	banksel PADCFG1
	bsf	PADCFG1, REPU, BANKED   ; set REPU bit of given byte to 1 ;
					; E pull ups on
	clrf	LATE			; clear LATE
	
	clrf	TRISC
	    
	clrf	previous_input		; clear previous input
	
	; Read code data form PM to RAM
	lfsr	FSR0, PadCodes		; Load FSR0 with address in RAM	
	
	movlw	upper(keypad_codes)	; address of data in PM
	movwf	TBLPTRU			; load upper bits to TBLPTRU
	movlw	high(keypad_codes)	; address of data in PM
	movwf	TBLPTRH			; load high byte to TBLPTRH
	movlw	low(keypad_codes)	; address of data in PM
	movwf	TBLPTRL			; load low byte to TBLPTRL
	movlw	keypad_bytes		; bytes to read
	movwf 	counter			; our counter register
rdlp1 	tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter			; count down to zero
	bra	rdlp1			; keep going until finished
	
	movlw	upper(desired_outputs)	; address of data in PM
	movwf	TBLPTRU			; load upper bits to TBLPTRU
	movlw	high(desired_outputs)	; address of data in PM
	movwf	TBLPTRH			; load high byte to TBLPTRH
	movlw	low(desired_outputs)	; address of data in PM
	movwf	TBLPTRL			; load low byte to TBLPTRL
	movlw	output_bytes		; bytes to read
	movwf 	counter			; our counter register
rdlp2 	tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter			; count down to zero
	bra	rdlp2			; keep going until finished
	
	
	return
	
Give_Input
	movlw	0x0F		    ; Drive columns low
	movwf	TRISE
	call	Delay		    ; Wait
	movf	PORTE, W	    ; Read Rows
	movwf	Temprd		    ; Overwrite tmeporary storage
	
	movlw	0xF0		    ; Drive rows low
	movwf	TRISE		
	call	Delay		    ; Wait
	movf	PORTE, W	    ; Read columns
	addwf	Temprd, F	    ; Combine with row data to give keypad code
	
	movff	Temprd,	PORTC
	movlw	0xFF
	cpfseq	Temprd
	bra	pass_nothing	    
				    ; Nothing is being pressed
	clrf	previous_input	    ; Clear previous input
	bra	no_action	    ; Take no action
	
pass_nothing	; Something has been pressed
	
	movf	Temprd, w
	cpfseq	previous_input
	bra	pass_repeat
	bra	no_action	    ; Button press is a repeat
	
pass_repeat	; Button Press is not a repeat
	
	movff	Temprd, previous_input	;overwrite previous input
	
	lfsr	FSR0, PadCodes
	
	movlw	keypad_bytes
	movwf	counter
libloop	
	movf	POSTINC0, W	    ; Load keypad input code to w
	cpfseq	Temprd		    ; Compair to input
	bra	pass_compare
	
	movlw	keypad_bytes -1     ; Offset by 0utput code
	movf	PLUSW0, W	    ; Load ASCII to W
	return
	
pass_compare
	
	decfsz	counter
	bra	libloop
	bra	no_action	    ; no match found
	
no_action
	retlw	0xFF		    ; return with statement of no input on W
	
	
;ReadPad
;	movlw	0x0F		    ; Drive columns low
;	movwf	TRISE
;	call	Delay		    ; Wait
;	movf	PORTE, W	    ; Read Rows
;	movwf	Temprd		    ; Overwrite tmeporary storage
;	
;	movlw	0xF0		    ; Drive rows low
;	movwf	TRISE		
;	call	Delay		    ; Wait
;	movf	PORTE, W	    ; Read columns
;	addwf	Temprd, F	    ; Combine with row data
;	
;	movff	Temprd, PORTH
;	
;	movlw	0x00		    ; Setting counter to zero
;	movwf	counter
;	
;	lfsr	FSR0, PadCodes
;	
;libloop	movlw	0x10		    
;	cpfsgt	counter		    ; If counter is > than 16, no code matches
;	bra	Lib1
;	movlw	0xFF		    ; Error code and exit
;	return
;	
;Lib1	movf	POSTINC0, W	    ; Load keypad input code to w
;	cpfseq	Temprd		    ; Compair to input
;	bra	Lib2
;	movlw	0x10		    ; Offset by 17 to find ACSII
;	movf	PLUSW0, W	    ; Load ASCII to W
;	return
;	
;Lib2	incf	counter		    ; Current position not a match
;	bra	libloop
;	
;	return
	

	
    end


