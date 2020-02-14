#include p18f87k22.inc

    global GLCD_Setup, Test_Write
    global Test_Write_2, Clear_Board
    
acs0	    udata_acs   ; reserve data space in access ram
delay_count     res 1	; reserve one byte for counter in the delay 
test_col_count	res 1
test_row_count	res 1
	
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
	    

glcd	code
 
GLCD_Setup
			
	clrf	TRISB		; Set PORT B and D Out
	clrf	TRISD
	
	clrf	PORTD		; Reset PORT B and D 
	clrf	PORTB

	bsf	PORTB, GLCD_RST	; Disable Resey
	bsf	PORTB, GLCD_CS2	; Select Right Side
	bcf	PORTB, GLCD_CS1	; Deselect Left Side
	call	Delay
	
	movlw	0x3F		; Turn On Instruction
	call	Send_Instr
	
	call	Clear_Board  
	return
	
Clear_Board ; Clear Every Cell on Current Side of Board
	clrf	test_row_count	; Row Counter = 0
	
rclrlp	    ; Iterate Over Rows
	movlw	X_Instr		; Format Row Count as Row Command
	iorwf	test_row_count, w
	call	Send_Instr	; Change Row
	
	clrf	test_col_count	; Col Counter = 0
cclrlp	    ; Iterate Over Cols, Nested inside Row Iteration
	movlw	0x00
	call	Send_Data	; Clear Col
	incf	test_col_count, f
	movlw	0x40
	cpfsgt	test_col_count	; Skip if counter > 64
	bra	cclrlp	
	
	incf	test_row_count, f
	movlw	0x8
	cpfseq	test_row_count	; Skip if counter = 8
	bra	rclrlp	
	
	return
	
Test_Write			; Write Two Numbers to Board
	
	call	Reset_Cursor
	
	movlw	0x00
	call	Send_Data
	movlw	b'00111110'
	call	Send_Data
	movlw	b'00101010'
	call	Send_Data
	movlw	b'00101010'
	call	Send_Data
	movlw	b'00101010'
	call	Send_Data
	movlw	b'00111010'
	call	Send_Data
	
	movlw	0x00
	call	Send_Data
	movlw	b'00101110'
	call	Send_Data
	movlw	b'00101010'
	call	Send_Data
	movlw	b'00101010'
	call	Send_Data
	movlw	b'00101010'
	call	Send_Data
	movlw	b'00111110'
	call	Send_Data
	
	movlw	0x00
	call	Send_Data
	
	return
	
Test_Write_2	; Write a Pattern to Every Row on Current Side
	
	clrf	test_row_count	; Counter Initially 0
twtp	
	movlw	Y_Instr		; Reset Y
	call	Send_Instr
	
	movlw	X_Instr		; Format Row Count as Row Command
	iorwf	test_row_count, w
	call	Send_Instr
	
	movlw	0x01
	movwf	test_col_count	  
rplp	movf	test_col_count, w
	call	Send_Data	; Send Counter as Data
	incf	test_col_count, f
	movlw	0x40
	cpfsgt	test_col_count	; Skip if counter > 64
	bra	rplp		 

	incf	test_row_count, f
	movlw	0x8
	cpfseq	test_row_count	; Skip if counter = 8
	bra	twtp	
	return
	
	
Reset_Cursor
	movlw	b'10111000'
	call	Send_Instr
	movlw	b'01000000'
	call	Send_Instr
	
	return

Send_Data			; Send WREG as Data
	movwf	PORTD
	bsf	LATB, GLCD_RS   ; Data
	bcf	LATB, GLCD_RW  	; Write
	call	E_Pulse		; Enable Pulse
	return

Send_Instr			; Send WREG as Instruction
	movwf	PORTD		
	bcf	LATB, GLCD_RS	; Instruction
	bcf	LATB, GLCD_RW  	; Write
	call	E_Pulse		; Enable Pulse
	return

E_Pulse
	bsf	LATB, GLCD_E   	; Enable Pin High
	call	Delay
	bcf	LATB, GLCD_E    ; Enable Pin Low
	call	Delay
	return
	
Delay	
	movlw	0xFF		;   32us Delay
	movwf	delay_count
dllp	decfsz	delay_count
	bra	dllp
	return
	
	end