close all; clear; clc; tic;

%% Hough圆变换（经典的，未使用梯度策略）的粗略实现
% Hough圆变换似乎对参数变化特别敏感！而且容易导致内存溢出！
I = imread('coins.png');
BW = edge(I,'canny');
[row,col] = size(BW);
step_r = 5; r_min = 25; r_max = 40;
r = r_min:step_r:r_max;
step_Theta = 5;
Theta = 0:step_Theta:360;
[x,y] = find(BW == 1);
dots = length(x); size_r = length(r); size_Theta = length(Theta);
Scores = zeros(row,col,size_r);
% 使用极坐标方程：a = x - r*cos(Theta); b = y - r*sin(Theta);
for i = 1:dots
   for j = 1:size_r
      for k = 1:size_Theta
          a = round(x(i) - (r_min+(j-1)*step_r)*cosd(k*step_Theta));
          b = round(y(i) - (r_min+(j-1)*step_r)*sind(k*step_Theta));
          if (a>0 && a<=row && b>0 && b<=col)
             Scores(a,b,j) = Scores(a,b,j) + 1; 
          end
      end
   end
end
peaks = find(Scores >= max(Scores(:))*0.7);
[X,Y,Z] = ind2sub([row,col,size_r],peaks);    % 线性索引转化为坐标索引
figure; imshow(I); hold on;
for k = 1:length(X)
   CirclePlot(r_min+(Z(k)-1)*step_r,Y(k),X(k)); 
end
hold off; toc;