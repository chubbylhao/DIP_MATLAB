function out_img = gaussian(input_img,sigma)
%% 对图像进行高斯平滑
hsize = round(6*sigma+1);
if mod(hsize,2) == 0    % 确保使用奇数核
    hsize = hsize + 1;
end
g_kernel = fspecial('gaussian',hsize,sigma);
out_img = imfilter(input_img,g_kernel,'replicate');
end