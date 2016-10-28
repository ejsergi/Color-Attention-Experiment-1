function [sendSMIRed,readSMIRed] = setupSMIRED()

global DisplayScreen ScreenResolution nocalibpoints hport cport host UserID 


try
    
    %UDP in java
    readSMIRed = RecieveMsgSMIRed(host,cport);
    sendSMIRed = SendMsgSMIRed(host,hport);
    
    calibrationSuccess = 1;

    % if the udp connection has been established appropriately, proceed with
    % streaming data
    if ~isempty(readSMIRed) && ~isempty(sendSMIRed)

        % Send command to set up acquisition format
        commandstring = 'ET_FRM "%TS: %SX, %SY, %DX, %DY, %EZ"';        
        sendSMIRed.executeMsg(commandstring);
        
    end

    %Perform Calibration
    while(calibrationSuccess)
        [output] = SMIRED_calibration(sendSMIRed,readSMIRed);
        [calibrationSuccess] = validateCalibration(sendSMIRed,readSMIRed);
    end

catch exception
   disp(exception.identifier);
   readSMIRed.stopQueueSMIData(); 
   sendSMIRed.stopSendConnection();
   throw(exception);
end