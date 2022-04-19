close all; clear; clc;
img = imread('lena.tif');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = double(img);
gauss_kernel = fspecial('gaussian',3,0.5);
gauss_kernel2 = fspecial('gaussian',7,1);
blur_img = imfilter(img,gauss_kernel,'replicate');
blur_img2 = imfilter(img,gauss_kernel2,'replicate');
diff = blur_img2 - blur_img;    % 直接作差就好
figure; imshow(diff,[]);    % 当两个标准差满足一定的关系时，可用DoG近似LoG