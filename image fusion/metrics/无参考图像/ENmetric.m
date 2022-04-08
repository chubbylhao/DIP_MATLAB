% 一幅图像的“熵”越大，表示其所含的信息越丰富，质量越好
% 注意，img为uint类型的图像
function EN = ENmetric(img)
[counts,~] = imhist(img);
p = counts/numel(img);
p = p(find(p));
EN = -sum(p.*log2(p));
end