% 一幅图像的“均值”越适中，表示其质量越好
function mean = meanmetric(img)
img = double(img);
mean = sum(img(:))/numel(img);
end