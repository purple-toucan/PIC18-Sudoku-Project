	#include p18f87k22.inc

	extern	GLCD_Setup, Test_Write
	extern	Test_Write_2, Clear_Board
	
rst	code	0    ; reset vector
	goto	setup

main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	
	call	GLCD_Setup
	goto	start
	
	; ******* Main programme ****************************************
start 	
	call	Test_Write_2
	
	
	goto	$		; goto current line in code
  

	end