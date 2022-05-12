close all; clear; clc;
img = imread('../pics/face.png');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = double(img);
img = imresize(img,[24,24]);    % 在一个小窗口内提取特征
% figure; imshow(img,[]);
% 定义最原始的3种类型4种形式的Haar特征（2001年Viola的论文）
haar_kernel = {[1,-1],[-1;1],[1,-2,1],[1,-1;-1,1]};
tic;
% 计算积分图
integral_img = integralImage(img);
% 获取Haar特征值
[haar_like,counts] = extractFeatures(integral_img,haar_kernel);
toc;
total_feature_num = sum(counts);    % Haar特征的总个数
% 对特征矩阵的数量进行校验
% 对于无45°Haar旋转模板（核）的情况：
% floor(24/1)*floor(24/2)*(24+1-2*(floor(24/2)+1)/2)*(24+1-1*(floor(24/1)+1)/2)
% = 24*12*12*12.5 = 43200 与counts(1)的值完全相等