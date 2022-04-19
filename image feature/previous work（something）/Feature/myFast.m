function [x,y,corners] = myFast(I,diffThreshold,s)
%% FAST-12-16的实现
% corners：找到的角点数量
% I：输入灰度图
% diffThreshold：人工设置的阈值
% s：局部邻域的大小

%% 得到候选角点
[row,col] = size(I);
V = zeros(row,col);    % 候选角点的得分矩阵
for i = 4:row-3
    for j = 4:col-3
        Ip = I(i,j);    % 获取区域中心像素的灰度值
        brighterThreshold = Ip+diffThreshold;    % 亮暗像素阈值
        dackerThreshold = Ip-diffThreshold;
        % 使用4个罗盘方向点进行快速测试（得到第一批候选角点）
        Ix_4 = [I(i-3,j);I(i,j+3);I(i+3,j);I(i,j-3)];
        if (sum((Ix_4-brighterThreshold)>=0)<3) && ...
                (sum((Ix_4-dackerThreshold)<=0)<3)
            continue;
        end
        % 使用12个连续点进行完整测试（得到第二批候选角点）
        % 圆的半径定为3px，则圆周经过16个像素点
        Ix_16 = [I(i-3,j);I(i-3,j+1);I(i-2,j+2);I(i-1,j+3);...
            I(i,j+3);I(i+1,j+3);I(i+2,j+2);I(i+3,j+1);...
            I(i+3,j);I(i+3,j-1);I(i+2,j-2);I(i+1,j-3);...
            I(i,j-3);I(i-1,j-3);I(i-2,j-2);I(i-3,j-1)];
        % 采用循环遍历函数对像素点进行重排
        for k = 1:16
            Ix_16 = circshift(Ix_16,k); 
            if (sum((Ix_16(1:12)-brighterThreshold)>=0))==12 || ...
                    (sum((Ix_16(1:12)-dackerThreshold)<=0))==12
               index = (abs(Ix_16-Ip)>=diffThreshold);
               % 为每一个候选角点打分
               V(i,j) = sum(abs(Ix_16(index)-Ip)-diffThreshold);
               break;
            end
        end
    end
end

%% 进行非极大值抑制
mapI = zeros(row,col);    % 角点映射图（存储最终角点的位置）
corners = 0;    % 找到的角点数量
for i = (4+(s+1)/2):(row-3-(s-1)/2)
   for j = (4+(s+1)/2):(col-3-(s-1)/2)
      if (V(i,j)==max(max(V(i-(s-1)/2:i+(s-1)/2,j-(s-1)/2:j+(s-1)/2)))) && (V(i,j)>0) 
         mapI(i,j) = 1;
         corners = corners+1;
      end
   end
end

%% 标出找到的FAST角点
imshow(I,[]);hold on;
[x,y] = find(mapI);
plot(y,x,'ro');hold off;
end