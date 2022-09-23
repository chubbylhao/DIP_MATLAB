close all;clear;clc;

%% 预处理
img = imread("helicopter.bmp");
eqimg = histeq(img);    % R = G = B ，可直接做均衡化，不会出现错误色彩
eqimg = double(eqimg);

%% 定义映射
T = 204;    % 灰度级范围为 [0,255] ，且有 5/4 个周期，即 5/4 * T = 255
fR = @(L) abs(sin(2*pi*L./T - 0));
fG = @(L) abs(sin(2*pi*L./T - pi/4));    % 右移 pi/4
fB = @(L) abs(sin(2*pi*L./T - pi/2));    % 右移 pi/2

%% 映射
eqimg(:,:,1) = fR(eqimg(:,:,1));
eqimg(:,:,2) = fG(eqimg(:,:,2));
eqimg(:,:,3) = fB(eqimg(:,:,3));

%% 显示结果
figure,imshow(eqimg,[]),title("伪彩色增强结果");