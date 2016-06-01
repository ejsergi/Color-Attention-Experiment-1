clear all
close all

load('F3_ANY.mat');
load('PatchDistance.mat');

CHROMAS = A(1,:,1,1);

Amean = mean(mean(A,3),4);
Dmean = mean(mean(CloseDis,3),4);

[h,l1,l2] = plotyy(CHROMAS,(Dmean(2,:)),CHROMAS,Amean(3,:)); hold on

set(h(1),'YLim',[4 5.25]);
xlabel('Chroma'); ylabel(h(1),'Distance in degree');
ylabel(h(2),'Posibility of reported');