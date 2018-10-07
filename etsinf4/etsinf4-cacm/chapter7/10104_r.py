
def gcd(a, b):
	x1 = 1
	x2 = 0
	y1 = 0
	y2 = 1
	flag = 0
	while a%b:
		if flag:
			x2 = x2 - ((a//b)*x1)
			y2 = y2 - ((a//b)*y1)
		else:
			x1 = x1 - ((a//b)*x2)
			y1 = y1 - ((a//b)*y2)
		aux = a
		a = b
		b = aux%b
		flag = flag ^ 1
	if flag == 1:
		print(x1, y1, b)
	else:
		print(x2, y2, b)

if __name__ == '__main__':
	while True:
		try:
			entrada = input()
			if entrada:
				tupla = entrada.split()
				a = int(tupla[0])
				b = int(tupla[1])
				gcd(a, b)
		except EOFError:
			break