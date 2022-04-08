close all; clear; clc;

%% 使用自己的函数实现模糊cmeans（明显感觉比kmeans的执行时间长）
img = imread('cameraman.tif');
[label_map,Iteration] = imgFcm(img,3);
figure; imshow(labeloverlay(img,label_map));