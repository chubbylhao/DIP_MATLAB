% “互信息”越大，表示融合图像从源图像中获得的有用信息越多（好像出了点问题？）
function MI = MImetric(img_f,img_r)
[M,N] = size(img_f);
[counts_f,binLocations_f] = imhist(img_f);
[counts_r,~] = imhist(img_r);
L = numel(binLocations_f);
joint = zeros(L);
% 求联合概率密度
for i = 1:L
    for j = 1:L
        joint(i,j) = counts_r(i)+counts_f(j);
    end
end
joint = joint/sum(joint(:));
norm_counts_f = counts_f/(M*N);
norm_counts_r = counts_r/(M*N);
mul_res = norm_counts_r*norm_counts_f';
map = (joint>0) & (mul_res>0);
joint = joint(find(joint.*map));
mul_res = mul_res(find(mul_res.*map));
MI = sum(sum(joint.*log2(joint./mul_res)));
end