function [W] = lda(X,xl)
    #Numero de clases (n)
    n=columns(X);
    #Numero de dimensiones (D)
    D=rows(X);
    #Calculo del vector media sumando todas las columnas de 
    #la matriz y partiendo por n
    sumat=sum(X,2);
    meanvect = sumat./n;
    #Inicializacion de las matrices intra y entre clases
    Sb=0;
    Sw=0;
    #Inicio del loop que itera clase a clase
    for c = unique(xl)
      #Separacion por clases
      ind=find(xl==c);
      Xc=X(:,ind);
      #Calculo del vector media de cada clase sumando la matriz de 
      #clase y partiendolo por el numero de elementos de la clase(nc)
      nc=columns(Xc);
      sumatC=sum(Xc,2);
      meanvectC=sumatC./nc;
      #Calculo de la matriz entre clases
      Sb=Sb+nc*((meanvectC-meanvect)*(meanvectC-meanvect)');
      #Calculo de la matriz de covarianza propia de la clase
      A = Xc-meanvectC;
      covarmat=A*A';
      covarmat=covarmat./nc;
      #Mediante la matriz de covarianza, calculo de la matriz intra clases
      Sw=Sw+covarmat;
    endfor
    #Obtencion de los eigenvectores y eigenvalores generalizados
    [eigenvectors, eigenvalues]=eig(Sb,Sw);
    #Puesto que los vectores se encuentran en la diagonal, estos se 
    #vectorizan y se ordenan, guardando el indice y usando este para 
    #ordenar la matriz de eigenvectores con el nuevo orden de los eigenvalores "index"
    eigenvalues = diag(eigenvalues);
    [sorted, index]=sort(eigenvalues);
    index=flip(index);
    W=eigenvectors(:,index);
endfunction


