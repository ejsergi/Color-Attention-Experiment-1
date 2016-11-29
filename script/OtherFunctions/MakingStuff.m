clear all
close all

addpath('Profiles and Colors/')
addpath('OtherFunctions/')

nameExp = 'EXPERIMENT1Andres';

info = struct([]);
%%%%
L_Target = 50;
Deviation = 50;
SL_Target = 50;
SDeviation = 50;
sHueRange = [0 360];
%%%%
MEANSTOCHOI = ([-0.495:0.005:-0.4 -0.3:0.1:0]);

for hue = 10%:20:350
    HueRange = [hue-10 hue+10];
    
    
    choi = randperm(length(MEANSTOCHOI));
    
    for i=1%:3
        
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
    
    disp(['Hue angle ' int2str(hue)]);
    
end

imshow(TESTMoni)

% imwrite(TESTMoni,'/Users/ejsergi/Documents/MATLAB/Git/Color-Attention-Experiment-1/Test.png');
% prompt = 'What is the original value? ';
% x = input(prompt)
%%

% infosimple = rmfield(info,{'image','guide'});
% 
% save(['/Volumes/myshares/Sergis share/ExperimentFiles/' nameExp '.mat'],'info','-v7.3');
% save(['EXPERIMENTFILES/' nameExp 'Simple.mat'],'infosimple','-v7.3');


%

% CHROMAS = [info(1).means info(2).means info(3).means];
% [~,index1] = sortrows([CHROMAS.MEANMIXTURE].'); CHROMAS = CHROMAS(index1); clear index1;
% 
% for i=1:length(CHROMAS)
%     
%     valu(i) = CHROMAS(i).mean(2);
%     
% end

