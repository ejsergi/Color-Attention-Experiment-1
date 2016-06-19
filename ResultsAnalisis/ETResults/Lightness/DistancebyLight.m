%{
Checking how de distance between the closest fixation and the patch changes
depending on the hue. 
ANOVA done for all the distances of each fixation gruped in the different
hues. It is shown that the difference is significant.

%}

clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');
load('DistancePatchCenter.mat');

CHROMAS = A(1,:,1,1);
hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

DisC = reshape(permute(CloseDis(2,17:24,:,:),[3,4,2,1]),72,[]);
DisvsChro = [reshape(DisC(1:18,:),1,[]);...
    reshape(DisC(18+(1:18),:),1,[]); reshape(DisC(2*18+(1:18),:),1,[]);...
    reshape(DisC(3*18+(1:18),:),1,[]);]';

disPatch2 = reshape(permute(A(2,17:24,:,:),[3,4,2,1]),72,[]);
disPatch = [reshape(disPatch2(1:18,:),1,[]);...
    reshape(disPatch2(18+(1:18),:),1,[]); reshape(disPatch2(2*18+(1:18),:),1,[]);...
    reshape(disPatch2(3*18+(1:18),:),1,[]);]';

for i=1:size(disPatch,1)
    for j = 1:size(disPatch,2);
        
        [~,indD] = min(abs(disPatch(i,j)-xx));
        disNorm(i,j) = DisvsChro(i,j)/yy(indD);
        
    end
end

p = anova1(disNorm,[],'off');

Dmean = median(disNorm,1)*3;
standDev = std(disNorm,0,1)/sqrt(size(disNorm,1));
normaT2 = [11,9,9,10];
figure, hold on;
for i=1:4
errorbar(i,Dmean(i)*normaT2(i)/9,standDev(i),'k.','MarkerSize',1,'LineWidth',3);
end
% plot(10:1:350,yy,'k','LineWidth',3);

for i = 1:4
plot(i,Dmean(i)*normaT2(i)/9,'s','MarkerSize',15,'LineWidth',4);
end
% axis([1,10,3.8,5.2]);
title('C^* = (7, 10] (p < 10^{-4})');
ylabel('Fixation - patch distance','FontSize',25);
set(gca,'LineWidth',2,'FontSize',25,'XTick',[1,2,3,4],...
    'XTickLabel',['B1';'B2';'B3';'B4']);
hgexport(gcf,'Figures/Light/DistancebyLight.eps');