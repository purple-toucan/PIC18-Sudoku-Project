#include p18f87k22.inc

	global	GLCD_Setup, Test_Write

acs0    udata_acs   ; named variables in access ram
delay_count res 1   ; reserve 1 byte for Delays
test_col_count res 1
test_row_count res 1

	; GLCD Control Pins - PORTB
	constant    GLCD_CS1 = 0 ; Notted - select left side
    	constant    GLCD_CS2 = 1 ; Notted - select right side
	constant    GLCD_RS  = 2 ; H - Data / L - Instruction
    	constant    GLCD_RW  = 3 ; H - Read / L - Write
	constant    GLCD_E   = 4 ; Enable Pulse
    	constant    GLCD_RST = 5 ; Reset Pin
	
	; Instruction Protocols for Changing Position
	constant    X_Instr = b'10111000'
	constant    Y_Instr = b'01000000'
	constant    Z_Instr = b'11000000'

GLCD	code
    
GLCD_Setup
	clrf	TRISD		; Clear PORTD and PORTB, set as outputs
	clrf	TRISB
	clrf	PORTD
	clrf	PORTB
	
	;ON Commands
	
	bcf	PORTB, GLCD_CS1 ; Select Left Sides
	bsf	PORTB, GLCD_CS2
	
	movlw	0x3F		
	call	Send_Instr_Byte	; Turn on Command

;	bsf	PORTB, GLCD_CS1 ; Select Right Side
;	bcf	PORTB, GLCD_CS2 
	
	movlw	0x3F		
	call	Send_Instr_Byte ; Turn on Command
	
	;Reset Commands
	
	bcf	PORTB, GLCD_CS1 ; Select Left Side
	bsf	PORTB, GLCD_CS2 
	movlw	0xA
	call	W_Delay		; 1.125us Delay
	
;	bsf	PORTB, GLCD_CS1 ; Select Right Side
;	bcf	PORTB, GLCD_CS2 
;	movlw	0xA
;	call	W_Delay		; 1.125us Delay
	
;	bsf	PORTB, GLCD_CS1 ; Deselect Both Sides
	bsf	PORTB, GLCD_CS2
	bsf	PORTB, GLCD_RST	; End Reset
	
	movlw	0xA
	call	W_Delay		; 1.125us Delay
	
	movlw	b'11000000'	; Z -> 0
	call	Send_Instr_Byte
	
	return
	
Test_Write			; Write 1 to 64 as Binary to GLCD 
;	call	Reset_Cursor
	
	clrf	test_row_count	; Counter Initially 0
twtp	
	movlw	Y_Instr		; Y -> 0
	call	Send_Instr_Byte
	
	movlw	X_Instr		; Format Row Count as Row Command
	iorwf	test_row_count, w
	call	Send_Instr_Byte
	NOP
	call	Row_Pattern

	incf	test_row_count, f
	movlw	0x7
	cpfseq	test_row_count	; Skip if counter = 7
	bra	twtp	
	return
	
Row_Pattern
	movlw	0x01
	movwf	test_col_count	  
rplp	movf	test_col_count, w
	call	Send_Data_Byte	; Send Counter as Data
	incf	test_col_count, f
	movlw	0x40
	cpfsgt	test_col_count	; Skip if counter > 64
	bra	rplp		 
	return
	
Reset_Cursor
;	bcf	PORTB, GLCD_CS1	; Select Left Side
;	bsf	PORTB, GLCD_CS2	; Deselect Right Side
	
	movlw	b'01000000'	; Y -> 0
	call	Send_Instr_Byte
	movlw	b'10111000'	; X -> 0
	call	Send_Instr_Byte
	
	return

Send_Data_Byte
	bsf	PORTB, GLCD_RS	; Data
	bcf	PORTB, GLCD_RW	; Write
	movwf	PORTD
	call	E_pulse
	return

Send_Instr_Byte
	bcf	PORTB, GLCD_RS	; Instruction
	bcf	PORTB, GLCD_RW	; Write
	movwf	PORTD
	call	E_pulse
	return
	
E_pulse
	movlw	0xA
	call	W_Delay		; 1.125us Delay
	bsf	PORTB, GLCD_E	; Enable Pin High
	call	W_Delay		; 1.125us Delay
	bcf	PORTB, GLCD_E   ; Enable Pin Low
	call	W_Delay         ; 1.125us Delay
	return
	

W_Delay	
	movwf	delay_count	; Delay 125ns times W
wdlp	decfsz	delay_count	; decrement until zero
	bra	wdlp
	return
	
    end


