import Printf # I just love the C way of printing...

#=
# TODO
# - make function return array of offsets, so functions can be called after each other -> different boards?
#
=#

#=
# Binomial Distribiution of tokens
#
# parameters:
# - spaces: amount of spaces of the "current" board
# - cA: amount of spaces occupied only by player A
# - cB: amount of spaces occupied only by player B
# - cD: amount of spaces occupied by both player A and player B at the same time
=#
binDist = function(spaces, cA, cB, cD)
	return factorial(spaces) / (factorial(cA) * factorial(cB) * factorial(cD) * factorial(spaces-cA-cB-cD))
end



#=
#
# calculate the offsets if spaces is greater than 10 (0x000F)
#
=#
calculateOffset1 = function(spaces, cA, cB) 
	offset = 0
	for a in 0:cA
		for b in 0:cB
			nA = a
			nB = b
			d = 0
			while true
				if nA + nB + d <= spaces
					offset += binDist(spaces, nA, nB, d) * calculateOffset2(8, cA-a, cB-b) # change here if you are using a different board
				end
				d += 1
				nA -= 1
				nB -= 1
				if(min(nA,nB) < 0)
					break
				end
			end
		end
	end
	return offset
end


# calculate offset for 0x0FF0
calculateOffset2 = function(spaces, cA, cB)
	offset = 0
	for a in 0:cA
		for b in 0:cB
			if(a + b <= spaces)
				offset += binDist(spaces, a, b, 0) * calculateOffset3(2, cA-a, cB-b) # change here if you are using a different board
			end
		end
	end
	return offset
end

# similar to calculateOffset1, but it does not call calculateOffset2, making this setup unpractical for different boards (I plan on doing that later :P)
# calculate offset for 0x3000
calculateOffset3 = function(spaces, cA, cB)
	offset = 0
	for a in 0:cA
		for b in 0:cB
			nA = a
			nB = b
			d = 0
			while true
				if nA + nB + d <= spaces
					offset += binDist(spaces, nA, nB, d)
				end
				d += 1
				nA -= 1
				nB -= 1
				if(min(nA, nB) < 0)
					break
				end
			end
		end
	end
	return offset
end



# change this function if you are using a different board
getOffset = function(spaces, cA, cB)
	if(cA > 7 || cB > 7)
		return 0
	end
	if spaces > 14
		return 0
	elseif spaces > 10
		return calculateOffset1(spaces - 10, cA, cB)
	elseif spaces > 2
		return calculateOffset2(spaces - 2, cA, cB)
	elseif spaces >= 0
		return calculateOffset3(spaces, cA, cB)
	else
		return 0
	end
end

printArray = function()
	
	println("static const long INDEX[] = {")
	for pos in reverse(1:14)
		offset = 0
	#=	print("[",pos,"]")
		for m in reverse(0:7)
			Printf.@printf("(% 9i)",m)
		end
		println()
	=#
		m = 0
		for a in reverse(0:7)
	#		print("(",a,")")
			for b in reverse(0:7)	
				if 7-a  <= 14 - pos && 7-b <= 14 - pos
				#	Printf.@printf("% 9i, ", offset)
				#	if(7-a <= pos+1 &&  7-b <= pos+1)
						k = a*8 + b + 1
						x = trunc(Int,k/8)
						y = k%8
				#		Printf.@printf("(%i, %i)", x,y)
					#	Printf.@printf("[%2i %3i] ",pos, m)
						Printf.@printf("% 9i, ", 0)
						off = getOffset(pos-1, a,b)
						Printf.@printf("% 9i, ", off)
						off += getOffset(pos-1, a,b-1)
						Printf.@printf("% 9i, ", off)
						off += getOffset(pos-1, a-1,b)
						Printf.@printf("% 9i, ", off)
						m += 1
						println()
				#		offset = getOffset(pos, b, a)
				#	end
				#	Printf.@printf("% 9i, ", offset)
				else
					Printf.@printf("0,0,0,0,\n")
				end
			end
		#	println()
		end
		println()
	end
	println("};")
end


runTest = function(spaces, a, b)
	top = getOffset(spaces, a, b)
	spaces -= 1
	p0 = getOffset(spaces, a, b)
	pa = getOffset(spaces, a-1, b)
	pb = getOffset(spaces, a, b-1)
	pd = 0
	if spaces < 2 || spaces > 10
		pd = getOffset(spaces, a-1, b-1)
	end
	println("top:	", BigInt(top))
	println("sum:	", BigInt(p0 + pa + pb + pd))
	println("0:	", BigInt(p0))
	println("a:	", BigInt(pa))
	println("b:	", BigInt(pb))
	println("d:	", BigInt(pd))
	println("error:	", BigInt(p0 + pa + pb + pd - top))

end

printArray()
