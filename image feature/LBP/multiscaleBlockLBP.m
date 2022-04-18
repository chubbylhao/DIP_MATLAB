% 多尺度分块LBP算子（由中科院提出），即MB-LBP特征
close all; clear; clc;
img = imread('person.png');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = imresize(double(img),0.5);    % 原图计算有点慢，故而缩小一半
trans_seque = zeros(1,8);
for k = 1:8
   trans_seque(k) = 2^(8-k);    % 二进制转十进制的权重序列
end
LBP_val = zeros(size(img));
% block块太大，若不进行填充，则浪费的像素点太多
img_pad = padarray(img,[3,3],'both','replicate');
[pad_rows,pad_cols] = size(img_pad);
for i = 5:pad_rows-4
    for j = 5:pad_cols-4
        % 求每块的均值
        block = [mean2(img_pad(i-4:i-2,j-4:j-2)),mean2(img_pad(i-4:i-2,j-1:j+1)),...
            mean2(img_pad(i-4:i-2,j+2:j+4)),mean2(img_pad(i-1:i+1,j+2:j+4)),...
            mean2(img_pad(i+2:i+4,j+2:j+4)),mean2(img_pad(i+2:i+4,j-1:j+1)),...
            mean2(img_pad(i+2:i+4,j-4:j-2)),mean2(img_pad(i-1:i+1,j-4:j-2))];
        bin_seque = block > mean2(img_pad(i-1:i+1,j-1:j+1));    % 得到二进制LBP描述子
        LBP_val(i-4:i-2,j-4:j-2) = sum(bin_seque.*trans_seque);    % 将值转化值0~255
    end
end
figure; imshow(uint8(LBP_val));
% 求SEMB-LBP
[counts,~] = imhist(uint8(LBP_val));
[~,index] = maxk(counts,63);
bins = zeros(1,256);
bins(index) = 63:-1:1;    % 数量越多，赋的值越大
SEMB_LBP = zeros(size(img));
for k = 1:256
    SEMB_LBP = (LBP_val == k-1)*bins(k) + SEMB_LBP;
end
figure; imshow(uint8(SEMB_LBP));
figure; imshow(SEMB_LBP,[]);
figure; histogram(SEMB_LBP,64);    % 在里面值为0的是混合模式类，占1/5左右
% 得到MB_LBP的特征向量：（归一化直方图，即概率密度矢量（pdf）就是特征向量）
% 其实思想很简单，先对LBP_val分块，如8×8块
% 计算每块的SEMB-LBP，并将其归一化，能得到一个64维的特征向量
% 按顺序串联这些分块特征向量即可得到总特征向量，共8×8×64维
% 若不使用等价模式类（即不进行特征降维），总特征向量的维数是8×8×256维
% 不仅维数增大为4倍，而且容易产生局部特征稀疏的情况
% 接下来就是进行人脸检测了：（LBP+Adaboost）方法