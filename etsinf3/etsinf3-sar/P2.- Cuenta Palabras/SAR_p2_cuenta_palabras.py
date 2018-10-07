# inspired by Lluís Ulzurrun and Víctor Grau work

from operator import itemgetter
import re
import sys
import string


clean_re = re.compile('\W+')
def clean_text(text):
    return clean_re.sub(' ', text)

def sort_dic(d):
    for key, value in sorted(sorted(d.items()), key=itemgetter(1), reverse=True):
        yield key, value

def getStopwords():
    stopwords=[]
    with open("stopwords_en.txt", "r") as f:
        for line in f:
            stopwords.extend(line.split())
    return stopwords


def printByFreq(dict):
    view = [(v,k) for k,v in dict.items()]
    view.sort(reverse=True)
    for v, k in view:
        print("\t{0}\t{1}".format(k, v))

def printByAlphabetic(dict):
    for key, value in sorted(dict.items()):
        print("\t{0}\t{1}".format(key,value))

def text_statistics(filename, to_lower=True, remove_stopwords=True):
    dicword ={}
    dicchar ={}
    linecounter = 0
    numberWords = 0
    numberWordsNoStop = 0
    vocab = 0
    numberSymbols = 0
    numberUniqueSymbols = 0
    with open(filename, "r") as f:
        for line in f:
            linecounter = linecounter+1
            line = clean_text(line)
            #WORD BLOCK
            if(to_lower):
                line = line.lower()
            words = line.split()
            numberWords += len(words)
            if(remove_stopwords):
                words = list(filter(lambda a: a not in stopwords, words))
                numberWordsNoStop += len(words)
            for n in words:
                if n in dicword:
                    dicword[n] = dicword[n]+1
                else:
                    vocab += 1
                    dicword[n] = 1
            #SYMBOL BLOCK
            chars = re.findall(r"[\w]","".join(words))
            for n in chars:
                if n in dicchar:
                    numberSymbols +=1
                    dicchar[n] = dicchar[n]+1
                else:
                    numberUniqueSymbols +=1
                    numberSymbols +=1
                    dicchar[n] = 1

    print("Lines:",linecounter)
    print("Number words (with stopwords):",numberWords)
    print("Number words (without stopwords):",numberWordsNoStop)
    print("Vocabulary size:", vocab)
    print("Number of symbols:", numberSymbols)
    print("Number of different symbols:",numberUniqueSymbols)

    print("Words (alphabetical order):")
    printByAlphabetic(dicword)

    print("Words(by frequency):")
    printByFreq(dicword)

    print("Symbols(alphabetical order):")
    printByAlphabetic(dicchar)

    print("Symbols (by frequency):")
    printByFreq(dicchar)



def syntax():
    print ("\n%s filename.txt [to_lower?[remove_stopwords?]\n" % sys.argv[0])
    sys.exit()

if __name__ == "__main__":
    stopwords = getStopwords()
    if len(sys.argv) < 2:
        syntax()
    name = sys.argv[1]
    lower = False
    stop = False
    if len(sys.argv) > 2:
        lower = (sys.argv[2] in ('1', 'True', 'yes'))
        if len(sys.argv) > 3:
            stop = (sys.argv[3] in ('1', 'True', 'yes'))
    text_statistics(name, to_lower=lower, remove_stopwords=stop)
