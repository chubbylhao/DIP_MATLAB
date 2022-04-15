close all; clear; clc;
img = imread('house.tif');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = double(img);
% 使用自写函数
[x,y] = myHarris(img,100);
figure; imshow(img,[]);hold on;
plot(y,x,'r+','MarkerSize',8);
% 与软件自带函数对比
corners = detectHarrisFeatures(img);
figure; imshow(img,[]); hold on;
plot(corners.selectStrongest(100));
% 试试DoH
[x,y] = myDoH(img,100);
figure; imshow(img,[]);hold on;
plot(y,x,'r+','MarkerSize',8);