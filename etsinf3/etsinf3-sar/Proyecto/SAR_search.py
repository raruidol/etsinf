from Compendium import *
import sys

loadedCompendiumName='newsComp'

if __name__ == '__main__':
    if len(sys.argv) > 1:
        loadedComp = loadCompendium(sys.argv[1])
    else:
        loadedComp = loadCompendium(loadedCompendiumName)
    while True:
            print("Introduzca su busqueda: ")
            query = input()
            if query=="":
                print('Hasta la próxima! :D')
                break
            else:
                loadedComp.search(query)
    pass
