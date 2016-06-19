clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');
load('DistancePatchCenter.mat');

CHROMAS = A(1,:,1,1);
hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

Report = reshape(permute(A(3,:,:,:),[3 1 2 4]),72,[]);
Report = [Report(1:18,:) Report(18+(1:18),:) Report(2*18+(1:18),:)...
    Report(3*18+(1:18),:)];

HueVal = repmat((1:18)',1,size(Report,2));

CloseDist = reshape(permute(sum(T(2:4,:,:,:),1),[3 1 2 4]),72,[]);
CloseDist = [CloseDist(1:18,:) CloseDist(18+(1:18),:) CloseDist(2*18+(1:18),:)...
    CloseDist(3*18+(1:18),:)];

oReport = reshape(Report,1,[]);
oHueVal = reshape(HueVal,1,[]);
oCloseDist = reshape(CloseDist,1,[]);

fixDist = oCloseDist(oReport==1);
fixHue = oHueVal(oReport==1);

p = anova1(fixDist,fixHue,'off');

[Tmean, sem] = grpstats(fixDist,fixHue,{'mean','sem'});

figure, hold on;
for i=1:18
    b = bar(hue(i),Tmean(i),20);
    set(b,'FaceColor',colors(i,:))
end
errorbar(hue,Tmean,sem,'k.','MarkerSize',1,'LineWidth',2);
axis([0 360 250 550]);
xlabel('Hue angle (h^o)','FontSize',20);
ylabel('Median fixation time (ms)','FontSize',20);
set(gca,'FontSize',20,'LineWidth',2);

hgexport(gcf,'Figures/DoubleData/TimeonReported.eps');