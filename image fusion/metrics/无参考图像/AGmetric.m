% 一幅图像的“平均梯度”越大，表示其细节越清晰，质量越好
function AG = AGmetric(img)
img = double(img);
[imgX,imgY] = gradient(img);
AG = sum(sum((sqrt((imgX.^2 + imgY.^2)/2)))) / numel(img);
end