clear all
close all


load('F3_ANY.mat');
load('PatchDistance2.mat');

disPatch_chroma = reshape(permute(A(2,:,:,:),[2 1 3 4]),24,[]);

disPatch_hue = reshape(permute(A(2,:,:,:),[3 1 2 4]),72,[]);
disPatch_hue = [disPatch_hue(1:18,:) disPatch_hue(18+(1:18),:)...
    disPatch_hue(2*18+(1:18),:) disPatch_hue(3*18+(1:18),:)];

[p,t,stats] = anova1(disPatch_hue');
figure;
[c,m,h,nms] = multcompare(stats,'CType','tukey-kramer');




