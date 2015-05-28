# open file
f = open("CO_P4_test1.txt", "r")

for line in f:
	line = line.replace("_", "").rstrip("\n")

	# R-type
	if line[0:6] == "000000":
		if line[26:32] == "100000":
			print "add"
		elif line[26:32] == "100010":
			print "sub"
		elif line[26:32] == "100100":
			print "and"
		elif line[26:32] == "100101":
			print "or"
		elif line[26:32] == "101010":
			print "slt"
		elif line[26:32] == "000000":
			print "sll"
		elif line[26:32] == "000110":
			print "srlv"
		elif line[26:32] == "011000":
			print "mul"
		elif line[26:32] == "001000":
			print "jr"

	# I-type
	elif line[0:6] == "001000":
		print "addi"
	elif line[0:6] == "001010":
		print "slti"
	elif line[0:6] == "001111":
		print "lui"
	elif line[0:6] == "001101":
		print "ori"

	# Branch
	elif line[0:6] == "000100":
		print "beq"
	elif line[0:6] == "000101":
		print "bne"
	elif line[0:6] == "000111":
		print "bgt"
	elif line[0:6] == "000001":
		print "bgez"

	# lw & sw
	elif line[0:6] == "100011":
		print "lw"
	elif line[0:6] == "101011":
		print "sw"

	# jump
	elif line[0:6] == "000010":
		print "jump"
	elif line[0:6] == "000011":
		print "jal"

	else:
		print ""