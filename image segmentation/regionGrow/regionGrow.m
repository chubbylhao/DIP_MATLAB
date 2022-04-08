function grow_region = regionGrow(img,gray_value,Threshold)
%% 该函数使用区域生长法分割图像
% img：待分割图像
% gray_value：种子点的灰度值
% Threshold：分割的阈值
% grow_region：含种子点的生长区域（这是一个标签矩阵！）

%% 简单实现
if numel(gray_value) == 1
   label_map = (img == gray_value);    % 是种子点的地方标记为1，不是种子点的地方标记为0
   seed_value = gray_value;    % 种子点所在位置的灰度值
else
    label_map = bwmorph(gray_value,'shrink',Inf);
    seed_value = img(label_map);
end
original_label_map = false(size(img));
for k = 1:length(seed_value)
    % 满足阈值条件的所有点都会被记录下来（其中包括一些我们不想分割出来的区域）
   original_label_map = ((abs(img - seed_value(k)) <= Threshold) | original_label_map);
end
% 有种子点存在的生长区域才是有意义的（连通性的使用是基本需求）（形态学重建可帮助我们完成这一操作）
grow_region = bwlabel(imreconstruct(label_map,original_label_map));
end