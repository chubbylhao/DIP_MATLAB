function [m,mu,Mu3,R,U,E] = grayMoment(I)
%% 说明
% m为均值
% mu为标准差
% Mu3为偏斜度
% R为平滑度，值越大越平滑
% U为一致性测度，值越大越一致
% E为平均熵测度，值越大图像信息越丰富

%% 归一化直方图
% imhist函数接受uint类型的数据
[counts,binLocations] = imhist(I);
% 归一化直方图
[M,N] = size(I);
normHist = counts / (M*N);

%% 描述子
% 计算图像灰度的均值（1阶原点矩）
m = sum(binLocations .* normHist);
% 计算图像灰度的方差（2阶中心矩）
Mu2 = sum((binLocations-m).^2 .* normHist);
% 计算图像灰度的偏斜度（3阶中心矩）
Mu3 = sum((binLocations-m).^3 .* normHist) / 255^2;
% 计算图像灰度的标准差
mu = sqrt(Mu2);
% 灰度对比度的测度：灰度平滑度（值在0和1之间）
% 该值越小，图像越平滑；该值越大，图像越粗糙
R = 1 - (1 + Mu2/255^2)^(-1);
% 一致性测度
% 各像素灰度值越一致，此值越接近于1，否则越接近于0
% 恒定灰度图像的一致性测度值为1
U = sum(normHist.^2);
% 平均熵测度
% 熵是可变性的一个测度，恒定图像的熵是0
% 图像越乱、细节越丰富，平均熵值越大
% 为计算中不出现NaN值，剔除0元素
newNormHist = normHist(normHist ~= 0);
E = - sum(newNormHist .* log2(newNormHist));
end