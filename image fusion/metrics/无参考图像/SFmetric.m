% 一幅图像的“空间频率”越大，表示其所包含的边缘和纹理信息越丰富（越清晰、越好）
function SF = SFmetric(img)
img = double(img);
MN = numel(img);

%% 经典的空间频率
RF_square = sum(sum((img(:,2:end) - img(:,1:end-1)).^2))/MN;
CF_square = sum(sum((img(2:end,:) - img(1:end-1,:)).^2))/MN;
SF = sqrt(RF_square + CF_square);

%% 改进的空间频率（加了两个对角方向）
% RF_square = sum(sum((img(:,2:end) - img(:,1:end-1)).^2))/MN;
% CF_square = sum(sum((img(2:end,:) - img(1:end-1,:)).^2))/MN;
% MDF_square = sqrt(0.5)*sum(sum((img(2:end,2:end) - img(1:end-1,1:end-1)).^2))/MN;
% SDF_square = sqrt(0.5)*sum(sum((img(2:end,1:end-1) - img(1:end-1,2:end)).^2))/MN;
% SF = sqrt(RF_square + CF_square + MDF_square + SDF_square);
end