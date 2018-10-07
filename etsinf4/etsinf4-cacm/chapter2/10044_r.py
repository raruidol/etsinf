if __name__ == '__main__':
    num_cases = int(input())
    res=[]
    for i in range(num_cases):
        dic={'Erdos, P.':0}
        data = input()
        aux = data.split(" ")
        num_papers = int(aux[0])
        num_authors = int(aux[1])
        auth=[]
        restantes=[]
        for n in range(num_papers):
            paper = input()
            udat = paper.split(":")
            authors = udat[0].split(".,")
            for i in range(len(authors)-1):
                authors[i] = authors[i]+"."
            for j in range(1, len(authors)):
                authors[j] = authors[j][1:]
            auth.append(authors)
        for relation in auth:
            if 'Erdos, P.' in relation:
                for au in relation:
                    if au != 'Erdos, P.':
                        dic[au] = 1
            else:
                restantes.append(relation)
        process=[]
        #print(restantes)
        #print(dic)
        #print("----------------------")
        while restantes != []:
            for relation in restantes:
                for member in relation:
                    if member in dic.keys():
                        process.append([relation, member])
                        break
                break
            if process == []:
                for relation in restantes:
                    for member in relation:
                        dic[member] = 'infinity'
                break
            #print(process)
            #print(restantes)
            for person in process[0][0]:
                if person not in dic.keys():
                    dic[person] = dic[process[0][1]]+1
            #print(dic)
            restantes.remove(process[0][0])
            process=[]
        #print('--------------------')
        #print(dic)
        print("Scenario", i+1)
        for k in range(num_authors):
            a = input()
            if a not in dic.keys():
                print(a, 'infinity')
            else:
                print(a,dic[a])
