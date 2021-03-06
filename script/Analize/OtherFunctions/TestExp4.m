clear all
close all

Moni = iccread('ColorNavSergiExp.icc');
ProfLab = iccread('Generic Lab Profile.icc');

Lab2Moni = makecform('icc', ProfLab, Moni);
Moni2Lab = makecform('icc', Moni, ProfLab);

load('PointsLab.mat');

npixels = 1440;

%% SURROUND

%%%%
SL_Target = 50; SDeviation = 1;
sHueRange = [0 360];
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

imshow(TESTMoni);

Lm = TESTLab(:,:,1); am = TESTLab(:,:,2); bm = TESTLab(:,:,3); 

info = struct('mean',[mean(Lm(:)) mean(am(:)) mean(bm(:))],'std',[std(Lm(:)) std(am(:)) std(bm(:))]);

%% Diferent distribution

%%%%
L_Target = 50; Deviation = 1;
HueRange = [90 100];
%%%%

nnpixels = round(npixels/8);

Sel = logical((Li<=L_Target+Deviation).*(Li>=L_Target-Deviation)...
    .*(Hue<HueRange(2)).*(Hue>HueRange(1)));

sL = Li(Sel); sa = ai(Sel); sb = bi(Sel);

sRadsel1 = floor(rand(nnpixels)*(size(sL,1)-1)+1);
sRadsel2 = floor(rand(nnpixels)*(size(L,1)-1)+1);

sTESTLab1 = cat(3,sL(sRadsel1),sa(sRadsel1),sb(sRadsel1));
sTESTLab2 = cat(3,L(sRadsel2),a(sRadsel2),b(sRadsel2));


meansvalues = -0.6:0.1:0.2;
posible = zeros(npixels);
legendIm = zeros(npixels);
posible(nnpixels:end-nnpixels,nnpixels:end-nnpixels) = 1;

for i=1:9
    
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

Rand2 = rand(nnpixels)+MEANVALUE;
Rand2 = cat(3,Rand2,Rand2,Rand2);

sTESTLab = zeros(size(sTESTLab1));
sTESTLab(Rand2<0.5) = sTESTLab2(Rand2<0.5);
sTESTLab(Rand2>=0.5) = sTESTLab1(Rand2>=0.5);

sTESTMoni = applycform(sTESTLab,Lab2Moni);

TESTMoni(xpos-round(nnpixels/2)+1:xpos+round(nnpixels/2),ypos-round(nnpixels/2)+1:ypos+round(nnpixels/2),:) = sTESTMoni;

imshow(TESTMoni);

Lm = sTESTLab(:,:,1); am = sTESTLab(:,:,2); bm = sTESTLab(:,:,3); 

info(i+1).mean=[mean(Lm(:)) mean(am(:)) mean(bm(:))];
info(i+1).std=[std(Lm(:)) std(am(:)) std(bm(:))];

posible(xpos-nnpixels:xpos+nnpixels,ypos-nnpixels:ypos+nnpixels) = 0;

legendIm(xpos-round(nnpixels/2)+1:xpos+round(nnpixels/2),ypos-round(nnpixels/2)+1:ypos+round(nnpixels/2)) = i;

end