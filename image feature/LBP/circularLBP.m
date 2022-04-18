% 圆形LBP算子（Ojala2002年改进）
% 又叫extendes LBP算子（扩展的LBP算子）
close all; clear; clc;
img = imread('person.png');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = double(img);
[rows,cols] = size(img);
% 选用的圆形LBP算子为：半径为2，点数为8，相比于原始的
% 半径为1的矩形LBP算子，对于更大的图像，其所描绘的纹理细节更加清晰
trans_seque = zeros(1,8);
for k = 1:8
   trans_seque(k) = 2^(8-k);    % 二进制转十进制的权重序列
end
LBP_val = zeros(rows,cols);
gray_val = zeros(1,8);
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
        LBP_val(i,j) = sum(bin_seque.*trans_seque);    % 将值转化值0~255
    end
end
figure; imshow(uint8(LBP_val));