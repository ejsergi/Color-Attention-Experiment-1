%{
Different ANOVA test will be conducted in this function. ANOVA for variable
being hue, lightness and observers. All of the result show significant
difference. Then there have been checked whether there is a correlation
between the different lightness, matrix has been calculated and shown to
have a correlation coeficient bigger than 0.5.
%}

clear all
close all

%Load all the A data
load('F3_ANY.mat'); 

 %Get the reported info
repo = permute(mean(A(3,:,:,:),2),[3,4,1,2]);

%Adapt number of reported to chroma
repo = ((1-repo)*(9.925-1.3))+1.3; 

%Re-transform to have the hues as columns and participants and lightness as
%rows
rerepot = [repo(1:18,:) repo(18+(1:18),:) repo(2*18+(1:18),:)...
    repo(3*18+(1:18),:)]'; 

%Re-transform anova to have the 4 lighness as coulmns and rest as rows
rerep = [reshape(repo(1:18,:),1,[]); reshape(repo(18+(1:18),:),1,[]); ...
    reshape(repo(2*18+(1:18),:),1,[]); reshape(repo(3*18+(1:18),:),1,[]);]'; 

%Run ANOVA test
p_hues = anova1(rerepot);
p_observers = anova1(repo);
p_lightness = anova1(rerep(:,2:4));

%Run t-test

[h,p_lightness] = ttest2(rerep(:,1),rerep(:,2));

[R,p] = corrcoef(rerep);