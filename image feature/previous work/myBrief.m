close all;clear;clc;

%% 使用自定义的myFast函数寻找FAST角点
I = imread('house.tif');
if size(I,3) == 3
    I = rgb2gray(I);
end
I = double(I);
[x,y,corners] = myFast(I,35,11);

%% 自定义实现BRIEF描述子
tic;
neigh_w = 15;    % 确定特征点的邻域窗口大小
n = 256;    % 在邻域窗口内随机选取n对像素点，以生成n（bit）的特征描述子
h = fspecial('gaussian',[9,9],2);      % 生成方差为2，大小为9的高斯滤波器
blurI = imfilter(I,h,'replicate');     % 直接对整幅图像进行高斯平滑
% % 生成n个随机点对，？？？是每个特征点都要重新生成一遍吗？？？
% rand_dots = normrnd(0,neigh_w/5,[n,2,2]);
% 生成二进制特征编码
bin_code = zeros(corners,n);
for i = 1:corners
    for j = 1:n
        rand_dots = normrnd(0,neigh_w/5,[n,2,2]);    % 生成n个随机点对
        % 此处为提高精度，应该进行插值（此处代码未插值！）
        rand_dots = floor(rand_dots);
        % 寻找用于比较灰度值的2个点（1个点对）
        % 这里也许会出现一些小问题：（此代码存在的潜在问题）
        % ！！！随机点的范围超出图像的范围！！！
        % ！！！在这之前应该先剔除靠近边缘的特征点！！！
        xhat = I(x(i)+rand_dots(j,1,1),y(i)+rand_dots(j,2,1));
        yhat = I(x(i)+rand_dots(j,1,2),y(i)+rand_dots(j,2,2));
        if xhat < yhat
            bin_code(i,j) = 1;
        end
    end
end
toc;

%% 可视化最后一幅随机点对图
figure;
for k = 1:n
    plot(rand_dots(k,:,2),rand_dots(k,:,1)); 
    hold on;
end
hold off;

%% 可视化BRIEF描述子生成的特征向量
figure;
imshow(bin_code);