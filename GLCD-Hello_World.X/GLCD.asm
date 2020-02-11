#include p18f87k22.inc

	global	GLCD_Setup, Test_Write

acs0    udata_acs   ; named variables in access ram
delay_count res 1   ; reserve 1 byte for Delays
test_counter res 1

	; GLCD Control Pins - PORTB
	constant    GLCD_CS1 = 0 ; Notted - select left side
    	constant    GLCD_CS2 = 1 ; Notted - select right side
	constant    GLCD_RS  = 2 ; H - Data / L - Instruction
    	constant    GLCD_RW  = 3 ; H - Read / L - Write
	constant    GLCD_E   = 4 ; Enable Pulse
    	constant    GLCD_RST = 5 ; Reset Pin

GLCD	code
    
GLCD_Setup
	clrf	TRISD		; Clear PORTD and PORTB, set as outputs
	clrf	TRISB
	clrf	PORTD
	clrf	PORTB
	
	bsf	PORTB, GLCD_CS1 ; Deselect Both Sides
	bsf	PORTB, GLCD_CS2
	bsf	PORTB, GLCD_RST
	
	movlw	0x4		; 500ns Delay
	call	W_Delay
	
	bcf	PORTB, GLCD_CS1 ; Select Both Sides
	bcf	PORTB, GLCD_CS2
	bcf	PORTB, GLCD_RS	; Instruction
	bcf	PORTB, GLCD_RW  ; Write
	
	movlw	0x3F		
	movwf	PORTD		; Turn On Comand
	call	E_pulse		; Enable Pulse
	
	call	Reset_Cursor
	return
	
Test_Write			; Write 1 to 64 as Binary to GLCD 
	movlw	0x01
	movwf	test_counter	   
	movlw	0x40		; 64
twlp	movff	test_counter, PORTD
	call	Send_Data_Byte	; Send Counter as Data
	incf	test_counter
	cpfsgt	test_counter	; Skip if counter > 64
	bra	twlp		 
	return
	
Reset_Cursor
	bcf	PORTB, GLCD_CS1	; Select Left Side
	bsf	PORTB, GLCD_CS2	; Deselect Right Side
	
	movlw	b'01000000'	; Y -> 0
	call	Send_Instr_Byte
	movlw	b'10111000'	; X -> 0
	call	Send_Instr_Byte
	movlw	b'11000000'	; Z -> 0
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
	movlw	0x4
	call	W_Delay		; 500ns Delay
	bsf	PORTB, GLCD_E	; Enable Pin High
	call	W_Delay		; 500ns Delay
	bcf	PORTB, GLCD_E   ; Enable Pin Low
	call	W_Delay          ; 500ns Delay
	return
	

W_Delay	
	movwf	delay_count	; Delay 125ns times W
wdlp	decfsz	delay_count	; decrement until zero
	bra	wdlp
	return
	
    end


