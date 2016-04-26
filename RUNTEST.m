clear all
close all

nameExp = '000';

addpath('SMIFiles/');

load('SMIFiles/EnvDet.mat');

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

for i=1:3;
    
    theImage = imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/' ...
    sprintf('%03d',i) '.png']);
    imageTexture = Screen('MakeTexture', window, theImage); 
    [s1, s2, s3] = size(theImage);
    Screen('DrawTextures', window, imageTexture);
    tic
    
    sendSMIRed.executeMsg('ET_CLR');
    sendSMIRed.executeMsg('ET_REC');
    sendSMIRed.executeMsg('ET_REM "Starting eye recording"')

    Screen('Flip', window);

    LastSeen = input('introduce number: ');
    
    sendSMIRed.executeMsg('ET_STP');
   sendSMIRed.executeMsg('ET_REM "Stop eye recording"'); 
    
    toSend = ['ET_SAV "D:/SergiResults/' nameExp '/' sprintf('%03d',i) '.idf" "' nameExp '" "' sprintf('%03d',i) '" "OVR"'];

    sendSMIRed.executeMsg(toSend);    
    
    Screen('FillRect', window, black);
    Screen('Flip', window);

    WaitSecs(2);
    
    if (i==1)
        
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
        
    end

end

% Clear the screen
sca;

readSMIRed.stopQueueSMIData(); 
sendSMIRed.stopSendConnection();

