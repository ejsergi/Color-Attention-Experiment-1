%{
Checking the dependency of the distance between fixation and patch for each
specific hue and each chroma (checking interesting chromas out of the
reported in DistancebyChroma.m

No suficient information to see differences chroma by chroma into an
specific hue
%}

clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');

CHROMAS = A(1,:,1,1);
hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

for i=1:18
DisvsChro(:,i) = reshape(CloseDis(2,16:24,[i 18+i 2*18+i 3*18+i],:),1,[])';
end

p = anova1(DisvsChro,[],'on');

Dmean = median(DisvsChro,1);

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
title('Chromas from 7 up');
set(gca,'LineWidth',2,'FontSize',20);
hgexport(gcf,'DistancehueChromaHigh.eps');
