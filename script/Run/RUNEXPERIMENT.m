clear all
close all

% Introduce the experiment code of the set to be executed
nameExp = '025';

% Path of where the SMIFiles to control the eye tracker are (by default is
% locted in the same path as the function)
addpath('SMIFiles/');
load('SMIFiles/EnvDet.mat');

% The path to the folder where the stimuli information was inserted.
load(['STIMULISinfo/' nameExp '.mat']);


%% 
% Selecting a random permutation through all the stimuli for only the 3
% first stimuli of each 9 (1st trial).
permu = randperm(length(info)/3);
sele = [1:9:648 2:9:648 3:9:648];
info(1).Permutation = permu;

% Opening the Psychtoolbox and connecting to the second monitor
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

% Displaying a example stimuli, so the instructions can be given to the
% observer. ��� It is important to update the the path to a stimuli with
% visible patches !!!
theImage = imread('/Volumes/myshares/Sergis share/STIMULIS/002/S258.png');
imageTexture = Screen('MakeTexture', window, theImage);
[s1, s2, s3] = size(theImage);
Screen('DrawTextures', window, imageTexture);
Screen('Flip', window);

% When instructions are done, after pressing any button, the eye-tracker
% calibration starts
waitforbuttonpress;
sca;
[sendSMIRed,readSMIRed] = setupSMIRED();
close gcf

% After calibration, showing red corss in the middle so the experiment can
% start
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

% The loop starts which go all over each permutation
for i=1:length(permu);
    
    % Loading image
    theImage = imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' ...
    sprintf('%03d',sele(permu(i))) '.png']);
    imageTexture = Screen('MakeTexture', window, theImage);
    [s1, s2, s3] = size(theImage);
    Screen('DrawTextures', window, imageTexture);
    
    % Start recording eye movements and counting time
    sendSMIRed.executeMsg('ET_CLR');
    sendSMIRed.executeMsg('ET_REC');
    sendSMIRed.executeMsg('ET_REM "Starting eye recording"')
    tic
    
    % Displaying the image and asking for imput of number of patches
    Screen('Flip', window);
    LastSeen = input([int2str(i) '/' int2str(length(permu)) ': ']);
    
    % Saving both the number of report and the time taken into info file
    info(sele(permu(i))).LastSeen = LastSeen;
    info(sele(permu(i))).Time = toc;
    
    % Stop recording eue movements and send the the the SMI CPU to be
    % saved.
    sendSMIRed.executeMsg('ET_STP');
    sendSMIRed.executeMsg('ET_REM "Stop eye recording"');
    toSend = ['ET_SAV "D:/SergiResults/' nameExp '/' sprintf('%03d',sele(permu(i))) '.idf" "' nameExp '" "' sprintf('%03d',permu(i)) '" "OVR"'];
    sendSMIRed.executeMsg(toSend);

    % Drowing cross during certain amount of time before looping to the
    % next stimulus
    Screen('DrawTextures', window, crossTexture);
    Screen('Flip', window);
    WaitSecs(1);

    % Introduction of breaks for the observer in specific stimuli, after
    % break task is resumed once eyetracker is calibrated again.
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

% Stoping communication with the eye-tracking device
readSMIRed.stopQueueSMIData();
sendSMIRed.stopSendConnection();
sca;

% Saving the permutation in the info file and storing the file locally
info(1).Permutation = permu;
save(['EXPERIMENTFILES/' nameExp '.mat'],'info','-v7.3');
