function A = eyeMatrix(nameExp, info,EyeEvents,check)

addpath('Profiles and Colors/');
Moni = iccread('ColorNavSergiExp.icc');
ProfLab = iccread('Generic Lab Profile.icc');

Lab2Moni = makecform('icc', ProfLab, Moni);
Moni2Lab = makecform('icc', Moni, ProfLab);

pix2deg = 49;

%%
sele = [1:9:648 2:9:648 3:9:648];
permu = info(1).Permutation;

Xresol = (2560-1440)/2;

CHROMAS = ((-0.49:0.0125:-0.2)+1)*30-14;

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

imL = bwlabel(imLa);

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
for j=1:8
    loc = (imL==j);
    imChroma(loc) = newChrom(SorChroma==j);
end

ptsFix = [];
outoftotal = zeros(1,24);
for j=1:size(eFix,1);
    x = floor(str2num(cell2mat(eFix(j,12)))-Xresol);
    y = floor(str2num(cell2mat(eFix(j,13))));
    disx = floor(str2num(cell2mat(eFix(j,17))));
    disy = floor(str2num(cell2mat(eFix(j,18))));
    diambig = 50;
    if x-diambig>0&&x+diambig<=1440&&y-diambig>0&&y+diambig<=1440
    fixi = zeros(size(imChroma));
    fixi = insertShape(fixi,'FilledCircle',[x y diambig],'Color','white','Opacity',1);
    fixi = fixi(:,:,1);
    patFix = imLa.*fixi;
    STATS = regionprops(logical(patFix),'Centroid');
    if ~isempty(STATS)
        centroid=[];
        for t=1:length(STATS);
            centroidcenter = floor(STATS(t).Centroid);
            ptsFix = [ptsFix imChroma(centroidcenter(2),centroidcenter(1))];
            fixloc = find(CHROMAS==imChroma(centroidcenter(2),centroidcenter(1)));
            if outoftotal(fixloc)==0, outoftotal(fixloc) = max(outoftotal)+1; end
        end
    end
    end
end

ChromaValues(i,:) = unique(imChroma);
EccenMag(i,:) = lenCent/pix2deg;
FixOfTotal(i,:) = outoftotal;

end
%%
A(1,:) = CHROMAS;
A(2,:) = zeros(1,24);
for i=1:3
    for j=1:8
        A(2,CHROMAS==ChromaValues(i,j+1)) = EccenMag(i,j);
    end
end
A(3,:) = zeros(1,24);
sumat = info(check(1)).LastSeen+info(check(2)).LastSeen+info(check(3)).LastSeen;
A(3,end-sumat+1:end) = 1;
A(4:6,:) = FixOfTotal;
end