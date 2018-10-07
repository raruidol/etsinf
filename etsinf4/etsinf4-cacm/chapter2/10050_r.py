if __name__ == '__main__':
	num_cases = int(input())
	for case in range(num_cases):
		num_days = int(input())
		num_parties = int(input())
		memory = [0]*(num_days+1)
		count = 0
		for party in range(num_parties):
			party_data = int(input())
			for d in range(1, num_days+1):
				day = d % 7
				if day != 0 and day != 6:
					if d % party_data == 0 and memory[d] == 0:
						count += 1
						memory[d] = 1
		print(count)