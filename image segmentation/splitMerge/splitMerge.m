function res = splitMerge(img,min_dim,func)
%% 该函数使用区域的分离和聚合来分割图像
% img：待分割图像
% min_dim：四叉树分解的最小块的大小
% func：谓词逻辑函数

%% 简单实现
Q = 2^nextpow2(max(size(img)));    % 填充图像，使之能够进行四叉树分解（2的次幂大小）
[rows,cols] = size(img);
img = padarray(img,[Q-rows,Q-cols],'post');    % 使用0填充即可
Z = qtdecomp(img,@split_test,min_dim,func);    % 使用函数句柄控制四叉树的分解
Lmax = full(max(Z(:)));    % Z是稀疏矩阵，需要用到full（建议多尝试去了解full的用法）
res = zeros(size(img));
marker = res;
% 开始聚合
for i = 1:Lmax    % Lmax是四叉树分解的最大块的大小
    [vals,r,c] = qtgetblk(img,Z,i);
    if ~isempty(vals)    % 如果存在这么大小的一个块
        for j = 1:length(r)
            xlow = r(j); ylow = c(j);
            xhigh = xlow+i-1; yhigh = ylow+i-1;
            region = img(xlow:xhigh,ylow:yhigh);
            flag = func(region);
            if flag
                res(xlow:xhigh,ylow:yhigh) = 1;
                marker(xlow,ylow) = 1;    % 只标记左上角点用于重建
            end
        end
    end
end
res = bwlabel(imreconstruct(marker,res));    % 利用形态学重建来保证连通性
res = res(1:rows,1:cols);    % 裁剪至原来的大小
end

%% 四叉树分解的函数句柄（这一部分需要参看qtdecomp函数的官方MATLAB文档）
% 测试块是否应该被进一步分解（为不相交的四象限）
function v = split_test(B,min_dim,func)
k = size(B,3);    % k是目前分解的块的数量
v(1:k) = false;    % 确定需要继续被分解的块
for i = 1:k
   quadregion = B(:,:,i);    % 取出其中一个块
   if size(quadregion,1) <= min_dim    % 若块已经小于规定的大小，则不应该继续分割
       v(i) = false;
       continue;
   end
   if func(quadregion)    % 大于规定的大小且满足谓词逻辑，应该继续分割
       v(i) = true;
   end
end
end