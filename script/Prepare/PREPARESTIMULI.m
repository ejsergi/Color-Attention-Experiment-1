clear all
close all

%%%%%
%Please add the number of set of stimuli (observers) you want to create,
%and which one is the last one already created
num_set = 10; 
last_created = 20;
%%%%%

addpath('Other');

for nexper=last_created+1:last_created+num_set

tic    
    
nameExp = sprintf('%03d',nexper);

mkdir('/Users/sergietchebehere/Desktop/STIMULIS/',nameExp);

info = struct([]);
%%
%%%%
L_Target = 50;
Deviation = 50;
SL_Target = 50;
SDeviation = 50;
sHueRange = [0 360];
%%%%
MEANSTOCHOI = (-0.49:0.0125:-0.2);

for hue = 10:20:350
    HueRange = [hue-10 hue+10];
    
    for invi=1:3
    
    choi = randperm(length(MEANSTOCHOI));
    
    for i=1:3
        
        meansvalues = MEANSTOCHOI(choi((i-1)*8+1:(i*8)));

[TESTMoni,means,legendIm,meansSur] = CreatePatt_MeanValue...
    (meansvalues,L_Target,Deviation,HueRange,SL_Target,SDeviation,sHueRange);

info(end+1).L_Stimuli = 'All';
info(end).Hue_Stimuli = int2str(hue);
info(end).meansSur = meansSur;
info(end).means = means;
[~,index] = sortrows([means.MEANMIXTURE].');
info(end).index = index(end:-1:1);

imwrite(TESTMoni,['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' ...
    sprintf('%03d',length(info)) '.png']);
imwrite(legendIm,['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/L' ...
    sprintf('%03d',length(info)) '.png']);
    end
    end
    
    disp(['Hue angle ' int2str(hue)]);
    
end
%%
%%%%
L_Target = 50;
Deviation = 1;
SL_Target = 50;
SDeviation = 1;
sHueRange = [0 360];
%%%%
MEANSTOCHOI = (-0.49:0.0125:-0.2);

for hue = 10:20:350
    HueRange = [hue-10 hue+10];
    
    for invi=1:3
    
    choi = randperm(length(MEANSTOCHOI));
    
    for i=1:3
        
        meansvalues = MEANSTOCHOI(choi((i-1)*8+1:(i*8)));

[TESTMoni,means,legendIm,meansSur] = CreatePatt_MeanValue...
    (meansvalues,L_Target,Deviation,HueRange,SL_Target,SDeviation,sHueRange);

info(end+1).L_Stimuli = '50';
info(end).Hue_Stimuli = int2str(hue);
info(end).meansSur = meansSur;
info(end).means = means;
[~,index] = sortrows([means.MEANMIXTURE].');
info(end).index = index(end:-1:1);

imwrite(TESTMoni,['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' ...
    sprintf('%03d',length(info)) '.png']);
imwrite(legendIm,['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/L' ...
    sprintf('%03d',length(info)) '.png']);
    end
    end
    
    disp(['Hue angle ' int2str(hue)]);
    
end

%%
%%%%
L_Target = 25;
Deviation = 1;
SL_Target = 25;
SDeviation = 1;
sHueRange = [0 360];
%%%%
MEANSTOCHOI = (-0.49:0.0125:-0.2);

for hue = 10:20:350
    HueRange = [hue-10 hue+10];
    
    for invi=1:3
    
    choi = randperm(length(MEANSTOCHOI));
    
    for i=1:3
        
        meansvalues = MEANSTOCHOI(choi((i-1)*8+1:(i*8)));

[TESTMoni,means,legendIm,meansSur] = CreatePatt_MeanValue...
    (meansvalues,L_Target,Deviation,HueRange,SL_Target,SDeviation,sHueRange);

info(end+1).L_Stimuli = '25';
info(end).Hue_Stimuli = int2str(hue);
info(end).meansSur = meansSur;
info(end).means = means;
[~,index] = sortrows([means.MEANMIXTURE].');
info(end).index = index(end:-1:1);

imwrite(TESTMoni,['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' ...
    sprintf('%03d',length(info)) '.png']);
imwrite(legendIm,['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/L' ...
    sprintf('%03d',length(info)) '.png']);
    end
    end
    
    disp(['Hue angle ' int2str(hue)]);
    
end

%%
%%%%
L_Target = 75;
Deviation = 1;
SL_Target = 75;
SDeviation = 1;
sHueRange = [0 360];
%%%%
MEANSTOCHOI = (-0.49:0.0125:-0.2);

for hue = 10:20:350
    HueRange = [hue-10 hue+10];
    
    for invi=1:3
    
    choi = randperm(length(MEANSTOCHOI));
    
    for i=1:3
        
        meansvalues = MEANSTOCHOI(choi((i-1)*8+1:(i*8)));

[TESTMoni,means,legendIm,meansSur] = CreatePatt_MeanValue...
    (meansvalues,L_Target,Deviation,HueRange,SL_Target,SDeviation,sHueRange);

info(end+1).L_Stimuli = '75';
info(end).Hue_Stimuli = int2str(hue);
info(end).meansSur = meansSur;
info(end).means = means;
[~,index] = sortrows([means.MEANMIXTURE].');
info(end).index = index(end:-1:1);

imwrite(TESTMoni,['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' ...
    sprintf('%03d',length(info)) '.png']);
imwrite(legendIm,['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/L' ...
    sprintf('%03d',length(info)) '.png']);
    end
    end
    
    disp(['Hue angle ' int2str(hue)]);
    
end
%%

save(['STIMULISinfo/' nameExp '.mat'],'info','-v7.3');

end_time = toc;

disp(['End exp. ' nameExp ' (Time used: ' mat2str(end_time/(60*60),4) 'h)']);



end

