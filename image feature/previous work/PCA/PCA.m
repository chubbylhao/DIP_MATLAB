%% PCA原理的简要说明
% PCA，又称主成分分析、主分量分析，用于精简特征空间、为数据降维（解决维度灾难（计算爆炸）的问题）
% 其实现过程本质上是一个“投影”的过程：如直线投影到点、平面投影到线、空间投影到面
% 1维到0维的PCA：将直线上的所有样本投影到一个点（均值点）
% 2维到1维的PCA：将平面上的所有样本投影到“某个椭圆”的长轴方向上
% 3维到2维的PCA：将空间中的所有样本投影到“某个椭球体”的最大截面上
% 或者实现更大跨度的降维（如100维降到10维）
% PCA简而言之就是根据输入数据的分布为其重新找到更能描述这组数据的正交坐标轴
% 这堆输入数据的协方差矩阵的特征值按降序排列，分别构成最大一直到最小的主成分、主分量
% 每个特征值所对应的特征向量是相互正交的，每个特征向量的方向分别代表了特征空间中一根坐标轴的方向

%% 简单验证
close all;clear;clc;
k = 2;
X = [1 2 1 1;
     3 3 1 2; 
     3 5 4 3; 
     5 4 5 4;
     5 6 1 5; 
     6 5 2 6;
     8 7 1 2;
     9 8 3 7];
% coeff是样本协方差矩阵的特征向量（降序排列）
% score是X经线性变换之后的坐标
% latent是样本协方差矩阵的特征值（降序排列）
[coeff,score,latent] = pca(X);