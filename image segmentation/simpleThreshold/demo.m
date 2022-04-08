close all; clear; clc;
img = imread('fingerprint.tif');
[thresh,iteration] = simpleThreshold(img,0.5);
res = imbinarize(img,thresh/255);
figure;
subplot(121), imshow(img);
subplot(122), imshow(res);
figure; imhist(img);    % 直方图双模式明显