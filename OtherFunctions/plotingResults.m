clear all
close all

load('ParticipantAngles.mat');

[a,b] = pol2cart(deg2rad(0:360),100*ones(1,361));
colors = applycform([50*ones(1,361); a; b]',makecform('lab2srgb'));
for i=1:361;
    h = polar(deg2rad(i-1),4,'.'); hold on;
    set(h,'MarkerSize',40,'Color',colors(i,:));
end
h = polar(deg2rad(0:360),ParticipantAngles(1,:),'k'); hold on
set(h,'LineWidth',3);
% h = polar(deg2rad(0:360),ParticipantAngles(2,:),'r');
% set(h,'LineWidth',2);
set(gca,'FontSize',30);
th = findall(gcf,'Type','text');
for i = 1:length(th),
      set(th(i),'FontSize',15)
end

%%
hgexport(gcf,'ResultsSanjana.eps');