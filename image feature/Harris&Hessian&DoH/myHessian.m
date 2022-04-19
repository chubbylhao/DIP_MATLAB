%% 套用语句
close all; clear; clc;
img = imread('house.tif');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = double(img);

%% 不使用邻域信息的Hessian矩阵
fxx = imfilter(img,[1;-2;1],'replicate');
fyy = imfilter(img,[1,-2,1],'replicate');
fxy = imfilter(img,[1;0;-1]*[1,0,-1]/4,'replicate');
fyx = fxy;
H = cell(size(img));
for i = 1:numel(img)
   H{i} = [fxx(i),fxy(i);fyx(i),fyy(i)];
end

%% 使用3×3邻域信息的Hessian矩阵（使用盒式核滤波）
h = fspecial('average',3);
blur_img = imfilter(img,h,'replicate');
fxx = imfilter(blur_img,[1;-2;1],'replicate');
fyy = imfilter(blur_img,[1,-2,1],'replicate');
fxy = imfilter(blur_img,[1;0;-1]*[1,0,-1]/4,'replicate');
fyx = fxy;
H = cell(size(img));
for i = 1:numel(img)
   H{i} = [fxx(i),fxy(i);fyx(i),fyy(i)];
end

%% 使用3×3邻域信息的Hessian矩阵（使用高斯核滤波）
h = fspecial('gaussian',3,1);
blur_img = imfilter(img,h,'replicate');
fxx = imfilter(blur_img,[1;-2;1],'replicate');
fyy = imfilter(blur_img,[1,-2,1],'replicate');
fxy = imfilter(blur_img,[1;0;-1]*[1,0,-1]/4,'replicate');
fyx = fxy;
H = cell(size(img));
R = zeros(size(img));
for i = 1:numel(img)
   H{i} = [fxx(i),fxy(i);fyx(i),fyy(i)];
   R(i) = det(H{i}) - 0.04*trace(H{i})^2;
end