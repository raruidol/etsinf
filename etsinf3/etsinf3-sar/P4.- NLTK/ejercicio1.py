#Ramon Ruiz Dolz
#Salvador Marti Roman

from nltk.corpus import cess_esp
from nltk.corpus import PlaintextCorpusReader
from nltk.probability import *
import os
import nltk
dir_path = os.path.dirname(os.path.realpath(__file__))
corpus_root = dir_path.replace(".idea","")
nltk.data.path.append(dir_path+"\\NLTK")
#EJERCICIO1
print("#act2")
print(len(cess_esp.words()))

print("#act3")
print(len(cess_esp.sents()))

print("#act4")
text= cess_esp.words(cess_esp.fileids()[0])
fdist=FreqDist(text)
print (fdist.most_common(20))

print("#act5")
voc = [w for w,f in fdist.most_common()]
print(voc)

print("#act6")
print(list(w for w in voc if len(w)>7 and fdist[w]>2))

print("#act7")
print(sorted(fdist.values(), key=int, reverse=True))
print("Freq aparición de la preposición a "+str(fdist['a']))

print("#act8")
print("No de palabras que aparecen una sóla vez: "+str(len(fdist.hapaxes())))

print("#act9")
print("La palabra más frecuente es "+fdist.max())

print("#act10")
dir_path = os.path.dirname(os.path.realpath(__file__))
wordlists = PlaintextCorpusReader(corpus_root+"/library",'.*')
print("#act11")
text= wordlists.words(wordlists.fileids()[0])
fdist=FreqDist(text)
for i in wordlists.fileids():
	text= wordlists.words(i)
	fdist=FreqDist(text)
	print((str(i)+" "+str(len(text))+" "+str(len(fdist.keys()))+" "+str(len(wordlists.sents(i)))))
"""
12. ¿Coinciden estos resultados con los de la práctica anterior? Justifica la respuesta.

Los resultados no coinciden por varias razones. La primera es que en la practica 2 solo se tenian en cuenta
las palabras alphabeticas en cambio NLTK incluye las alphanumericas como '-Fpa-' ó '51_por_ciento". Anteriormente tambien
quitabamos las stopwords de las cuentas. Finalmente el criterio de separación de frases de la práctica 2 eran ".", ";" y "\n\n"
dando como resultado más lineas totales.

"""
#EJERCICIO2

#EJERCICIO3	