#!/usr/bin/octave -qf

disp("Loading data...");
load("data/usps/tr.dat");
load("data/usps/trlabels.dat");
load("data/usps/ts.dat");
load("data/usps/tslabels.dat");
disp("Data load complete.");

S=[]
minerr = Inf
bestK=4
C=0.01
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

		if minerr>err

			minerr=err
			bestK = kernel
		end



endfor

par = cstrcat('-t ',num2str(bestK),' -c ',num2str(C));
svm = svmtrain(trlabels, tr, par);


minerr
S


