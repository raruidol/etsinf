#!/usr/bin/octave -qf

disp("Loading data...");
load("data/mini/trSep.dat");
load("data/mini/trSeplabels.dat");
disp("Data load complete.");

%Obtención de la SVM 
svm = svmtrain(trlabels, tr, '-t 0 -c 1000');

%Obtención de los multiplicadores de Lagrange
alpha = svm.sv_coef

%Obtención del vector de pesos
w1=sum(alpha'*tr(svm.sv_indices,1));
w2=sum(alpha'*tr(svm.sv_indices,2));
w=[w1;w2]

%Obtención del umbral de la función discriminante lineal
umbral=sign(alpha(1))-(w1*tr(svm.sv_indices(1),1)+w2*tr(svm.sv_indices(1),2))

%Obtención de los vectores de soporte
vect_sop = [tr(svm.sv_indices,1),tr(svm.sv_indices,2)]

%Parametros de la recta
m=w1/w2
d=umbral/w2

%Parametros margen
d1=(umbral-1)/w2
d2=(umbral+1)/w2

%Impresión de la gráfica
t = 0:1:7;
plot (tr(trlabels==1,1),tr(trlabels==1,2),"s r",
	  tr(trlabels==2,1),tr(trlabels==2,2),"o b",
	  t, -m*t-d,
	  t,-t*m - d2,
	  t,-t*m - d1,
	  tr(svm.sv_indices,1),tr(svm.sv_indices,2),"x k");
axis([0,7,0,7]);
sleep(10)
