clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');
load('DistancePatchCenter.mat');

CHROMAS = A(1,:,1,1);
hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

TimeF = reshape(permute(sum(T(2:4,:,:,:),1),[3 1 2 4]),72,[]);

TimeF = [reshape(TimeF(1:18,:),1,[]);...
    reshape(TimeF(18+(1:18),:),1,[]); reshape(TimeF(2*18+(1:18),:),1,[]);...
    reshape(TimeF(3*18+(1:18),:),1,[]);]';

p = anova1(TimeF,[],'off');

Tmean = trimmean(TimeF,40,'round',1);
standDev = std(TimeF,0,1)/sqrt(size(TimeF,1));

TNime = TimeF;
TNime(TimeF==0) = NaN;
TNime(TimeF>1300) = NaN;

Tmean = nanmedian(TNime,1);
colorlines = lines(4);
figure, hold on;
normaT2 = [11,9,9,10];
for i=1:4
    b = bar(i,Tmean(i)/normaT2(i)*9);
    set(b,'FaceColor',colorlines(i,:))
end
for i=1:4
errorbar(i,Tmean(i)/normaT2(i)*9,standDev(i),'k.','MarkerSize',1,'LineWidth',2);
end
axis([0.5 4.5 250 400]);
title( 'p < 0.0115')
ylabel('Median fixation time (ms)','FontSize',25);
set(gca,'FontSize',25,'LineWidth',2,'XTick',[1,2,3,4],...
    'XTickLabel',['B1';'B2';'B3';'B4']);
hgexport(gcf,'Figures/Light/TimebyLight.eps');
