	#include p18f87k22.inc

	extern	GLCD_Setup, Test_Write
	extern	Test_Write_2, Clear_Board
	extern	Draw_Grid
	
	extern Write_Cell, Write_Cells_Setup
	extern number_name
	extern sudoku_x, sudoku_y
	
acs0	    udata_acs   ; reserve data space in access ram
game_loop_counter res 1	    
w_store    res 1	

    constant	loops_per_semi_flash = 15
    
rst	code	0    ; reset vector
	goto	setup

main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	
	call	GLCD_Setup
	call	Draw_Grid
	call	Write_Cells_Setup

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
	
	call	validate_board	    ; check solution
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
	
correct_board_exit
	
	call	write_correct		; display message and stop
	
	goto	$

	end