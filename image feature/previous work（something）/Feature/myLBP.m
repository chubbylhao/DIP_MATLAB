close all;clear;clc;

%% 提取一个最原始的LBP特征
tic;
I = imread('house.tif');
if size(I,3) == 3
    I = rgb2gray(I);
end
I = double(I);
[row,col] = size(I);
bin_sequence = zeros((row-2)*(col-2),8);
str = zeros(row,col);
flag = 0;
for i = 2:row-1
    for j = 2:col-1
        flag = flag+1;
        sequence = [I(i-1,j-1),I(i-1,j),I(i-1,j+1),...
            I(i,j+1),I(i+1,j+1),I(i+1,j),I(i+1,j-1),I(i,j-1)];
        for k = 1:8
           if sequence(k) > I(i,j)
               bin_sequence(flag,k) = 1;
           end
        end
        for s = 1:8
            str(i,j) = bin_sequence(flag,s)*2^(8-s) + str(i,j);
        end
    end
end

%% 显示用LBP特征表示的纹理图像（LBP可用于提取图像的纹理信息）
imshow(str,[]);
toc;