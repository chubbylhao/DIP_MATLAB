% 一幅图像的“方差”越大，表示其对比度越高，质量越好
function STD = STDmetric(img)
img = double(img);
MN = numel(img);
mean = sum(img(:))/MN;
STD = sqrt(sum(sum((img-mean).^2))/MN);
end