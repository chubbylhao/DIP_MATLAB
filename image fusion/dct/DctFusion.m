function [fusedDctVar,fusedDctVarCv] = DctFusion(I1,I2)
%% 该函数使用DCT变换实现图像的融合
% I1和I2：待融合的两幅图像
% fusedDctVar：未进行一致性校验(CV)的融合图像
% fusedDctVarCv：进行了一致性校验(CV)的融合图像

%% 简单实现
[row,col] = size(I1);
fusedDctVar = zeros(row,col);
fusedDctVarCv = zeros(row,col);
cvMap = zeros(floor(row/8),floor(col/8));    % 用于一致性校验
I1 = double(I1)-128; I2 = double(I2)-128;    % 灰度平移

%% 划分8*8的块进行DCT变换，融合规则选用区域能量最大法（方差最大法）
for i = 1:floor(row/8)
    for j = 1:floor(col/8)
        % 划分子块
        im1Sub = I1(8*i-7:8*i,8*j-7:8*j);
        im2Sub = I2(8*i-7:8*i,8*j-7:8*j);
        % 计算子块的DCT
        im1SubDct = dct2(im1Sub);
        im2SubDct = dct2(im2Sub);
        % 计算DCT块的系数平均值
        im1Mean = mean(im1SubDct(:));
        im2Mean = mean(im2SubDct(:));
        % 计算DCT块的方差（能量），若担心值溢出，可对DCT系数进行归一化
        im1Var = sum(sum(im1SubDct.^2)) - im1Mean.^2;
        im2Var = sum(sum(im2SubDct.^2)) - im2Mean.^2;
        % 按能量最大法进行融合
        if im1Var > im2Var
            dctVarSub = im1SubDct;
            cvMap(i,j) = -1;	% 标记-1
        else
            dctVarSub = im2SubDct;
            cvMap(i,j) = +1;    % 标记+1
        end
        % 进行DCT逆变换重构图像
        fusedDctVar(8*i-7:8*i,8*j-7:8*j) = idct2(dctVarSub); 
    end
end

%% 使用均值滤波器以进行一致性校验
filter = ones(7,7)/49;
cvMapFiltered = imfilter(cvMap, filter, 'symmetric');
cvMapFiltered = imfilter(cvMapFiltered, filter, 'symmetric');
for i = 1:row/8
    for j = 1:col/8
        if cvMapFiltered(i,j) <= 0
            fusedDctVarCv(8*i-7:8*i,8*j-7:8*j) = I1(8*i-7:8*i,8*j-7:8*j);
        else
            fusedDctVarCv(8*i-7:8*i,8*j-7:8*j) = I2(8*i-7:8*i,8*j-7:8*j);
        end
    end
end
fusedDctVar = fusedDctVar+128; fusedDctVarCv = fusedDctVarCv+128;    % 灰度反平移
end