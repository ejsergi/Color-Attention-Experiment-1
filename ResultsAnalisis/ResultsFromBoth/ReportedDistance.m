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

CloseDist = reshape(permute(CloseDis(2,:,:,:),[3 1 2 4]),72,[]);
CloseDist = [CloseDist(1:18,:) CloseDist(18+(1:18),:) CloseDist(2*18+(1:18),:)...
    CloseDist(3*18+(1:18),:)];

oReport = reshape(Report,1,[]);
oHueVal = reshape(HueVal,1,[]);
oCloseDist = reshape(CloseDist,1,[]);

fixDist = oCloseDist(oReport==1);
fixHue = oHueVal(oReport==1);

p = anova1(fixDist,fixHue,'off');

[Dmean, sem] = grpstats(fixDist,fixHue,{'mean','sem'});

figure, hold on;
errorbar(hue,Dmean,sem,'k.','MarkerSize',1,'LineWidth',2);
for i = 1:18
plot(hue(i),Dmean(i),'.','MarkerSize',60,'LineWidth',3,'Color',colors(i,:));
end
xlabel('Hue angle (h^o)','FontSize',25);
ylabel('Fixation - patch distance','FontSize',25);
set(gca,'LineWidth',2,'FontSize',25,'XLim',[0 360]);

hgexport(gcf,'Figures/DoubleData/DistanceonReported.eps');