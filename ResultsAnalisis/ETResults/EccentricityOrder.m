%{
Checking center-bias twards comparing the distance of each fixation on
patch from the center and the order of the fixation. If there is
center-bias the first fixations will be closer to the center.

Results show a center bias, being first fixations closeset to the center,
when compared to latest fixations. ANOVA test confirms the significance of
this data.
%}

clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');

OrderF = reshape(sum(A(4:6,:,:,[1,6,9,12]),1),1,[]);
DistanceF = reshape(A(2,:,:,[1,6,9,12]),1,[]);

OrderDis = DistanceF(OrderF>0);
OrderDis(2,:) = OrderF(OrderF>0);

p = anova1(OrderDis(1,:),OrderDis(2,:),'off');

for i=1:8
    comD(i) = median(OrderDis(1,OrderDis(2,:)==i));
end


po = polyfit(1:8,comD,3);
yy = polyval(po,1:0.05:8);
colors=lines(2);
figure, hold on;
plot(1:0.05:8,yy,'LineWidth',3,'Color',colors(2,:));
plot(1:8,comD,'o','LineWidth',2,'Color',colors(1,:));
xlabel('Order of Fixation');
ylabel('Distance fixation to center (^o)');
set(gca,'LineWidth',2,'FontSize',20);
% boxplot(disLabel(1,:),disLabel(2,:))
