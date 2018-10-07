if __name__ == '__main__':
	exit = ['0', '0']
	while True:
		entrada = input().split()
		if entrada == exit:
			break
		sum1 = entrada[0][::-1]
		sum2 = entrada[1][::-1]
		maxlen = max(len(sum1), len(sum2))
		minlen = min(len(sum1), len(sum2))
		carry = [0]*maxlen
		for i in range(minlen):
			if i == 0 and int(sum1[i])+int(sum2[i]) >= 10:
				carry[0] = 1

			elif int(sum1[i])+int(sum2[i])+carry[i-1] >= 10:
				carry[i] = 1
		if minlen != maxlen:
			x = minlen
			if len(sum2) == maxlen:
				while True:
					if x == maxlen:
						break 
					if int(sum2[x])+carry[x-1] >= 10:
						carry[x] = 1
					x+=1

			if len(sum1) == maxlen:
				while True:
					if x == maxlen:
						break
					if int(sum1[x])+carry[x-1] >= 10:
						carry[x] = 1
					x += 1

		val = sum(carry)
		if val == 0:
			print("No carry operation.")
		elif val == 1:
			print(val, "carry operation.")
		else:
			print(val, "carry operations.")