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


DisvsChro = reshape(CloseDis(2,:,:,:),24,[])';

p = anova1(DisvsChro(:,13:20),[],'off');

% Dmean = trimmean(DisvsChro,5,'round',1);
standDev = std(DisvsChro,0,1)/sqrt(size(DisvsChro,1));
DisvsChroNan=DisvsChro;
for i =1:24
DisvsChroNan(DisvsChro(:,i)>3,i) = NaN;
end
Dmean = nanmean(DisvsChroNan);

% figure, hold on;
% for i=1:24
%     plot(repmat(CHROMAS(i),864,1),DisvsChro(:,i),'.');
% end

po = polyfit(CHROMAS,Dmean,2);
yy = polyval(po,1.3:0.05:10);
colors=lines(2);
figure, hold on;
plot([1 10.3],[3 3],'--','LineWidth',2);
plot([1 10.3],[4 4],'-.','LineWidth',2);
plot([1 10.3],[3.5 3.5],'k','LineWidth',1);

% plot(1.3:0.05:10,yy,'k--','LineWidth',2);
errorbar(CHROMAS,Dmean,standDev,'k','MarkerSize',50,'LineWidth',2);
plot(CHROMAS,Dmean,'.','MarkerSize',50,'LineWidth',2);
% axis([1,10,3,4.3]);
xlabel('Chroma (C^*)','FontSize',20);
ylabel('Fixation - patch distance (visual degrees)','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20,'XLim',[1 10.3]);
hgexport(gcf,'Figures/DistancebyChroma.eps');
