def ejercicio2(V):
    res = [1]*len(V)
    for n in range(len(V)):
        maxm = 1
        for l in range(n):
            if V[n] > V[l]:
                if res[l]>=maxm:
                    maxm = res[l]+1
        res[n]=maxm
    return res


def ejercicio3(V):
    return max(ejercicio2(V))

def ejercicio4(V):
    reslen = [1]*len(V)
    respos = range(len(V))
    res = []
    for n in range(len(V)):
        maxm = 1
        pos = n
        for l in range(n):
            if V[n] > V[l]:
                if reslen[l]>=maxm:
                    maxm = reslen[l]+1
                    pos = l
        reslen[n]=maxm
        respos[n]=pos
    maxpos = reslen.index(max(reslen))

    aux = respos[maxpos]
    res.append(V[maxpos])
    res.append(V[aux])
    while aux > 0:
        auxActual = aux
        aux = respos[aux]
        if auxActual == aux:
            break
        res.append(V[aux])
        
    resreverse = res.reverse()

    return res

if __name__ == "__main__":
    print(ejercicio2([210, 816, 357, 107, 889, 635, 733, 930, 842, 542]))
    print(ejercicio3([210, 816, 357, 107, 889, 635, 733, 930, 842, 542]))
    print(ejercicio4([210, 816, 357, 107, 889, 635, 733, 930, 842, 542]))
