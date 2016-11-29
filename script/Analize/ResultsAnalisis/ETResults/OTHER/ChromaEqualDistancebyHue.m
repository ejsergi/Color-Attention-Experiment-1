%{
Checking how de distance between the closest fixation and the patch changes
depending on the chroma. 
ANOVA done for all the distances of each fixation gruped in the different
chromas. It is shown that the difference is significant.

The plot shows the mean fixation distance for each chroma and overlies a
polynomial fit. We can observe a wierd behavior, distance is big big for
low chroma (no fixation), it decreases drastically for where the threshold
are find and it increases again for really obvious and visible chromas.
This means the observer didn't need to accuratelly fixate to perceive
ceirtan really high chroma and obvious patches.
%}

clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');

CHROMAS = A(1,:,1,1);

for i=1:18
DisvsChro = reshape(CloseDis(2,:,[i 18+i 18*2+i 18*3+i],[1,6,9,12]),24,[])';

p = anova1(DisvsChro,[],'off');

Dmean = median(DisvsChro,1);
nChroma = 1.3:0.05:10;
po = polyfit(CHROMAS,Dmean,3);
yy = polyval(po,nChroma);

[~,indM] = min(abs(yy-4.5));

eqDis(i) = nChroma(indM);

end

plot(eqDis);
% hgexport(gcf,'Figures/DistancebyChroma.eps');
