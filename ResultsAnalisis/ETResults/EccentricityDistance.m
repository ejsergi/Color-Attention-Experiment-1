%{
Checking if there is a important depndence on the angle where the patch was
located. To do so we plot the distance between the closest fixation and the
patch center depending on the distance of the pacth twards the center. So
we will see if there is a center bias in ower data.

Results show a center bias, being the more far away from the center, the
more distant the closest fixation. Anova test confirms this center bias.
%}

clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');

disPatch = reshape(A(2,:,:,[1,6,9,12]),1,[]);
disFix = reshape(CloseDis(2,:,:,[1,6,9,12]),1,[]);

disLabel = disFix;
disLabel(2,:) = zeros(size(disFix));

for i=1:18
    comD(i) = median(disFix(logical((disPatch>(i-1)).*(disPatch<i))));
    disLabel(2,logical((disPatch>(i-1)).*(disPatch<i))) = i;
end

p = anova1(disLabel(1,:),disLabel(2,:),'off');


po = polyfit(0.5:17.5,comD,2);
yy = polyval(po,0.5:0.05:17.5);
colors=lines(2);
figure, hold on;
plot(0.5:0.05:17.5,yy,'LineWidth',3,'Color',colors(2,:));
plot(0.5:17.5,comD,'o','LineWidth',2,'Color',colors(1,:));
xlabel('Distance patch to center (^o)');
ylabel('Distance fixation to patch (^o)');
set(gca,'LineWidth',2,'FontSize',20);
% boxplot(disLabel(1,:),disLabel(2,:))
