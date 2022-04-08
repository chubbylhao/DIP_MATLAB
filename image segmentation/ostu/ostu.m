close all;clear;clc;
I = imread("fingerprint.tif");

%% 使用内置函数实现大津法
% 这里的level为归一化的值
level = graythresh(I);
BW = imbinarize(I,level);
figure;imshow(BW);
title("内置函数实现Otsu");

%% 手动实现大津法
[m,n] = size(I);
total_pixs = m*n;
[counts,binLocations] = imhist(I);
norm_pdf = counts/total_pixs;

% 计算累计和P1(k)
% P1k = zeros(256,1);
% sum = 0;
% for i = 0:255
%     sum = sum+norm_pdf(i+1);
%     P1k(i+1) = sum;
% end
% 计算累计和P1(k)的简单方法
P1k = cumsum(norm_pdf);

% 计算累积均值Mk
every_bin_aver_gray = norm_pdf.*(binLocations+1);
Mk = cumsum(every_bin_aver_gray);

% 计算全局灰度均值Mg
Mg = sum(every_bin_aver_gray);

% 计算类间方差Sigma2B（注意P1k中的0元素和1元素）
Sigma2B = (Mg*P1k-Mk).^2./(P1k.*(1-P1k));
row = find(isnan(Sigma2B));
Sigma2B(row) = 0;

% 寻找最大类间方差所对应的k值（即划分阈值）
k = find(Sigma2B == max(Sigma2B));
if size(k) > 1
    % k_star是阈值，需要使用索引减去1
    k_star = round(mean(k))-1;
else
    k_star = k-1;
end

% 计算一个归一化阈值
norm_k = k_star/255;

% 进行二值化操作
for j = 1:total_pixs
    if I(j) > k_star
        I(j) = 255;
    else
        I(j) = 0;
    end
end

% 计算全局方差Sigma2G和可分离性测度Eta
Sigma2G = sum((binLocations+1-Mg).^2.*norm_pdf);
Eta = Sigma2B(k_star+1)/Sigma2G;

% 观察结果
figure;imshow(I);
title("手动实现Otsu");