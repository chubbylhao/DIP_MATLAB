% 这个程序的迭代中心的表示有点问题，最好用三维数组表示（另外，对每个分块边界的处理也不是很好）
% 这个实例值得学习与记录的地方有：边界像素的处理、图像聚类的编程思路、标记矩阵的使用
% 后期有时间的话再回来修改错误
% 先去看看kmeans是怎么实现的
close all; clear; clc;
I = imread('lena.tif');
% I = imread('kobi.png');
if size(I,3) == 3
    I = rgb2gray(I);
end
I = double(I);
[row,col] = size(I);
% 所需的超像素数目
supix = 100;
% 规则网格的步长
s = floor(sqrt((row*col)/supix));
% 能规则划分的网格数量
regular_row_grid_num = floor(row/s);
regular_col_grid_num = floor(col/s);
% 不规则网格的大小
irregular_row_grid_size = mod(row,s);
irregular_col_grid_size = mod(col,s);
% 不规则网格的最小限制（后期再做改进）
if irregular_row_grid_size < 2 || irregular_col_grid_size < 2
    error('重新规定划分超像素的数量！');
end
% 网格的顶点坐标
up_row_peak = [1,(irregular_row_grid_size+1):s:(row-s+1)];
down_row_peak = irregular_row_grid_size:s:row;
left_col_peak = [1,(irregular_col_grid_size+1):s:(col-s+1)];
right_col_peak = irregular_col_grid_size:s:col;
% 网格的中心坐标
centre_row = floor((up_row_peak+down_row_peak-1)/2);
centre_col = floor((left_col_peak+right_col_peak-1)/2);
% % 显示网格的划分结果
% grid = zeros(row,col);
% grid(up_row_peak,:) = 1;
% grid(:,left_col_peak) = 1;
% grid(row,:) = 1;
% grid(:,col) = 1;
% for i = 1:regular_row_grid_num+1
%     for j = 1:regular_col_grid_num+1
%         grid(centre_row(i),centre_col(j)) = 1;
%     end
% end
% figure; imshow(grid);
% 求梯度图像（采用sobel核、复制填充方式）
[Gmag,~] = imgradient(I);
% figure; imshow(Gmag,[]);
% 填充梯度图像，防止聚类中心出现在图像边框上（从而造成下一步索引错误）
pad_Gmag = padarray(Gmag,[1,1],Inf,'both');
% 将聚类中心移至3*3邻域中的最小梯度位置
new_centre_row = centre_row;
new_centre_col = centre_col;
for i = 1:regular_row_grid_num+1
    for j = 1:regular_col_grid_num+1
        % 使用填充梯度图像时，索引的横纵坐标各加1
        neighbourhood = pad_Gmag(centre_row(i):centre_row(i)+2,centre_col(j):centre_col(j)+2);
        % 出现多个相同的最小梯度时，按线性索引排序取第一个
        [offset_x,offset_y] = ind2sub([3,3],find(neighbourhood == min(neighbourhood(:)),1));
        % 完成聚类中心的初始化
        new_centre_row(i) = centre_row(i) + offset_x - 2;
        new_centre_col(j) = centre_col(j) + offset_y - 2;
    end
end
% 对于图像中的每个像素位置，设置标签“-1”和距离“∞”
map_label = -ones(row+2*s,col+2*s);
map_distance = 10^10*ones(row+2*s,col+2*s);
% 将样本分配给聚类中心
pad_I = padarray(I,[s,s],0,'both');
c = 10;
flag = 0;
while flag < 20
for i = 1:regular_row_grid_num+1
    for j = 1:regular_col_grid_num+1
        neighbourhood = pad_I(new_centre_row(i):new_centre_row(i)+2*s,...
            new_centre_col(j):new_centre_col(j)+2*s);
        centre_martix = repmat(pad_I(new_centre_row(i)+s,new_centre_col(j)+s),2*s+1);
        d_c = sqrt((neighbourhood-centre_martix).^2);
        x_martix = repmat((-s:s)',1,2*s+1);
        y_martix = repmat((-s:s),2*s+1,1);
        d_s = sqrt(x_martix.^2 + y_martix.^2);
        D = sqrt((d_c).^2 + (d_s/s).^2 * c^2);
        d = map_distance(new_centre_row(i):new_centre_row(i)+2*s,...
            new_centre_col(j):new_centre_col(j)+2*s);
        map_distance(new_centre_row(i):new_centre_row(i)+2*s,...
            new_centre_col(j):new_centre_col(j)+2*s) ...
                = (~(D<d)).*d + (D<d).*D;
        label = map_label(new_centre_row(i):new_centre_row(i)+2*s,...
            new_centre_col(j):new_centre_col(j)+2*s);
        map_label(new_centre_row(i):new_centre_row(i)+2*s,...
            new_centre_col(j):new_centre_col(j)+2*s) ...
                = (~(D<d)).*label + (D<d).*((i-1)*(regular_col_grid_num+1)+j);
    end
end
% % 记录前一次的聚类中心
% old_centre_row = new_centre_row;
% old_centre_col = new_centre_col;
% 更新聚类中心
true_label = map_label(s+1:row+s,s+1:col+s);
for i = 1:regular_row_grid_num+1
    for j = 1:regular_col_grid_num+1
        k = (i-1)*(regular_col_grid_num+1)+j;
        [ind_x,ind_y] = ind2sub([row,col],find(true_label == k));
        new_centre_row(i) = floor(sum(ind_x)/numel(ind_x));
        new_centre_col(j) = floor(sum(ind_y)/numel(ind_y));
    end
end
% 收敛性检验
flag = flag + 1;
end
figure; imshow(label2rgb(true_label,'jet','w','shuffle'));
% img = imread('kobi.png');
img = imread('lena.tif');
L = labeloverlay(img,true_label);
figure; imshow(L);