close all; clear; clc;

%% 使用区域生长法分割图像
img = imread('defective_weld.tif');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = im2double(img);    % 使用归一化的值
region = regionGrow(img,1,0.26);    % 种子值的选取以及阈值的设定需要一定的人工
region(region~=0) = 1;    % 将所有的前景连通区域显示出来
figure; imshow(logical(region));