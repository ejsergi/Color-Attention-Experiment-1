%{
In order to check whether the less saliency in the 75 and 25 L is due to
adaptation problems or no, we will compare the total amount of reported
patches depending on the preciding Lighness level.

Results are showing that the difference between the total number of reports
depending of the preceding ligthness are insignificant, which means that
the adaptation issue can be ignored.
%}

clear all
close all

load('Preceding.mat');

L_all = [];
L_50 = [];
L_25 = [];
L_75 = [];
yesno = 0;
for i=2:length(L);
    switch Reported{i}
        case 'FALSE'
            yesno = 0;
        case 'TRUE'
            yesno = 1;
    end
    switch PrecedingL{i}
        case 'All'
            L_all = [L_all yesno];
        case '50'
            L_50 = [L_50 yesno];
        case '25'
            L_25 = [L_25 yesno];
        case '75'
            L_75 = [L_75 yesno];
    end
end

M(1) = mean(L_all);
M(2) = mean(L_50);
M(3) = mean(L_25);
M(4) = mean(L_75);

p = anova1([L_all L_50 L_25 L_75],[ones(1,length(L_all)) ...
    ones(1,length(L_50))*2 ones(1,length(L_25))*3 ...
    ones(1,length(L_75))*4]);
            
