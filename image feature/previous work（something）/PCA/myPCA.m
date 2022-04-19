function [newX,T,M] = myPCA(X,rate)
%% 说明
% 每行每行每行！！！是一个样本
% newX为降维后的矩阵
% T为线性变换矩阵
% M为均值矩阵
% X为初始矩阵
% rate为贡献率

%% 求协方差矩阵及其特征值和特征向量，并按降序排列
% 矩阵按列求均值
mx = mean(X);
row = size(X,1);
M = ones(row,1) * mx;

% 注意分母（一般使用row-1而不是row），无偏估计
Cx = (X-M)' * (X-M) / (row-1);
% 计算特征向量与特征值
[V,D] = eig(Cx);
% 直接用D为升序排列
[~,order] = sort(diag(-D));
% 将特征向量按特征值的大小进行降序排列
newV = V(:,order);
d = diag(D);
% 将特征值按降序排列构成一个列向量
newd = d(order);

%% 取前n个特征向量，构成变换矩阵,进行变换并得到降维后的矩阵
sumd = sum(newd);
% 自动保留特征向量的个数
% 由贡献率rate决定
for i = 1:length(newd)
    j = sum(newd(1:i)) / sumd;
    if j > rate
        cols = i;
        break;
    end
end
T = newV(:,1:cols);
newX = (X-M) * T;

%% 使用主分量（主成分）重建
% % 用转置矩阵近似逆矩阵（因为非方阵不存在逆矩阵）
% % 由降维后的矩阵重建初始矩阵（存在误差，重建不是精确的）
% rebuild = newX*T' + M;

%% 使用测试例子
% 博客参考链接：https://www.cnblogs.com/simon-c/p/4902651.html
% X = [10 15 29;15 46 13;23 21 30;11 9 35;42 45 11;...
%     9 48 5;11 21 14;8 5 15;11 12 21;21 20 25];
% [newX,T,M] = myPCA(X,0.94);
% rebuild = newX*T' + M;
end