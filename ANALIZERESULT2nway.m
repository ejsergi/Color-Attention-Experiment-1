clear all
close all

nameExp = '003';

load(['EXPERIMENTFILES/' nameExp '.mat']);

iter = 1;
for i=1:4
    for j=1:18
        for n=1%:3
            means = [];
            mixtures = [];
            total = 0;
            for t=1:3
                
                for l = 1:8
                    
                    means = [means info(iter).means(l).mean(2)];
                    mixtures = [mixtures info(iter).means(l).MEANMIXTURE];
                    
                end
                
                total = total+info(iter).LastSeen;
                iter = iter+1;
                
                if t==3
                    iter = iter+6;
                end
                 
            end
        
            B = sort(means,'descend');
            C = sort(mixtures,'descend');
            result(i,j,n) = C(total);    
            
        end
    end
end

% result = median(result,3);

hue = [0 10:20:350 360];

[X,Y,Z] = meshgrid(hue,1:4,1:1); %Change last for adapt
[Xq,Yq,Zq] = meshgrid(0:360,1:4,1:1); %Change last for adapt

angles = [mean([result(:,1) result(:,end)],2) result mean([result(:,1) result(:,end)],2)];
% angles = interp2(X,Y,angles,Xq,Yq,'spline');

[a,b] = pol2cart(deg2rad(0:360),100*ones(1,361));
colors = applycform([50*ones(1,361); a; b]',makecform('lab2srgb'));

for j=1:4
figure; 
for i=1:361;
    h = polar(deg2rad(i-1),0,'.'); hold on;
    set(h,'MarkerSize',40,'Color',colors(i,:));
end
colorslines = lines(4);

h = polar(deg2rad(hue),angles(j,:)); hold on
set(h,'LineWidth',3,'Color',colorslines(j,:));
end


% % h = polar(deg2rad(0:360),ParticipantAngles(2,:),'r');
% % set(h,'LineWidth',2);
% set(gca,'FontSize',15);
% th = findall(gcf,'Type','text');
% for i = 1:length(th),
%       set(th(i),'FontSize',15)
% end
% 
% %%
% hgexport(gcf,[nameExp 'Results.eps']);
% 
% %%
% close all
% iter = 1;
% for i=1:length(infosimple)/3
%     for j=1:3
%        
% 
%             time(i,j) = infosimple(iter).Time;
% 
%         iter = iter+1;
%     end
% end
% close all;
% time = sum(time,2);
% resTime = [mean([time(1) time(end)]);time;mean([time(1) time(end)])];
% resTime = interp1(hue,resTime,0:360,'spline');
% [a,b] = pol2cart(deg2rad(0:360),100*ones(1,361));
% colors = applycform([50*ones(1,361); a; b]',makecform('lab2srgb'));
% for i=1:361;
%     h = polar(deg2rad(i-1),40,'.'); hold on;
%     set(h,'MarkerSize',40,'Color',colors(i,:));
% end
% h = polar(deg2rad(0:360),resTime,'k: '); hold on
% set(h,'LineWidth',3);
% legend(h,'Time used (s)','Location','northoutside');
% set(gca,'FontSize',15);
% th = findall(gcf,'Type','text');
% for i = 1:length(th),
%       set(th(i),'FontSize',15)
% end
% 
% %%
% hgexport(gcf,[nameExp 'Time.eps']);
