clear all
close all

nameExp = 'EXPERIMENT1Sergi';

load(['EXPERIMENTFILES/' nameExp 'Simple.mat']);

%%
clearvars -except infosimple nameExp
close all
iter = 1;
for i=1:length(infosimple)/3
    for j=1:3
        
        if infosimple(iter).LastSeen == 0
            chroma(i,j) = 100;
        else
            chroma(i,j) = infosimple(iter).means(infosimple(iter).index(infosimple(iter).LastSeen)).mean(2);
        end
        iter = iter+1;
    end
end

result = min(chroma');

hue = [0 10:20:350 360];
angles = [mean([result(1) result(end)]) result mean([result(1) result(end)])];

angles = interp1(hue,angles,0:360,'spline');

[a,b] = pol2cart(deg2rad(0:360),100*ones(1,361));
colors = applycform([50*ones(1,361); a; b]',makecform('lab2srgb'));
for i=1:361;
    h = polar(deg2rad(i-1),4,'.'); hold on;
    set(h,'MarkerSize',40,'Color',colors(i,:));
end
h = polar(deg2rad(0: 360),angles,'k'); hold on
legend(h,'Chroma threshold','Location','northoutside');
set(h,'LineWidth',3);
% h = polar(deg2rad(0:360),ParticipantAngles(2,:),'r');
% set(h,'LineWidth',2);
set(gca,'FontSize',15);
th = findall(gcf,'Type','text');
for i = 1:length(th),
      set(th(i),'FontSize',15)
end

%%
hgexport(gcf,[nameExp 'Results.eps']);

%%
close all
iter = 1;
for i=1:length(infosimple)/3
    for j=1:3
       

            time(i,j) = infosimple(iter).Time;

        iter = iter+1;
    end
end
close all;
time = sum(time,2);
resTime = [mean([time(1) time(end)]);time;mean([time(1) time(end)])];
resTime = interp1(hue,resTime,0:360,'spline');
[a,b] = pol2cart(deg2rad(0:360),100*ones(1,361));
colors = applycform([50*ones(1,361); a; b]',makecform('lab2srgb'));
for i=1:361;
    h = polar(deg2rad(i-1),40,'.'); hold on;
    set(h,'MarkerSize',40,'Color',colors(i,:));
end
h = polar(deg2rad(0:360),resTime,'k: '); hold on
set(h,'LineWidth',3);
legend(h,'Time used (s)','Location','northoutside');
set(gca,'FontSize',15);
th = findall(gcf,'Type','text');
for i = 1:length(th),
      set(th(i),'FontSize',15)
end

%%
hgexport(gcf,[nameExp 'Time.eps']);
