% “空间频率误差”为正且越大，表示融合效果越好
function SFE = SFEmetric(img_f,img_r)
img_f = double(img_f);
img_r = double(img_r);
MN = numel(img_f);

%% 融合后图像的空间频率
RF_square_f = sum(sum((img_f(:,2:end) - img_f(:,1:end-1)).^2))/MN;
CF_square_f = sum(sum((img_f(2:end,:) - img_f(1:end-1,:)).^2))/MN;
SF_f = sqrt(RF_square_f + CF_square_f);

%% 参考图像的空间频率
RF_square_r = sum(sum((img_r(:,2:end) - img_r(:,1:end-1)).^2))/MN;
CF_square_r = sum(sum((img_r(2:end,:) - img_r(1:end-1,:)).^2))/MN;
SF_r = sqrt(RF_square_r + CF_square_r);

%% 计算空间频率误差
SFE = (SF_f - SF_r)/SF_r;
end