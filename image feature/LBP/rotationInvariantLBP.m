% 旋转不变LBP算子（Ojala2002年改进）
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
gray_val = zeros(1,8);
LBP_seque = zeros(1,8);
for i = 3:rows-2
    for j = 3:cols-2
        % 与原始LBP的区别
        for k = 1:8
            coords_x = i + 2*cos(2*pi*k/8);
            coords_y = j + 2*sin(2*pi*k/8);
            % 得到周围4个（整数）像素点的坐标
            x1 = floor(coords_x); x2 = ceil(coords_x);
            y1 = floor(coords_y); y2 = ceil(coords_y);
            tx = coords_x - x1; ty = coords_y - y1;
            % 计算插值系数
            w1 = (1-tx)*(1-ty); w4 = tx*ty;
            w2 = tx*(1-ty); w3 = (1-tx)*ty;
            % 进行灰度插值（双线性插值）
            gray_val(k) = w1*img(x1,y1)+w2*img(x1,y2)+w3*img(x2,y1)+w4*img(x2,y2);
        end
        bin_seque = gray_val > img(i,j);    % 得到二进制LBP描述子
        for k = 1:8    % 使LBP算子是“旋转不变”的（就这一小段代码）
            LBP_seque(k) = sum(bin_seque.*trans_seque);
            bin_seque = circshift(bin_seque,1);
        end
        LBP_val(i,j) = min(LBP_seque);    % 将值转化值0~255
    end
end
figure; imshow(uint8(LBP_val));