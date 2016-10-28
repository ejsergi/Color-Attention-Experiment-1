function [output] = SMIRED_calibration(sendSMIRed,readSMIRed)
% This function starts a gaze calibration on a SMI RED eye tracker.
%
% The following functions are used, and should be downloaded;
%
% UDP connection, pnet():
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=345.
%
% Fullscreen image display, fullscreen() and closescreen():
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=
% 11112&objectType=File
% -------------------------------------------------------------------------


global DisplayScreen ScreenResolution nocalibpoints hport cport host UserID

output = 0; 

% Cancel a possible ongoing calibration
commandstring = sprintf('ET_BRK');
sendSMIRed.executeMsg(commandstring);

%set a black screen for calibration
stim = zeros(ScreenResolution(2),ScreenResolution(1),3,'uint8');    
fullscreen(stim,DisplayScreen);
    
% Show black image on preview screen
%figure(1);image(stim);axis off;
try

pause(1);
% Clear the internal data buffer
commandstring = sprintf('ET_CLR');
sendSMIRed.executeMsg(commandstring);

% Set the calibration to auto accept
commandstring = sprintf('ET_CPA 2 1');
sendSMIRed.executeMsg(commandstring);

commandstring = sprintf('ET_CPA 0 1');
sendSMIRed.executeMsg(commandstring);

% Set the calibration screen resolution
commandstring = sprintf('ET_CSZ %1.0f %1.0f',...
    ScreenResolution(1),ScreenResolution(2));
sendSMIRed.executeMsg(commandstring);

% Start calibration sequence
commandstring = sprintf('ET_CAL %1.0f',nocalibpoints);
sendSMIRed.executeMsg(commandstring);

%read from the eye tracked using UDP socked connection
pause(0.01);

% Wait for iViewX response
while 1        
        dataStrJava = readSMIRed.getSMIDataStr();
        dataString = char(dataStrJava);

        if(~strcmpi(dataString,''))
          dataSringNew = regexprep(dataString,',','');
          dataStringSplit = regexpi(dataSringNew,' ','split');
          command = dataStringSplit{1};            
        else
           continue;
        end

        % Which command have we received?
        switch strtrim(command)
            
            % Screen resolution of calibration
            case 'ET_CSZ'
                a = str2double(dataStringSplit{2});
                b = str2double(dataStringSplit{3});
                % if there is no consistency between screen resolutions
                if a ~= ScreenResolution(1) || b ~= ScreenResolution(2)
                    % close the socket connection
                    fclose(sendSMIRed);
                    fclose(readSMIRed);
                    
                    % close screen image
                    closescreen();
                    %close all;
                    
                    % display error
                    error('Calibration screen resolution parameter does not match the local setting!');
                end % if
                
            % iViewX gives us the calibration point coordinates
            case 'ET_PNT'
                 a = str2double(dataStringSplit{2});
                 b = str2double(dataStringSplit{3});
                 c = str2double(dataStringSplit{4});
                % Save calibration points
                 eval(sprintf('CalibrationPoints.Point%1.0f = [b c];',a));
            % iViewX tells us to show a calibration point
            case 'ET_CHG'
                a = str2double(dataStringSplit{2});
                % create an image with a cross at the apropriate coordinate
                stim = zeros(ScreenResolution(2),ScreenResolution(1),3,'uint8');
                
                % Get saved calibration point
                eval(sprintf('cx = CalibrationPoints.Point%1.0f(1);',a));
                eval(sprintf('cy = CalibrationPoints.Point%1.0f(2);',a));
                
                % Create cross
                stim(cy-20:cy+20,cx-1:cx+1,1) = 255;
                stim(cy-1:cy+1,cx-20:cx+20,1) = 255;
                
                                
                % Display calibration point on screen
                fullscreen(stim,DisplayScreen);
                
                % if it is the first ET_CHG, then wait 2 seconds
                if a == 1
                    % Wait two seconds for convenience
                    % Send accept calibration (ET_ACC)
                    commandstring = sprintf('ET_ACC');
                    sendSMIRed.executeMsg(commandstring);
                else
                    continue;
                end % if     
                
            case 'ET_FIN'                 
                closescreen();
                output = 1;
                return;               
        end % switch        
end % while

catch exception
   disp(exception.identifier); 
   closescreen();
%    readSMIRed.stopQueueSMIData(); 
%    sendSMIRed.stopSendConnection();
   throw(exception);
end    