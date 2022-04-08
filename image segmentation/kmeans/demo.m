close all; clear; clc;
img = imread('cameraman.tif');

%% 使用自己的函数实现kmeans
[label_map,Iteration] = imgKeans(img,3);
figure; imshow(labeloverlay(img,label_map));

%% 使用MATLAB自带的函数实现kmeans
[L,Centers] = imsegkmeans(img,3);
figure; imshow(labeloverlay(img,L));

%% 结论：结果几乎一模一样