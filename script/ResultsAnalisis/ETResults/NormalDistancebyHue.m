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

DisC = reshape(permute(CloseDis(2,9:16,:,:),[3,4,2,1]),72,[]);
DisvsChro = [DisC(1:18,:) DisC(18+(1:18),:) DisC(2*18+(1:18),:) DisC(3*18+(1:18),:)]';

disPatch2 = reshape(permute(A(2,9:16,:,:),[3,4,2,1]),72,[]);
disPatch = [disPatch2(1:18,:) disPatch2(18+(1:18),:) disPatch2(2*18+(1:18),:)...
    disPatch2(3*18+(1:18),:)]';

for i=1:size(disPatch,1)
    for j = 1:size(disPatch,2);
        
        [~,indD] = min(abs(disPatch(i,j)-xx));
        disNorm(i,j) = DisvsChro(i,j)/yy(indD);
        
    end
end

p = anova1(disNorm,[],'off');

Dmean = median(disNorm,1)*3;
standDev = std(disNorm,0,1)/sqrt(size(disNorm,1));


po = polyfit(hue,Dmean,6);
yy = polyval(po,10:1:350);
figure, hold on;
errorbar(hue,Dmean,standDev,'k.','MarkerSize',1,'LineWidth',2);
% plot(10:1:350,yy,'k','LineWidth',3);
for i = 1:18
plot(hue(i),Dmean(i),'^','MarkerSize',15,'LineWidth',3,'Color',colors(i,:));
end
% axis([1,10,3.8,5.2]);
title('C^* = (4, 7] (p < 0.0011)');
xlabel('Hue angle (h^o)','FontSize',20);
ylabel('Fixation - patch distance (visual degrees)','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20,'XLim',[0 360]);
hgexport(gcf,'Figures/DistancebyHueMid.eps');