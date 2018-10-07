from math import sqrt

if __name__ == '__main__':
	cases = int(input())
	for case in range(cases):
		ent = input().split()
		x = int(ent[0])
		y = int(ent[1])
		L = y-x
		steps = 0
		n = int(sqrt(L))
		steps = n
		L -= n*(n+1)/2
		while L>0:
			while n*(n+1)/2 > L:
				n -= 1
			if n*(n+1)/2 == L:
				L = 0
				steps += n
			else:
				L -= n
				steps += 1
		print(steps)
