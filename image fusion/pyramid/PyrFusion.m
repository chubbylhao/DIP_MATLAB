%% 测试拉普拉斯金字塔的融合效果
close all; clear; clc;
I1 = imread('r1.jpg');
I2 = imread('r2.jpg');
if size(I1,3) == 3
    I1 = rgb2gray(I1);
end
if size(I2,3) == 3
    I2 = rgb2gray(I2);
end
I1 = double(I1);
I2 = double(I2);
[~,lp_pyr1] = PyrBuild(I1,3);
[~,lp_pyr2] = PyrBuild(I2,3);
res = PyrRebuild(lp_pyr1,lp_pyr2,0.5);
figure;
subplot(131),imshow(I1,[]),title('左聚焦图像');
subplot(132),imshow(I2,[]),title('右聚焦图像');
subplot(133),imshow(res,[]),title('融合后图像');
res = (res-min(res(:)))/(max(res(:))-min(res(:)))*255;
imwrite(uint8(res),'f_pyr.jpg');