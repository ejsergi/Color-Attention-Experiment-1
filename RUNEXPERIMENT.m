clear all
close all

nameExp = '017';

addpath('SMIFiles/');

load('SMIFiles/EnvDet.mat');


load(['STIMULIS/' nameExp '.mat']);

permu = randperm(length(info)/3);

sele = [1:9:648 2:9:648 3:9:648];

info(1).Permutation = permu;

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

theImage = imread('/Volumes/myshares/Sergis share/STIMULIS/002/S258.png');
imageTexture = Screen('MakeTexture', window, theImage); 
[s1, s2, s3] = size(theImage);
Screen('DrawTextures', window, imageTexture);
Screen('Flip', window); 

waitforbuttonpress;

sca;

[sendSMIRed,readSMIRed] = setupSMIRED();

close gcf

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

cross = zeros(1440,1440,3);
cross(719:721,700:740,1)=1;
cross(700:740,719:721,1)=1;
crossTexture = Screen('MakeTexture', window, cross);

for i=1:length(permu);
    
    theImage = imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' ...
    sprintf('%03d',sele(permu(i))) '.png']);
    imageTexture = Screen('MakeTexture', window, theImage); 
    [s1, s2, s3] = size(theImage);
    Screen('DrawTextures', window, imageTexture);
    
    sendSMIRed.executeMsg('ET_CLR');
    sendSMIRed.executeMsg('ET_REC');
    sendSMIRed.executeMsg('ET_REM "Starting eye recording"')
    tic

    Screen('Flip', window);

    LastSeen = input([int2str(i) '/' int2str(length(permu)) ': ']);
    info(sele(permu(i))).LastSeen = LastSeen;
    info(sele(permu(i))).Time = toc;
    
    sendSMIRed.executeMsg('ET_STP');
    sendSMIRed.executeMsg('ET_REM "Stop eye recording"'); 
    
    toSend = ['ET_SAV "D:/SergiResults/' nameExp '/' sprintf('%03d',sele(permu(i))) '.idf" "' nameExp '" "' sprintf('%03d',permu(i)) '" "OVR"'];

    sendSMIRed.executeMsg(toSend);
    
    Screen('DrawTextures', window, crossTexture);
    Screen('Flip', window);

    WaitSecs(1);
    
    if (i==108)
        
        save(['EXPERIMENTFILES/' nameExp '.mat'],'info','-v7.3');
        
        sca;
        
        f = figure;
        h = uicontrol('Position',[20 20 200 40],'String','Continue',...
                'Callback','uiresume(gcbf)');
        uiwait(gcf);
        close(f);
        
        calibrationSuccess = 1;
        while(calibrationSuccess)
        [output] = SMIRED_calibration(sendSMIRed,readSMIRed);
        [calibrationSuccess] = validateCalibration(sendSMIRed,readSMIRed);
        end
        close gcf
        
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
        
        cross = zeros(1440,1440,3);
        cross(719:721,700:740,1)=1;
        cross(700:740,719:721,1)=1;
        crossTexture = Screen('MakeTexture', window, cross);
        
    end

end

readSMIRed.stopQueueSMIData(); 
sendSMIRed.stopSendConnection();

sca;

info(1).Permutation = permu;

save(['EXPERIMENTFILES/' nameExp '.mat'],'info','-v7.3');

