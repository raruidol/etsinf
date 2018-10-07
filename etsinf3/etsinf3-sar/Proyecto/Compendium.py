import re
from nltk.corpus import stopwords
from nltk.tokenize import *
import xml.etree.ElementTree as ET
import io
import pickle
import math
import datetime
from collections import OrderedDict
DATE=2
CATEGORY=7
TITLE=11
TEXT=12
STOPWORDS = stopwords.words('spanish')
ID=1
SNIPPET_SENTENCE_RETURN_AMOUNT = 2
MAX_DISPLAY_RESULT_AMOUNT = 10
NOTHING=[]
DEFAULT_LOGICAL_OP='AND'
class Compendium(object):
    title = {}
    text = {}
    category = {}
    date = {}
    router = {}
    def __init__(self):
        self.title=OrderedDict()
        self.text=OrderedDict()
        self.category=OrderedDict()
        self.date=OrderedDict()
        self.router=OrderedDict()

    def addTitleToCompendium(self, newsTitle, docID, includeStopwords, stemming):
        temp={}

        newsTitle=re.sub("[\!\¡\"\'\(\)\,\\.\-\:\;\¿\?\[\]\«\»]+",'',newsTitle.lower())
        if(not(includeStopwords)):
            newsTitle=re.sub(STOPWORDS,'',newsTitle)
        #nonstoptext=[word for word in word_tokenize(filterContent) if word.lower() not in stopWords]
        newsTitle=word_tokenize(newsTitle)

        for index in range(0,len(newsTitle)-1):
            word = newsTitle[index]
            # Creating tuple with TotalFreq and a dictionary per docID
            if word not in self.title:
                self.title[word] = [0, OrderedDict()]

            if word in temp:
                temp[word][0] += 1
                temp[word][1].append(index)
                #Updating the total frequency of a term
                self.title[word][0] += 1
            else:
                temp[word]=[1,[index]]

        for word, value in temp.items():
            #Adding a list (FreqPerDoc, (pos,pos,pos...)) to the docID dictionary inside main dictionary[1]
            self.title[word][1].update({docID:value})
            self.title[word][0]+=1

    def addTextToCompendium(self, newsText, docID, includeStopwords, stemming):
        temp={}


        newsText=re.sub("[\!\¡\"\'\(\)\,\\.\-\:\;\¿\?\[\]\«\»]+",'',newsText.lower())
        if(not(includeStopwords)):
            newsText=re.sub(STOPWORDS,'',newsText)
        #nonstoptext=[word for word in word_tokenize(filterContent) if word.lower() not in stopWords]
        newsText=word_tokenize(newsText)

        for index in range(0,len(newsText)-1):
            word = newsText[index]
            # Creating tuple with TotalFreq and a dictionary per docID
            if word not in self.text:
                self.text[word] = [0, OrderedDict()]

            if word in temp:
                temp[word][0] += 1
                temp[word][1].append(index)
                #Updating the total frequency of a term
                self.text[word][0] += 1
            else:
                temp[word]=[1,[index]]

        for word, value in temp.items():
            #Adding a list (FreqPerDoc, (pos,pos,pos...)) to the docID dictionary inside main dictionary[1]
            self.text[word][1].update({docID:value})
            self.text[word][0] += 1

    def addDateToCompendium(self,newsDate, docID,includeStopwords, stemming):
        temp={}
        newsDate=re.sub("[\!\¡\"\'\(\)\,\\.\-\:\;\¿\?\[\]\«\»]+",'',newsDate.lower())
        if(not(includeStopwords)):
            newsDate=re.sub(STOPWORDS,'',newsDate)
        #nonstoptext=[word for word in word_tokenize(filterContent) if word.lower() not in stopWords]
        # Creating tuple with TotalFreq and a dictionary per docID
        if newsDate not in self.date:
            self.date[newsDate] = [0, OrderedDict()]

        if newsDate in temp:
            temp[newsDate][0] += 1
            temp[newsDate][1].append(0)
            #Updating the total frequency of a term
            self.date[newsDate][0] += 1
        else:
            temp[newsDate]=[1,[0]]

        for newsDate, value in temp.items():
            #Adding a list (FreqPerDoc, (pos,pos,pos...)) to the docID dictionary inside main dictionary[1]
            self.date[newsDate][1].update({docID:value})
            self.date[newsDate][0] += 1


    def addCategoryToCompendium(self,newsCategory, docID,includeStopwords, stemming):
        temp={}
        newsCategory=re.sub("[\!\¡\"\'\(\)\,\\.\-\:\;\¿\?\[\]\«\»]+",'',newsCategory.lower())
        if(not(includeStopwords)):
            newsCategory=re.sub(STOPWORDS,'',newsCategory)
        #nonstoptext=[word for word in word_tokenize(filterContent) if word.lower() not in stopWords]

        # Creating tuple with TotalFreq and a dictionary per docID
        if newsCategory not in self.category:
            self.category[newsCategory] = [0, OrderedDict()]

        if newsCategory in temp:
            temp[newsCategory][0] += 1
            #temp[newsCategory][1].append(index)

            #Updating the total frequency of a term
            self.category[newsCategory][0] += 1
        else:
            temp[newsCategory]=[1,[0]]

        for newsCategory, value in temp.items():
            #Adding a list (FreqPerDoc, (pos,pos,pos...)) to the docID dictionary inside main dictionary[1]
            self.category[newsCategory][1].update({docID:value})
            self.category[newsCategory][0] += 1

    def addRouteToCompendium(self,docID,fileName,position):
        self.router[docID]=(fileName,position)

    def addToCompendium(self, file ,stopwords, stemming):
        #Creates a tree given a markup language in a file
        volume = "<Aux>"+io.open(file, encoding="utf8").read()+"</Aux>"
        volume = ET.fromstring(volume)
        position=0
        for doc in volume:
            self.addRouteToCompendium(str(doc[ID].text),str(file),position)
            self.addTitleToCompendium(str(doc[TITLE].text),doc[ID].text, stopwords, stemming)
            self.addTextToCompendium(str(doc[TEXT].text),doc[ID].text,stopwords, stemming)
            self.addDateToCompendium(str(doc[DATE].text),doc[ID].text,stopwords, stemming)
            self.addCategoryToCompendium(str(doc[CATEGORY].text),doc[ID].text,stopwords, stemming)
            position+=1
    def getFreqInTitle(self,word, docID=None):
        try:
            if docID is None:
                return self.title[word.lower()][0]
            else:
                return self.title[word.lower()][1][docID][0]
        except KeyError:
            return(0)

    def getFreqInText(self, word, docID=None):
        try:
            if docID is None:
                return self.text[word.lower()][0]
            else:
                return self.text[word.lower()][1][docID][0]
        except KeyError:
            return(0)

    def getFreqInCategory(self,word, docID=None):
        try:
            if docID is None:
                return self.category[word.lower()][0]
            else:
                return self.category[word.lower()][1][docID][0]
        except KeyError:
            return(0)

    def getFreqInDate(self, word, docID=None):
        try:
            if docID is None:
                return self.date[word.lower()][0]
            else:
                return self.date[word.lower()][1][docID][0]
        except KeyError:
            return(0)

    def getTitlePositionsInDoc(self, word, docID):
        try:
            return self.title[word.lower()][1][docID][1]
        except KeyError:
            return(NOTHING)

    def getTextPositionsInDoc(self, word, docID):
        try:
            return self.text[word.lower()][1][docID][1]
        except KeyError:
            return(NOTHING)

    def getDocsWithDate(self,date):
        try:
            return self.date[date][1].keys()
        except KeyError:
            return(NOTHING)

    #To be extended upon for more than one word
    def getDocsWithText(self, word):
        try:
            return self.text[word.lower()][1].keys()
        except KeyError:
            return(NOTHING)
    #To be extended upon for more than one word
    def getDocsWithTitle(self,word):
        try:
            return self.title[word.lower()][1].keys()
        except KeyError:
            return(NOTHING)

    def getDocsWithCategory(self,category):
        try:
            return self.category[category.lower()][1].keys()
        except KeyError:
            return(NOTHING)

    def saveCompendium(self,file):
        f = open(file,'wb')
        pickle.dump(self,f,-1)
        f.close()

    def displayText(self,docID):
        #Returns a string text of the document with that ID
        try:
            volume = "<Aux>" + io.open(self.router[docID][0], encoding="utf8").read() + "</Aux>"
            volume = ET.fromstring(volume)
            return  str(volume[self.router[docID][1]][TEXT].text)
        except KeyError:
            return("no results were found.")

    def displayTitle(self,docID):
        #Returns a string title of the document with that ID
        try:
            volume = "<Aux>" + io.open(self.router[docID][0], encoding="utf8").read() + "</Aux>"
            volume = ET.fromstring(volume)
            return str(volume[self.router[docID][1]][TITLE].text)
        except KeyError:
            return("Sadly,")

    def getSnippet(self,docID,searchTerms):
        returned=0
        snippet=""
        for term in searchTerms:

            position=list(self.getTextPositionsInDoc(term,docID))
            if position != []:
                snippet+=self.getSentence(position.pop(),docID)+"\n"
                returned+=1
            if returned >= SNIPPET_SENTENCE_RETURN_AMOUNT:
                break
        return snippet
        #Since we have already the list of docIDs and the search terms
        #We can obtain the positions of those terms in the text
        #by calling getTextPositionsInDoc(searchTerm, docID)
        #Then print sentences with words that are in those positions


    def getSentence(self,position,docID):
        text=self.displayText(docID)
        sentences=text.split(".")
        counter=0
        for sentence in sentences:
            counter+=len(sentence.split(" "))
            if counter > position:
                return sentence
        return "No text found"

        #DOESNT ADMIT SYNTAX
    def getWeight(self,term,doc): #ToBeTested
        TextFreq=self.getFreqInText(term, doc)
        TitleFreq=self.getFreqInTitle(term, doc)

        tf=int(TextFreq+TitleFreq)
        if tf is not 0:
            tf=1+math.log10(tf)

        idf = int(len(self.getDocsWithTitle(term)) + len(self.getDocsWithText(term)))
        idf /= int(len(list(self.router.keys())))

        return tf*idf


    def orderByRelevance(self,docList,searchTerms): #ToBeTested
        weightList=[]
        for doc in docList:
            docWeight=0
            for term in searchTerms:
                docWeight+=self.getWeight(term,doc)
            weightList.append(docWeight)

        orderedTermList=list(zip(*sorted(zip(weightList,docList))))
        #We zip it, order it, then unzip it to obtain the ordered by relevance term list
        return orderedTermList[1]

        #Here we use idf weighting to determine the relevance of each doc
        #and return and ordered list.
        #We obtain the frequencies from getFreqInText(self, word, docID)
        #Not specifying docID will return the total number of uses of that term
        #in the compendium

        pass

    def displayResults(self,docList,searchTerms,time): #ToBeTested
        amount=len(docList)
        if docList == []:
            return "No results were found."
        docList=self.orderByRelevance(docList,searchTerms)
        if(amount <= 2):
            for doc in docList:
                if doc is not []:
                    print(self.displayTitle(str(doc)))
                    print("\t"+self.displayText(str(doc)))
                    print("\t" + "From: " + str(self.router[doc][0]) + "\n")
        elif(amount<=5):
            for doc in docList:
                if doc is not []:
                    print(self.displayTitle(str(doc)))
                    print("\t"+self.getSnippet(doc,searchTerms))
                    print("\t"+"From: " + str(self.router[doc][0])+"\n")
        else:
            for i, j in zip(range(MAX_DISPLAY_RESULT_AMOUNT),range(len(docList))):
                if i==MAX_DISPLAY_RESULT_AMOUNT:
                    break
                if j==MAX_DISPLAY_RESULT_AMOUNT:
                    break
                print(self.displayTitle(str(docList[i])))
                print("\t" + "From: " + str(self.router[docList[i]][0]) + "\n")
                i+=1
                j+=1
        print(str(len(docList))+" results found in "+str(time.total_seconds())+" seconds.")

    def getResults(self, query, inverted=False):
        terms=[]
        laux=[]
        if ':' in query:
            search = query.split(':', 1)
            if (search[0] == 'headline'):
                laux = self.getDocsWithTitle(search[1])
                if(inverted):
                    laux = [doc for doc in list(self.router.keys()) if doc not in laux]
                if laux != NOTHING:
                    terms.append(search[1])
            elif (search[0] == 'date'):
                laux = self.getDocsWithDate(search[1])
                if(inverted):
                    laux = [doc for doc in list(self.router.keys()) if doc not in laux]
                if laux != NOTHING:
                    terms.append(search[1])
            elif (search[0] == 'category'):
                laux = self.getDocsWithCategory(search[1])
                if(inverted):
                    laux = [doc for doc in list(self.router.keys()) if doc not in laux]
                if laux != NOTHING:
                    terms.append(search[1])
            elif (search[0] == 'text'):
                laux = self.getDocsWithText(search[1])
                if(inverted):
                    laux = [doc for doc in list(self.router.keys()) if doc not in laux]
                if laux != NOTHING:
                    terms.append(search[1])
            return (laux, terms)
        else:
            laux = self.getDocsWithText(query)
            if (inverted):
                laux = [doc for doc in list(self.router.keys()) if doc not in laux]
            if laux != NOTHING:
                terms.append(str(query))
            return (laux, terms)

    def search(self, input): #Search 2.0 including boolean logic
        words=input.split(" ")
        terms=[[]]
        logic=[[]]
        previousIsLogic = True
        previousIsNot = False
        searchAmount = 0
        for i in range(len(words)):
            if words[i] not in ['AND','OR']:
                if(previousIsLogic==False):
                    searchAmount+=1
                    logic.append([])
                    terms.append([])
                    previousIsNot=False
                previousIsLogic=False
                if (previousIsNot == False):
                    if words[i] == 'NOT':
                        i = i + 1
                        result=self.getResults(str(words[i]),True)
                        logic[searchAmount].append(result[0])
                        previousIsNot = True
                        previousIsLogic = True
                    else:
                        result=self.getResults(str(words[i]))
                        logic[searchAmount].append(result[0])
                        terms[searchAmount].append(words[i])
                        previousIsNot = False
                        previousIsLogic = False
            else:
                previousIsLogic=True
                logic[searchAmount].append(words[i])
                previousIsNot=False
        searchTerms=0

        if(DEFAULT_LOGICAL_OP=='AND'): #If no operator two terms will form an AND
            aux=[]
            auxTerms=[]
            for i in range(len(logic)):
                if(i>0 and i<=(len(logic))):
                    aux.append('AND')
                for elem in logic[i]:
                    aux.append(elem)
            for term in terms:
                if term != []:
                    for elem in term:
                        auxTerms.append(elem)
            logic=[aux]
            terms=[auxTerms]
            searchTerms=0

        for search in logic:
            t1 = datetime.datetime.utcnow()
            aux = []
            if len(search) <= 2:
                t2 = datetime.datetime.utcnow()
                time = t2-t1
                self.displayResults(list(search[0]),terms[searchTerms],time)
            else:
                for i in range (len(search)-2):
                    if(search[i+1]=="AND"):
                        search[i+2]=mergeAND(list(search[i]),list(search[i+2]))
                        aux.append(search[i+2])
                    elif(search[i+1]=="OR"):
                        search[i+2]=mergeOR(list(search[i]),list(search[i+2]))
                        aux.append(search[i+2])
                t2 = datetime.datetime.utcnow()
                time = t2-t1
                self.displayResults(list(aux[-1]),terms[searchTerms],time)
            searchTerms+=1

def loadCompendium(file):
    with open(file, 'rb') as input:
        return pickle.load(input)

def mergeAND(l1, l2):
    res = []
    p1 = 0
    p2 = 0
    while p1 <= len(l1)-1 and p2 <= len(l2)-1:
        if l1[p1] == l2[p2]:
            res.append(l1[p1])
            p1 = p1 + 1
            p2 = p2 + 1
        else:
            if l1[p1] < l2[p2]:
                p1 = p1 + 1
            else:
                p2 = p2 + 1
    return res

def mergeOR(l1, l2):
    res = []
    p1 = 0
    p2 = 0
    while p1 <= len(l1)-1 and p2 <= len(l2)-1:
        if l1[p1] == l2[p2]:
            res.append(l1[p1])
            p1 = p1 + 1
            p2 = p2 + 1
        else:
            if l1[p1] < l2[p2]:
                res.append(l1[p1])
                p1 = p1 + 1
            else:
                res.append(l2[p2])
                p2 = p2 + 1
    while p1 <= len(l1)-1:
        res.append(l1[p1])
        p1 = p1 + 1
    while p2 <= len(l2)-1:
        res.append(l2[p2])
        p2 = p2 + 1
    return res