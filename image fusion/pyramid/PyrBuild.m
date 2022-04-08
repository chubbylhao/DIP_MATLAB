function [gauss_pyr,lp_pyr] = PyrBuild(I,N)
%% 此函数用于生成拉普拉斯金字塔
% I是输入灰度图像（类型为double类型）
% N是欲构建的金字塔的层数
% gauss_pyr是生成的高斯金字塔
% lp_pyr是生成的拉普拉斯金字塔
h = [1,4,6,4,1]; kernel = h'*h/256;

%% 构建高斯金字塔
gauss_pyr = cell(N,1); gauss_pyr{1} = I;
for i = 1:N-1
    blurI = imfilter(gauss_pyr{i},kernel,'replicate');
    gauss_pyr{i+1} = blurI(1:2:size(blurI,1),1:2:size(blurI,2));
end

%% 构建拉普拉斯金字塔
lp_pyr = cell(N,1); lp_pyr{N} = gauss_pyr{N};
for j = 1:N-1
%     % 偶数行与偶数列都填充零时的上采样过程
%     upI = zeros(size(gauss_pyr{j}));
%     upI(1:2:size(gauss_pyr{j},1),1:2:size(gauss_pyr{j},2)) = gauss_pyr{j+1};
    upI = imresize(gauss_pyr{j+1},2);
    lp_pyr{j} = gauss_pyr{j} - imfilter(upI,kernel,'replicate');
end

%% 查看金字塔图像
% for j = 1:N
%    figure; imshow(lp_pyr{j},[]);
% end
end