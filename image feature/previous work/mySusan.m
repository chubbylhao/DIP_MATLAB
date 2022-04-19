%% 有点问题！！！
% 编程实现上的问题：排除伪角点的第2步！！！
% 参考：https://blog.csdn.net/zhiTjun/article/details/114638289
% https://blog.csdn.net/kezunhai/article/details/11269793?utm_source=tuicool&utm_medium=referral
function [counts] = mySusan(I,T,s)
%% SUSAN角点检测函数
% counts为找到的角点数量
% I为灰度图像
% T为核值相似区的判定阈值
% s为非极大值抑制的窗口大小（s*s）

%% 实现
[M,N] = size(I);
% 映射矩阵
mapI = zeros(M,N);
for i = 4:M-3
    for j = 4:N-3
        w = I(i-3:i+3,j-3:j+3);
        % 初始化核值相似区的大小
        USAN = 0;
%         % 初始化核值相似区的重心
%         centx = 0;
%         centy = 0;
        for p = 1:7
            for q = 1:7
                % 排除不属于37像素圆形模板的其余12点
                if ((p-4)^2 + (q-4)^2) < 13
                    % 计算核值相似区的大小
                    if abs(I(i,j)-w(p,q)) < T
%                         centx = centx + p;
%                         centy = centy + q;
                        USAN = USAN + 1;
                    end
                end
            end
        end
%         % 计算重心
%         centx = centx / USAN;
%         centy = centy / USAN;
%         % 排除伪角点
%         % 1、计算USAN的重心，若其到模板中心的距离过小，则判定为伪角点
%         if ((centx-4)^2 + (centy-4)^2) < 0.25
%             USAN = 37;
%             % 2、USAN的重心和模板中心的连线所经过的像素若存在不属于USAN区域的像素
%             % 则判定为伪角点
%             k = (centy-4) / (centx-4);
%             b = 4 * (centx-centy) / (centx-4);
%             if centx < 4
%                 centx = ceil(centx);     % 向上取整
%             else
%                 centx = floor(centx);    % 向下取整
%             end
%             if centy < 4
%                 centy = ceil(centy);     % 向上取整
%             else
%                 centy = floor(centy);    % 向下取整
%             end
%             for u = min(centx,4):max(centx,4)
%                 for v = min(centy,4):max(centy,4)
%                     if ((abs(v-k*u-b)<1) || (abs(u-(v-b)/k)<1)) && (abs(I(i,j)-w(u,v))>T)
%                         USAN = 37;
%                         break;
%                     end
%                 end
%             end
%         end
        % 筛选出候选角点，构建极大值映射图
        % 筛选阈值一般为USAN最大值的一般，即37/2=18.5
        if USAN < 18.5
            % 将USAN的小值（USAN的值越小，模板中心点是角点的概率越高）转换为大值
            mapI(i,j) = 18.5 - USAN;
        end
    end
end
% 非极大值抑制
Re = zeros(M,N);
% 计算角点的个数
counts = 0;
for i = (4+(s+1)/2):(M-3-(s-1)/2)
   for j = (4+(s+1)/2):(N-3-(s-1)/2)
      if (mapI(i,j)==max(mapI(i-(s-1)/2:i+(s-1)/2,j-(s-1)/2:j+(s-1)/2),[],'all')) && (mapI(i,j)>0) 
         Re(i,j) = 1;
         counts = counts+1;
      end
   end
end
% 绘制找到的角点
[x,y] = find(Re==1);
imshow(I,[]);hold on;
plot(y,x,'r+','MarkerSize',20);
end