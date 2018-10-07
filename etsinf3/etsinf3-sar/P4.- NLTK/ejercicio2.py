#Ramon Ruiz Dolz
#Salvador Marti Roman
from nltk.corpus import brown
from nltk.corpus import PlaintextCorpusReader
from nltk.probability import *

def wordCountPerCategory(word):
    result=[]
    for category in brown.categories():
        words = brown.words(categories=category)
        wordCount = FreqDist(words)
        result.append(category)
        result.append(wordCount[word])
    return result


fiveW=['what','when','where','who','why']
result=[]
for w in fiveW:
    result.append(w)
    result.append(wordCountPerCategory(w))

print(result)