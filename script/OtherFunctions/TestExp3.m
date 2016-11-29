clear all
close all

Moni = iccread('ColorNavSergiExp.icc');
ProfLab = iccread('Generic Lab Profile.icc');

Lab2Moni = makecform('icc', ProfLab, Moni);
Moni2Lab = makecform('icc', Moni, ProfLab);

RGBall = cat(3,rand(100000,1),rand(100000,1),rand(100000,1));

LABall = applycform(RGBall,Moni2Lab);

L = LABall(:,:,1);

%Which L are we targeting
Ltar = 50;

L50 = LABall(logical((L>=Ltar-0.5).*(L<=Ltar+0.5)),1,:);

k = convhull(L50(:,1,2),L50(:,1,3));

bound = [L50(k,1,2) L50(k,1,3)];

newBound = interppolygon(bound,1000);

DIST = sqrt(sum(newBound.^2,2));
radius = min(DIST);

t = 0:2*pi/200:2*pi;

[px, py] = meshgrid(-radius:radius/60:radius,-radius:radius/60:radius);

in = inpolygon(px,py,radius*cos(t),radius*sin(t));

ptx = px(in); pty = py(in);

Radsel = floor(rand(500)*(length(ptx)-1)+1);

TESTLab = cat(3,ones(500)*Ltar,ptx(Radsel),pty(Radsel));

TESTMoni = applycform(TESTLab,Lab2Moni);

imshow(TESTMoni);

%% PLOTS
color = applycform([ones(size(newBound,1),1)*Ltar,newBound(:,1),newBound(:,2)],Lab2Moni);
color2 = applycform([ones(size(ptx,1),1)*Ltar,ptx,pty],Lab2Moni);
figure; hold on; axis equal; grid on;
for i=1:size(newBound,1)
    plot(newBound(i,1),newBound(i,2),'.','MarkerSize',15,'Color',color(i,:));
end
for i=1:length(ptx)
    plot(ptx(i),pty(i),'.','MarkerSize',15,'Color',color2(i,:));
end
xlabel('a^*','FontSize',15); ylabel('b^*','FontSize',15); 
title('Selected colors for L=50','FontSize',18);
set(gca,'FontSize',15);
% hgexport(gcf,'FIGURESPRESENTATION/SelectColors.eps');

