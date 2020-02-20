	#include p18f87k22.inc

	extern GLCD_Setup	
	extern Write_Cursor, Write_Cells_Setup
	extern Give_Input, PadSetup
	extern validate
	extern update_game, logic_setup
	extern write_correct, write_wrong
	extern Create_Board
	
acs0	    udata_acs   ; reserve data space in access ram
game_loop_counter res 1	    
w_store    res 1	

    constant	loops_per_semi_flash = 0x7F
    
rst	code	0    ; reset vector

	goto	setup

main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	
	call	PadSetup
	call	GLCD_Setup
	call	logic_setup
	call	Write_Cells_Setup
	call	Create_Board
	goto	start
	
	; ******* Main programme ****************************************
start 
	
	
game_loop_start
	call	Give_Input	    ; get keypad input
	movwf	w_store
	
	movlw	0xFF
	cpfseq	w_store
	bra	received_input	    ; input found
	bra	game_loop_end	    ; no input
	
received_input
	
	movlw	0xFE
	cpfseq	w_store
	bra	continue	    ; input is not exit command
	bra	validation	    ; input is exit command
	
validation
	
	call	validate	    ; check solution
	movwf	w_store
	
	movlw	0x00
	cpfsgt	w_store
	bra	game_loop_end	    ; board is incomplete
	
	movlw	0x01
	cpfseq	w_store
	bra	correct_board_exit  ; solution is correct
	
	call	write_wrong	    ; solution is incorrect
	
	bra	game_loop_end
	
continue
	movf	w_store, w
	call	update_game	    ; input edits cursor position or cell value
	bra	game_loop_end
	
game_loop_end
	
	incf	game_loop_counter, f ; count game loops
	
	movlw	loops_per_semi_flash	
	cpfseq	game_loop_counter
	bra	not_N
	
	movlw	0xFF
	call	Write_Cursor		; write cursor as solid block
	
not_N
	movlw	loops_per_semi_flash*2
	cpfseq	game_loop_counter
	bra	game_loop_start
	
	movlw	0x0
	movwf	game_loop_counter	; reset counter
	call	Write_Cursor		; write cursor's true value
	bra	game_loop_start
	
correct_board_exit
	
	call	write_correct		; display message and stop
	
	goto	$

	end