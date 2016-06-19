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

numFix = reshape(permute(NumberOfFix(:,:,:,:),[3 1 2 4]),4,[])';

p = anova1(numFix,[],'off');

numFixM = median(numFix,1);
standDev = std(numFix,0,1)/sqrt(size(numFix,1));
figure, hold on;
% plot(10:1:350,yy,'k','LineWidth',3);
errorbar(numFixM,standDev,'k.','LineWidth',3);
for i = 1:4
plot(i,numFixM(i),'.','MarkerSize',70);
end

title('p < 0.1422');
ylabel('Number of fixations per stimuli','FontSize',25);
set(gca,'LineWidth',2,'FontSize',25,'XTick',[1,2,3,4],...
    'XTickLabel',['B1';'B2';'B3';'B4']);

hgexport(gcf,'Figures/Light/NumberFixationsbyLight.eps');