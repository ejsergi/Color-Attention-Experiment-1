clear all
close all

addpath('Profiles and Colors/');
Moni = iccread('ColorNavSergiExp.icc');
ProfLab = iccread('Generic Lab Profile.icc');

Lab2Moni = makecform('icc', ProfLab, Moni);
Moni2Lab = makecform('icc', Moni, ProfLab);

pix2deg = 49;

Xresol = (2560-1440)/2;

CHROMAS = ((-0.49:0.0125:-0.2)+1)*30-14;

expnames = [11,12,14,15,16,18,19,20,21,22,24,25];
sele = [1:9:648 2:9:648 3:9:648];

CloseDis = ones(3,24,18*4,12)*30;


for nex = 1:length(expnames);
    
nameExp = sprintf('%03d',expnames(nex));

load(['EXPERIMENTFILES/' nameExp '.mat']);
load(['ImportET/ET_' nameExp '.mat']);


permu = info(1).Permutation;

iter = 1;
for t=1:4
for n=1:18
    
CloseDis(1,:,(t-1)*18+n,nex) = CHROMAS;
for i=1:3
[~,I] = find(sele==iter);
Take=(cell2mat(EyeEvents(:,1))==I);
ETData = EyeEvents(Take,:);

fixations = strcmp(ETData(:,4),'Fixation');
saccades = strcmp(ETData(:,4),'Saccade');
right = strcmp(ETData(:,5),'Right');

eFix = ETData(logical(fixations.*right),:);

imLa = im2double(imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/L' sprintf('%03d',iter) '.png']));
imS = im2double(imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' sprintf('%03d',iter) '.png']));
LabIm = applycform(imS,Moni2Lab);
aIm = LabIm(:,:,2);
bIm = LabIm(:,:,3);
imL = bwlabel(imLa);
imChroma = zeros(size(imL));
imLabel = zeros(size(imL));
for j=1:8
    loc = (imL==j);
    ChromaVal(j) = sqrt(mean(aIm(loc)).^2+mean(bIm(loc)).^2);
    realChroma(j) = info(iter).means(j).MEANMIXTURE;
end
[~,SorChroma] = sort(ChromaVal);
newChrom = sort((realChroma+1)*30-14);

for j=1:8
    loc = (imL==j);
    STATS = regionprops(loc,'Centroid');
    center = STATS.Centroid;
    Ind = find(CHROMAS==newChrom(SorChroma==j));
    for e=1:size(eFix,1);
    x = floor(str2num(cell2mat(eFix(e,12)))-Xresol);
    y = floor(str2num(cell2mat(eFix(e,13))));
    
    distanceEye = sqrt((center(1)-x).^2+(center(2)-y).^2)/pix2deg;
    AngleEye = wrapTo360(atan2d(center(1)-x,center(2)-y));
    if CloseDis(2,Ind,(t-1)*18+n,nex)>distanceEye
        CloseDis(2,Ind,(t-1)*18+n,nex)=distanceEye;
        CloseDis(3,Ind,(t-1)*18+n,nex)=AngleEye;
    end
    end
    if CloseDis(2,Ind,(t-1)*18+n,nex)==100
        CloseDis(2,Ind,(t-1)*18+n,nex)=15;
    end
end
iter=iter+1;
end
iter = iter+6;
end
end
end

save('PatchDistance.mat','CloseDis');