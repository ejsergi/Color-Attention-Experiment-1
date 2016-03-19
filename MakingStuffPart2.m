clear all
close all

%%%%
L_Target = 50;
Deviation = 1;
HueRange = 10:40:350;
meansvalues = ones(size(HueRange))*0;
HueDeviation = 10;
SL_Target = 50;
SDeviation = 1;
sHueRange = [0 360];
%%%%


[TESTMoni,info,legendIm,infoSur] = CreatePatt_Hue...
    (meansvalues,L_Target,Deviation,HueRange,HueDeviation,SL_Target,SDeviation,sHueRange);

imshow(TESTMoni);
imwrite(TESTMoni,'SecondPart.png');