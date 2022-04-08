function [thresh,iteration] = simpleThreshold(img,delta)
%% 使用简单迭代法实现双模式直方图图像的阈值分割
% img：待分割的图像
% delta：迭代停止的阈值
% thresh：分割的阈值（迭代的结果）
% iteration：迭代的次数

%% 简单实现
thresh = mean2(img);    % 使用图像的均值作为迭代的初值
iteration = 0;
while 1
    iteration = iteration + 1;    % 记录迭代的次数
    next_thresh = (mean(img(img>thresh)) + mean(img(img<=thresh))) / 2;
    if abs(next_thresh-thresh) < delta
        break;
    end
    thresh = next_thresh;
end
end