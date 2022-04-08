% 一幅图像的“大平均梯度”越大，表示其细节越清晰，质量越好
function MG = MGmetric(img)
img = double(img);
[M,N] = size(img);
R_G_square = (img(2:end,1:end-1) - img(1:end-1,1:end-1)).^2;
C_G_square = (img(1:end-1,2:end) - img(1:end-1,1:end-1)).^2;
MG = sum(sum(sqrt((R_G_square + C_G_square)/2))) / ((M-1)*(N-1));
end