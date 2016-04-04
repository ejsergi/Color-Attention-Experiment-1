clear all
close all

A = double(drawcircle(1000,550,550,100));

imshow(A)
mex imgaussian.c -v
B = imgaussian(A,30,100);

figure; imshow(B)

figure; plot(B(550,:,1))

C = rand(1000);
C = cat(3,C,C,C);

T = (C+B)/2;

figure; imshow(T);

F = zeros(size(T));
F(T>0.5)=1;

figure; imshow(F);