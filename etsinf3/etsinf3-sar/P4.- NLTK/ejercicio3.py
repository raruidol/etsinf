#Ramon Ruiz Dolz
#Salvador Marti Roman
import nltk
from nltk.corpus import *
from nltk.corpus import PlaintextCorpusReader
from nltk.probability import *
from nltk.tokenize import *
from nltk.stem import SnowballStemmer
import io
import os
from nltk.data import path
dir_path = os.path.dirname(os.path.realpath(__file__))
corpus_root = dir_path.replace(".idea","")
path.append(dir_path+"\\NLTK")
#Act1
originalContent = io.open("./library/quijote.txt",encoding="utf8").read()
#Act2
originalFreq = FreqDist(w for w in RegexpTokenizer(".").tokenize(originalContent))
print("Act2")
print(sorted(originalFreq.keys()))

#Act3
filterContent= re.sub('[.|,"¡!()\-:;¿?«»\'\]\[\\n]','',originalContent)

#Act4
print("Act4")
filterFreq = FreqDist(filterContent)
print(sorted(filterFreq.keys()))

#Act5
originalContent = io.open("./library/quijote.txt",encoding="utf8").read()
filterContent= re.compile("[\!\¡\"\'\(\)\,\\.\-\:\;\¿\?\[\]\«\»]+").sub("",originalContent)#re.sub('[.|\,"¡!()\-:;¿?«»\'\]\[]','',originalContent)
filteredWords = word_tokenize(filterContent)
filterFreq = FreqDist(filteredWords)
print("Act5")
print(str(len(filteredWords))+"\t"+str(len(filterFreq.keys())))
print(str(sorted(filterFreq.keys())[:10])+"\n"+str(sorted(filterFreq.keys())[-10:]))

#Act6
print("Act6")
filterFreq=FreqDist(word_tokenize(filterContent))
print(filterFreq.most_common(20))

#Act7
originalContent = io.open("./library/quijote.txt",encoding="utf8").read()
filterContent= re.compile("[\!\¡\"\'\(\)\,\\.\-\:\;\¿\?\[\]\«\»]+").sub("",originalContent)#re.sub('[.|\,"¡!()\-:;¿?«»\'\]\[]','',originalContent)
stopWords=stopwords.words('spanish')
file=io.open("./library/nonstopquijote.txt","w")
nonstoptext=[word for word in word_tokenize(filterContent) if word.lower() not in stopWords]
file.write(" ".join(nonstoptext))
file.close()

#Act8
nonstopFreq = FreqDist(nonstoptext)
print("Act8")
print(str(len(nonstoptext))+"\t"+str(len(nonstopFreq.keys())))
print(str(sorted(nonstopFreq.keys())[:10])+"\n"+str(sorted(nonstopFreq.keys())[-10:]))

#Act9
print("Act9")
print(nonstopFreq.most_common(20))

#Act10
file=io.open("./library/stemquijote.txt","w")
stemtext=map(SnowballStemmer('spanish',True).stem,nonstoptext)
file.write(" ".join(stemtext))
file.close()

#Act11
originalContent = io.open("./library/quijote.txt",encoding="utf8").read()
filterContent= re.compile("[\!\¡\"\'\(\)\,\\.\-\:\;\¿\?\[\]\«\»]+").sub("",originalContent)
#re.sub('[.|\,"¡!()\-:;¿?«»\'\]\[]','',originalContent)
stopWords=stopwords.words('spanish')
nonstoptext=[word for word in word_tokenize(filterContent) if word.lower() not in stopWords]
stemtext=map(SnowballStemmer('spanish',True).stem,nonstoptext)
stemtext=[w for w in stemtext]
stemFreq = FreqDist(stemtext)
print("Act11")
print(str(len(stemtext))+"\t"+str(len(stemFreq.keys())))
print(str(sorted(stemFreq.keys())[:10])+"\n"+str(sorted(stemFreq.keys())[-10:]))

#Act12
print("Act12")
print(stemFreq.most_common(20))

#Act13
"""
Entre la 8 y las 18 podemos ver como la cantidad de palabras totales no cambia eso se debe a que solo
aplicamos stemming y por lo tanto lo que se reduce es el numero de palabras distintas. Las palabras
más frecuentes cambian ligeramente ya que se agrupan palabras que anterior mente tenian diferente
terminacion pero pertenecian a la misma familia como "hac"

Entre 5 y 8 podemos ver que la cantidad de palabras totales se ve severamente recortada dado que
quitamos los stopwords que son palabras bastante frecuentes pero poco relevantes. Por eso las palabras
con más ocurrencias tambien pasan a ser otras de caracter más distinctivo
"""