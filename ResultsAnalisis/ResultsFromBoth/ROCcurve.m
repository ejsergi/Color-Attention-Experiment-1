clear all
close all

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

figure, hold on;
plot([0 1],[0 1],'k--','LineWidth',2);

hueU = 1:3;
ReportedN = reshape(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],[1 6 9 12]),1,[]);
FixatedN = reshape(CloseDis(2,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],[1 6 9 12]),1,[]);

distanceF = 0:0.5:30;

for i=1:length(distanceF);
    
    TP = (FixatedN<=distanceF(i)).*ReportedN;
    FN = (FixatedN>distanceF(i)).*ReportedN;
    
    FP = (FixatedN<=distanceF(i)).*(1-ReportedN);
    TN = (FixatedN>distanceF(i)).*(1-ReportedN);
    
    TPR(i) = sum(TP)/sum(ReportedN);
    FPR(i) = sum(FP)/sum(1-ReportedN);
end

plot(FPR,TPR,'r','LineWidth',2)


hueU = 5:8;
ReportedN = reshape(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],[1 6 9 12]),1,[]);
FixatedN = reshape(CloseDis(2,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],[1 6 9 12]),1,[]);

distanceF = 0:0.5:30;

for i=1:length(distanceF);
    
    TP = (FixatedN<=distanceF(i)).*ReportedN;
    FN = (FixatedN>distanceF(i)).*ReportedN;
    
    FP = (FixatedN<=distanceF(i)).*(1-ReportedN);
    TN = (FixatedN>distanceF(i)).*(1-ReportedN);
    
    TPR(i) = sum(TP)/sum(ReportedN);
    FPR(i) = sum(FP)/sum(1-ReportedN);
end

plot(FPR,TPR,'g','LineWidth',2)