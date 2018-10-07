#Ramón Ruíz Dolz
#Salvador Martí Román

from operator import itemgetter
import re
import sys
import string

clean_re = re.compile('\W+')
def clean_text(text):
    return clean_re.sub(' ', text)

def addWordsToCountingDictionary(dictionary, words, specialChar):
    for word in words:
        if word in dictionary:
            dictionary[word] += 1
        else:
            dictionary[word] = 1
    #Makes Special char the line counter
    dictionary[specialChar] = dictionary[specialChar] - 1


def indexWords(dictionary, words):

    for index in range(0,len(words)-1):
        currentWord = words[index]
        nextWord = words[index+1]
        if currentWord in dictionary:

            if nextWord in dictionary[currentWord]:
                dictionary[currentWord][nextWord]+=1
            else:
                dictionary[currentWord][nextWord]=1

        else:
            dictionary[currentWord]={nextWord:1}

#Not used
def printByFreq(freqDict, indexDict):
    view = [(v,k) for k,v in freqDict.items()]
    view.sort(reverse=True)
    for v, k in view:
        print("\t{0}\t{1}\t{2}".format(k, v,indexDict[k]))

def printByAlphabet(freqDict, indexDict):
    for key, value in sorted(freqDict.items()):
        print("\t{0}\t{1}\t{2}".format(key,value,indexDict[key]))

def indexer(f1, f2):
    wordCountDict={}
    indexDict={}
    #Had to specify "uft_8" so quijote wouldn't launch charmac can't decode byte error
    with open(f1) as file1:
        #Content is the full document in one string
        content = file1.read().lower()
        content = re.split(r"[;|.|\n\n]+",content)
        content = list(filter(None,content))
        for sentence in content:
            #Cleaning sentence and adding special markers
            sentence = '$ '+clean_text(sentence)+' $'
            #Converting sentences into a list
            words = sentence.split(" ")
            words = list(filter(None,words))
            addWordsToCountingDictionary(wordCountDict,words,"$")
            indexWords(indexDict,words)

    #Print to file redirecting stdout (Not ideal but reuses code)
    sys.stdout=open(f2,"w")
    printByAlphabet(wordCountDict,indexDict)
    sys.stdout.close()

if __name__ == "__main__":
    if len(sys.argv)!=3:
        print("Wrong number of arguments")
        sys.exit()
    f1 = sys.argv[1]
    f2 = sys.argv[2]
    indexer(f1,f2)
