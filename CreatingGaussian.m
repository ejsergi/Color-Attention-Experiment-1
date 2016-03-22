clear all
close all

A = zeros(51);
A(11:41,11:41) = 1;

imshow(A)

fil = fspecial('gaussian',[20 20],2);

B = imfilter(A,fil);

imshow(B)

figure; plot(B(25,:))