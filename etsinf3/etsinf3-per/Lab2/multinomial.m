#!/usr/bin/octave -qf

if (nargin!=1)
    printf("Usage: multinomial.m <data_filename>");
    exit(1);
end

arglist=argv();
datafile=arglist{1};
disp("Loading data...");
load(datafile);
disp("Data load complete.");

[nrows,ncols]=size(data);

for e = 1:20

	epsilon = 10.^-e
	rand("seed",23);
	all_err=[];
	for i = 1:30
		
		%Barajado y particion de las muestras
		perm=randperm(nrows);
		pdata=data(perm,:);

		trper=0.9;
		ntr=floor(nrows*trper);
		nte=nrows-ntr;
		tr=pdata(1:ntr,:);
		te=pdata(ntr+1:nrows,:);
		
		%Probabilidades a priori
		n = rows(tr);
		p=length(find(tr(:,end)==1));
		pspam=p/n;
		pham=1-pspam;

	    %Probabilidades multinomiales
	    i=find(tr(:,end)==1);
	    xnSpam=sum(tr(i,1:end-1));
	    xndSpam=sum(sum(tr(i,1:end-1)));

	    i=find(tr(:,end)==0);
	    xnHam=sum(tr(i,1:end-1));
	    xndHam=sum(sum(tr(i,1:end-1)));

	    pmultiSpam = xnSpam/xndSpam;
	    pmultiHam = xnHam/xndHam;

        %Suavizado
        
        numeradorS = pmultiSpam+epsilon;
        denominadorS = sum(pmultiSpam+epsilon);
        suavS = numeradorS/denominadorS;


        numeradorH = pmultiHam+epsilon;
        denominadorH = sum(pmultiHam+epsilon);
        suavH = numeradorH/denominadorH;

        %Clasificador con suavizado
		wh=log(suavH);
		ws=log(suavS);
		wh0=log(pham);
		ws0=log(pspam);
		x = te(:,1:end-1);
		gh = wh*x'+wh0;
		gs = ws*x'+ws0;

		%Error con suavizado
		c = te(:, end);
		clas = gh<gs;
		errorSuav=sum(c != clas');
		perrSuav=(errorSuav/rows(c))*100;

		all_err(end+1) = perrSuav;
	
	endfor

	%Calculo de la media de errores
	media_err=mean(all_err);
	media_err

	%Calculo de la desviación típica
	desvtip_err=std(all_err)

endfor




