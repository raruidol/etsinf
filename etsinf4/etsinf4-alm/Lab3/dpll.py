# -*- coding: utf-8 -*-
import sys
import random
from copy import deepcopy
def read_cnf_dimacs(filename):
  linenumber = 0
  num_variables = 0
  num_clauses = 0
  clauses = []
  try:
    with open(filename) as f:
      for line in f:
        linenumber += 1
        line = line.split()
        if len(line)==0 or line[0]=='c': continue
        if len(line)==4 and line[0]=='p' and line[1]=='cnf':
          num_variables = int(line[2])
          num_clauses = int(line[3])
          break;
        sys.exit("error reading cnf file '%s' at line %d" % (filename,linenumber))
      for line in f:
        linenumber += 1
        line = line.split()
        if len(line)==0 or line[0]=='c': continue
        clause = [int(x) for x in line]
        if clause[-1] != 0:
          sys.exit("error reading cnf file '%s' at line %d expecting 0 at last position" \
                   % (filename,linenumber))
        del clause[-1] # remove last element
        if any(abs(x)>num_variables for x in clause):
          sys.exit("error reading cnf file '%s' at line %d variable out of range" \
                   % (filename,linenumber))
        clauses.append(clause)
  except ValueError:
      sys.exit("error reading cnf file '%s' at line %d parsing int" % (filename,linenumber))
  if len(clauses) != num_clauses:
      sys.exit("error reading cnf file '%s' number of clauses differ" % (filename,))
  # just in case, remove empty clauses
  clauses = [clause for clause in clauses if len(clauses)>0]
  return num_variables,clauses

def choose_literal(clauses):
  smallest = min(len(clause) for clause in clauses)
  variables = set(y for clause in clauses for y in clause if len(clause)==smallest)
  #return random.choice(tuple(variables))
  return variables.pop()

def simplify(clauses,literal):
  aux = []
  for element in clauses:
    if -literal in element:
      aux.append([])
      for i in element:
        if -literal != i :
          aux[-1].append(i)
    elif literal not in element:
        aux.append(element)
    
  if len(aux) == 0:
    return True
  elif [] in aux:
    return False
  else:
    return aux
  

def check(formula,listofliterals):
  # determines if the list of literals is able to assign a True value
  # to the formula
  for literal in listofliterals:
    formula = simplify(formula,literal)
    print("Despejando literal",literal)
    print(formula)
    if isinstance(formula,bool):
      return formula
  # at this point, the formula has not been fully simplified
  return False

def backtracking(formula):
  literal = choose_literal(formula)
  for choice in (literal,-literal):
    f = simplify(formula,choice)
    if f is not False:
      if f is True:
        return [choice]
      resul = backtracking(f)
      if resul:
        return resul+[choice]
  return None

def unit_propagation(clauses):
  auxAnterior = []
  aux = []
  for element in clauses:
    aux.append(element)
  asig=[]
  unitary = True
  while unitary:
    print("iteracion a",asig)
    auxAnterior = []
    for element in aux:
      auxAnterior.append(element)
    unitary = False
    for element in auxAnterior:
      if len(element) == 1:
        if(unitary is False):
          aux = []
        unitary = True
        asig.append(element[0])
        for clause in auxAnterior:
          if element[0] not in clause:
            aux.append(clause)
          if -element[0] in clause:
            aux.append(clause)
            aux[-1].pop(aux.index(-element[0]))
        if [] in aux:
          return False, []
        if len(aux) == 0:
          
          return True, asig
  return aux, asig
            
def pure_literal_elimination(clauses):
  aux=[]
  for element in clauses:
    aux.append(element)
  pos=[]
  neg=[]
  pures=[]
  for clause in aux:
    for literal in clause:
      if literal > 0:
        pos.append(literal)
      else:
        neg.append(literal)
  pos = list(set(pos))
  neg = list(set(neg))
  for element in pos:
    if -element not in neg:
      pures.append(element)
      for clause in aux:
        if element in clause:
          aux.pop(aux.index(clause))
  for element in neg:
    if -element not in pos:
      pures.append(element)
      for clause in aux:
        if element in clause:
          aux.pop(aux.index(clause))
  if len(aux)==0:
    return True, pures
  return aux, pures

def dpll(formula):
  res, u = unit_propagation(formula)
  if res is not False:
    if res is True:
      return u
    else:
      res2, u2 = pure_literal_elimination(res)
      if res2 is not False:
        if res2 is True:
          print("HERE")
          return u2+u
        else:
          literal = choose_literal(res2)

          for choice in (literal,-literal):
            f = simplify(res2,choice)
            if f is not False:
              if f is True:
                return [choice]
              resul = backtracking(f)
              if resul:
                return resul+[choice]+u2+u  
  return None

######################################################################
######################       MAIN PROGRAM       ######################
######################################################################
if __name__ == "__main__":
  if len(sys.argv) != 2:
    print('\n%s dimacs_cnf_file\n' % (sys.argv[0],))
    sys.exit()
        
  file_name = sys.argv[1]
  num_variables,clauses = read_cnf_dimacs(file_name)
  print(clauses)
  # replace backtracking by dpll when checking dpll
  resul = dpll(clauses)
  #resul = backtracking(clauses)
  if resul != None:
    print("We have found a solution:",resul)
    print("The check returns:",check(clauses,resul))
  else:
    print("Not solution has been found")
