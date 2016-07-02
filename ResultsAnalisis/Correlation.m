clear all
close all

%Load all the A data
load('F3_ANY.mat'); 
load('PatchDistance2.mat');
load('DistancePatchCenter.mat');
load('TimetoReport.mat');
load('Totalnumberoffixationsperstimulus.mat');
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

probR = reshape(mean(A(3,:,:,:),2),1,[])';
numFix = reshape(mean(double(CloseDis(2,:,:,:)<3.5),2),1,[])';
timeR = reshape(mean(time,1),1,[])';
numOF = reshape(mean(NumberOfFix,1),1,[])';

[R,P]= corrplot([probR numFix timeR numOF]);


