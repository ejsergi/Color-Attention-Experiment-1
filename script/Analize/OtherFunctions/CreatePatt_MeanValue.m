function [FinalTESTMoni,info,legendIm,infoSur] = CreatePatt_MeanValue...
    (meansvalues,L_Target,Deviation,HueRange,SL_Target,SDeviation,sHueRange)
%%%%%
% meansvalues = ((CHANGING VARIABLE)) Mean between stimuli and background 
%   (0 means 50%, -1 means 0% and 1 means 100%) 
% L_Target = Mean luminance of stimuli
% Deviation = Luminance deviation of stimuli (50 to get all)
% HueRange = Range of stimuli hue
% SL_Target = Mean luminance of background
% SDeviation = Luminance deviation of background (50 to get all)
% sHueRange = Range of background hue
%%%%%

Moni = iccread('ColorNavSergiExp.icc');
ProfLab = iccread('Generic Lab Profile.icc');

Lab2Moni = makecform('icc', ProfLab, Moni);
Moni2Lab = makecform('icc', Moni, ProfLab);

load('PointsLab.mat');

npixels = 1440;

%% SURROUND

%%%%

%%%%

Li = pointsLab(:,1); ai = pointsLab(:,2); bi = pointsLab(:,3);

Hue = atan2d(bi,ai);
Chroma = sqrt((ai.^2)+(bi.^2));
Hue(Hue<0) = Hue(Hue<0)+360;

sSel = logical((Li<=SL_Target+SDeviation).*(Li>=SL_Target-SDeviation)...
    .*(Hue<sHueRange(2)).*(Hue>sHueRange(1)));

L = Li(sSel); a = ai(sSel); b = bi(sSel);

Radsel = floor(rand(npixels)*(size(L,1)-1)+1);

TESTLab = cat(3,L(Radsel),a(Radsel),b(Radsel));

TESTMoni = TESTLab;

% imshow(TESTMoni);

Lm = TESTLab(:,:,1); am = TESTLab(:,:,2); bm = TESTLab(:,:,3); 

Huem = atan2d(bm,am);
Huem(Huem<0) = Huem(Huem<0)+360;
Chromam = sqrt((am.^2)+(bm.^2));

infoSur = struct('mean',[mean(Lm(:)) sqrt((mean(am(:)).^2)+(mean(bm(:)).^2)) wrapTo360(atan2d(mean(bm(:)),mean(am(:))))],'std',[std(Lm(:)) std(Chromam(:)) std(Huem(:))]);
%% Diferent distribution

nnpixels = round(npixels*tand(1)*26*2/(13+3/8));

Sel = logical((Li<=L_Target+Deviation).*(Li>=L_Target-Deviation)...
    .*(Hue<HueRange(2)).*(Hue>HueRange(1)));

sL = Li(Sel); sa = ai(Sel); sb = bi(Sel);

sRadsel1 = floor(rand(npixels)*(size(sL,1)-1)+1);
sRadsel2 = floor(rand(npixels)*(size(L,1)-1)+1);

sTESTLab1 = cat(3,sL(sRadsel1),sa(sRadsel1),sb(sRadsel1));
sTESTLab2 = cat(3,L(sRadsel2),a(sRadsel2),b(sRadsel2));


posible = zeros(npixels);
legendIm = zeros(npixels);
posible(nnpixels:end-nnpixels,nnpixels:end-nnpixels) = 1;
info = struct([]);
for i=1:length(meansvalues);
    
FALSE = 1;

while FALSE==1
    
    xpos = randperm(npixels,1);
    ypos = randperm(npixels,1);
    
    if posible(ypos,xpos)==1
        FALSE = 0;
    end
    
end
%%%%%%
MEANVALUE = meansvalues(i);
%%%%%%

circlePixels = drawcircle(npixels,xpos,ypos,round(nnpixels/2));
pcirclePixels = drawcircle(npixels,xpos,ypos,round(nnpixels*1.25));


Rand2 = rand(npixels)+MEANVALUE; % ADD GAUSSIAN STUFF HERE
Rand2 = cat(3,Rand2,Rand2,Rand2);

sTESTLab = zeros(size(sTESTLab1));
sTESTLab(Rand2<0.5) = sTESTLab2(Rand2<0.5);
sTESTLab(Rand2>=0.5) = sTESTLab1(Rand2>=0.5);

sTESTMoni = sTESTLab;

% fil = fspecial('gaussian',[round(nnpixels/2) round(nnpixels/2)],round(nnpixels/6));
% 
% B = imfilter(double(circlePixels),fil);

B = imgaussian(double(circlePixels),round(nnpixels/6),round(nnpixels/2));

C = rand(npixels);
C = cat(3,C,C,C);

T = (C+B)/2;
F = zeros(size(T));
F(T>0.5)=1;

TESTMoni(F==1) = sTESTMoni(F==1);

% imshow(TESTMoni);

Lm = sTESTLab(:,:,1); am = sTESTLab(:,:,2); bm = sTESTLab(:,:,3); 

Huem = 0;
Huem(Huem<0) = Huem(Huem<0)+360;
Chromam = sqrt((am.^2)+(bm.^2));

info(i).MEANMIXTURE = MEANVALUE;
info(i).mean=[mean(Lm(:)) sqrt((mean(am(:)).^2)+(mean(bm(:)).^2)) wrapTo360(atan2d(mean(bm(:)),mean(am(:))))];
info(i).std=[std(Lm(:)) std(Chromam(:)) std(Huem(:))];

posible = posible-double(pcirclePixels(:,:,1));

legendIm(circlePixels(:,:,1)==1) = i;

end

FinalTESTMoni = applycform(TESTMoni,Lab2Moni);
end