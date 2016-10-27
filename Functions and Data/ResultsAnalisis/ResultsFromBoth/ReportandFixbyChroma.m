clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');
load('DistancePatchCenter.mat');

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



hueU = 1:3;
Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],:)...
    ,[2 1 3 4]),24,[]);
CloseDist = reshape(permute(1/CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
    3*18+hueU],:),[2 1 3 4]),24,[]);
for i=1:24
    ProbFR(i) = trimmean(CloseDist(i,:).*Report(i,:),20)*2.4;
    stdF(i) = std(CloseDist(i,Report(i,:)==1)); 
end

Red = CloseDist(:).*Report(:);

plot(CHROMAS,smooth(ProbFR),'r','LineWidth',3);

hueU = 5:6;
Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],:),...
    [2 1 3 4]),24,[]);
CloseDist = reshape(permute(1/CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
    3*18+hueU],:),[2 1 3 4]),24,[]);
for i=1:24
    ProbFG(i) = trimmean(CloseDist(i,:).*Report(i,:),20)*2.4;
    stdF(i) = std(CloseDist(i,Report(i,:)==1)); 
end

plot(CHROMAS,smooth(ProbFG),'g','LineWidth',3);

set(gca,'YLim',[0 1]);
legend('h^o = [310^o,330^o]','h^o = [230^o,270^o]','Location','SouthEast');
xlabel('Chroma value (C^*)','FontSize',25);
ylabel('Prob of rep. & precise fix.','FontSize',25);
grid on;
set(gca,'FontSize',25,'LineWidth',2);

hgexport(gcf,'FixAndRepBM.eps');


