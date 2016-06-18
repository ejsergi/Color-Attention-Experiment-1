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

DisC = reshape(permute(CloseDis(2,:,:,:),[3,4,2,1]),72,[]);
DisvsChro = [DisC(1:18,:) DisC(18+(1:18),:) DisC(2*18+(1:18),:) DisC(3*18+(1:18),:)]';

disPatch2 = reshape(permute(A(2,:,:,:),[3,4,2,1]),72,[]);
disPatch = [disPatch2(1:18,:) disPatch2(18+(1:18),:) disPatch2(2*18+(1:18),:)...
    disPatch2(3*18+(1:18),:)]';

for i=1:size(disPatch,1)
    for j = 1:size(disPatch,2);
        
        [~,indD] = min(abs(disPatch(i,j)-xx));
        disNorm(i,j) = DisvsChro(i,j)/yy(indD);
        
    end
end

p = anova1(disNorm,[],'off');

Dmean = median(disNorm,1);

po = polyfit(hue,Dmean,6);
yy = polyval(po,10:1:350);
figure, hold on;
plot(10:1:350,yy,'k','LineWidth',3);
for i = 1:18
plot(hue(i),Dmean(i),'.','MarkerSize',50,'Color',colors(i,:));
end
% axis([1,10,3.8,5.2]);
xlabel('Hue angle (h^o)','FontSize',20);
ylabel('Fixation - patch distance (visual degrees)','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20);
hgexport(gcf,'Figures/DistancebyHue.eps');