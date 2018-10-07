#!/usr/bin/octave -qf
if (nargin!=7)
printf("Usage: pcaexp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk>\n");
exit(1);
end
arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
mink=str2num(arg_list{5});
stepk=str2num(arg_list{6});
maxk=str2num(arg_list{7});
load(trdata);
load(trlabs);
load(tedata);
load(telabs);

[W, m]=pca(X);
c = length(unique(xl));
res=[];
for k = mink:stepk:maxk
    XR=W(:,1:k)'*(X-m);
    YR=W(:,1:k)'*(Y-m);
    [Wlda]=lda(XR, xl);
    kk = min(c-1, k);
	for r = 25:1:35  
		XRR=Wlda(:,1:r)'*XR;
	        YRR=Wlda(:,1:r)'*YR;
	        err=knn(XRR,xl,YRR,yl,1);
		res=[res;k r err];
		k
		r
		err
	endfor
endfor
save PCA+LDA.txt res
