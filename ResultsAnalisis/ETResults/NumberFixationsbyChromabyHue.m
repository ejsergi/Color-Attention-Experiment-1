%{
This functions checks the total number of fixation in each path and
compares them in realtion to the chroma of the patch. The function is
calulated for each individual hue.
%}

clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');

CHROMAS = A(1,:,1,1);

for i=1:18
numFix(i,:) = permute(trimmean(reshape(sum(L(2:4,:,[i 18+i 2*18+i 3*18+i],[1,6,9,12],1)),24,[])',5,'round',1),[3 2 1]);
po = polyfit(CHROMAS,numFix(i,:),3);
yy(i,:) = polyval(po,1.3:0.05:10);
end

% p = anova1(numFix,[],'off');


plot(median(yy,2));
% po = polyfit(CHROMAS,numFixM,3);
% yy = polyval(po,1.3:0.05:10);
% 
% colors=lines(2);
% figure, hold on;
% plot(1.3:0.05:10,yy,'LineWidth',3,'Color',colors(2,:));
% plot(CHROMAS,numFixM,'o','LineWidth',2,'Color',colors(1,:));
% % axis([1,10,3,4.3]);
% xlabel('Chroma (C^*)');
% ylabel('Number of fixation on patch');
% set(gca,'LineWidth',2,'FontSize',20);