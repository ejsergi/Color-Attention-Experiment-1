%{
In this scrip we will check the total number of fixations done in the
stimuli presented to each hue, in this way we can assume that the stimuli
that a higher number of fixations was done will mean a higher task needed
to be done, therefore less saliency will be find.

Will be interesnting to make a comparison of number of fiations and number
of reported.

Again no significant difference is fund, even though red has a noticible
lower number of fixations.
%}

clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');
load('Totalnumberoffixationsperstimulus.mat');


CHROMAS = A(1,:,1,1);
hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

numFix = reshape(permute(NumberOfFix(:,:,:,[1,3,5,6,11,12]),[2 1 3 4]),18,[])';

p = anova1(numFix(:,[1 9]),[],'off');

numFixM = trimmean(numFix,5,'round',1);
standDev = std(numFix,0,1)/sqrt(size(numFix,1));
po = polyfit(hue,numFixM,6);
yy = polyval(po,10:1:350);
figure, hold on;
% plot(10:1:350,yy,'k','LineWidth',3);
errorbar(hue,numFixM,standDev,'k.','LineWidth',2);
for i = 1:18
plot(hue(i),numFixM(i),'.','MarkerSize',50,'Color',colors(i,:));
end

% axis([1,10,3,4.3]);
xlabel('Hue angle (h^o)','FontSize',20);
ylabel('Number of fixations per stimuli','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20,'XLim',[0 360]);

hgexport(gcf,'Figures/NumberOfFixHue.eps');