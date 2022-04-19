%% 简单说明
% RANdom SAmple Consensus -- 随机采样一致（算法）
% 应用：直线拟合、平面拟合
% 场合：包含有效数据点（内点）和噪声点（外点），克服最小二乘法易受噪点影响的缺点
% 方式：数学迭代
% 参考链接：https://blog.csdn.net/u010128736/article/details/53422070
close all;clear;clc;

%% 拟合直线
% 生成内点
mu = [1,1];    % 均值向量
Sigma = [1,3;3,10];    % 协方差矩阵（对称半正定）
data_1 = mvnrnd(mu,Sigma,200);    % 生成数据点

% 生成外点
mu_2 = [3,3];
Sigma_2 = [9,-2.5;-2.5,9];
data_2 = mvnrnd(mu_2,Sigma_2,200);

% 合并数据
data = [data_1;data_2];

% 可视化数据点
figure;
scatter(data(:,1),data(:,2));
hold on;

% 由已知条件确定迭代次数
P = 0.999;    % 拟合直线的正确率
t = 0.5;    % 内点概率
n = 2;    % 拟合直线需要的点数
k = ceil(log10(1-P)/log10(1-t^n));

% 为数组预分配内存
total = zeros(1,k);
result = zeros(3,k);

% 进行RANSAC
for i = 1:k
    % 随机采样两个点
    idx = randperm(size(data,1),2);
    sample = data(idx,:);
    
    % 计算斜率和截距
    x = sample(:,1);
    y = sample(:,2);
    a = (y(2)-y(1))/(x(2)-x(1));
    b = y(1)-a*x(1);
    
    % 计算距离并统计结果
    result(:,i) = [a,-1,b];
    distance = abs(result(:,i)'*[data';ones(1,size(data,1))])/sqrt(a^2+b^2);
    total(i) = sum(distance<0.5);
end

% 画出拟合直线
m = find(total == max(total));
n = result(:,m);
lim = [-5,10];
plot(lim,n(1)*lim+n(3),'r');

% 观察并对比最小二乘的结果
coefficient = polyfit(data(:,1),data(:,2),1);
plot(lim,coefficient(1)*lim+coefficient(2),'k');