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
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

probR = reshape(permute(A(3,:,:,:),[3,4,2,1]),72,[]);
probR = mean(cat(2,probR(1:18,:),probR(18+(1:18),:),probR(2*18+(1:18),:),probR(2*18+(1:18),:)),2);

distantT = 3.5;
numFix = double(CloseDis(2,:,:,[1,3,5,6,11,12])<distantT);
numFix = reshape(permute(numFix,[3,4,2,1]),72,[]);
numFix = mean(cat(2,numFix(1:18,:),numFix(18+(1:18),:),numFix(2*18+(1:18),:),numFix(2*18+(1:18),:)),2);

figure; hold on; plot([0,1],[0,1],'--k');
for i=1:18
plot(probR(i),numFix(i),'.','MarkerSize',40,'Color',colors(i,:))
end

% figure; hold on; plot([0,1],[0,1],'--k');
% plot(probR(5,:),probR(15,:),'o')
% plot(numFix(5,:),numFix(15,:),'*')

