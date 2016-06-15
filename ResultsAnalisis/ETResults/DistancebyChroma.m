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

DisvsChro = reshape(CloseDis(2,:,:,[1,6,9,12]),24,[])';

p = anova1(DisvsChro,[],'off');

Dmean = median(DisvsChro,1);

po = polyfit(CHROMAS,Dmean,5);
yy = polyval(po,1.3:0.05:10);
colors=lines(2);
figure, hold on;
plot(1.3:0.05:10,yy,'LineWidth',3,'Color',colors(2,:));
plot(CHROMAS,Dmean,'o','LineWidth',2,'Color',colors(1,:));
% axis([1,10,3,4.3]);
xlabel('Chroma (C^*)','FontSize',20);
ylabel('Fixation - patch distance (visual degrees)','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20);
hgexport(gcf,'Figures/DistancebyChroma.eps');
