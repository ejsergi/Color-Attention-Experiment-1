clear all
close all

%Load all the A data
load('F3_ANY.mat'); 
load('PatchDistance2.mat');
load('DistancePatchCenter.mat');
dispatch = A(2,:,:,:);
for i=1:size(dispatch,2)
    for j=1:size(dispatch,3)
        for t=1:size(dispatch,4)
            [~,indD] = min(abs(dispatch(1,i,j,t)-xx));
            CloseDis(2,i,j,t) = CloseDis(2,i,j,t)*mean(yy)/yy(indD);
        end
    end
end
CHROMAS = A(1,:,1,1);
hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
% colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));
colors = hsv(18);
colors = [colors(end,:); colors(1:end-1,:)];

probR = reshape(permute(A(3,:,:,:),[3,1,2,4]),72,[]);
probR = [probR(1:18,:) probR(18+(1:18),:) probR(2*18+(1:18),:) probR(3*18+(1:18),:)]';

[p,~,stats] = anova1(probR,[],'off');
figure;
[c,m]=multcompare(stats);

MeanFix = mean(probR,1);
StandError = std(probR,0,1)/sqrt(size(probR,1));

%%

distantT = 3.5;
numFix = double(CloseDis(2,:,:,[1,3,5,6,11,12])<distantT);
numFix = reshape(permute(numFix,[3 1 2 4]),72,[]);
numFix = [numFix(1:18,:) numFix(18+(1:18),:) numFix(2*18+(1:18),:) numFix(3*18+(1:18),:)]';

[p2,~,stats2] = anova1(numFix,[],'off');
figure;
[c2,m2]=multcompare(stats2);

MeanFix2 = mean(numFix,1);
StandError2 = std(numFix,0,1)/sqrt(size(numFix,1));
colorlin = lines(2);
figure, hold on;
subplot(2,1,1); hold on
errorbar(hue,MeanFix,StandError,'k','LineWidth',2);
for i = 1:18
plot(hue(i),MeanFix(i),'.','MarkerSize',40,'Color',colors(i,:));
end
ylabel('Prob. Report','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20,'XLim',[0 360],'YLim',[0.555,0.72]);

subplot(2,1,2); hold on
errorbar(hue,MeanFix2,StandError2,'--k','LineWidth',2);
for i = 1:18
plot(hue(i),MeanFix2(i),'o','MarkerSize',10,'LineWidth',2,'Color',colors(i,:));
end
% axis([1,10,3,4.3]);
xlabel('Hue angle (h^o)','FontSize',20);
ylabel('Prob. Fixate','FontSize',20);
set(gca,'LineWidth',2,'FontSize',20,'XLim',[0 360]);

hgexport(gcf,'Probingeneral.eps');