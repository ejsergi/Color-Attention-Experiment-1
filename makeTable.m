close all
clear all

expnames = [11,12,14,15,16,17,18,19,20,21,22,24,25];
seleold = [1:9:648 2:9:648 3:9:648];
sele = sort(seleold);

FINALTABLE = cell(length(sele)*length(expnames)+1,15);
FINALTABLE{1,1} = 'Observer';
FINALTABLE{1,2} = 'L*';
FINALTABLE{1,3} = 'Hue';
FINALTABLE{1,4} = 'Ch.1';
FINALTABLE{1,5} = 'Ch.2';
FINALTABLE{1,6} = 'Ch.3';
FINALTABLE{1,7} = 'Ch.4';
FINALTABLE{1,8} = 'Ch.5';
FINALTABLE{1,9} = 'Ch.6';
FINALTABLE{1,10} = 'Ch.7';
FINALTABLE{1,11} = 'Ch.8';
FINALTABLE{1,12} = 'Reported';
FINALTABLE{1,13} = 'Time';
FINALTABLE{1,14} = 'Previous L*';
FINALTABLE{1,15} = 'Previous Hue';


for nex = 1:length(expnames);
experimentname = sprintf('%03d',expnames(nex));
load(['EXPERIMENTFILES/' experimentname '.mat']);
permu = info(1).Permutation;
for i = 1:length(sele);  
FINALTABLE{(nex-1)*length(sele)+i+1,1} = experimentname; 
FINALTABLE{(nex-1)*length(sele)+i+1,2} = info(sele(i)).L_Stimuli; 
FINALTABLE{(nex-1)*length(sele)+i+1,3} = info(sele(i)).Hue_Stimuli;
for j=1:8
chromaval(j) = (info(sele(i)).means(j).MEANMIXTURE+1)*30-14;
end
chromaval=sort(chromaval);
for j=1:8
FINALTABLE{(nex-1)*length(sele)+i+1,3+j} = chromaval(j);
end
FINALTABLE{(nex-1)*length(sele)+i+1,12} = info(sele(i)).LastSeen;
FINALTABLE{(nex-1)*length(sele)+i+1,13} = info(sele(i)).Time;
[~,I] = find(seleold==sele(i));
[~,IP] = find(permu==I);
if IP>1;
FINALTABLE{(nex-1)*length(sele)+i+1,14} = info(seleold(permu(IP-1))).L_Stimuli;
FINALTABLE{(nex-1)*length(sele)+i+1,15} = info(sele(permu(IP-1))).Hue_Stimuli;
end
end
end
cell2csv('ALLINFOTABLE.csv',FINALTABLE);