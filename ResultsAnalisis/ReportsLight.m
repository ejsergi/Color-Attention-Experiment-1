%{
The plot shows the probability of reported by each hue for the 4 different
lightness. Wee can see the best results are when lightness is 50, and worse
when L has all the posible values. Also dark and light lightness show a
similar result.

Even though K-S test still shows a significand difference between 25 and
75 L value.
%}

clear all
close all

chromas = [1.3 1.675 2.05 2.425 2.8 3.175 3.55 3.925 4.3 4.675 5.05 5.425 5.8...
    6.175 6.55 6.925 7.3 7.675 8.05 8.425 8.8 9.175 9.55 9.925];

load('ReportLight.mat');

hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

nChroma = 1.3:0.01:9.925;

color = lines(4);
figure; hold on;
for i=1:4
RChr(:,i) = interp1(chromas,smooth(L_Report(:,i)),nChroma);
end

plot(nChroma,RChr,'LineWidth',3)
legend('L^* \in [0,100]','L^*=50','L^*=25','L^*=75','Location','SouthEast');
xlabel('Chroma (C^*)');
ylabel('Probability of report');
set(gca,'FontSize',20,'LineWidth',2);


% for i=1:18
% 
% RChr = interp1(chromas,smooth(L_all(:,i)),nChroma);
% [diff,inx] = min(abs(RChr-0.5));
% LChroma(i,1) = nChroma(inx);
% 
% RChr = interp1(chromas,smooth(L_50(:,i)),nChroma);
% [diff,inx] = min(abs(RChr-0.5));
% LChroma(i,2) = nChroma(inx);
% 
% RChr = interp1(chromas,smooth(L_25(:,i)),nChroma);
% [diff,inx] = min(abs(RChr-0.5));
% LChroma(i,3) = nChroma(inx);
% 
% RChr = interp1(chromas,smooth(L_75(:,i)),nChroma);
% [diff,inx] = min(abs(RChr-0.5));
% LChroma(i,4) = nChroma(inx);
% 
% end

[h,t] = kstest2(RChr(:,3),RChr(:,4));