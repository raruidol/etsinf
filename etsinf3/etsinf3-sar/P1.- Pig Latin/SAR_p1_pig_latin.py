#!/usr/bin/env python
#! -*- encoding: utf8 -*-

"""
1.- Pig Latin

Nombre Alumno: Marti Roman, Salvador

Nombre Alumno: Ruiz Dolz, Ramon
"""

import sys
import re


def piglatin_word(word):
    """
    Esta función recibe una palabra en inglés y la traduce a Pig Latin

    :param word: la palabra que se debe pasar a Pig Latin
    :return: la palabra traducida
    """
    # COMPLETAR
    vowel = ["a","e","i","o","u","y","A","E","I","O","U","Y"]
    if not word.isalpha():
        return word
    if word[0] in vowel:
        if word.isupper():
            word += 'YAY'
        else: 
            word += 'yay'

    else:
        if not word.isupper():
            if word[0].isupper():
                word = word.lower()
                while word[0] not in vowel:
                    aux = word[0]
                    word += aux
                    word = word[1:]
                word = word.title()
                word += 'ay'
            else:
                while word[0] not in vowel:
                    aux = word[0]
                    word += aux
                    word = word[1:]
                word += 'ay'
        else:
            while word[0] not in vowel:
                aux = word[0]
                word += aux
                word = word[1:]
            word += 'AY'
    return word


def piglatin_sentence(sentence):
    """
    Esta función recibe una frase en inglés i la traduce a Pig Latin

    :param sentence: la frase que se debe pasar a Pig Latin
    :return: la frase traducida
    """
    # COMPLETAR
    sentence = re.findall(r"[\w']+|[.,!?; ]", sentence)
    result = ""
    for word in sentence:
        if word.isalpha():
            result += piglatin_word(word)
        else:
            result += word
    return  result


if __name__ == "__main__":
    if len(sys.argv) == 2:
        print (piglatin_sentence(sys.argv[1]))
    #Lectura/escritura de ficheros:
    elif len(sys.argv) == 3 and sys.argv[1] == "-f":
        name = sys.argv[2]
        filein = open(name)
        fileout = open(name[:-4]+"_piglatin.txt", 'w+')
        for line in filein:
            fileout.write(piglatin_sentence(line))
            fileout.write("\n")
    #Modo interactivo:
    else:
        while True:
            inp = input()
            if inp=="":
                break
            else:
                print (piglatin_sentence(inp))
        pass
