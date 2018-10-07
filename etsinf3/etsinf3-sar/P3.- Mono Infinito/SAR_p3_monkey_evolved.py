#Ramón Ruiz Dolz
#Salvador Martí Román
import sys
import random
import ast
#Dictionary with an int corresponding amount of words (used for random value)
wordCountDict = {}
indexDict = {}

def constructDictionaries(file):
    with open(f1) as file:
        DictEntry = file.read().split("\n")
        for entry in DictEntry:
            entry = entry.split("\t")
            if (len(entry)==4):
                indexDict[entry[1]]=ast.literal_eval(entry[3])

    for entry in indexDict.keys():
        wordCountDict[entry] = sum(indexDict[entry].values())

def selectNextWord(currentWord):
    chosen = random.randint(1,wordCountDict[currentWord])
    nextWord="EMPTY_ENTRY"
    while (chosen > 0):
        nextWord = random.choice(list(indexDict[currentWord].keys()))
        chosen = chosen - indexDict[currentWord][nextWord]
    return nextWord


def monkeyBusiness(sentenceCount):
    for i in range(0,sentenceCount):
        sentence="$"
        currentWord='$'
        for j in range (1,25):
            currentWord = selectNextWord(currentWord)
            sentence += " "+currentWord
            if(currentWord=="$"):
                break
        print(sentence)




if __name__ == "__main__":
    if len(sys.argv)!=2:
        print("Wrong number of arguments")
        sys.exit()
    f1 = sys.argv[1]
    constructDictionaries(f1)
    monkeyBusiness(10)