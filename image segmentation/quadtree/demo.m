close all;clear;clc;

img = double(rgb2gray(imread("gay.jpg")));
% img = imresize(img, [1024, 1024]);
thresh = var(img(:))/100;
res = quadtree_seg(img, thresh);
subplot(121), imshow(img, []);
subplot(122), imshow(res, []);