if __name__ == '__main__':
	cases = int(input())
	for case in range(cases):
		val = input()
		c = 1
		while True:
			val = str(int(val) + int(val[::-1]))
			if val == val[::-1]:
				print(c, val)
				break
			c += 1

