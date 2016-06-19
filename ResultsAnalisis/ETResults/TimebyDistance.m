clear all
close all

load('F3_ANY.mat');
load('PatchDistance2.mat');
load('DistancePatchCenter.mat');

CHROMAS = A(1,:,1,1);
hue = 10:20:350;
[a,b] = pol2cart(deg2rad(hue),140*ones(1,18));
colors = applycform([60*ones(1,18); a; b]',makecform('lab2srgb'));

DisT = reshape(CloseDis(2,10:end,:,:),1,[]);
TimeT = reshape(sum(T(2:4,10:end,:,:),1),1,[]);

DisTN = DisT(TimeT~=0);
TimeTN = TimeT(TimeT~=0);

DisTN = round(DisTN*4)/4;

p = anova1(TimeTN,DisTN,'off');

statarray = grpstats(TimeTN,DisTN,'mean');

plot(statarray);