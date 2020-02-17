	#include p18f87k22.inc

	extern	GLCD_Setup, Test_Write
	extern	Test_Write_2, Clear_Board
	extern	Draw_Grid
	
	extern Write_Cell, Write_Cells_Setup
	extern number_name, invert_flag
	extern sudoku_x, sudoku_y
	
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
	
	movlw	0x00
	movwf	sudoku_x
	movlw	0x01
	movwf	sudoku_y
	movlw	0x04
	movwf	number_name
	call	Write_Cell
	

	
	
	goto	$		; goto current line in code
  

	end