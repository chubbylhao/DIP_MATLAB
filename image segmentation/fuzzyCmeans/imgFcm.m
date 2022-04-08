function [label_map,Iteration] = imgFcm(img,cluster_nums)
%% 在图像中使用FCM算法
% img：待聚类分割的图像
% cluster_nums：聚类的数量
% label_map：聚类后的标记图
% Iteration：算法的迭代次数
% 该函数既能处理灰度图像，也能处理RGB图像

%% 简单实现
[rows,cols,channels] = size(img);
expand_img = reshape(double(img),rows*cols,channels);
fuzzy_index = 2;    % 模糊指数范围为(1,∞)，一般情形下取2
% 注释“rng('default');”，以观察初始聚类中心对分割结果的影响
% rng('default');
member_mtrix = rand(cluster_nums,rows*cols);    % 随机初始化隶属度矩阵
member_mtrix = member_mtrix./(ones(cluster_nums,1)*sum(member_mtrix));    % 保持列归一化状态
cluster_centre = member_mtrix.^fuzzy_index*expand_img./...
    (sum(member_mtrix.^fuzzy_index,2)*ones(1,channels));    % 通过迭代公式初始化聚类中心
Iteration = 0;    % 为防止迭代振荡而设置的次数标记
while Iteration < 100
    Iteration = Iteration + 1;
    Euclid = sqrt((sum(expand_img.^2,2)*ones(1,cluster_nums))' + ...
        (sum(cluster_centre.^2,2)*ones(1,rows*cols)) - 2*cluster_centre*expand_img');
    next_member_mtrix = 1./(Euclid.^(2/(fuzzy_index-1))).*...
        (ones(cluster_nums,1)*sum(Euclid.^((-2/(fuzzy_index-1)))));
    next_member_mtrix = next_member_mtrix./...
        (ones(cluster_nums,1)*sum(next_member_mtrix));    % 保持列归一化状态
    next_cluster_centre = next_member_mtrix.^fuzzy_index*expand_img./...
        (sum(next_member_mtrix.^fuzzy_index,2)*ones(1,channels));
    % 使用矩阵的无穷范数来充当收敛条件（这里灵活多变，合理使用矩阵的范数即可）
    if norm(next_cluster_centre-cluster_centre,Inf) < 1e-3    % 迭代终止阈值设为0.001
        break;
    end
    cluster_centre = next_cluster_centre;
end
% 记录标记图
label_map = zeros(rows,cols);
[~,label] = max(next_member_mtrix,[],1);
for i = 1:cluster_nums
    label_map(label == i) = i;
end
end