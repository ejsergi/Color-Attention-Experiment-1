clear all
close all

load('F3_BNY1.mat');
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
            
%           [A(:,:,(i-1)*18+j,nex),L(:,:,(i-1)*18+j,nex),T(:,:,(i-1)*18+j,nex)]...
%                 = eyeMatrix(nameExp, info,EyeEvents,iter:iter+2);
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

% save('F3_BNY.mat','A','L','T')

anglesM=mean(angles,3);
anglesMstd=std(angles,[],3);

CHROMAS = A(1,:,1,1);
[a,b] = pol2cart(deg2rad(0:360),100*ones(1,361));
colors = applycform([50*ones(1,361); a; b]',makecform('lab2srgb'));

textla = {'All', '50', '25', '75'};
%% ALL THE HUES AVERAGE
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

%% ALL THE HUES PER OBSERVER
% colorsprev = [0 0 1; 0.5 0.5 0.5; 0.25 0.25 0.25; 0.75 0.75 0.75];
% 
% colorEcc = parula(18);
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
% h = polar(deg2rad(0:360),ParticipantAngles(2,:),'r');
% set(h,'LineWidth',2);
% set(gca,'FontSize',15);
% th = findall(gcf,'Type','text');
% for i = 1:length(th),
%       set(th(i),'FontSize',15)
% end

%%
% hgexport(gcf,[nameExp 'Results.eps']);

%%
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
% 
% hgexport(gcf,[nameExp 'Time.eps']);

%% Adaptation time
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
% hgexport(gcf,'ResultsFigures/AdaptationRepresentTime.eps');

%% Adaptation reported
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

%% Detection order only reported
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
% title('Detection order only reported C','FontSize',20);
% hgexport(gcf,'ResultsFigures/EccentrictyAveragesReportedC.eps');

%% Detection order
% EYES = sum(A(4:6,:,:,:),1);
% CHROMA = A(1,:,:,:);
% ECCEN = A(2,:,:,:);
% REPO = A(3,:,:,:);
% for i=1:max(EYES(:));
% ploteyes(i) = mean(ECCEN(EYES==i));
% plotchrom(i) = mean(CHROMA(EYES==i));
% end
% [ax,h1,h2] = plotyy(1:8,ploteyes,1:8,plotchrom);
% set(h1,'Marker','o','LineWidth',3,'MarkerSize',10);
% set(h2,'Marker','o','LineWidth',3,'MarkerSize',10);
% set(ax,'FontSize',15);
% xlabel('Detection order','FontSize',15);
% ylabel(ax(1),'Avarage eccentricity (visual angles)','FontSize',15);
% ylabel(ax(2),'Chroma of patches fixated','FontSize',15);
% title('Detection order C','FontSize',20);
% hgexport(gcf,'ResultsFigures/EccentrictyAveragesC.eps');

%% Prob of Fixated by Chroma (AVERAGE)
% CHROMA = A(1,:,1,1);
% probaFix = zeros(1,24);
% reported = zeros(1,24);
% for i=1:24
%     numfix = L(2:4,i,:,:);
%     numRep = A(3,i,:,:);
%     probaFix(i) = sum(numfix(:))/(72*12);
%     reported(i) = sum(numRep(:))/(72*12);
% end
% map = winter(256);
% nCHROMA = min(CHROMA):0.01:max(CHROMA);
% probaFix = interp1(CHROMA,probaFix,nCHROMA,'linear');
% reported = interp1(CHROMA,reported,nCHROMA,'pchip');
% figure; hold on
% for i=1:length(probaFix)
%     plot(nCHROMA(i),probaFix(i),'.','Color',map(ceil(reported(i)*255)+1,:)...
%         ,'MarkerSize',15)
% end
% colormap(map);
% colbar = colorbar('southoutside');
% set(colbar,'Ticks',[0;1],'TickLabels',['No reported';'Reported   ']);
% xlabel('Chroma');
% ylabel('Probability of being fixated');
% axis([0 10 0 1]);
% set(gca,'FontSize',15);
% title('Prob of Fixation (Average hues and observers)');
% hgexport(gcf,'ResultsFigures/ProbFixation/AverageAllL.eps');

%% Prob of Fixated (By observers)
% CHROMA = A(1,:,1,1);
% 
% for j = 1:12
% probaFix = zeros(1,24);
% reported = zeros(1,24);
% for i=1:24
%     numfix =  L(2:4,i,:,j);
%     numRep = A(3,i,:,j);
%     probaFix(i) = sum(numfix(:))/(72);
%     reported(i) = sum(numRep(:))/(72);
% end
% map = winter(256);
% nCHROMA = min(CHROMA):0.01:max(CHROMA);
% probaFix = interp1(CHROMA,probaFix,nCHROMA,'pchip');
% reported = interp1(CHROMA,reported,nCHROMA,'pchip');
% figure; hold on
% for i=1:length(probaFix)
%     plot(nCHROMA(i),probaFix(i),'.','Color',map(ceil(reported(i)*255)+1,:)...
%         ,'MarkerSize',15)
% end
% colormap(map);
% colbar = colorbar('southoutside');
% set(colbar,'Ticks',[0;1],'TickLabels',['No reported';'Reported   ']);
% xlabel('Chroma');
% ylabel('Probability of being fixated');
% set(gca,'FontSize',15);
% axis([0 10 0 1]);
% title(['Prob of Fixation (Observer ' sprintf('%03d',j) ')']);
% hgexport(gcf,['ResultsFigures/ProbFixation/Observer/ObserverL_' ...
%     sprintf('%03d',j) '.eps']);
% close all
% end

%% Prob of Fixated (By hues)
% CHROMA = A(1,:,1,1);
% 
% for j = 1:12
% probaFix = zeros(1,24);
% reported = zeros(1,24);
% for i=1:18
%     numfix = double(A(4:6,i,[j 18+j 18*2+j 18*3+j],:)>=1);
%     numRep = double(A(3,i,[j 18+j 18*2+j 18*3+j],:)==1);
%     probaFix(i) = sum(numfix(:))/(12*4);
%     reported(i) = sum(numRep(:))/(12*4);
% end
% map = winter(256);
% nCHROMA = min(CHROMA):0.01:max(CHROMA);
% probaFix = interp1(CHROMA,probaFix,nCHROMA,'pchip');
% reported = interp1(CHROMA,reported,nCHROMA,'pchip');
% figure; hold on
% for i=1:length(probaFix)
%     plot(nCHROMA(i),probaFix(i),'.','Color',map(ceil(reported(i)*255)+1,:)...
%         ,'MarkerSize',15)
% end
% colormap(map);
% colbar = colorbar('southoutside');
% set(colbar,'Ticks',[0;1],'TickLabels',['No reported';'Reported   ']);
% xlabel('Chroma');
% ylabel('Probability of being fixated');
% set(gca,'FontSize',15);
% title(['Prob of Fixation (Hue ' mat2str(hue(j+1)) ')']);
% hgexport(gcf,['ResultsFigures/ProbFixation/Hue/Hue_' ...
%     mat2str(hue(j+1)) '.eps']);
% close all
% end

%% EXCENTRICITY VS CHROMA
% CHROMAS = A(1,:,1,1);
% ECCS = reshape(A(2,:,:,:),1,24,[]);
% plot(CHROMAS,mean(ECCS,3),'LineWidth',3)
% axis([1 10 2 15]), xlabel('Chroma'), ylabel('Eccentricity in visual degree');
% title('ECCENTRICITY VS CHROMA');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/EccVsChroma.eps');

%% CUM.Prob OF DETECTION & CUM.Prob OF REPORT vs CHROMA
% CHROMA = A(1,:,1,1);
% PReport = trimmean(trimmean(A(3,:,:,:),5,4),5,3);
% PDetected = trimmean(trimmean(sum(L(2:4,:,:,:),1),5,4),5,3);
% plot(CHROMA,PReport); hold on
% plot(CHROMA,PDetected); 

%% CUM.Prob OF D.YELLOW & CUM.Prob OF D.BLUE vs CHROMA
% for i=1:14
% CHROMA = A(1,:,1,1);
% for j = 1:24
% PYellow = A(3,j,[(4:6) 18+(4:6) 2*18+(4:6) 3*18+(4:6)],:);
% PBlue = A(3,j,[(13:15) 18+(13:15) 2*18+(13:15) 3*18+(13:15)],:);
% PRed = A(3,j,[([1 2 17 18]) 18+([1 2 17 18]) 2*18+([1 2 17 18]) 3*18+([1 2 17 18])],:);
% PGreen = A(3,j,[(8:11) 18+(8:11) 2*18+(8:11) 3*18+(8:11)],:);
% PrY(j) = trimmean(PYellow(:),5);
% PrB(j) = trimmean(PBlue(:),5);
% PrR(j) = trimmean(PRed(:),5);
% PrG(j) = trimmean(PGreen(:),5);
% end
% figure, plot(CHROMA,PrY,'y','LineWidth',2); 
% hold on, plot(CHROMA,PrB,'b','LineWidth',2);
% xlabel('Chroma'), ylabel('Prob. of Reported');
% title('Overall prob of reported (Blue-Yellow)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/ReportYBAverage.eps');
% 
% figure, plot(CHROMA,PrR,'r','LineWidth',2); 
% hold on, plot(CHROMA,PrG,'g','LineWidth',2); 
% xlabel('Chroma'), ylabel('Prob. of Reported');
% title('Overall prob of reported (Red-Green)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/ReportRGAverage.eps');
% end

%% CUM.Prob OF F.YELLOW & CUM.Prob OF F.BLUE vs CHROMA
% for i=1:14
% CHROMA = A(1,:,1,1);
% for j = 1:24
% PYellow = sum(L(2:4,j,[(4:6) 18+(4:6) 2*18+(4:6) 3*18+(4:6)],:),1);
% PBlue = sum(L(2:4,j,[(13:15) 18+(13:15) 2*18+(13:15) 3*18+(13:15)],:),1);
% PRed = sum(L(2:4,j,[([1 2 17 18]) 18+([1 2 17 18]) 2*18+([1 2 17 18]) 3*18+([1 2 17 18])],:),1);
% PGreen = sum(L(2:4,j,[(8:11) 18+(8:11) 2*18+(8:11) 3*18+(8:11)],:),1);
% PrY(j) = sum(PYellow(:));
% PrB(j) = sum(PBlue(:));
% PrR(j) = sum(PRed(:));
% PrG(j) = sum(PGreen(:));
% end
% figure, plot(CHROMA,cumsum(PrY),'y','LineWidth',2); 
% hold on, plot(CHROMA,cumsum(PrB),'b','LineWidth',2); 
% xlabel('Chroma'), ylabel('Cumulative # of detection');
% title('Overall # of detection (Blue-Yellow)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/DetectedYBAverage.eps');
% 
% figure, plot(CHROMA,cumsum(PrR),'r','LineWidth',2); 
% hold on, plot(CHROMA,cumsum(PrG),'g','LineWidth',2); 
% xlabel('Chroma'), ylabel('Cumulative # of detection');
% title('Overall # of detection (Red-Green)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/DetectedRGAverage.eps');
% end

%% CUM.Prob OF T.YELLOW & CUM.Prob OF T.BLUE vs CHROMA
% for i=1:14
% CHROMA = A(1,:,1,1);
% for j = 1:24
% PYellow = sum(T(2:4,j,[(4:6) 18+(4:6) 2*18+(4:6) 3*18+(4:6)],:),1);
% PBlue = sum(T(2:4,j,[(13:15) 18+(13:15) 2*18+(13:15) 3*18+(13:15)],:),1);
% PRed = sum(T(2:4,j,[([1 2 17 18]) 18+([1 2 17 18]) 2*18+([1 2 17 18]) 3*18+([1 2 17 18])],:),1);
% PGreen = sum(T(2:4,j,[(8:11) 18+(8:11) 2*18+(8:11) 3*18+(8:11)],:),1);
% PrY(j) = sum(PYellow(:));
% PrB(j) = sum(PBlue(:));
% PrR(j) = sum(PRed(:));
% PrG(j) = sum(PGreen(:));
% end
% figure, plot(CHROMA,cumsum(PrY),'y','LineWidth',2); 
% hold on, plot(CHROMA,cumsum(PrB),'b','LineWidth',2); 
% xlabel('Chroma'), ylabel('Cumulative time of fixation');
% title('Overall time of fixation (Blue-Yellow)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/TimeYBAverage.eps');
% 
% figure, plot(CHROMA,cumsum(PrR),'r','LineWidth',2); 
% hold on, plot(CHROMA,cumsum(PrG),'g','LineWidth',2); 
% xlabel('Chroma'), ylabel('Cumulative time of fixation');
% title('Overall time of fixation (Red-Green)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/TimeRGAverage.eps');
% end

%% CUM.Prob OF T/F.YELLOW & CUM.Prob OF T/F.BLUE vs CHROMA
% for i=1:14
% CHROMA = A(1,:,1,1);
% for j = 1:24
% PYellow = sum(L(2:4,j,[(4:6) 18+(4:6) 2*18+(4:6) 3*18+(4:6)],:),1);
% PBlue = sum(L(2:4,j,[(13:15) 18+(13:15) 2*18+(13:15) 3*18+(13:15)],:),1);
% PRed = sum(L(2:4,j,[([1 2 17 18]) 18+([1 2 17 18]) 2*18+([1 2 17 18]) 3*18+([1 2 17 18])],:),1);
% PGreen = sum(L(2:4,j,[(8:11) 18+(8:11) 2*18+(8:11) 3*18+(8:11)],:),1);
% PYellowT = sum(T(2:4,j,[(4:6) 18+(4:6) 2*18+(4:6) 3*18+(4:6)],:),1);
% PBlueT = sum(T(2:4,j,[(13:15) 18+(13:15) 2*18+(13:15) 3*18+(13:15)],:),1);
% PRedT = sum(T(2:4,j,[([1 2 17 18]) 18+([1 2 17 18]) 2*18+([1 2 17 18]) 3*18+([1 2 17 18])],:),1);
% PGreenT = sum(T(2:4,j,[(8:11) 18+(8:11) 2*18+(8:11) 3*18+(8:11)],:),1);
% PrY(j) = sum(PYellowT(:))./sum(PYellow(:));
% PrB(j) = sum(PBlueT(:))./sum(PBlue(:));
% PrR(j) = sum(PRedT(:))./sum(PRed(:));
% PrG(j) = sum(PGreenT(:))./sum(PGreen(:));
% end
% figure, plot(CHROMA,(PrY),'y','LineWidth',2); 
% hold on, plot(CHROMA,(PrB),'b','LineWidth',2);
% axis([1 10 0 800]);
% xlabel('Chroma'), ylabel('Average time per fixation');
% title('Overall time/fixation ratio (Blue-Yellow)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/RatioYBAverage.eps');
% 
% figure, plot(CHROMA,(PrR),'r','LineWidth',2); 
% hold on, plot(CHROMA,(PrG),'g','LineWidth',2); 
% axis([1 10 0 800]);
% xlabel('Chroma'), ylabel('Average time per fixation');
% title('Overall time/fixation ratio (Red-Green)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/RatioRGAverage.eps');
% end

%% CUM.Prob OF D.YELLOW & CUM.Prob OF D.BLUE vs CHROMA (OBSERVERS)
% for i=1:12
% CHROMA = A(1,:,1,1);
% for j = 1:24
% PYellow = A(3,j,[(4:6) 18+(4:6) 2*18+(4:6) 3*18+(4:6)],i);
% PBlue = A(3,j,[(13:15) 18+(13:15) 2*18+(13:15) 3*18+(13:15)],i);
% PRed = A(3,j,[([1 2 17 18]) 18+([1 2 17 18]) 2*18+([1 2 17 18]) 3*18+([1 2 17 18])],i);
% PGreen = A(3,j,[(8:11) 18+(8:11) 2*18+(8:11) 3*18+(8:11)],i);
% PrY(j) = trimmean(PYellow(:),5);
% PrB(j) = trimmean(PBlue(:),5);
% PrR(j) = trimmean(PRed(:),5);
% PrG(j) = trimmean(PGreen(:),5);
% end
% figure, plot(CHROMA,PrY,'y','LineWidth',2); 
% hold on, plot(CHROMA,PrB,'b','LineWidth',2);
% xlabel('Chroma'), ylabel('Prob. of Reported');
% title(['Prob of reported (Blue-Yellow): Observer ' int2str(i)]);
% set(gca,'FontSize',15);
% hgexport(gcf,['ResultsFigures/OpponentDetection/Cases/ReportYB' int2str(i) '.eps']);
% 
% figure, plot(CHROMA,PrR,'r','LineWidth',2); 
% hold on, plot(CHROMA,PrG,'g','LineWidth',2); 
% xlabel('Chroma'), ylabel('Prob. of Reported');
% title(['Prob of reported (Red-Green): Observer ' int2str(i)]);
% set(gca,'FontSize',15);
% hgexport(gcf,['ResultsFigures/OpponentDetection/Cases/ReportRG' int2str(i) '.eps']);
% end

%% CUM.Prob OF D.YELLOW & CUM.Prob OF D.BLUE vs CHROMA (Ligthness)
% Light = {'All','50','25','75'};
% for i=1:4
% CHROMA = A(1,:,1,1);
% for j = 1:24
% PYellow = A(3,j,18*(i-1)+(4:6),:);
% PBlue = A(3,j,18*(i-1)+(13:15),:);
% PRed = A(3,j,18*(i-1)+([1 2 17 18]),:);
% PGreen = A(3,j,18*(i-1)+(8:11),:);
% PrY(j) = trimmean(PYellow(:),5);
% PrB(j) = trimmean(PBlue(:),5);
% PrR(j) = trimmean(PRed(:),5);
% PrG(j) = trimmean(PGreen(:),5);
% end
% figure, plot(CHROMA,PrY,'y','LineWidth',2); 
% hold on, plot(CHROMA,PrB,'b','LineWidth',2);
% xlabel('Chroma'), ylabel('Prob. of Reported');
% title(['Prob of reported (Blue-Yellow): Lightness ' Light{i}]);
% set(gca,'FontSize',15);
% hgexport(gcf,['ResultsFigures/OpponentDetection/Cases/ReportYBLight' Light{i} '.eps']);
% 
% figure, plot(CHROMA,PrR,'r','LineWidth',2); 
% hold on, plot(CHROMA,PrG,'g','LineWidth',2); 
% xlabel('Chroma'), ylabel('Prob. of Reported');
% title(['Prob of reported (Red-Green): Lightness ' Light{i}]);
% set(gca,'FontSize',15);
% hgexport(gcf,['ResultsFigures/OpponentDetection/Cases/ReportRGLight' Light{i} '.eps']);
% end

%% PROB OF FIXATED BUT NOT REPORTED vs CHROMA
% CHROMA = A(1,:,1,1);
% but = (1-A(3,:,:,:)).*sum(L(2:4,:,:,:),1);
% for j = 1:24
% PYellow = but(:,j,[(4:6) 18+(4:6) 2*18+(4:6) 3*18+(4:6)],:);
% PBlue = but(:,j,[(13:15) 18+(13:15) 2*18+(13:15) 3*18+(13:15)],:);
% PRed = but(:,j,[([1 2 17 18]) 18+([1 2 17 18]) 2*18+([1 2 17 18]) 3*18+([1 2 17 18])],:);
% PGreen = but(:,j,[(8:11) 18+(8:11) 2*18+(8:11) 3*18+(8:11)],:);
% PrY(j) = trimmean(PYellow(:),5);
% PrB(j) = trimmean(PBlue(:),5);
% PrR(j) = trimmean(PRed(:),5);
% PrG(j) = trimmean(PGreen(:),5);
% end
% figure, plot(CHROMA,PrY,'y','LineWidth',2); 
% hold on, plot(CHROMA,PrB,'b','LineWidth',2);
% xlabel('Chroma'), ylabel('Prob. of detected and no Reported');
% title('Overall prob of detected and no reported (Blue-Yellow)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/NoReportYBAverage.eps');
% 
% figure, plot(CHROMA,PrR,'r','LineWidth',2); 
% hold on, plot(CHROMA,PrG,'g','LineWidth',2); 
% xlabel('Chroma'), ylabel('Prob. of detected and no Reported');
% title('Overall prob of detected and no reported (Red-Green)');
% set(gca,'FontSize',15);
% hgexport(gcf,'ResultsFigures/OpponentDetection/NoReportRGAverage.eps');
% % end

%% PROB OF REPORT vs CHROMA (per HUE)
% CHROMA = A(1,:,1,1);
% hue = 10:20:350;
% for i = 1:18
% for j = 1:24
% PYellow = A(3,j,[(i) 18+(i) 2*18+(i) 3*18+(i)],:);
% PrY(j) = trimmean(PYellow(:),5);
% end
% plot(CHROMA,PrY,'y','LineWidth',2,'Color',colors(hue(i),:)); 
% hold on
% end
% 
% xlabel('Chroma'), ylabel('Prob. of detected and no Reported');
% title('Overall prob of detected and no reported (Blue-Yellow)');
% set(gca,'FontSize',15);
% % hgexport(gcf,'ResultsFigures/OpponentDetection/NoReportYBAverage.eps');

%% Number of fixated and NO reported
% CHROMA = A(1,:,1,1);
% but = sum(sum((1-A(3,:,:,:)).*sum(L(2:4,:,:,:),1),2),4);
% butT = sum(sum(sum(L(2:4,:,:,:),1),2),4);
% hue = 10:20:350;
% PFNR = [];
% PFNRT = [];
% for j=1:4
% for i=1:18
% PFNR(i,j) = but(:,:,18*(j-1)+(i),:);
% PFNRT(i,j) = butT(:,:,18*(j-1)+(i),:);
% end
% end
% 
% PFNR = sum(PFNR,2);
% PFNR = [(PFNR(1)+PFNR(end))/2; PFNR; (PFNR(1)+PFNR(end))/2];
% PFNRT = sum(PFNRT,2);
% PFNRT = [(PFNRT(1)+PFNRT(end))/2; PFNRT; (PFNRT(1)+PFNRT(end))/2];
% 
% figure; 
% 
% % for j=1:4
% h = polar(deg2rad(0:360),interp1([0 hue 360],PFNRT ,0:360,'pchip')); hold on
% set(h,'LineWidth',3);
% h = polar(deg2rad(0:360),interp1([0 hue 360],PFNR,0:360,'pchip')); hold on
% set(h,'LineWidth',3);
% % end
% % legend('Total # of fixations','# of non-reported fixations');
% for i=1:361;
%     h = polar(deg2rad(i-1),800,'.'); hold on;
%     set(h,'MarkerSize',40,'Color',colors(i,:));
% end
% % h = polar(deg2rad(0:360),interp1(hue,anglesM(j,:)-anglesMstd(j,:),0:360,'pchip')); hold on
% % set(h,'LineWidth',2,'Color',colorslines(j,:),'LineStyle','--');
% % 
% % h = polar(deg2rad(0:360),interp1(hue,anglesM(j,:)+anglesMstd(j,:),0:360,'pchip')); hold on
% % set(h,'LineWidth',2,'Color',colorslines(j,:),'LineStyle','--');

%% Number of fixated and NO reported
% CHROMA = A(1,:,1,1);
% but = sum(sum((1-A(3,:,:,:)).*sum(L(2:4,:,:,:),1),2),4);
% butT = sum(sum(sum(L(2:4,:,:,:),1),2),4);
% hue = 10:20:350;
% PFNR = [];
% PFNRT = [];
% for j=1:4
% for i=1:18
% PFNR(i,j) = but(:,:,18*(j-1)+(i),:);
% PFNRT(i,j) = butT(:,:,18*(j-1)+(i),:);
% end
% end
% 
% PFNR = sum(PFNR,2);
% PFNR = [(PFNR(1)+PFNR(end))/2; PFNR; (PFNR(1)+PFNR(end))/2];
% PFNRT = sum(PFNRT,2);
% PFNRT = [(PFNRT(1)+PFNRT(end))/2; PFNRT; (PFNRT(1)+PFNRT(end))/2];
% 
% figure; 
% 
% for i=1:361;
%     h = polar(deg2rad(i-1),0.6,'.'); hold on;
%     set(h,'MarkerSize',40,'Color',colors(i,:));
% end

% for j=1:4
% h = polar(deg2rad(0:360),interp1([0 hue 360],PFNR./PFNRT ,0:360,'pchip')); hold on
% set(h,'LineWidth',3);
% h = polar(deg2rad(0:360),interp1([0 hue 360],PFNR,0:360,'pchip')); hold on
% set(h,'LineWidth',3);
% end
% legend('Total # of fixations','# of non-reported fixations');

% h = polar(deg2rad(0:360),interp1(hue,anglesM(j,:)-anglesMstd(j,:),0:360,'pchip')); hold on
% set(h,'LineWidth',2,'Color',colorslines(j,:),'LineStyle','--');
% 
% h = polar(deg2rad(0:360),interp1(hue,anglesM(j,:)+anglesMstd(j,:),0:360,'pchip')); hold on
% set(h,'LineWidth',2,'Color',colorslines(j,:),'LineStyle','--');


%% THREE THINGS INSIDE SAME PLOT (DETECTION - FIXATION - FIXATION AND NON DETACTION)
observer = 1:12;

but = sum(sum((1-A(3,:,:,observer)).*sum(L(2:4,:,:,observer)>0,1),2),4)/(24*4*numel(observer));
butT = sum(sum(sum(L(2:4,:,:,observer)>0,1),2),4)/(24*4*numel(observer));
detec = sum(sum(A(3,:,:,observer),2),4)/(24*4*numel(observer));
hue = 10:20:350;
PFNR = [];
PFNRT = [];
DT = [];
for j=1:4
for i=1:18
PFNR(i,j) = but(:,:,18*(j-1)+(i),:);
PFNRT(i,j) = butT(:,:,18*(j-1)+(i),:);
DT(i,j) = detec(:,:,18*(j-1)+(i),:);
end
end

PFNR = sum(PFNR,2);
PFNR = [(PFNR(1)+PFNR(end))/2; PFNR; (PFNR(1)+PFNR(end))/2];
PFNRT = sum(PFNRT,2);
PFNRT = [(PFNRT(1)+PFNRT(end))/2; PFNRT; (PFNRT(1)+PFNRT(end))/2];
DT = sum(DT,2);
DT = [(DT(1)+DT(end))/2; DT; (DT(1)+DT(end))/2];

figure;

h = plot((0:360),interp1([0 hue 360],DT ,0:360,'pchip')); hold on
set(h,'LineWidth',3);
h = plot((0:360),interp1([0 hue 360],PFNRT ,0:360,'pchip')); hold on
set(h,'LineWidth',3);
h = plot((0:360),interp1([0 hue 360],PFNR ,0:360,'pchip')); hold on
set(h,'LineWidth',3);

for i=1:361;
    h = plot((i-1),0.8,'.'); hold on;
    set(h,'MarkerSize',40,'Color',colors(i,:));
end

figure;

h = polar(deg2rad(0:360),interp1([0 hue 360],DT ,0:360,'pchip')); hold on
set(h,'LineWidth',3);
h = polar(deg2rad(0:360),interp1([0 hue 360],PFNRT ,0:360,'pchip')); hold on
set(h,'LineWidth',3);
h = polar(deg2rad(0:360),interp1([0 hue 360],PFNR ,0:360,'pchip')); hold on
set(h,'LineWidth',3);

for i=1:361;
    h = polar(deg2rad(i-1),0.8,'.'); hold on;
    set(h,'MarkerSize',40,'Color',colors(i,:));
end