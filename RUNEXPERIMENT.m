clear all
close all

nameExp = '001';

addpath('SMIFiles/');

load('SMIFiles/EnvDet.mat');

[sendSMIRed,readSMIRed] = setupSMIRED();

load(['STIMULIS/' nameExp '.mat']);

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

permu = randperm(length(info));

for i=1:length(permu);
    
    theImage = imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' ...
    sprintf('%03d',permu(i)) '.png']);
    imageTexture = Screen('MakeTexture', window, theImage); 
    [s1, s2, s3] = size(theImage);
    Screen('DrawTextures', window, imageTexture);
    
    sendSMIRed.executeMsg('ET_CLR');
    sendSMIRed.executeMsg('ET_REC');
    sendSMIRed.executeMsg('ET_REM "Starting eye recording"')
    tic

    Screen('Flip', window);

    LastSeen = input([int2str(i) '/' int2str(length(info)) ': ']);
    info(permu(i)).LastSeen = LastSeen;
    info(permu(i)).Time = toc;
    
    sendSMIRed.executeMsg('ET_STP');
    sendSMIRed.executeMsg('ET_REM "Stop eye recording"'); 
    
    toSend = ['ET_SAV "D:/SergiResults/' nameExp '/' sprintf('%03d',permu(i)) '.idf" "' nameExp '" "' sprintf('%03d',permu(i)) '" "OVR"'];

    sendSMIRed.executeMsg(toSend);
    
    Screen('FillRect', window, black);
    Screen('Flip', window);

    WaitSecs(2);
    
    if (i==220||i==440)
        
        readSMIRed.stopQueueSMIData(); 
        sendSMIRed.stopSendConnection();
        sca;
        
        f = figure;
        h = uicontrol('Position',[20 20 200 40],'String','Continue',...
                'Callback','uiresume(gcbf)');
        uiwait(gcf);
        close(f);
        
        [sendSMIRed,readSMIRed] = setupSMIRED();
        
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
        
    end

end

readSMIRed.stopQueueSMIData(); 
sendSMIRed.stopSendConnection();

sca;

info(1).Permutation = permu;

save(['EXPERIMENTFILES/' nameExp '.mat'],'info','-v7.3');

