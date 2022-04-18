% 使用等价模式的LBP算子（Ojala2002年改进）
close all; clear; clc;
img = imread('person.png');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = double(img);
[rows,cols] = size(img);
trans_seque = zeros(1,8);
for k = 1:8
   trans_seque(k) = 2^(8-k);    % 二进制转十进制的权重序列
end
% 58种等价模式（映射到1~58）和1种混合模式（映射为0）
op_num = zeros(1,8);
table = zeros(1,256);
flag = 1;
for i = 0:255
    dec_num = i;
    for j = 1:8    % 十进制转二进制
        op_num(j) = floor(dec_num/trans_seque(j));
        dec_num = mod(dec_num,trans_seque(j));  
    end
    if sum(bitxor(op_num,circshift(op_num,1))) <= 2
       table(i+1) = flag;
       flag = flag + 1;
    end
end
% 计算LBP描述子
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
        hop_counts = sum(bitxor(bin_seque,circshift(bin_seque,1)));    % 计算跳变次数
        if hop_counts <= 2    % 使用映射表
            LBP_val(i,j) = table(0:255==sum(bin_seque.*trans_seque));
        end
    end
end
figure; imshow(uint8(LBP_val));    % 值在0~58之间，看起来会很暗
figure; imshow(LBP_val,[]);    % 缩放亮度级