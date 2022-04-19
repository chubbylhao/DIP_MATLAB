close all; clear; clc;
img = imread('lena.tif');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = double(img);
gauss_kernel = fspecial('gaussian',3,0.5);
blur_img = imfilter(img,gauss_kernel,'replicate');    % 先进行高斯平滑
log_img = rescale(imfilter(blur_img,[0,1,0;1,-4,1;0,1,0]/4,'replicate'));    % 再对结果求拉普拉斯变换
figure; imshow(log_img,[]);
% 看看先对高斯函数求导再与图像卷积的结果
log_kernel = fspecial('log',3);    % 生成log卷积核
log_img2 = rescale(imfilter(img,log_kernel,'replicate'));
figure;imshow(log_img2,[]);
% 作个差（二者结果相差很小，基本上可认为相等）
diff = (log_img - log_img2)*255;