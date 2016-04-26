clear all
close all

Header = importfileHeader('000 (1)_003_922 Events.txt');
Values = importfileNumbers('000 (1)_003_922 Events.txt');

fixations = Values(strcmp(Header,'Fixation L'),:);
Xresol = (2560-1440)/2;

for i=1:size(fixations,1);
    
    im = imread('Test.png');
    
    RGB = insertShape(im,'FilledCircle',[fixations(i,6)-Xresol,fixations(i,7),fixations(i,5)/10000],...
        'LineWidth',1);
    
    imshow(RGB);
    
    waitforbuttonpress;
    
end
    