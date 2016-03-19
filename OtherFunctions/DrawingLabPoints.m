load('EXPERIMENTFILES/EXPERIMENT1SanajanaSimple.mat');

[x,y] = pol2cart(1:360,20*ones(1,360));
colors = applycform([50*ones(1,360);5*x;5*y]',makecform('lab2srgb'));
figure; hold on; axis equal; grid on;
for i=1:360
    plot(x(i),y(i),'.','MarkerSize',30,'Color',colors(i,:));
end

iter = 1;
for i=1:length(infosimple)
    for j=1:8
        hue(iter) = deg2rad(str2num(infosimple(i).Hue_Stimuli));
        chroma(iter) = infosimple(i).means(j).mean(2);
        iter = iter+1;
    end
end
    
[a,b] = pol2cart(hue,chroma);
colorab = applycform([50*ones(1,length(a));a;b]',makecform('lab2srgb'));

for i=1:length(a)
    plot(a(i),b(i),'o','MarkerSize',10,'LineWidth',3,'Color',colorab(i,:));
end
xlabel('a^*','FontSize',15); ylabel('b^*','FontSize',15); 
title('Patch colors for L=50','FontSize',18);
set(gca,'FontSize',15);
hgexport(gcf,'FIGURESPRESENTATION/PatchColors.eps');

