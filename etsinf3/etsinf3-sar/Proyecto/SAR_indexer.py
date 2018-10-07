from Compendium import *
import os
import sys

if __name__ == '__main__':

    if len(sys.argv)>1:
        path = sys.argv[1]
        savedCompName = sys.argv[2]
    else:
        path = "./mini_enero"
        savedCompName = "newsComp"
        
    collection = sorted(os.listdir(path))
    newsCompendium = Compendium()

    for volume in collection:
        print(path + "/" + volume)
        newsCompendium.addToCompendium(path + "/" + volume, True, False)
    newsCompendium.saveCompendium(savedCompName)

    print('Successfully saved '+path+" to "+savedCompName+".")