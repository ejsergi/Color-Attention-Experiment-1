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
distantT = [2.5, 3, 3.5];
for i=1:3
numFix = double(CloseDis(2,:,:,:)<distantT(i));
numFix = reshape(permute(numFix,[3 1 2 4]),72,[]);
numFix = [numFix(1:18,:) numFix(18+(1:18),:) numFix(2*18+(1:18),:) numFix(3*18+(1:18),:)]';


p(i) = anova1(numFix,[],'off');

numFixM(i,:) = mean(numFix,1);
standDev(i,:) = std(numFix,0,1)/sqrt(size(numFix,1));
end
figure, hold on;
% plot(10:1:350,yy,'k','LineWidth',3);
errorbar(hue,numFixM(2,:),standDev(2,:),'k','LineWidth',2);
for i = 1:18
plot(hue(i),numFixM(2,i),'.','MarkerSize',50,'Color',colors(i,:));
end
colorlin = lines(2);
plot(hue,numFixM(1,:),'--','LineWidth',2,'Color',colorlin(1,:));
plot(hue,numFixM(3,:),'-.','LineWidth',2,'Color',colorlin(2,:));


% axis([1,10,3,4.3]);
xlabel('Hue angle (h^o)','FontSize',20);
ylabel('Probability of patch being fixated','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20,'XLim',[0 360]);

hgexport(gcf,'Figures/ProbPatchFix.eps');