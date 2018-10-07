if __name__ == '__main__':
	cases = int(input())
	for case in range(cases):
		num_to_pop = 0
		num_turtles = int(input())
		real_list = []
		ordered_list = []
		for turtle in range(num_turtles):
			turt = input()
			real_list.append(turt)
		for turtle in range(num_turtles):
			turt = input()
			ordered_list.append(turt)
		
		real_list.reverse()
		ordered_list.reverse()
		#todo leido

		indices=[]
		for tortuguita in ordered_list:
			indices.append(real_list.index(tortuguita))
		for n in range(len(indices)):
			if n < len(indices)-1 and indices[n] > indices[n+1]:
				num_to_pop = len(indices)-1-n
				break

		ordered_list.reverse()
		if num_to_pop != 0:

			for i in range(num_to_pop-1, -1, -1):
				print(ordered_list[i])

		print()