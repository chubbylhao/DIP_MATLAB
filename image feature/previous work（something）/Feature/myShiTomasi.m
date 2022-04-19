%% 参考资料
% https://zhuanlan.zhihu.com/p/83064609
% https://zhuanlan.zhihu.com/p/87745981
function [counts] = myShiTomasi(I,ratio)
%% Shi-Tomasi角点检测函数
% Shi-Tomasi角点检测方法又称为“最小特征值方法”
% 它是Harris角点检测方法的改进
% 相比于Harris，Shi-Tomasi只是更换了“角响应测度”

%% 实现
% 为避免图像边缘出现伪极值，需进行复制或镜像填充（不使用零填充）
fx = imfilter(I,[-1,0,1],'symmetric');
fy = imfilter(I,[-1;0;1],'symmetric');
fx2 = fx.^2;
fy2 = fy.^2;
fxy = fx.*fy;
% 高斯平滑滤波，相当于高斯加权操作
w = fspecial('gaussian',[7,7],1);
A = imfilter(fx2,w);
B = imfilter(fy2,w);
C = imfilter(fxy,w);
% 获得原图大小
[m,n] = size(I);
R = zeros(m,n);
% 区别！！！区别！！！区别！！！
% 计算“角响应测度”的值
for i = 1:m
    for j = 1:n
        M = [A(i,j),C(i,j);C(i,j),B(i,j)];
        % 取最小特征值
        % 区别！！！区别！！！区别！！！
        R(i,j) = min(eig(M));
    end
end
% 非极大值抑制的窗口大小
h = 5;
% 半窗宽
halfh = (h-1)/2;
% 记录映射图
mapR = zeros(m,n);
% 计算角点的个数
counts = 0;
% 剔除边缘点的阈值
T = ratio*max(R(:));
% 既要寻找区域极大值，也要剔除边缘点
for p = (halfh+1:m-halfh)
    for q = (halfh+1:n-halfh)
        if (R(p,q)==max(max(R(p-halfh:p+halfh,q-halfh:q+halfh)))) && (R(p,q)>T)
            mapR(p,q) = 1;
            counts = counts+1;
        end
    end
end
% 绘制找到的角点
[x,y] = find(mapR==1);
imshow(I,[]);hold on;
plot(y,x,'ro','MarkerSize',8);

% %% 使用matlab的自带函数corner
% C = corner(I);
% %% 使用matlab的自带函数detectHarrisFeatures
% points = detectHarrisFeatures(I);
end