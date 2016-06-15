%{
This script will study the relation between the chroma and the fixation
order, in this case the higer chromas should have the first fixations and
later fixation chromas will drop.

Results confirm that first fixation were on patches with higher chroma.
ANOVA confirms the significance of these differences.

It would be interesting to show this data for different Hues. Also it can
be checket how the different hues behave when observing 
%}

clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');

OrderF = reshape(sum(A(4:6,:,:,[1,6,9,12]),1),1,[]);
ChromaF = reshape(A(1,:,:,[1,6,9,12]),1,[]);

OrderDis = ChromaF(OrderF>0);
OrderDis(2,:) = OrderF(OrderF>0);

p = anova1(OrderDis(1,:),OrderDis(2,:),'off');

for i=1:8
    comD(i) = median(OrderDis(1,OrderDis(2,:)==i));
end


po = polyfit(1:8,comD,2);
yy = polyval(po,1:0.05:8);
colors=lines(2);
figure, hold on;
plot(1:0.05:8,yy,'LineWidth',3,'Color',colors(2,:));
plot(1:8,comD,'o','LineWidth',2,'Color',colors(1,:));
xlabel('Order of Fixation','FontSize',20);
ylabel('Distance fixation to center (^o)','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20);
hgexport(gcf,'Figures/ChromaOrder.eps');
