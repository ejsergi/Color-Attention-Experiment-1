clear all
close all

nameExp = 'EXPERIMENT1Sergi';

load(['/Volumes/myshares/Sergis share/ExperimentFiles/' nameExp '.mat']);
load(['EXPERIMENTFILES/' nameExp 'Simple.mat']);


%%
clearvars -except info infosimple nameExp
close all

PsychDefaultSetup(2);

screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);
[xCenter, yCenter] = RectCenter(windowRect);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

permu = randperm(length(info));

for i=1:length(permu);
    tic
theImage = info(permu(i)).image;
imageTexture = Screen('MakeTexture', window, theImage); 
[s1, s2, s3] = size(theImage);
Screen('DrawTextures', window, imageTexture);
Screen('Flip', window);

LastSeen = input([int2str(i) '/' int2str(length(info)) ': ']);
info(permu(i)).LastSeen = LastSeen;

% KbWait;

Screen('FillRect', window, black);
Screen('Flip', window);

info(permu(i)).Time = toc;

WaitSecs(2);

end

% Clear the screen
sca;

info(1).Permutation = permu;


infosimple = rmfield(info,{'image','guide'});
save(['/Volumes/myshares/Sergis share/ExperimentFiles/' nameExp '.mat'],'info','-v7.3');
save(['EXPERIMENTFILES/' nameExp 'Simple.mat'],'infosimple','-v7.3');

