% “通用图像质量指标”越接近于1，表示融合的效果越好
function UIQI = UIQImetric(img_f,img_r)
img_f = double(img_f(:));
img_r = double(img_r(:));

%% 计算平均值
img_f_mean = mean(img_f);
img_r_mean = mean(img_r);

%% 计算协方差矩阵
img_fr_cov = cov(img_f,img_r);
img_f_var = img_fr_cov(1,1);
img_r_var = img_fr_cov(2,2);
img_fr_var = img_fr_cov(1,2);

%% 计算通用图像质量指标
UIQI = (img_fr_var/(sqrt(img_f_var)*sqrt(img_r_var))) * ...
    (2*img_f_mean*img_r_mean/(img_f_mean^2 + img_r_mean^2)) * ...
    (2*sqrt(img_f_var)*sqrt(img_r_var)/(img_f_var + img_r_var));
end