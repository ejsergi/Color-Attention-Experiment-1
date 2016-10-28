clear all
close all

Moni = iccread('ColorNavSergiExp.icc');
ProfLab = iccread('Generic Lab Profile.icc');

Lab2Moni = makecform('icc', ProfLab, Moni);
Moni2Lab = makecform('icc', Moni, ProfLab);

N = 50000;

RGBall = cat(3,rand(N,1),rand(N,1),rand(N,1));

LABall = applycform(RGBall,Moni2Lab);

figure; axis equal;
grid on; hold on;
for i = 1:N
    plot3(LABall(i,1,2),LABall(i,1,3),LABall(i,1,1),'.','Color',RGBall(i,1,:),'MarkerSize',20)
end
view(67,13);
xlabel('a^*','FontSize',15), ylabel('b^*','FontSize',15), zlabel('L^*','FontSize',15);
set(gca,'FontSize',15);

hgexport(gcf,'AllPoints.eps');

