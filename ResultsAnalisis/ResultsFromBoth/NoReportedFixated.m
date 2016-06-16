clear all
close all

load('FixAndNoRep.mat');
load('Report.mat');

figure; hold on;

plot(mean(FixAndNoRep(:,1:3),2),'r','LineWidth',3);
plot(mean(FixAndNoRep(:,6:9),2),'g','LineWidth',3);

plot(mean(Report(:,1:3),2),'--r','LineWidth',3);
plot(mean(Report(:,6:9),2),'--g','LineWidth',3);

xlabel('Chroma','FontSize',20);
ylabel('Prob of no report and fixation','FontSize',20);
set(gca,'FontSize',20,'LineWidth',2);
hgexport(gcf,'FixAndNoRep.eps');