function [ calibrationSuccess ] = validateCalibration(sendSMIRed,readSMIRed)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
try
global DisplayScreen ScreenResolution nocalibpoints hport cport host UserID

calibNum = 0;
rowCnt =1;
count =1;
validateflg = 1;
commandstring = sprintf('ET_RES');
sendSMIRed.executeMsg(commandstring);
pause(1); 

while validateflg

        dataStrJava = readSMIRed.getSMIDataStr();    
        dataString = char(dataStrJava);
        
        if(~strcmpi(dataString,''))
           dataSringNew = regexprep(dataString,',','');
           dataStringSplit = regexpi(dataSringNew,' ','split');
           command = dataStringSplit{1};  
           count = count +1;           
        else
            continue;
        end
%         if(count == length(cData)-1)        
%           disp(command);
%         end    
        % Switch case for the command recieved
        switch strtrim(command)
            case 'ET_PNT'
                a = str2double(dataStringSplit{2});
                b = str2double(dataStringSplit{3});
                c = str2double(dataStringSplit{4});
                calibNum = a;
                calibPoints(calibNum,:)=[b c];
            case 'ET_CSP'    
                b = str2double(dataStringSplit{3});
                c = str2double(dataStringSplit{4});
                GazeData(rowCnt,:) = [calibNum b c];                
                rowCnt = rowCnt+1;    
            case 'ET_RES'
                validateflg = 0;                
        end          
end

if(~isempty(GazeData))
  for count1 = 1:1:nocalibpoints  
     Data = abs(GazeData(GazeData ==count1,:));
     [m n] = size(Data);
     Data(:,2) =Data(:,2) - calibPoints(count1,1);
     Data(:,3) = Data(:,3) - calibPoints(count1,2);
     Data(:,2) = Data(:,2) .^ 2;
     Data(:,3) = Data(:,3) .^ 2;
     DataXSum = sum(Data(:,2));
     DataYSum = sum(Data(:,3));
     DataXAvg = DataXSum ./ m;
     DataYAvg = DataYSum ./ m;
     DataXRMS = sqrt(DataXAvg);
     DataYRMS = sqrt(DataYAvg);
     calibPoints(count1,3)= DataXRMS;
     calibPoints(count1,4)= DataYRMS;
  end 
end    

stim = zeros(ScreenResolution(2),ScreenResolution(1),3,'uint8');

for count2 = 1:1:nocalibpoints

    calibX = uint16(calibPoints(count2,1));
    calibY = uint16(calibPoints(count2,2));
    
    if(calibX < (ScreenResolution(1)/2))
      ErrorX = uint16(calibX + calibPoints(count2,3));
    else
       ErrorX = uint16(calibX - calibPoints(count2,3)); 
    end
    
    if(calibY < (ScreenResolution(2)/2))
      ErrorY = uint16(calibY + calibPoints(count2,4));
    else
      ErrorY = uint16(calibY - calibPoints(count2,4));  
    end

    stim(calibY-10:calibY+10,calibX-1:calibX+1,2) = 255;
    stim(calibY-1:calibY+1,calibX-10:calibX+10,2) = 255;    
   
    if ErrorY-10 > 0 && ErrorY+10 <= ScreenResolution(2) && ErrorX-10 > 0 && ErrorX+10 <= ScreenResolution(1)
        stim(ErrorY-10:ErrorY+10,ErrorX-1:ErrorX+1,1) = 255;
        stim(ErrorY-1:ErrorY+1,ErrorX-10:ErrorX+10,1) = 255;    
    end   
end

h = figure; imshow(stim);

pause(1);

stdX = round(mean(calibPoints(:,3)));
stdY = round(mean(calibPoints(:,4)));
calibrationCheck = (stdX+stdY)/2;

if(calibrationCheck < 20)
    calibrationStatus = 'Strong';
elseif (calibrationCheck < 50)
    calibrationStatus = 'Good';
elseif(calibrationCheck < 100)
    calibrationStatus = 'Normal';
else
    calibrationStatus = 'Weak';
end    
        
%Accept or Decline calibration================================================
varout = 'Yes';
while (strcmp(varout,'Run') == 0 && strcmp(varout,'Skip') == 0)
    varout = ValidationDialog('title',[calibrationStatus,' Calibration'],'stdX',stdX,'stdY',stdY);
    
    if(strcmp(varout,'Accept') == 1)
        commandstring = sprintf('ET_REM "Accept Calibration"');
        ssendSMIRed.executeMsg(commandstring);
        calibrationSuccess = 0;
        
        
        break;
    end
    if(strcmp(varout,'Decline') == 1)
        commandstring = sprintf('ET_REM "Decline Calibration"');
        sendSMIRed.executeMsg(commandstring);
        calibrationSuccess = 1;
        
        
        break;
    end          
end

closescreen();
readSMIRed.resetSMIQueue();

catch exception
   disp(exception.identifier); 
   closescreen();
%    readSMIRed.stopQueueSMIData(); 
%    sendSMIRed.stopSendConnection();
   calibrationSuccess = 0;
   return;
end    
end

