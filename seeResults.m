clear all
close all

addpath('Profiles and Colors/');
Moni = iccread('ColorNavSergiExp.icc');
ProfLab = iccread('Generic Lab Profile.icc');

Lab2Moni = makecform('icc', ProfLab, Moni);
Moni2Lab = makecform('icc', Moni, ProfLab);


pix2deg = 49;

nameExp = '025';



load(['EXPERIMENTFILES/' nameExp '.mat']);
load(['ImportET/ET_' nameExp '.mat']);

%%
sele = [1:9:648 2:9:648 3:9:648];
permu = info(1).Permutation;

check = 1:3;
Xresol = (2560-1440)/2;

CHROMAS = ((-0.49:0.0125:-0.2)+1)*30-14;

FinalInfo = info(check); FinalInfo = rmfield(FinalInfo,'Permutation');
for i=1:length(check)
[~,I] = find(sele==check(i));
Take=(cell2mat(EyeEvents(:,1))==I);
ETData  = EyeEvents(Take,:);

fixations = strcmp(ETData(:,4),'Fixation');
saccades = strcmp(ETData(:,4),'Saccade');
right = strcmp(ETData(:,5),'Right');

eFix = ETData(logical(fixations.*right),:);
eSac = ETData(logical(saccades.*right),:);

imLa = im2double(imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/L' sprintf('%03d',check(i)) '.png']));
imS = im2double(imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' sprintf('%03d',check(i)) '.png']));
LabIm = applycform(imS,Moni2Lab);
aIm = LabIm(:,:,2);
bIm = LabIm(:,:,3);

imL = imerode(bwlabel(imLa),strel('disk',1));

imChroma = zeros(size(imL));

for j=1:8
    
    loc = (imL==j);
    ChromaVal(j) = sqrt(mean(aIm(loc)).^2+mean(bIm(loc)).^2);
    realChroma(j) = info(check(i)).means(j).MEANMIXTURE;
    STATS = regionprops(loc,'Centroid');
    center = STATS.Centroid;
    lenCent(j) = sqrt((center(1)-720).^2+(center(2)-720).^2);
    angCent(j) = wrapTo360(atan2d(center(1)-720,center(2)-720));
    
end
[~,SorChroma] = sort(ChromaVal);
newChrom = sort((realChroma+1)*30-14);
lenCent = lenCent(SorChroma);
angCent = angCent(SorChroma);
for j=1:8
    loc = (imL==j);
    loc = imdilate(loc,strel('disk',floor(newChrom(SorChroma==j)*12)));
    imChroma(loc) = newChrom(SorChroma==j);
end

if i==0||i==1||i==2||i==3

figure(1); imshow(imS);
figure(2);
for j=1:size(eFix,1);
    
    imshow(imChroma,[]); hold on
    colormap(hot),colorbar;
        
    plot(str2num(cell2mat(eFix(j,12)))-Xresol,...
        str2num(cell2mat(eFix(j,13))),'go','MarkerSize',cell2mat(eFix(j,11))/2);
    plot(str2num(cell2mat(eFix(j,12)))-Xresol,...
        str2num(cell2mat(eFix(j,13))),'g+','MarkerSize',10); hold off;
    
    waitforbuttonpress;
    
end
end

ptsFix = [];
outoftotal = NaN(1,24);
outoftotal(ismember(CHROMAS,unique(imChroma))) = 0;
for j=1:size(eFix,1);
    x = floor(str2num(cell2mat(eFix(j,12)))-Xresol);
    y = floor(str2num(cell2mat(eFix(j,13))));
    disx = floor(str2num(cell2mat(eFix(j,17))));
    disy = floor(str2num(cell2mat(eFix(j,18))));
    diambig = 75;
    if x-diambig>0&&x+diambig<=1440&&y-diambig>0&&y+diambig<=1440
    fixi = zeros(size(imChroma));
    fixi = insertShape(fixi,'FilledCircle',[x y diambig],'Color','white','Opacity',1);
    fixi = fixi(:,:,1);
    patFix = imLa.*fixi;
    STATS = regionprops(logical(patFix), 'Area','Centroid');
    if ~isempty(STATS)
        area = []; centroid=[];
        for t=1:length(STATS);
            area(t) = STATS(t).Area;
            centroidcenter = floor(STATS(t).Centroid);
            ptsFix = [ptsFix imChroma(centroidcenter(2),centroidcenter(1))];
            fixloc = find(CHROMAS==imChroma(centroidcenter(2),centroidcenter(1)));
            if outoftotal(fixloc)==0, outoftotal(fixloc) = max(outoftotal)+1; end
        end
    end
    end
end


frstPatch = ptsFix(1);
frstTime = cell2mat(eFix(i,11));
[~,IP] = find(permu==I);
FinalInfo(i).nFixations = size(eFix,1);
FinalInfo(i).nSaccades = size(eSac,1);
FinalInfo(i).ChromaValues = unique(imChroma);
FinalInfo(i).EccenMag = lenCent/pix2deg;
FinalInfo(i).EccenAng = angCent;
FinalInfo(i).PointsFix = unique(ptsFix);
FinalInfo(i).PointsFixOrder = ptsFix;
FinalInfo(i).FixOfTotal = outoftotal;
FinalInfo(i).FirstFix = frstPatch;
FinalInfo(i).FirstFixTime = frstTime;
if IP>1
FinalInfo(i).PreviousL = info(sele(permu(IP-1))).L_Stimuli;
FinalInfo(i).PreviousHue = info(sele(permu(IP-1))).Hue_Stimuli;
end
FinalInfo(i).Position = IP;
end
%%
A(1,:) = CHROMAS;
A(2,:) = zeros(1,24);
for i=1:3
    for j=1:8
        A(2,CHROMAS==FinalInfo(i).ChromaValues(j+1)) = FinalInfo(i).EccenMag(j);
    end
end
A(3,:) = zeros(1,24);
sumat = FinalInfo(1).LastSeen+FinalInfo(2).LastSeen+FinalInfo(3).LastSeen;
A(3,end-sumat+1:end) = 1;
A(4,:) = FinalInfo(1).FixOfTotal;
A(5,:) = FinalInfo(2).FixOfTotal;
A(6,:) = FinalInfo(3).FixOfTotal;