def australianVoting(recount, n, candidates):
    recount1 = recount[0]
    recount2 = []
    for z in range(1,len(recount)):
        recount2.append(recount[z])
    while True:
        count = [0]*n
        numvotes = 0
        for vote in recount1:
            count[vote-1] = count[vote-1]+1
            numvotes += 1
        maxval = 0
        minval = 1001
        for value in count:
            if value > maxval:
                maxval = value
            if value != 0 and value < minval:
                minval = value
            if 2*value > numvotes:
                return candidates[count.index(value)]
        if maxval == minval:
            ale = []
            for element in range(len(count)):
                if count[element] == maxval:
                    ale.append(candidates[element])
            return ale

        delete = []
        for value in count:
            if value == minval:
                delete.append(count.index(value)+1)
        for cand in delete:
            candidates[cand-1] = None
        for vote in recount1:
            if vote in delete:
                pos = recount1.index(vote)
                for aux in recount2:
                    for i in aux:
                        if i in delete:
                            aux[aux.index(i)] = None
                for alt in recount2:
                    if alt[pos] is not None:
                        v = alt[pos]
                        alt[pos] = None
                        recount1[pos]=v
                        break
                    

def doVotation(results):
    recount = []
    candidates = []
    num_candidates = int(results.pop(0))
    i = 0
    while i < num_candidates:
        candidates.append(results.pop(0))
        recount.append([])
        i += 1

    for ballot in results:
        j = 0
        votes = ballot.split(' ')
        for pick in votes:
            recount[j].append(int(pick))
            j += 1
    win = australianVoting(recount, num_candidates, candidates)
    return win



if __name__ == '__main__':
    text = ''
    num_cases = int(input())
    dummy = input()
    for i in range(num_cases):
        num_candidates = int(input())
        candidates = []
        ballot = []
        for j in range(num_candidates):
            candidates.append(input())
        while True:
            votes = input()
            if votes:
                ballot.append(votes)
            else:
                break
        text1 = "\n".join(candidates)
        text2 = "\n".join(ballot)
        text_aux = str(num_candidates)+"\n"+text1+"\n"+text2+"\n\n"
        text += text_aux
    final_text = str(num_cases)+"\n\n"+text
    inData = final_text.split("\n\n")
    inData.pop(0)
    del inData[-1:]
    c = 1
    print(len(inData))
    for block in inData:
        election = block.split("\n")
        winner = doVotation(election)
        
        if isinstance(winner, list):
            for man in winner:
                if man is not None:
                    print(man)
            print()
        else:
            print(winner)
            print()
