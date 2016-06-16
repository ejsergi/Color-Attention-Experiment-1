%{
This functions checks the total number of fixation in each path and
compares them in realtion to the chroma of the patch.

We can see significant difference with ANOVA, and as expected, it shows an
increasing number of fixations when chroma increases.
%}

clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');


CHROMAS = A(1,:,1,1);

numFix = reshape(sum(L(2:4,:,:,[1,6,9,12],1)),24,[])';

p = anova1(numFix,[],'off');

numFixM = trimmean(numFix,5,'round',1);
po = polyfit(CHROMAS,numFixM,3);
yy = polyval(po,1.3:0.05:10);

colors=lines(2);
figure, hold on;
plot(1.3:0.05:10,yy,'LineWidth',3,'Color',colors(2,:));
plot(CHROMAS,numFixM,'o','LineWidth',2,'Color',colors(1,:));
% axis([1,10,3,4.3]);
xlabel('Chroma (C^*)','FontSize',20);
ylabel('Number of fixation on patch','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20);

hgexport(gcf,'Figures/NumberOfFixChroma.eps')