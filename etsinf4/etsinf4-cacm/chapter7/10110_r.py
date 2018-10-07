import math
if __name__ == '__main__':
	while True:
		entrada = int(input())
		if entrada == 0:
			break
		else:
			aux = int(math.sqrt(entrada))
			if aux*aux == entrada:
				print("yes")
			else:
				print("no")