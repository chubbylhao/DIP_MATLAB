close all; clear; clc;
img = imread('yeast.tif');
% 学会成为一个合格的调参侠是无法避免的
res = variableThreshold(img,ones(3),30,1.5,'global');
figure;
subplot(121), imshow(img);
subplot(122), imshow(res);