function myHoughLine(I,lineNum)
%% 参数说明
% I为灰度图像
% lineNum为要提取的直线数量

%% Hough线变换
BW = edge(I,'canny');    % 提取边缘，以作为Hough线变换的前景
[row,col] = size(BW);
D = ceil(sqrt(row^2 + col^2));    % 图像平面的对角距离，为避免索引时超出数组边界，向上取整
Rho = -D:D; Theta = -90:90;    % 定义参数平面的取值范围
Scores = zeros(length(Rho),length(Theta));    % 创建voting矩阵
[x,y] = find(BW == 1);    % 取出前景像素作为voting点
rho = round(x.*cosd(Theta) + y.*sind(Theta));
for i = 1:size(rho,1)
    for j = 1:length(Theta)
        Scores(D + rho(i,j) + 1,j) = Scores(D + rho(i,j) + 1,j) + 1;    % 遍历投票
    end
end
lineMaxValue = maxk(Scores(:),lineNum);
[lineRho,lineTheta] = find(Scores >= lineMaxValue(lineNum),lineNum);
lineRho = lineRho - D - 1;    % 记得转换回来
lineTheta = lineTheta - 90 - 1;

%% 绘制“最强的”lineNum条直线
figure; imshow(I); hold on;
for k = 1:lineNum
   n = 0.05*row:0.95*row;
   m = (-cosd(lineTheta(k))*n + lineRho(k)) / sind(lineTheta(k));
   m(m < 0.05*col | m > 0.95*col) = NaN;    % 绘制范围不要超过图像边界
   plot(m,n,'c','Linewidth',2);
end
hold off;
end