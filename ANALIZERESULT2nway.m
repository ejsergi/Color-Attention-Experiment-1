clear all
close all

load('C.mat');
% A = B;

expnames = [11,12,14,15,16,18,19,20,21,22,24,25];
sele = [1:9:648 2:9:648 3:9:648];

previous = zeros(4,18,3,12);
timetaken = zeros(4,18,3,12);
totalreported = zeros(4,18,3,12);


for nex = 1:length(expnames);

nameExp = sprintf('%03d',expnames(nex));

load(['EXPERIMENTFILES/' nameExp '.mat']);
% load(['ImportET/ET_' nameExp '.mat']);

permu = info(1).Permutation;

iter = 1;
for i=1:4
    for j=1:18
        for n=1%:3
            means = [];
            mixtures = [];
            total = 0;
            
%             A(:,:,(i-1)*18+j,nex) = eyeMatrix(nameExp, info,EyeEvents,iter:iter+2);
            for t=1:3
                
                for l = 1:8
                    means = [means (info(iter).means(l).MEANMIXTURE+1)*30-14];
                end
                
                [seleI] = find(sele==iter);
                [permI] = find(permu==seleI);
                if permI~=1
                    if strcmp(info(sele(permu(permI-1))).L_Stimuli,'All');
                        previous(i,j,t,nex) = 1;
                    elseif strcmp(info(sele(permu(permI-1))).L_Stimuli,'50');
                        previous(i,j,t,nex) = 2;
                    elseif strcmp(info(sele(permu(permI-1))).L_Stimuli,'25');
                        previous(i,j,t,nex) = 3;
                    elseif strcmp(info(sele(permu(permI-1))).L_Stimuli,'75');
                        previous(i,j,t,nex) = 4;
                    end
                else
                previous(i,j,t,nex) = 1;
                end
                timetaken(i,j,t,nex) = info(iter).Time;
                totalreported(i,j,t,nex) = info(iter).LastSeen;
                total = total+info(iter).LastSeen;
                iter = iter+1;
                
                if t==3
                    iter = iter+6;
                end
                
                 
            end
        
            B = sort(means,'descend');
            result(i,j,n) = B(total); 
            
            
        end
    end
end

% result = median(result,3);

hue = [0 10:20:350 360];

[X,Y,Z] = meshgrid(hue,1:4,1:1); %Change last for adapt
[Xq,Yq,Zq] = meshgrid(0:360,1:4,1:1); %Change last for adapt

angles(:,:,nex) = [mean([result(:,1) result(:,end)],2) result mean([result(:,1) result(:,end)],2)];
% angles = interp2(X,Y,angles,Xq,Yq,'spline');

end

% save('C.mat','A')

anglesM=mean(angles,3);
anglesMstd=std(angles,[],3);

CHROMAS = A(1,:,1,1);
[a,b] = pol2cart(deg2rad(0:360),100*ones(1,361));
colors = applycform([50*ones(1,361); a; b]',makecform('lab2srgb'));

textla = {'All', '50', '25', '75'};
%%
% for t=1:size(angles,3);
% for j=1:4
% figure; 
% for i=1:361;
%     h = polar(deg2rad(i-1),10,'.'); hold on;
%     set(h,'MarkerSize',40,'Color',colors(i,:));
% end
% colorslines = lines(4);
% 
% h = polar(deg2rad(0:360),interp1(hue,anglesM(j,:),0:360,'pchip')); hold on
% set(h,'LineWidth',3,'Color',colorslines(j,:));
% 
% h = polar(deg2rad(0:360),interp1(hue,anglesM(j,:)-anglesMstd(j,:),0:360,'pchip')); hold on
% set(h,'LineWidth',2,'Color',colorslines(j,:),'LineStyle','--');
% 
% h = polar(deg2rad(0:360),interp1(hue,anglesM(j,:)+anglesMstd(j,:),0:360,'pchip')); hold on
% set(h,'LineWidth',2,'Color',colorslines(j,:),'LineStyle','--');
% 
% hgexport(gcf,['ResultsFigures/Reported/Mean_' textla{j} '.eps']);
% end
% end

%%
% colorsprev = [0 0 1; 0.5 0.5 0.5; 0.25 0.25 0.25; 0.75 0.75 0.75];
% 
% colorEcc = autumn(18);
% 
% for t=1:size(angles,3);
% for j=1:4
% figure; 
% for i=1:361;
%     h = polar(deg2rad(i-1),10,'.'); hold on;
%     set(h,'MarkerSize',40,'Color',colors(i,:));
% end
% colorslines = lines(4); 
% 
% h = polar(deg2rad(0:360),interp1(hue,angles(j,:,t),0:360,'pchip')); hold on
% set(h,'LineWidth',3,'Color',colorslines(j,:));
% 
% for i=1:18
%     eyet = A(:,:,(j-1)*18+i,t);
%     [~, firstcol] = find(eyet(4:6,:)==1);
% %     h = polar(deg2rad(repmat(hue(i+1),1,size(firstcol))),CHROMAS(firstcol),'ko'); hold on
%     for n = 1:3
%         if numel(firstcol)>=n
%         h(n) = polar(deg2rad(hue(i+1)),CHROMAS(firstcol(n)),'.'); hold on;
%         set(h(n),'MarkerSize',20,'Color',colorEcc(ceil(A(2,firstcol(n),(j-1)*18+i,t)),:));
%         end
%     end
% end
% colormap(colorEcc)
% colorBar = colorbar('eastoutside');
% set(colorBar,'Position',get(colorBar,'Position') + [0.08 0 0 0]);
% hgexport(gcf,['ResultsFigures/Reported/' textla{j} '_' sprintf('%03d',expnames(t)) '.eps']);
% close all
% end
% end

%%
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

%%
% for i=1:4
% checktime = timetaken(i,:,:,:);
% for j=1:4
% plottime(i,j) = median(checktime(previous(i,:,:,:)==j)); 
% end
% end
% plottime = plottime([1 3 2 4],[1 3 2 4]);
% plot(plottime','-o','LineWidth',3,'MarkerSize',10);
% legend('All','25','50','75','Location','NorthWest');
% set(gca,'XTick',[1;2;3;4],'XTickLabel',['All';'25 ';'50 ';'75 '],'XLim',[0.8 4.2],'FontSize',15);
% xlabel('Previous L^*','FontSize',15);
% ylabel('Median Time','FontSize',15);
% title('Adaptation time','FontSize',20);
% hgexport(gcf,'ResultsFigures/AdaptationRepresent.eps');
%%
% for i=1:4
% checktime = totalreported(i,:,:,:);
% for j=1:4
% plottime(i,j) = mean(checktime(previous(i,:,:,:)==j)); 
% end
% end
% plottime = plottime([1 3 2 4],[1 3 2 4]);
% plot(plottime','-o','LineWidth',3,'MarkerSize',10);
% legend('All','25','50','75','Location','NorthEast');
% set(gca,'XTick',[1;2;3;4],'XTickLabel',['All';'25 ';'50 ';'75 '],'XLim',[0.8 4.2],'FontSize',15);
% xlabel('Previous L^*','FontSize',15);
% ylabel('Average # of Reported','FontSize',15);
% title('Adaptation reported','FontSize',20);
% hgexport(gcf,'ResultsFigures/AdaptationRepresentReported.eps');

% %%
% EYES = sum(A(4:6,:,:,:),1);
% CHROMA = A(1,:,:,:);
% ECCEN = A(2,:,:,:);
% REPO = A(3,:,:,:);
% for i=1:max(EYES(:));
% ploteyes(i) = mean(ECCEN(EYES==i.*REPO==1));
% plotchrom(i) = mean(CHROMA(EYES==i.*REPO==1));
% end
% [ax,h1,h2] = plotyy(1:8,ploteyes,1:8,plotchrom);
% set(h1,'Marker','o','LineWidth',3,'MarkerSize',10);
% set(h2,'Marker','o','LineWidth',3,'MarkerSize',10);
% set(ax,'FontSize',15);
% xlabel('Detection order','FontSize',15);
% ylabel(ax(1),'Avarage eccentricity (visual angles)','FontSize',15);
% ylabel(ax(2),'Chroma of patches fixated','FontSize',15);
% title('Detection order only reported A','FontSize',20);
% hgexport(gcf,'ResultsFigures/EccentrictyAveragesReportedA.eps');

%%
EYES = sum(A(4:6,:,:,:),1);
CHROMA = A(1,:,:,:);
ECCEN = A(2,:,:,:);
REPO = A(3,:,:,:);
for i=1:max(EYES(:));
ploteyes(i) = mean(ECCEN(EYES==i));
plotchrom(i) = mean(CHROMA(EYES==i));
end
[ax,h1,h2] = plotyy(1:8,ploteyes,1:8,plotchrom);
set(h1,'Marker','o','LineWidth',3,'MarkerSize',10);
set(h2,'Marker','o','LineWidth',3,'MarkerSize',10);
set(ax,'FontSize',15);
xlabel('Detection order','FontSize',15);
ylabel(ax(1),'Avarage eccentricity (visual angles)','FontSize',15);
ylabel(ax(2),'Chroma of patches fixated','FontSize',15);
title('Detection order C','FontSize',20);
hgexport(gcf,'ResultsFigures/EccentrictyAveragesC.eps');