%{
Checking the different time taken to report for each hue and lightness.
Chroma can't be done since we dont have the time taken for each specific
chroma, but for each eight of them.

When running ANOVA by each hue grups it shows no significant difference.
ANOVA for the different Lightness it shows significant difference: the
fastest was 50, then 25 and 75 and slowest was when showing all L

ANOVA by different observers show really significant difference, and in the
boxplot we can see for each observer how long it was taken to report the
patches.
%}

clear all
close all

hue = 10:20:350;

hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

load('TimetoReport.mat');

timeT = permute(sum(time,1),[2 3 1]);
timeT = [timeT(1:18,:) timeT(18+(1:18),:) timeT(2*18+(1:18),:) timeT(3*18+(1:18),:)]';

p_hue = anova1(timeT(:,[4 5 11 12]),[],'off');
% [cof,p] = corrcoef(timeT);
% plot(hue,mean(timeT,1));
figure; hold on
for i=1:18
    b = bar(hue(i),median(timeT(:,i)),20);
    set(b,'FaceColor',colors(i,:))
end
axis([0 360 20 30]);
% grid on;
xlabel('Hue angle (h^o)','FontSize',20);
ylabel('Median time taken (s)','FontSize',20);
set(gca,'FontSize',20,'LineWidth',2);
% hgexport(gcf,'Figures/TimeReportHue.eps');

timeTT = permute(sum(time,1),[2,3,1]);
timeTT = [reshape(timeTT(1:18,:),1,[]); reshape(timeTT(18+(1:18),:),1,[]); ...
    reshape(timeTT(2*18+(1:18),:),1,[]); reshape(timeTT(3*18+(1:18),:),1,[])]';

p_light = anova1(timeTT(:,3:4),[],'off');
colorlines = lines(4);
figure; hold on
for i=1:4
    b = bar(i,median(timeTT(:,i)));
    set(b,'FaceColor',colorlines(i,:))
end
axis([0 5 15 30]);
ylabel('Median time taken (s)','FontSize',20);
set(gca,'FontSize',20,'LineWidth',2,'XTick',[1,2,3,4],...
    'XTickLabel',['L^* \in [0,100]      ';'      L^* = 50       ';...
    '      L^* = 25       ';'      L^* = 75       ']);
% hgexport(gcf,'Figures/TimeReportLight.eps');

timeTTT = permute(sum(time,1),[3,2,1])';
p_observer = anova1(timeTTT,[],'off');


