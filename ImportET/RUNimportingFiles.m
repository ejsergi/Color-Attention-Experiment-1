clear all
close all

nameExp = '021';

EyeEvents = importfileEvents(['/Volumes/myshares/Sergis share/SergiExportData/'...
    nameExp '.txt']);
Head = importfileHeader(['/Volumes/myshares/Sergis share/SergiExportData/'...
    nameExp '.txt']);

save(['ET_' nameExp '.mat'],'EyeEvents','Head');