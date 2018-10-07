function [pca, meanvect] = pca(w)
    #Numero de clases(n)
    n=columns(w);
    #Numero de dimensiones(D)
    D=rows(w);
    #Calculo del vector media sumando todas las columnas de 
    #la matriz y partiendo por n
    sumat=sum(w,2);
    meanvect = sumat./n;
    #Calculo de la matriz de covarianza restando a cada columna 
    #el vector media, multiplicando por la transpuesta y partiendo por n
    A = w.-meanvect;
    covarmat=A*A';
    covarmat=covarmat./n;
    #Obtencion de los eigenvectores y eigenvalores
    [eigenvectors, eigenvalues]=eig(covarmat);
    #Puesto que los vectores se encuentran en la diagonal, estos se 
    #vectorizan y se ordenan, guardando el indice y usando este para 
    #ordenar la matriz de eigenvectores con el nuevo orden de los eigenvalores "index"
    eigenvalues = diag(eigenvalues);
    [sorted, index]=sort(eigenvalues);
    index=flip(index);
    pca=eigenvectors(:,index);
endfunction
