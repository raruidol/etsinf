if __name__ == '__main__':
    while True:
        try:    
            num = input()
            if num:
                num = int(num)
                aux = 1
                not_found = True
                while not_found:
                    if aux % num == 0:
                        print(len(str(aux)))
                        not_found = False
                    else:
                        aux = (aux*10)+1
        except EOFError:
            break