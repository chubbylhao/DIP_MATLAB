close all;clear;clc;

%% 归一化灰度共生矩阵
I = imread('random.tif');
% offset决定了所检测的纹理模式
glcms = graycomatrix(I,'NumLevels',256,'offset',[0,1]);
% 归一化灰度共生矩阵
normGlcms = glcms / sum(glcms(:));

%% 常见的6个描述子
% 最大概率
colNormGlcms = normGlcms(:);
maxProbability = max(colNormGlcms);
% 熵
newColNormGlcms = colNormGlcms(colNormGlcms ~= 0);
entropy = - sum(newColNormGlcms .* log2(newColNormGlcms));
% 函数graycoprops支持4种属性
% 分别是相关性、对比度、均匀性和同质性
stats = graycoprops(glcms,'all');