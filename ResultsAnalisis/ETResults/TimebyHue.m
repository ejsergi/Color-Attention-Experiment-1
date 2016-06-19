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

TimeF = [TimeF(1:18,:) TimeF(18+(1:18),:) TimeF(2*18+(1:18),:) ...
    TimeF(3*18+(1:18),:)]';

p = anova1(TimeF,[],'off');

Tmean = trimmean(TimeF,40,'round',1);
standDev = std(TimeF,0,1)/sqrt(size(TimeF,1));

TNime = TimeF;
TNime(TimeF==0) = NaN;
TNime(TimeF>1300) = NaN;

Tmean = nanmedian(TNime,1);

figure, hold on;
for i=1:18
    b = bar(hue(i),Tmean(i),20);
    set(b,'FaceColor',colors(i,:))
end
errorbar(hue,Tmean,standDev,'k.','MarkerSize',1,'LineWidth',2);
axis([0 360 300 450]);
xlabel('Hue angle (h^o)','FontSize',20);
ylabel('Median fixation time (ms)','FontSize',20);
set(gca,'FontSize',20,'LineWidth',2);

hgexport(gcf,'Figures/TimebyHue.eps');