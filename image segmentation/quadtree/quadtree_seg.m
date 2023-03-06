function N = quadtree_seg(M, thresh)

[rows, cols] = size(M);

% 递归停止条件
if rows <= 4
    M(:, :) = 1;
    N = M;
    return
end

% node的结构划分：
% -----------------
% node{1} | node{3}
% -----------------
% node{2} | node{4}
% -----------------
node{1} = M(1:rows/2, 1:cols/2);
node{2} = M(rows/2+1:rows, 1:cols/2);
node{3} = M(1:rows/2, cols/2+1:cols);
node{4} = M(rows/2+1:rows, cols/2+1:cols);

% 深度优先搜素
for k = 1:4
    if var(node{k}(:)) < thresh
        node{k}(:, :) = 0;
    else
        node{k} = quadtree_seg(node{k}, thresh);
    end
end
N = [node{1}, node{3}; node{2}, node{4}];

end