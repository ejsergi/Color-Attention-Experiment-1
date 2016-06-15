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

CHROMAS = A(1,:,1,1);
Hue = 10:20:350;

DisC = reshape(permute(CloseDis(2,:,:,[1,6,9,12,3,4,10,11]),[3,4,2,1]),72,[]);

DisvsChro = [DisC(1:18,:) DisC(18+(1:18),:) DisC(2*18+(1:18),:) DisC(3*18+(1:18),:)]';

p = anova1(DisvsChro,[],'on');

Dmean = median(DisvsChro,1);

po = polyfit(Hue,Dmean,5);
yy = polyval(po,10:1:350);
colors=lines(2);
figure, hold on;
plot(10:1:350,yy,'LineWidth',3,'Color',colors(2,:));
plot(Hue,Dmean,'o','LineWidth',2,'Color',colors(1,:));
% axis([1,10,3.8,5.2]);
xlabel('Hue angle (h^o)');
ylabel('Fixation - patch distance (visual degrees)');
set(gca,'LineWidth',2,'FontSize',20);
