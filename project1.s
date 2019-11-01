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

#In my case my ID number is 02859054, as 02859054%11 is zero it will be base 26 number and the last number will be
 #"p" and 'P' respectively which corresponds to 25 in decimal number respectively. Hence the maximum sum I can get is 02859054
 #with the combination of P and p.

compute:

		la 	$s4, 1					# Making note that a character has been found.
		beq 	$a0, 	32, 	space  #Checks if the character is a space

		blt $a0, 48, invalid 		# checks if the number is less than 48. Goes to invalid if true

		ble $a0, 57, valid_num		# Checks if the ASCII of character is less than equal to 58. At this point,
									# already greater than 48, so it is a valid num in the range 0-9

		blt $a0, 65, invalid 		# Checks if the ASCII of character is less than 65. At this point,
									# already greater than 58, so if true it is an invalid character
		ble $a0, 80, valid_capital	# Checks if the ASCII of character is less than equal to 80. At this point,
									# already greater than 65, so if true it is a valid char in the range A - P

		blt $a0, 96, invalid 		# Checks if the ASCII of character is less than 96. At this point,
									# already greater than 80, so if true it is an invalid character

		ble $a0, 112, valid_small	# Checks if the ASCII of character is less than equal to 112. At this point,
									# already greater than 96, so if true, it is a valid num in the range a-p

		j invalid 					#At this point, already greater than 103, so it is invalid


invalid:                  #If the character is invalid add zero to the total sum
		addi $s1, $s1 , 0

		j loop_through


valid_num:

		subu 	$s2, 	$a0, 	48				# Finding the real value of the character by subtracting
		addu 	$s1,	$s1, 	$s2 			# Adding the value of the character to the result

		j loop_through

valid_capital:

		subu 	$s2, 	$a0, 	55				# Finding the real value of the character by subtracting
		addu 	$s1,	$s1, 	$s2				# Adding the value of the character to the result

		j loop_through
