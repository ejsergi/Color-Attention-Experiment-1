close all
clear all

expnames = [11,12,14,15,16,18,19,20,21,22,24,25];
partID = {'SK','AU','YB','SH','SB','SY','AZ','FC','MX','NP','EF','SE'};
seleold = [1:9:648 2:9:648 3:9:648];
sele = sort(seleold);

FINALTABLE = cell(length(sele)*length(expnames)+1,15);
FINALTABLE{1,1} = 'Participant #';
FINALTABLE{1,2} = 'Participant ID';
FINALTABLE{1,3} = 'Stimulus squence order';
FINALTABLE{1,4} = 'Stimulus type';
FINALTABLE{1,5} = 'Stimulus ID';
FINALTABLE{1,6} = 'L*';
FINALTABLE{1,7} = 'Preceding L*';
FINALTABLE{1,8} = 'Hue angle';
FINALTABLE{1,9} = 'Patch Chroma value';
FINALTABLE{1,10} = 'Eccentricity';
FINALTABLE{1,11} = 'Location Angle';
FINALTABLE{1,12} = 'Reported';
FINALTABLE{1,13} = 'Number of reported';
FINALTABLE{1,14} = 'Fixated';
FINALTABLE{1,15} = 'Number of fixation per path';
FINALTABLE{1,16} = 'Total number of fixations per stimulus';
FINALTABLE{1,17} = 'Order of first fixation on the path';
FINALTABLE{1,18} = 'Distance between fixation and path';
FINALTABLE{1,19} = 'Angle between fixation and path';
FINALTABLE{1,20} = 'Dwell time per patch';
FINALTABLE{1,21} = 'Total dwell time per stimulus';

load('F3_BNY.mat');

tablepos = 1;
for nex = 1:length(expnames);
experimentname = sprintf('%03d',expnames(nex));
load(['EXPERIMENTFILES/' experimentname '.mat']);
permu = info(1).Permutation;
for i = 1:length(sele);  
for j=1:8
chromaval(j) = (info(sele(i)).means(j).MEANMIXTURE+1)*30-14;
end
chromaval=sort(chromaval);
[~,I] = find(seleold==sele(i));
[~,IP] = find(permu==I);
Ai = A(:,:,floor((i+2)/3),nex);
Li = L(:,:,floor((i+2)/3),nex);
Ti = T(:,:,floor((i+2)/3),nex);
LPatch = mod((i+2),3)+2;
for j=1:8
    tablepos = tablepos+1;
    posPatch = find(Ai(1,:)==chromaval(j));
    
    FINALTABLE{tablepos,1} = experimentname;
    FINALTABLE{tablepos,2} = partID{nex};
    FINALTABLE{tablepos,3} = IP;
    FINALTABLE{tablepos,4} = ['H' info(sele(i)).Hue_Stimuli 'L' info(sele(i)).L_Stimuli];
    if IP>1
    FINALTABLE{tablepos,5} = [FINALTABLE{tablepos,4} '_' info(seleold(permu(IP-1))).L_Stimuli];
    FINALTABLE{tablepos,7} = info(seleold(permu(IP-1))).L_Stimuli;
    end
    FINALTABLE{tablepos,6} = info(sele(i)).L_Stimuli;
    FINALTABLE{tablepos,8} = info(sele(i)).Hue_Stimuli;
    FINALTABLE{tablepos,9} = chromaval(j);
    FINALTABLE{tablepos,10} = Ai(2,posPatch);
    FINALTABLE{tablepos,11} = Ai(5,posPatch);
    FINALTABLE{tablepos,12} = j>(8-info(sele(i)).LastSeen);
    FINALTABLE{tablepos,13} = info(sele(i)).LastSeen;
    FINALTABLE{tablepos,14} = Ai(LPatch+2,posPatch)>0;
    FINALTABLE{tablepos,15} = sum(Li(2:4,posPatch));
    FINALTABLE{tablepos,16} = sum(Li(LPatch,:),2);
    FINALTABLE{tablepos,17} = sum(Ai(4:6,posPatch));
    FINALTABLE{tablepos,18} = Ai(6,posPatch);
    FINALTABLE{tablepos,19} = Ai(7,posPatch);
    FINALTABLE{tablepos,20} = sum(Ti(2:4,posPatch));
    FINALTABLE{tablepos,21} = info(sele(i)).Time;
end
end
end

cell2csv('ALLINFOTABLE.csv',FINALTABLE);