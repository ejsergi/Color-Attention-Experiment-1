clear all
close all

load('PointsLab.mat');

color = applycform(pointsLab,makecform('lab2srgb'));

% K = convhull(pointsLab(:,2),pointsLab(:,3),pointsLab(:,1));
% h = trisurf(K,pointsLab(:,2),pointsLab(:,3),pointsLab(:,1),1:size(pointsLab,1));
% colormap(color);
% set(h, 'linestyle', 'none');

randSel = randperm(size(pointsLab,1),50000);
figure; axis equal;
grid on; hold on;
for i = randSel
    plot3(pointsLab(i,2),pointsLab(i,3),pointsLab(i,1),'.','Color',color(i,:),'MarkerSize',20)
end
view(110,15);
xlabel('a^*','FontSize',15), ylabel('b^*','FontSize',15), zlabel('L^*','FontSize',15);
set(gca,'FontSize',15);

hgexport(gcf,'SelectedPoints.eps');