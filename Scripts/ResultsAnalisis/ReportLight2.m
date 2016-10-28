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
probR = [reshape(probR(1:18,:),1,[]); reshape(probR(18+(1:18),:),1,[]);...
    reshape(probR(2*18+(1:18),:),1,[]); reshape(probR(3*18+(1:18),:),1,[]);]';

[p,~,stats] = anova1(probR,[],'off');
figure;
[c,m]=multcompare(stats);

ProM = mean(probR,1);
ProS = std(probR,1)/sqrt(size(probR,1));


distantT = 3.5;
numFix = double(CloseDis(2,:,:,[1,3,5,6,11,12])<distantT);
numFix = reshape(permute(numFix,[3 1 2 4]),72,[]);
numFix = [reshape(numFix(1:18,:),1,[]); reshape(numFix(18+(1:18),:),1,[]);...
    reshape(numFix(2*18+(1:18),:),1,[]); reshape(numFix(3*18+(1:18),:),1,[]);]';

[p2,~,stats2] = anova1(numFix,[],'off');
figure;
[c2,m2]=multcompare(stats2);

ProM2 = mean(numFix,1);
ProS2 = std(numFix,1)/sqrt(size(numFix,1));