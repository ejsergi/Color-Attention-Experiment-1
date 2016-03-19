clear all
close all

A = zeros(51);
A(11:41,11:41) = 1;

imshow(A)

B = imgaussfilt(A,3);

imshow(B)

plot(B(25,:))