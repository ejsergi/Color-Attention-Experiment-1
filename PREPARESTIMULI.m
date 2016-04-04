clear all
close all

addpath('Profiles and Colors/')
addpath('OtherFunctions/')

nameExp = '001';

info = struct([]);
%%%%
L_Target = 50;
Deviation = 1;
SL_Target = 50;
SDeviation = 1;
sHueRange = [0 360];
%%%%
MEANSTOCHOI = ([-0.495:0.005:-0.4 -0.3:0.1:0]);

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
info(end).image = TESTMoni;
info(end).guide = legendIm;

% imwrite(TESTMoni,['IMAGES/1-Changing Mean/5-30_30_All/' int2str(hue) '_' int2str(i) '.png']);
    end
    end
    
    disp(['Hue angle ' int2str(hue)]);
    
end

infosimple = rmfield(info,{'image','guide'});
 
save(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '.mat'],'info','-v7.3');
save(['STIMULIS/' nameExp 'Simple.mat'],'infosimple','-v7.3');
