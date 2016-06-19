clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');
load('DistancePatchCenter.mat');

CHROMAS = A(1,:,1,1);

figure; hold on
hueU = 1:3;
Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],:)...
    ,[2 1 3 4]),24,[]);
CloseDist = reshape(permute(1/CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
    3*18+hueU],:),[2 1 3 4]),24,[]);
for i=1:24
    ProbF(i) = trimmean(CloseDist(i,:).*Report(i,:),20)*2.4;
    stdF(i) = std(CloseDist(i,Report(i,:)==1)); 
end

plot(smooth(ProbF),'r');

hueU = 8:10;
Report = reshape(permute(A(3,:,[hueU 18+hueU 2*18+hueU 3*18+hueU],:),...
    [2 1 3 4]),24,[]);
CloseDist = reshape(permute(1/CloseDis(2,:,[hueU 18+hueU 2*18+hueU ...
    3*18+hueU],:),[2 1 3 4]),24,[]);
for i=1:24
    ProbF(i) = trimmean(CloseDist(i,:).*Report(i,:),20)*2.4;
    stdF(i) = std(CloseDist(i,Report(i,:)==1)); 
end

plot(smooth(ProbF),'g');

set(gca,'YLim',[0 1]);