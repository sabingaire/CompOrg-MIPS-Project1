.data
	input_message:     	.asciiz "Choose a string: "
  newline: 			.asciiz "\n"
	Input_user: .space  10

.text
		main:
		la $s1, 0					# s1 is the register reserved to print the result
		la $s3, 0					# Boolean for checking if a space is found after a valid character
		la $s4, 0


		li $v0, 4 						#Make it ready to print the instruction to console
		la $a0, input_message  #This will allow the "Choose a string method to print"
		syscall

		li $v0, 8		#load 8 in $v0 to read string input from user
		la $a0, Input_user	#load the value given by the users to $a0
		li $a1, 11   #This allows the user to only input 10 characters
		move $t0, $a0	 	#5 in $a1 to store 1000 bytes in buffer
		syscall

loop_through:									#Loops through all the character of the input string one by one

		lb $a0, ($t0)								#Initializing the address for the character of the string

		add $t0, $t0, 1								#Incrementing the address

		beqz 	$a0, 			end_of_loop			#If "\0" found, end of loop. We know the ascii value of "\0" is zero

		beq  	$a0, 	11, 	end_of_loop			#For string less than 10, the last characters
																			# is "\n", so checking for that

		#So now as we have removed the edge cases like end of line so we move on to compute the result
		bne $s3, 1, compute
		bne $s4, 1, compute

		j invalid
