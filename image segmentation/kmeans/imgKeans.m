function [label_map,Iteration] = imgKeans(img,cluster_nums)
%% 在图像中使用kmeans算法
% img：待聚类分割的图像
% cluster_nums：聚类的数量
% label_map：聚类后的标记图
% 该函数既能处理灰度图像，也能处理RGB图像

%% 简单实现
[rows,cols,channels] = size(img);
expand_img = reshape(double(img),rows*cols,channels);
% 注释“rng('default');”，以观察初始聚类中心对分割结果的影响
% rng('default');    % 保存随机数生成器的当前状态
cluster_centre = expand_img(randperm(rows*cols,cluster_nums),:);    % 初始聚类中心
next_cluster_centre = cluster_centre;
Iteration = 0;    % 为防止迭代振荡而设置的次数标记
while Iteration < 100
    Iteration = Iteration + 1;
    % 这里有个转换：(a-b)^2 = a^2 + b^2 - 2*a*b（便于矩阵运算）
    Euclid = sqrt(sum(expand_img.^2,2)*ones(1,cluster_nums) + ...
        (sum(cluster_centre.^2,2)*ones(1,rows*cols))' - 2*expand_img*cluster_centre');
    [~,label] = min(Euclid,[],2);
    % 计算新的聚类中心
    for i = 1:cluster_nums
        next_cluster_centre(i,:) = mean(expand_img(label == i,:));
    end
    % 计算残差
    residual_error = sum(sqrt(sum((next_cluster_centre - cluster_centre).^2)));
    % 检查迭代是否满足收敛条件
    if residual_error < 1e-3    % 阈值定为0.001
        break;
    end
    cluster_centre = next_cluster_centre;
end
% 记录标记图
label_map = zeros(rows,cols);
for i = 1:cluster_nums
    label_map(label == i) = i;
end
end