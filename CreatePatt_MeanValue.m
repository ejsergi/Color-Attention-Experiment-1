function [TESTMoni,info,legendIm,infoSur] = CreatePatt_MeanValue...
    (meansvalues,L_Target,Deviation,HueRange,SL_Target,SDeviation,sHueRange)
%%%%%
% meansvalues = ((CHANGING VARIABLE)) Mean between stimuli and background 
%   (0 means 50%, -1 means 0% and 1 means 100%) 
% L_Target = Mean luminance of stimuli
% Deviation = Luminance deviation of stimuli (50 to get all)
% HueRange = Range of stimuly hue
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

TESTMoni = applycform(TESTLab,Lab2Moni);

% imshow(TESTMoni);

Lm = TESTLab(:,:,1); am = TESTLab(:,:,2); bm = TESTLab(:,:,3); 

Huem = atan2d(bm,am);
Huem(Huem<0) = Huem(Huem<0)+360;
Chromam = sqrt((am.^2)+(bm.^2));

infoSur = struct('mean',[mean(Lm(:)) sqrt((mean(am(:)).^2)+(mean(bm(:)).^2)) wrapTo360(atan2d(mean(bm(:)),mean(am(:))))],'std',[std(Lm(:)) std(Chromam(:)) std(Huem(:))]);
%% Diferent distribution

%%%%

%%%%

nnpixels = round(npixels/8)+20;

Sel = logical((Li<=L_Target+Deviation).*(Li>=L_Target-Deviation)...
    .*(Hue<HueRange(2)).*(Hue>HueRange(1)));

sL = Li(Sel); sa = ai(Sel); sb = bi(Sel);

sRadsel1 = floor(rand(nnpixels)*(size(sL,1)-1)+1);
sRadsel2 = floor(rand(nnpixels)*(size(L,1)-1)+1);

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
    
    if posible(xpos,ypos)==1
        FALSE = 0;
    end
    
end
%%%%%%
MEANVALUE = meansvalues(i);
%%%%%%

circlePixels = drawcircle(npixels,xpos,ypos,round(nnpixels/2-20));
pcirclePixels = drawcircle(nnpixels,round(nnpixels/2),round(nnpixels/2),round(nnpixels/2-20));


Rand2 = rand(nnpixels)+MEANVALUE; % ADD GAUSSIAN STUFF HERE
Rand2 = cat(3,Rand2,Rand2,Rand2);

sTESTLab = zeros(size(sTESTLab1));
sTESTLab(Rand2<0.5) = sTESTLab2(Rand2<0.5);
sTESTLab(Rand2>=0.5) = sTESTLab1(Rand2>=0.5);

sTESTMoni = applycform(sTESTLab,Lab2Moni);

TESTMoni(circlePixels==1) = sTESTMoni(pcirclePixels==1);

% imshow(TESTMoni);

Lm = sTESTLab(:,:,1); am = sTESTLab(:,:,2); bm = sTESTLab(:,:,3); 

Huem = atan2d(bm,am);
Huem(Huem<0) = Huem(Huem<0)+360;
Chromam = sqrt((am.^2)+(bm.^2));

info(i).MEANMIXTURE = MEANVALUE;
info(i).mean=[mean(Lm(:)) sqrt((mean(am(:)).^2)+(mean(bm(:)).^2)) wrapTo360(atan2d(mean(bm(:)),mean(am(:))))];
info(i).std=[std(Lm(:)) std(Chromam(:)) std(Huem(:))];

posible(xpos+1-nnpixels:xpos-1+nnpixels,ypos+1-nnpixels:ypos-1+nnpixels) = 0;

legendIm(xpos-round(nnpixels/2)+1:xpos+round(nnpixels/2),ypos-round(nnpixels/2)+1:ypos+round(nnpixels/2)) = i;

end