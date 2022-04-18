close all; clear; clc;
img = imread('person.png');
if size(img,3) == 3
    img = rgb2gray(img);
end
img = rescale(sqrt(im2double(img)));    % gamma为1/2的光照（阴影）校正
img = imresize(img,0.5);
% figure; imshow(img,[]);
Gx = imfilter(img,[-0.5;0;0.5],'symmetric');
Gy = imfilter(img,[-0.5,0,0.5],'symmetric');
Gmag = sqrt(Gx.^2 + Gy.^2);
% figure; imshow(rescale(Gmag),[]);
Gdir = atan2d(Gy,Gx);    % 使用atand将有：0/0出现NaN，(非0)/0出现±Inf，使用atan2d则无此顾虑
[rows,cols] = size(img);
cell_size = 8;
row_cells = floor(rows/cell_size);
col_cells = floor(cols/cell_size);
M = cell(row_cells,col_cells);    % 通过划分cell获得的描述子
bins = 9;
bin_step = 180/bins;
cell_hist = zeros(1,bins);
for i = 1:row_cells
    for j = 1:col_cells
        op_cell_mag = Gmag((i-1)*cell_size+1:i*cell_size,(j-1)*cell_size+1:j*cell_size);
        op_cell_dir = Gdir((i-1)*cell_size+1:i*cell_size,(j-1)*cell_size+1:j*cell_size);
        label = ceil(((op_cell_dir<0)*180+op_cell_dir)/bin_step);
        label(label==0) = 1;    % 0°属于第一个bin
        for k = 1:numel(label)
            cell_hist(uint8(label(k))) = cell_hist(uint8(label(k))) + op_cell_mag(k);    % 按权重投票
        end
        M{i,j} = cell_hist;
        cell_hist = zeros(1,bins);
    end
end

%% 可视化通过划分cell获得的描述子（为了理解而加的代码）
% hog = zeros(rows,cols);
% figure; imshow(hog,[]); hold on;
% for i = 1:row_cells
%     for j = 1:col_cells
%         centre = [(i-0.5)*cell_size ,(j-0.5)*cell_size];    % 绘制中心
%         for k = 1:bins
%             offset = [M{i,j}(k)*cosd((k-0.5)*bin_step),M{i,j}(k)*sind((k-0.5)*bin_step)];
%             quiver(centre(2),centre(1),offset(1),offset(2),2,'w');    % 绘制单向箭头
%         end
%     end
% end
% hold off;

%% 在block中归一化梯度方向直方图（N即为最终所求的描述子）
block_size = 2;
N = cell(row_cells-1,col_cells-1);
for i = 1:row_cells-1    % blok的数量显然要更少
    for j = 1:col_cells-1
        block_hist = [M{i,j},M{i,j+1},M{i+1,j},M{i+1,j+1}];
        N{i,j} = block_hist/sum(block_hist);    % 归一化
    end
end