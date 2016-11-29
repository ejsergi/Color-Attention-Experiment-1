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
distantT = 0:0.1:20;

for i=1:length(distantT);
numFix = zeros(1,24,72,12);
numFix(CloseDis(2,:,:,:)<distantT(i)) = 1;
numFix = reshape(permute(numFix,[3 1 2 4]),72,[]);
numFix = [reshape(numFix(1:18,:),1,[]);...
    reshape(numFix(18+(1:18),:),1,[]); reshape(numFix(2*18+(1:18),:),1,[]);...
    reshape(numFix(3*18+(1:18),:),1,[]);]';


p(i) = anova1(numFix,[],'off');

numFixM(i,:) = mean(numFix,1);
standDev(i,:) = std(numFix,0,1)/sqrt(size(numFix,1));
end
figure, hold on;
% normaT2 = [11,9,9,10];
normaT = [2 0 0.5 0.5];
for i=1:4
plot(distantT+normaT(i),numFixM(:,i),'LineWidth',3)
end
legend('L^* \in [0,100]','L^*=50','L^*=25','L^*=75','Location','SouthEast');

% axis([1,10,3,4.3]);
xlabel('Threshold distance to detect fixation','FontSize',25);
ylabel('Probability of patch being fixated','FontSize',25);
set(gca,'LineWidth',2,'FontSize',25);

% hgexport(gcf,'Figures/ProbPatchFix.eps');