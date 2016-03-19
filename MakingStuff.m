clear all
close all

nameExp = 'EXPERIMENT1Andres';

info = struct([]);
% load('EXPERIMENT1.mat');

for hue = 10%:20:350
    %MEANSTOCHOI = ([-0.495:0.005:-0.4 -0.3:0.1:0]);
    MEANSTOCHOI = (-0.5:0.7/24:0.2);
    choi = randperm(length(MEANSTOCHOI));
    
    for i=1%:3
%%%%
meansvalues = MEANSTOCHOI(choi((i-1)*8+1:(i*8)));
L_Target = 50;
Deviation = 1;
HueRange = [hue-10 hue+10];
SL_Target = 50;
SDeviation = 1;
sHueRange = [0 360];
%%%%

[TESTMoni,means,legendIm,meansSur] = CreatePatt_MeanValue...
    (meansvalues,L_Target,Deviation,HueRange,SL_Target,SDeviation,sHueRange);

info(end+1).L_Stimuli = '50';
info(end).Hue_Stimuli = int2str(hue);
info(end).L_Background = '50';
info(end).Hue_Background = 'All';
info(end).meansSur = meansSur;
info(end).means = means;
[~,index] = sortrows([means.MEANMIXTURE].');
info(end).index = index(end:-1:1);
info(end).image = TESTMoni;
info(end).guide = legendIm;

% imwrite(TESTMoni,['IMAGES/1-Changing Mean/5-30_30_All/' int2str(hue) '_' int2str(i) '.png']);
    end
    
    disp(['Hue angle ' int2str(hue)]);
    
end

imshow(TESTMoni)

%imwrite(TESTMoni,['FIGURESPRESENTATION/IMAGEAll.png']);
%%

% infosimple = rmfield(info,{'image','guide'});
% 
% save(['/Volumes/myshares/Sergis share/ExperimentFiles/' nameExp '.mat'],'info','-v7.3');
% save(['EXPERIMENTFILES/' nameExp 'Simple.mat'],'infosimple','-v7.3');


%%

CHROMAS = [info(1).means info(2).means info(3).means];
[~,index1] = sortrows([CHROMAS.MEANMIXTURE].'); CHROMAS = CHROMAS(index1); clear index1;

for i=1:length(CHROMAS)
    
    valu(i) = CHROMAS(i).mean(2);
    
end

