if __name__ == '__main__':
	num_cases = int(input())
	for case in range(num_cases):	
		n = int(input())
		res = ((n**4) - (6*(n**3)) + (23*(n**2)) - (18*n) + 24)//24
		print(res)
