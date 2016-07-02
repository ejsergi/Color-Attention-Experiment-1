clear all
% close all

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

figure; hold on

% hueU = 16:17;
% Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],:),...
%     [2 1 3 4]),24,[]);
% CloseDist = reshape(permute(1/CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
%     3*18+hueU],:),[2 1 3 4]),24,[]);
% for i=1:24
%     ProbF(i) = trimmean(CloseDist(i,:).*Report(i,:),20)*2.4;
%     stdF(i) = std(CloseDist(i,Report(i,:)==1)); 
% end
% 
% plot(CHROMAS,smooth(ProbF),'m','LineWidth',3);
% 
% hueU = 12:15;
% Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],:),...
%     [2 1 3 4]),24,[]);
% CloseDist = reshape(permute(1/CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
%     3*18+hueU],:),[2 1 3 4]),24,[]);
% for i=1:24
%     ProbF(i) = trimmean(CloseDist(i,:).*Report(i,:),20)*2.4;
%     stdF(i) = std(CloseDist(i,Report(i,:)==1)); 
% end
% 
% plot(CHROMAS,smooth(ProbF),'b','LineWidth',3);



area([0 360],[0.29 0.29],'LineWidth',2,'LineStyle','--','FaceAlpha',0.1,'FaceColor','k');

hueU = 1:2;
Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],[1 6 9 12]),...
    [2 1 3 4]),24,[]);
CloseDist2 = reshape(permute(double(CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
    3*18+hueU],[1 6 9 12])<3.5),[2 1 3 4]),24,[]);

plot(CHROMAS,smooth(mean(CloseDist2,2)),'LineWidth',3,'Color',[255, 64, 64]/255);
plot(CHROMAS,smooth(mean(Report,2)),'--','LineWidth',3,'Color',[255, 64, 64]/255);


hueU = 8:9;
Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],[1 6 9 12]),...
    [2 1 3 4]),24,[]);
CloseDist1 = reshape(permute(double(CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
    3*18+hueU],[1 6 9 12])<3.5),[2 1 3 4]),24,[]);

plot(CHROMAS,smooth(mean(CloseDist1,2)),'LineWidth',3,'Color',[50, 205, 50]/255);
plot(CHROMAS,smooth(mean(Report,2)),'--','LineWidth',3,'Color',[50, 205, 50]/255);

set(gca,'XLim',[1 10],'YLim',[0 1]);
legend('Random T.','Fixation','Report','Fixation','Report','Location','SouthEast');
xlabel('Chroma value (C^*)','FontSize',20);
ylabel('Probability','FontSize',20);
grid on;
set(gca,'FontSize',20,'LineWidth',2);

hgexport(gcf,'Figures2/FixAndRepRG.eps');


figure; hold on
area([0 360],[0.29 0.29],'LineWidth',2,'LineStyle','--','FaceAlpha',0.1,'FaceColor','k');

hueU = 4:5;
Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],[1 6 9 12]),...
    [2 1 3 4]),24,[]);
CloseDist1 = reshape(permute(double(CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
    3*18+hueU],[1 6 9 12])<3.5),[2 1 3 4]),24,[]);

plot(CHROMAS,smooth(mean(CloseDist1,2)),'LineWidth',3,'Color',[255, 193, 37]/255);
plot(CHROMAS,smooth(mean(Report,2)),'--','LineWidth',3,'Color',[255, 193, 37]/255);


hueU = 13:14;
Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],[1 6 9 12]),...
    [2 1 3 4]),24,[]);
CloseDist1 = reshape(permute(double(CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
    3*18+hueU],[1 6 9 12])<3.5),[2 1 3 4]),24,[]);

plot(CHROMAS,smooth(mean(CloseDist1,2)),'LineWidth',3,'Color',[30, 144, 255]/255);
plot(CHROMAS,smooth(mean(Report,2)),'--','LineWidth',3,'Color',[30, 144, 255]/255);

% p = anova1(CloseDist');

set(gca,'XLim',[1 10],'YLim',[0 1]);
legend('Random T.','Fixation','Report','Fixation','Report','Location','SouthEast');
xlabel('Chroma value (C^*)','FontSize',20);
ylabel('Probability','FontSize',20);
grid on;
set(gca,'FontSize',20,'LineWidth',2);

hgexport(gcf,'Figures2/FixAndRepBY.eps');