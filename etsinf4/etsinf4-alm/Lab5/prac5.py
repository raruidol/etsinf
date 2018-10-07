import numpy as np
import heapq # a priority queue

def create_graph(N,maxvalue=1000):
  G = np.random.randint(maxvalue, size=(N, N))
  for i in range(N):
    G[i][i] = 0
    for j in range(i+1,N):
      m = min(G[i][j],G[j][i])
      G[i][j] -= m
      G[j][i] -= m
  return G

def generate_random_ordering(G):
  # let's assume that G is a square Numpy matrix of integers
  N = G.shape[0]
  return np.random.permutation(N)

def evaluate(G,ordering):
  # assume that G.shape is of type (N,N) and ordering.shape is of type
  # (N) and is a permutation of values 0,...,N-1
  N = G.shape[0]
  return sum(G[ordering[i]][ordering[j]]-G[ordering[j]][ordering[i]]
             for i in range(N) for j in range(i+1,N))

def show_evaluate(G,ordering):
  N = G.shape[0]
  positivos = list(G[ordering[i]][ordering[j]] for i in range(N) for j in range(i+1,N))
  negativos = list(G[ordering[j]][ordering[i]] for i in range(N) for j in range(i+1,N))
  vpos = sum(positivos)
  vneg = sum(negativos)
  resul = vpos-vneg
  print("(" + ",".join(map(str,positivos))+") - (" + ",".join(map(str,negativos))+
  ") = ",vpos, "-", vneg, "=", resul)
  return resul

  #METODO DE LA PRACTICA 4
def process_graph(G):
  N = G.shape[0]
  for nodo in range(N):
    for nodo2 in range(N):
      if(G[nodo][nodo2]>G[nodo2][nodo]):
        G[nodo][nodo2] = G[nodo][nodo2] - G[nodo2][nodo]
        G[nodo2][nodo] = 0
      else:
        G[nodo2][nodo] = G[nodo2][nodo] - G[nodo][nodo2]
        G[nodo][nodo2] = 0
  return G


def generate_greedy_ordering(G):
  # let's assume that G is a square Numpy matrix of integers
  N = G.shape[0]
  resul = []
  while len(resul)<N:
    noresul = list(set(range(N))-set(resul))
    aux = []
    for i in range(N):
      if i not in resul:
        score = (sum(G[j][i]-G[i][j] for j in resul) +
                 sum(G[i][j]-G[j][i] for j in noresul if j!=i))
        aux.append((score,i))
    print(resul,aux)
    score,choice = max(aux)
    resul.append(choice)
  return np.asarray(resul,dtype=np.int)

def evaluate_partial(G,ordering):
  # assume that G.shape is of type (N,N) and ordering.shape is of type
  # (N) and is a permutation of values 0,...,N-1
  N = len(ordering)
  return sum(G[ordering[i]][ordering[j]]-G[ordering[j]][ordering[i]]
             for i in range(N) for j in range(i+1,N))


def BranchAndBound(G):
  # ojo con graph <- "se mira pero no se toca"
  N = G.shape[0]

  def optimisticIncremental(s,opt):
    last = s[-1]
    for elemento in range(N):
      if elemento not in s:
        opt = opt - 2 * G[elemento][last]
    return opt



  def optimistic(s):
    # s es una lista de vertices entre 0 y N-1
    opt = 0
    # COMPLETAR:
    # sumamos la parte conocida:
    # en primer lugar, las aristas entre elementos conocidos:

    for indice in range(len(s)):
        origen = s[0:indice]
        detino = s[indice+1:]

        i = s[indice]
        for iterador in range(N):
          if(iterador not in origen):
            opt += (G[i][iterador] - 2*G[iterador][i])
          

    # luego la suma entre elementos conocidos y desconocidos:
    
    # finalmente sumamos una estimaciÃ³n de la parte desconocida: 
    desconocido = []
    for iterador in range(N):
      if(iterador not in s):
        desconocido.append(iterador)
    for origen in desconocido:
      for destino in desconocido:
        opt += G[origen][destino]  
            #opt -= G[elementoDesconcoidoDestino][elementoDesconocidoOrigen]
    return opt

  def branch(s):
    return (s+[i] for i in range(N) if i not in s)

  def is_complete(s):
    # COMPLETAR NO SE SABE
    if(len(s) == N ):
      return True

  A = [] # empty priority queue
  x = generate_greedy_ordering(G)
  fx = optimistic(x) # equivale a evaluate quando is_complete(x)
  #optimistic(x) # equivale a evaluate quando is_complete(x)
  # anyadimos el estado inicial:
  s = []

  opt = optimistic(s)
  print(opt)
  heapq.heappush(A,(-opt,s))
  iter = 0
  maxA = 0
  print(len(A))
  # bucle principal de ramificacion y poda:
  while len(A)>0 and -A[0][0] > fx: # PODA IMPLICITA
    iter += 1
    lenA = len(A)
    maxA = max(maxA,lenA)
    score_s, s = heapq.heappop(A)
    score_s = -score_s # ahora ya no estÃ¡ negado
    print("Iter. %04d |A|=%05d max|A|=%05d fx=%04d score_s=%04d" % \
          (iter,lenA,maxA,fx,score_s))
    for child in branch(s):
      if is_complete(child): # si es terminal
        # seguro que es factible
        # falta ver si mejora la mejor solucion en curso
        if (evaluate(G,child)>fx):
          fx = evaluate(G,child)
          x = child
        # COMPLETAR
      else: # no es terminal
        # lo metemos en el cjt de estados activos si supera
        # la poda por cota optimista:
        opt = optimisticIncremental(child,score_s)
        if(opt>fx):
          heapq.heappush(A,(-opt,child))
        # COMPLETAR
    print(A)

  return x,fx
 
if __name__ == "__main__":
    N = 8
    G = create_graph(N,5)
    #G= [[ 0, 881,   0,   0,  72, 191,   0,   0],[  0,   0,  94, 535, 490,  19, 224,   0],[357,   0,   0, 259,   0,  65, 287, 456],[129,   0,   0,   0,   0,   8,   0, 266],[  0,   0, 916,  23,   0, 300,   0, 290],[  0,   0,   0,   0,   0,   0,   0,   0],[ 63,   0,   0,  44, 178, 627,   0,   0],[231,  86,   0,   0,   0, 260, 547,   0]]
    print("G=",G)
    G = process_graph(G)
    x,fx = BranchAndBound(G)
    greedy_ordering = generate_greedy_ordering(G)
    
    print("greedy ordering", greedy_ordering, evaluate(G,greedy_ordering))
    print("exacto",x,fx,evaluate(G,x))
