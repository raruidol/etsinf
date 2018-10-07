#!/usr/bin/octave -qf

disp("Loading data...");
load("data/usps/tr.dat");
load("data/usps/trlabels.dat");
load("data/usps/ts.dat");
load("data/usps/tslabels.dat");
disp("Data load complete.");

S=[]
minerr = Inf
bestC=0
bestK=2
C=10

par = cstrcat('-t ',num2str(bestK),' -c ',num2str(C));
svm = svmtrain(trlabels, tr, par);

number = tr(svm.sv_indices(1476),:);
number = reshape(number,16,16);

imshow(1.-number')
sleep(10)
