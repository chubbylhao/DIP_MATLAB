%% 自己的实现效率有点低
close all; clear; clc;
img = imread('cameraman.tif');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = imresize(img,0.25);    % 自己的方法太慢（所以通过减小图像大小来缩短运行时间）
img = double(img);
[rows,cols] = size(img);
seed_row = 55; seed_col = 30;
seedvalue = img(seed_row,seed_col);
tolerance = 32;    % 这个相似度阈值很重要
range = [seedvalue-32,seedvalue+32];    % 这才是关键，仅靠差值和阈值比较大小的方法是错误的
img_fill = padarray(img,[1,1],510);    % 解决边界问题，510=255+255
label_map = zeros(size(img_fill));
label_map(seed_row+1,seed_col+1) = 1;    % 初始种子点
next_label_map = label_map;
Iteration = 0;    % 防止陷入迭代振荡
while Iteration < 200    % “遍历”这里执行效率太低下了
    Iteration = Iteration + 1;
    for i = 1:nnz(label_map)
        index = find(label_map == 1);
        [row,col] = ind2sub(size(label_map),index(i));
        block = img_fill(row-1:row+1,col-1:col+1);
        next_label_map(row-1:row+1,col-1:col+1) = ((block >= range(1)) & (block <= range(2)));
    end
    if sum(sum(next_label_map-label_map)) == 0
        break;
    end
    label_map =  next_label_map;
end
figure; imshow(labeloverlay(uint8(img),label_map(2:rows+1,2:cols+1)));
% 使用漫水填充进行抠图（分离前景和背景）
figure; imshow(uint8(label_map(2:rows+1,2:cols+1).*img + ~label_map(2:rows+1,2:cols+1)*255));

%% 看看MATLAB的实现（比我的快好多）
close all; clear; clc;
I = imread('cameraman.tif');
J = grayconnected(I,110,65);
figure; imshow(labeloverlay(I,J));
figure; imshow(uint8(J.*double(I) + ~J*255));