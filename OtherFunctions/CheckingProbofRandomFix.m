clear all
close all

Stimuli = zeros(1440);

numbFix = 7;

for i=1:10000;
    
Patch = round(rand(2,1)*1300+50);
PatchR = repmat(Patch,1,numbFix);

fixations = round(rand(2,numbFix)*1300+50);

distanceF = sqrt(sum((fixations-PatchR).^2,1))/49;

FixorNot = sum(distanceF<=3.5);

probFix(i) = double(FixorNot>0);

end

TotalP = mean(probFix);
standError = std(probFix)/sqrt(length(probFix));