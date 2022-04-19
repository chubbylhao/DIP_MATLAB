function [counts] = myMoravec(I,m,n,ratio)
%% Moravec角点检测函数
% counts为找到的角点数量
% I为灰度图像
% m为滑动窗口的一半
% n为抑制窗口的一半
% ratio为阈值比例
% 滑动窗口的大小为(2m+1)*(2m+1)
% 抑制窗口的大小为(2n+1)*(2n+1)

%% 实现
[M,N] = size(I);
V = zeros(1,8);
mapI = zeros(M,N);
for x = (m+2):(M-m-1)
    for y = (m+2):(N-m-1)
        % 中心窗口
        w0 = I(x-m:x+m,y-m:y+m);
        % 垂直向上移动
        w1 = I(x-m-1:x+m-1,y-m:y+m);
        % 垂直向下移动
        w2 = I(x-m+1:x+m+1,y-m:y+m);
        % 水平向左移动
        w3 = I(x-m:x+m,y-m-1:y+m-1);
        % 水平向右移动
        w4 = I(x-m:x+m,y-m+1:y+m+1);
        % 左上移动
        w5 = I(x-m-1:x+m-1,y-m-1:y+m-1);
        % 右下移动
        w6 = I(x-m+1:x+m+1,y-m+1:y+m+1);
        % 左下移动
        w7 = I(x-m+1:x+m+1,y-m-1:y+m-1);
        % 右上移动
        w8 = I(x-m-1:x+m-1,y-m+1:y+m+1);
        % 整合
        w = [w1(:),w2(:),w3(:),w4(:),w5(:),w6(:),w7(:),w8(:)];
        for i = 1:8
           V(i) = sum((w0(:)-w(:,i)).^2);
        end
        % 因角点沿8个方向变化都较大，故取最小值构成映射图
        mapI(x,y) = min(V);
    end
end
imshow(I,[]);hold on;
%% 设置阈值,筛选出候选角点
T = ratio*max(mapI(:));
mapI(mapI<T) = 0;
%% 进行非极大值抑制
counts = 0;
for u = (n+3):(M-n-2)
   for v = (n+3):(N-n-2)
       wstar = mapI(u-n:u+n,v-n:v+n);
       if (mapI(u,v)==max(wstar(:))) && (mapI(u,v)~=0)
           plot(v,u,'ro','MarkerFaceColor','red');
           counts = counts+1;
       end
   end
end
end