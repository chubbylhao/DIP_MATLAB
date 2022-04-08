close all; clear; clc;
img = imread('cygnusloop.tif');
if size(img,3) == 3
    img = rgb2gray(img);
end
figure; imshow(img);
res = splitMerge(img,16,@predicate);
res(res~=0) = 1;    % 将所有连通域当作前景显示
figure; imshow(logical(res));
figure; imshow(double(img).*res,[]);    % 显示分割结果