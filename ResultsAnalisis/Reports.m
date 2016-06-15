%{ 
The plot shows the average of all the observers and all the lightness over
the different chroma, hue, and probability of report.

For each hue the probability of report function vs. the chroma will be
calculated. It will have a shape of comulative gaussian, since there is a
point as the chroma increases that the prob of report will increase until 1
and remain as 1.

The plot shows the chroma value where the 0.5 point in the probability 
function for each hue is located. The upper and lower boundaries represent
the 0.9 and the 0.1 respectivally.
%}

clear all
close all

chromas = [1.3 1.675 2.05 2.425 2.8 3.175 3.55 3.925 4.3 4.675 5.05 5.425 5.8...
    6.175 6.55 6.925 7.3 7.675 8.05 8.425 8.8 9.175 9.55 9.925];

load('Report.mat');

hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

for i=1:18

nChroma = 1.3:0.01:9.925;
RChr = interp1(chromas,smooth(Report(:,i)),nChroma);

[diff,inx] = min(abs(RChr-0.5));

MinChroma(i) = nChroma(inx);

[diff,inx] = min(abs(RChr-0.75));
U(i) = nChroma(inx);
[diff,inx] = min(abs(RChr-0.25));
L(i) = nChroma(inx);
end


figure; hold on

plot(hue,L,'--','LineWidth',2);
plot(hue,U,'--','LineWidth',2);

for i=1:18

plot(hue(i),MinChroma(i),'.','MarkerSize',70,'Color',colors(i,:));

end

plot(hue,MinChroma,'k','LineWidth',3)

axis([10,350,2,7]);
xlabel('Hue angle (h^o)','FontSize',20);
ylabel('Chroma value (C^*)','FontSize',20);
set(gca,'FontSize',20,'LineWidth',2);
% hgexport(gcf,'Figures/reports.eps');

% p = polyfit(hue,MinChroma,11);
% fitti = polyval(p,10:350);
% 
% plot(10:350,fitti,'k','LineWidth',3)