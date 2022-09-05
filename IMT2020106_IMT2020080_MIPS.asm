#Written by Harshith(IMT2017516)
#email: Harshith.Reddy@iiitb.org

#run in linux terminal by java -jar Mars4_5.jar nc filename.asm(take inputs from console)

#system calls by MARS simulator:
#http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html
.data
	next_line: .asciiz "\n"	
.text
#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       
#############################################################
#Do not change any code above this line
#Occupied registers $t1,$t2,$t3. Don't use them in your sort function.
#############################################################
#function: should be written by students(sorting function)
#The below function adds 10 to the numbers. You have to replace this with
#your code

# denote number of values to be sorted as N 
move $t5, $t1	# the address stored in $t1 is now also stored in $t5
move $t6, $t2  	# the address stored in $t2 is now also stored in $t6
move $t7, $t3  	# the address stored in $t3 is now also stored in $t7
# this copying is done to completely avoid the usage of $t1,$t2,$t3 inside the sort function

# "sort" is used to store the values given as input in the adresses meant to store the output after sorting them. 
# the data is sorted using bubble sort

sort: 	move $s0,$zero	# initialize value in $s0 to 0(this value in $s0 acts like a loop counter to the loop "part1")
	move $t8, $t6	# the address stored in $t6(also stored in $t2) is now also stored in $t8
	move $t9, $t7	# the address stored in $t7(also stored in $t3) is now also stored in $t9
	
	# part1 is a loop that copies all the values starting from the address in $t2 and stores them in consecutive memory locations 
	# starting from the address in $t3
	
	part1:		beq $s0,$t5,part1_end	# if (value in $s0) = (value in $t5) where (value in $t5 = value in $t1 = number of inputs(N) ) 
						# then this loop breaks and "part1_end" is executed 
			# else			
			lw $s1,0($t8)	# loading the values in the address in $t8(i.e, the values starting from $t2) into $s1
        		sw $s1,0($t9)	# storing the values of $s1 in each iteration of the loop in address in $t9
        				# (i.e, storing the values starting from address $t3)
        				
        		addi $t8,$t8,4	# increment value of $t8 by 4 to access the next address location    
        		addi $t9,$t9,4	# increment value of $t9 by 4 to change the adress where the new number has to be stored
        		addi $s0,$s0,1	# increment the loop counter(i.e the value in $s0)
        		j part1		# next iteration of the loop
        		
        		
	part1_end: 	move $t8,$t6	# after the execution of loop "part1", change the value in $t8 which has been altered 
					# inside the the "part1" loop to its initial value before "part1" is executed
			move $s4,$t5	# initialize $s4 to value in $t5 which is total number of inputs(N)
					# this value in $s4 is used as a loop counter of the loop "part2"
			
	# part2 is a loop that sortss all the N values starting from the address in $t3 after execution of loop "part1"
	
	part2:		beq $s4,$zero,part2_end	# if (value in $s4) = 0(value in $zero) 
						# where value in $4 is initially equal to value in $t5 which is the number of inputs
						
			move $t9,$t7		#   in the first iteration of "part2" loop :
						# > after the execution of loop "part1", change the value in $t9 which has been altered 
						#   inside the the "part1" loop to its initial value before "part1" is executed
						
						#   In the other iterations of "part2" loop :
						# > the value in $t9 is getting altered inside the innerloop.
						#   So, after the execution of innerloop in each iteration of outerloop "part2", change the
						#   value in $t9 to its initial value which is the value in $t7
						
						
			addi $s0,$zero,1	# initialize value in $s0 as 1 to act as a loop counter for the innerloop


			# inner_loop is a loop inside the loop "part2". 
			# this is similar to a nested loop where "part2" is outerloop and "inner_loop" acts as inner loop
			# "inner_loop" is reffered as innerloop in the comments

			inner_loop:	beq $s0,$s4,inner_loopend	# when value in $s0(initially 1 at the start of execution of innerloop)
									# becomes equal to value in $s4(total numnber of inputs) then the 
									# inner loop breaks.
									
					# loading the first 2 elements in the adress starting at $t9 into $s1, $s2 respectively
					# the value in $t9 is changing inside the innerloop. So, in every iteration of the inner loop 
					# a different pair of numbers is loaded into $s1, $s2
					lw $s1,0($t9)			
					lw $s2,4($t9)
					
					move $s3,$zero		# intitializing the value in $s3 to 0
					slt $s3,$s1,$s2		# updating the value in $s3 to 1 if value in $s1 < value in $s2
					
					beq $s3,$zero,swap	# if value in $s3 = 0, then it implies the values in $s1 >= value in $s2
								# if the second number is smaller than the first then 
								# to arrange these two numbers in ascending order they can be swapped using "swap"
								
					bne $s3,$zero,noswap	# if value in $s3 = 1(not equal to 0) then it implies $s1 < $s2
								# as the first number is smaller than second number these 2 numbers are
								# already sorted in ascending order. hence "noswap" is called
								
					swap: 	lw $s2,0($t9)
						lw $s1,4($t9)
						sw $s1,0($t9)
						sw $s2,4($t9) 
						# "swap" swaps the values in location 0($t9) and 4($t9)
						
					noswap:	# nothing has to be done in noswap
					
        				addi $t9,$t9,4	# increment t9 by 4 to access the next pair of numbers
					addi $s0,$s0,1	# increment value in $s0 in every iteration of innerloop
					j inner_loop	# next itration of innerloop
					
			inner_loopend:	# nothing has to be done in "inner_loopend"
			
        		# after the execution of a innerloop the greatest number of all the values stored in $t3 
        		# is at the greatest location among the rest of data which was stored in the consecutive
        		# memory locations.( starting from $t3)
        		# So, we can ignore it in next iteration of the outerloop "part2"
        		# So, in the execution of innerloop in next iteration of outerloop "part2", the greatest element which was stored in
        		# greatest location in previous iteration of outerloop is now not taken into consideration 
        		# So, ineach iteration of outerloop "part2" the number of pairs compared in innerloop is decreased by 1
        		# this could be done by decrementing the value in $s4 by 1, in each iteration of outerloop "part2"
			subi $s4,$s4,1
			
			j part2	# next iteration of outerloop "part2"
				
	part2_end:	# nothing has to be done in "part2_end"
	
	# after the execution of both "part1" and "part2" loops( and the loops inside them such as innerlooop inside "part2" loop)
	# the numbers stored in the memory locations starting from the adress in $t3 are stored in a sorted manner.
	# this sorting has been done using bubblesort
	
#endfunction
#############################################################
#You need not change any code below this line

#print sorted numbers
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1		#1 implie
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra
