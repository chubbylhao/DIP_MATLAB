% 原始LBP算子（Ojala在1994年提出）
close all; clear; clc;
img = imread('../pics/person.png');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = double(img);
[rows,cols] = size(img);
trans_seque = zeros(1,8);
for k = 1:8
    trans_seque(k) = 2^(8-k);    % 二进制转十进制的权重序列
end
LBP_val = zeros(rows,cols);
for i = 2:rows-1
    for j = 2:cols-1
        block = [img(i-1,j-1),img(i-1,j),img(i-1,j+1),img(i,j+1),...
            img(i+1,j+1),img(i+1,j),img(i+1,j-1),img(i,j-1)];
        bin_seque = block > img(i,j);    % 得到二进制LBP描述子
        LBP_val(i,j) = sum(bin_seque.*trans_seque);    % 将值转化值0~255
    end
end
figure; imshow(uint8(LBP_val));