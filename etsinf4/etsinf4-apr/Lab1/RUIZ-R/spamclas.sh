#!/usr/bin/octave -qf

disp("Loading data...");
load("data/spam/tr.dat");
load("data/spam/trlabels.dat");
load("data/spam/ts.dat");
load("data/spam/tslabels.dat");
disp("Data load complete.");
C=0.01
S=[]
for kernel = 0:3


		%Obtención de la SVM
		par = cstrcat('-t ',num2str(kernel),' -c ',num2str(C));
		svm = svmtrain(trlabels, tr, par);

		%Obtencion del error de clasificación con la SVM anterior
		[labels, accuracy, param] = svmpredict(tslabels,ts, svm,' ');

		N=rows(tslabels);

		acc = accuracy(1)/100;
		err = 1-(accuracy(1)/100);

		conf1 = err+1.96*sqrt((err*acc)/N);
		conf2 = err-1.96*sqrt((err*acc)/N);

		data=cstrcat('Kernel:',num2str(kernel),' C:',num2str(C),' Error:',num2str(err),' Intervalo1:',num2str(conf1),' Intervalo2:',num2str(conf2));
		S=[S; data];


endfor

S
