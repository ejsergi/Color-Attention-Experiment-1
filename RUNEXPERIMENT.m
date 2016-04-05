clear all
close all

nameExp = '001';

load(['EXPERIMENTFILES/' nameExp '.mat']);
info = infosimple;

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
    
    theImage = imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' ...
    sprintf('%03d',permu(i)) '.png']);
    imageTexture = Screen('MakeTexture', window, theImage); 
    [s1, s2, s3] = size(theImage);
    Screen('DrawTextures', window, imageTexture);
    tic

    Screen('Flip', window);

    LastSeen = input([int2str(i) '/' int2str(length(info)) ': ']);
    info(permu(i)).LastSeen = LastSeen;
    info(permu(i)).Time = toc;
    
    Screen('FillRect', window, black);
    Screen('Flip', window);

    WaitSecs(2);

end

% Clear the screen
sca;

info(1).Permutation = permu;

save(['EXPERIMENTFILES/' nameExp '.mat'],'info','-v7.3');

