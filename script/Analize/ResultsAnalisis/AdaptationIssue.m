%{
In order to check whether the less saliency in the 75 and 25 L is due to
adaptation problems or no, we will compare the total amount of reported and
the time taken to report of different patches depending on the preciding 
Lighness level and the actual lightness.
Three groups will be made, for instance if preciding and current are same
the group will be 0, if difference if of 1 step group will be 1 and 2 for
2. 
If any, the previous or current, is L_all will be just discarted, since
process is different

Results are showing that the difference between the total number of reports
depending en the lightness changes are significant, and plot of mean is 
shown, that only changes from 5.3 to 5 of the average of reported, which is
not a big difference.
which means that the adaptation issue can be ignored. There has been also 
check the difference between the time taken for each case, no significant 
difference at all.
%}

clear all
close all

load('Preceding.mat');

repo = [];
yesno = 0;
for i=2:8:length(L);
    yesno = 0;
    for j=0:7
    switch Reported{i+j}
        case 'TRUE'
            yesno = yesno+1;
    end
    end
    switch PrecedingL{i}
        case '50'
            switch L{i}
                case '50'
                    repo = [repo; 0 yesno Totaldwelltimeperstimulus(i)];
                case {'25','75'}
                    repo = [repo; 1 yesno Totaldwelltimeperstimulus(i)];
            end
        case '25'
            switch L{i}
                case '50'
                    repo = [repo; 1 yesno Totaldwelltimeperstimulus(i)];
                case '25'
                    repo = [repo; 0 yesno Totaldwelltimeperstimulus(i)];
                case '75'
                    repo = [repo; 2 yesno Totaldwelltimeperstimulus(i)];
            end
        case '75'
            switch L{i}
                case '50'
                    repo = [repo; 1 yesno Totaldwelltimeperstimulus(i)];
                case '25'
                    repo = [repo; 2 yesno Totaldwelltimeperstimulus(i)];
                case '75'
                    repo = [repo; 0 yesno Totaldwelltimeperstimulus(i)];
            end
   end
    
end

p_chroma = anova1(repo(:,2),repo(:,1),'off');
M(1) = median(repo(repo(:,1)==0,2));
M(2) = median(repo(repo(:,1)==1,2));
M(3) = median(repo(repo(:,1)==2,2));

p_time = anova1(repo(:,3),repo(:,1),'off');
N(1) = median(repo(repo(:,1)==0,3));
N(2) = median(repo(repo(:,1)==1,3));
N(3) = median(repo(repo(:,1)==2,3));

colors = lines(7);
% figure; hold on
% for i=1:3
%     b = bar(i,M(i));
%     set(b,'FaceColor',colors(i,:))
% end
% set(gca,'YLim',[4 6],'XTick',[1 2 3],'XTickLabel',[0;1;2])
% 
figure; hold on
for i=1:3
    b = bar(i,N(i));
    set(b,'FaceColor',colors(i+4,:))
    x_loc = get(b, 'XData');
y_height = get(b, 'YData');
arrayfun(@(x,y) text(x-0.2, y+0.2,num2str(y), 'FontSize',20), x_loc, y_height);
end
set(gca,'YLim',[5 10],'XTick',[1 2 3],'XTickLabel',[0;1;2])
xlabel('Lightness difference','FontSize',20);
ylabel('Median time taken (s)','FontSize',20);
set(gca,'FontSize',20);
hgexport(gcf,'Figures/Adaptation.eps');