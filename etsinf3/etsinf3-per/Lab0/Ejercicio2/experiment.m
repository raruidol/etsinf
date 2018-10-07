#!/usr/bin/octave -qf

load("OCR_14x14.gz"); 
[N,L]=size(data); D=L-1;
ll=unique(data(:,L)); 
C=numel(ll); rand("seed",23);
data=data(randperm(N),:);
[w,E,k]=perceptron(data(1:round(.7*N),:));
M=N-round(.7*N); te=data(N-M+1:N,:);
rl=zeros(M,1);
rl=ll(linmachMatrix(w,M))
[nerr m]=confus(te(:,L),rl)

#for m=1:M 
#  tem=[1 te(m,1:D)]';
#  rl(m)=ll(linmach(w,tem)); end
