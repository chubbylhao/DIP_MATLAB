function res = variableThreshold(img,nhood,a,b,mean_type)
%% 使用可变阈值分割图像
% img：待分割的图像
% nhood：计算局部统计量所用的邻域大小
% a：局部方差的加权值
% b：局部（全局）均值的加权值
% mean_type：是使用局部均值还是全局均值

%% 简单实现
img = double(img);
local_std = stdfilt(img,nhood);    % 局部标准差
if nargin == 5 && strcmp(mean_type,'global')
    mean_local = mean2(img);    % 全局均值
else
    mean_local = meanfilt(img,nhood);    % 局部均值
end
% res = img > (a*local_std + b*mean_local);
res = (img > a*local_std) & (img > b*mean_local);
end

%% 仿照MATLAB自带函数stdfilt的功能，编写一个meanfilt函数
function local_mean = meanfilt(img,nhood)
if nargin == 1
    nhood = ones(3) / 9;    % 默认使用3×3大小的邻域
else
    nhood = nhood / sum(nhood(:));    % 做好归一化
end
local_mean = imfilter(img,nhood,'replicate');
end