close all;clear;clc;

%% 预处理
img = imread("helicopter.bmp");
grayimg = rgb2gray(img);
eqimg = histeq(grayimg);

%% 灰度分层
% 根据灰度直方图，分 4 层为宜
eqimg(eqimg <= 50) = 1;
eqimg((eqimg > 50) & (eqimg <= 150)) = 2;
eqimg((eqimg > 150) & (eqimg <= 200)) = 3;
eqimg(eqimg >= 200) = 4;

%% 彩色编码
mymap_1 = [0,0,1;1,1,0;0,1,0;1,0,0];    % 伪彩色增强
mymap_2 = [0,0,1;0,0,1;0,0,1;1,1,0];    % 分割目标

%% 显示结果
figure,imshow(eqimg,[]),colormap(mymap_1),title("伪彩色增强结果");
figure,imshow(eqimg,[]),colormap(mymap_2),title("分割目标结果");