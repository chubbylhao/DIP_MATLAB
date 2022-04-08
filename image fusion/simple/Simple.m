close all; clear; clc;
I1 = imread('cameraman.tif'); I1 = double(I1);
I2 = imread('lena.tif'); I2 = double(I2);
I3 = imread('livingroom.tif'); I3 = double(I3);

%% 简单平均灰度法（Simple Average）
res1 = (I1 + I2 + I3) / 3;

%% 最小灰度法（Minimum Technique）
res2 = I1.*((I1<=I2)&(I1<=I3)) + I2.*((I2<I1)&(I2<I3)) + I3.*((I3<I1)&(I3<I2));

%% 最大灰度法（Maximum Technique）
res3 = I1.*((I1>=I2)&(I1>=I3)) + I2.*((I2>I1)&(I2>I3)) + I3.*((I3>I1)&(I3>I2));

%% 最大最小平均灰度法（Max–Min Technique）
% 效果介于最小灰度法和最大灰度法之间
res4 = (res2 + res3) / 2;

%% 简单邻域平均灰度法（Simple block replacement）
% 这其实就是盒式滤波，融合后的图像会变得模糊
h = fspecial('average',[5,5]);
res5 = (imfilter(I1,h,'replicate') + imfilter(I2,h,'replicate') + imfilter(I3,h,'replicate')) / 3;

%% 加权平均灰度法（Weighted Averaging Technique）
res6 = 0.1*I1 + 0.3*I2 + 0.6*I3;

%% 画个图看看效果
figure;
subplot(231); imshow(res1,[]); title('简单平均灰度法');
subplot(232); imshow(res2,[]); title('最小灰度法');
subplot(233); imshow(res3,[]); title('最大灰度法');
subplot(234); imshow(res4,[]); title('最大最小平均灰度法');
subplot(235); imshow(res5,[]); title('简单邻域平均灰度法');
subplot(236); imshow(res6,[]); title('加权平均灰度法');