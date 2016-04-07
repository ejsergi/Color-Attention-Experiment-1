clear all
close all

Moni = iccread('MonitorExperiementBo.icc');
ProfLab = iccread('Generic Lab Profile.icc');

Lab2Moni = makecform('icc', ProfLab, Moni);
Moni2Lab = makecform('icc', Moni, ProfLab);

RGBall = cat(3,rand(100000,1),rand(100000,1),rand(100000,1));

LABall = applycform(RGBall,Moni2Lab);

L = LABall(:,:,1);

pointsLab = [];

for Ltar = 5:95
    
    L50 = LABall(logical((L>=Ltar-0.5).*(L<=Ltar+0.5)),1,:);

k = convhull(L50(:,1,2),L50(:,1,3));

bound = [L50(k,1,2) L50(k,1,3)];

newBound = interppolygon(bound,1000);

DIST = sqrt(sum(newBound.^2,2));
radius = min(DIST);

t = 0:2*pi/200:2*pi;

[px, py] = meshgrid(-radius:radius/60:radius,-radius:radius/60:radius);

in = inpolygon(px,py,radius*cos(t),radius*sin(t));

ptx = px(in); pty = py(in);

pointsLab = [pointsLab; Ltar*ones(size(ptx)) ptx pty];

Ltar

end

% save('PointsLab.mat','pointsLab');

