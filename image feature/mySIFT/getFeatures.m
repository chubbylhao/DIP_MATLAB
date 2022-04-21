function [descrs,locs] = getFeatures(img)
%% SIFT特征提取主函数
global gauss_pyr;
global dog_pyr;
global init_sigma;
global octvs;
global intvls;
global ddata_array;
global features;
if size(img,3) == 3
    img = rgb2gray(img);
end
img = im2double(img);

%% 基本参数初始化
init_sigma = 1.6;    % 初始sigma，第一个倍频程的第一层图像的高斯滤波核的标准差
intvls = 3;    % 尺度空间的层数，差分金字塔的层数为s+2，高斯金字塔的层数为s+3
s = intvls;
k = 2^(1/s);
sigma = ones(1,s+3);    % 每层图像使用的高斯滤波核的标准差（下一幅图像是在上一幅图像上做平滑）
sigma(1) = init_sigma;    % 只对第一个倍频程中的第一幅图像使用
sigma(2) = init_sigma * sqrt(k^2-1);    % ！！！改成sqrt(k^2-1)看得更加清晰！！！
for i = 3:s+3    % 从第3个sigma开始，后一个sigma是前一个sigma的k倍
    sigma(i) = k * sigma(i-1);
end
% input_img = imresize(input_img,2);    % 使用双立方插值会导致最终匹配到的关键点对数少很多
img = imresize(img,2,'bilinear');    % ！！！使用线性插值将图像扩展为原来的2倍！！！
img = gaussian(img,sqrt(init_sigma^2 - (2*0.5)^2));    % ！！！第一次高斯平滑！！！
% octvs = floor(log2(min(size(img))) - 2);    % ！！！根据图片的大小确定倍频程数（保证最少有8像素）！！！
octvs = 5;    % 指定层数为5层

%% 构建高斯金字塔
gauss_pyr = cell(octvs,1);
gimg_size = zeros(octvs,2);
gimg_size(1,:) = size(img)';    % 第一个倍频程图片的大小
for i = 1:octvs
    if (i~=1)    % 第一个倍频程以外的其它倍频程图片的大小
        gimg_size(i,:) = [round(size(gauss_pyr{i-1},1)/2);round(size(gauss_pyr{i-1},2)/2)];
    end
    % 初始化第一个倍频程
    gauss_pyr{i} = zeros(gimg_size(i,1),gimg_size(i,2),s+3);
end
for i = 1:octvs
    for j = 1:s+3
        if (i==1 && j==1)
            gauss_pyr{i}(:,:,j) = img;    % 现在input_img是原图2倍大小的、sigma为1.6的高斯平滑图像
        elseif (j==1)
            % 第一个倍频程以外的其它倍频程的第一幅图像是由上一个倍频程的第s+1幅图像降采样而得来的
            gauss_pyr{i}(:,:,j) = imresize(gauss_pyr{i-1}(:,:,s+1),0.5,'bilinear');
        else
            gauss_pyr{i}(:,:,j) = gaussian(gauss_pyr{i}(:,:,j-1),sigma(j));
        end
    end
end

%% 构建高斯差分金字塔（没什么可说的，逐次相减就行）
dog_pyr = cell(octvs,1);
for i = 1:octvs
    dog_pyr{i} = zeros(gimg_size(i,1),gimg_size(i,2),s+2);
    for j = 1:s+2
    dog_pyr{i}(:,:,j) = gauss_pyr{i}(:,:,j+1) - gauss_pyr{i}(:,:,j);
    end
end

%% 关键点的定位
img_border = 5;    % 留白边界大小(此范围内不考虑关键点的查找)
max_interp_steps = 5;     % 利用插值法完成精确定位时，最大的迭代次数
contr_thr = 0.04/s;    % ！！！低反差阈值，最好使用论文中的值0.03？而Rob Hess使用0.04/s！！！
curv_thr = 10;    % 边缘响应阈值
% ddata_array用于存储找到的所有关键点
ddata_array = struct('x',0,'y',0,'octv',0,'intvl',0,'x_hat',[0,0,0],'scl_octv',0);
ddata_index = 1;
for i = 1:octvs
    [height, width] = size(dog_pyr{i}(:,:,1));
    % 首尾两幅图像无法检测极值（无法参与关键点的定位）
    for j = 2:s+1
        dog_imgs = dog_pyr{i};    % 拿到每个倍频程中的所有高斯差分图像
        dog_img = dog_imgs(:,:,j);    % 一幅一幅图像操作
        for x = img_border+1:height-img_border
            for y = img_border+1:width-img_border
                % 与附近的26个点比较（空间3邻域），确定极值点
                if (isExtremum(j,dog_imgs,x,y))
                    ddata = interpLocation(dog_imgs,height,width,i,j,x,y,img_border,contr_thr,max_interp_steps);
                    if (~isempty(ddata))    % 若非空
                        if (~isEdgeLike(dog_img,ddata.x,ddata.y,curv_thr))    % 且不是边缘
                             ddata_array(ddata_index) = ddata;    % 存储关键点
                             ddata_index = ddata_index + 1;
                        end
                    end
                end
            end
        end
    end
end

%% 为关键点分配方向
n = size(ddata_array,2);    % 关键点的个数
ori_sig_factr = 1.5;    % Lowe建议的乘积因子，用于平滑梯度方向和大小矩阵
ori_hist_bins = 36;    % 直方图bin的数量
ori_peak_ratio = 0.8;    % 特征方向阈值，超过0.8倍最大值将保留
features = struct('ddata_index',0,'x',0,'y',0,'scl',0,'ori',0,'descr',[]);    % 特征集
feat_index = 1;
for i = 1:n
    ddata = ddata_array(i);
    ori_sigma = ori_sig_factr * ddata.scl_octv;    % 高斯加权窗的sigma
     % 在一个关键点的周围产生一个直方图
    hist = oriHist(gauss_pyr{ddata.octv}(:,:,ddata.intvl),ddata.x,ddata.y,ori_hist_bins,round(3*ori_sigma),ori_sigma);
    for j = 1:2    % 平滑两次
        smoothOriHist(hist,ori_hist_bins);
    end
    % 产生feature(梯度大小超过80%最大梯度值的梯度)
    feat_index = addOriFeatures(i,feat_index,ddata,hist,ori_hist_bins,ori_peak_ratio);
end

%% 为关键点生成特征(描述子)，这段有点难读
n = size(features,2);    % 特征点的数量
descr_hist_d = 4;    % 关键点形成描述子时所划分子区域的宽度
descr_hist_obins = 8;    % 方向直方图bin的数量
descr_mag_thr = 0.2;    % 特征梯度大小阈值
descr_length = descr_hist_d * descr_hist_d * descr_hist_obins;    % 特征向量的维数是4×4×8=128
local_features = features;    % 转全局变量为局部变量
local_ddata_array = ddata_array;
local_gauss_pyr = gauss_pyr;
clear global variable;    % 释放全局变量，节省内存
parfor feat_index = 1:n    % 对每一个关键点进行操作（共n个关键点）
    feat = local_features(feat_index);    % 取出一个关键点的features信息
    ddata = local_ddata_array(feat.ddata_index);    % 关联到该关键点的尺度空间，而不是原图
    gauss_img = local_gauss_pyr{ddata.octv}(:,:,ddata.intvl);    % 取出该关键点的高斯图像（梯度的求取应在此上进行）
    % 计算相应关键点的描述子的梯度直方图
    hist_width = 3 * ddata.scl_octv;    % 每个子区域（即那1/16个区域）所应包含的像素数目
    radius = round(hist_width * (descr_hist_d + 1) * sqrt(2) / 2);    % 描述子所需的图像区域半径
    feat_ori = feat.ori;    % 关键点的方向
    ddata_x = ddata.x;    % 关键点的坐标（在尺度空间里的坐标）
    ddata_y = ddata.y;    % 而不是在原图里的坐标
    hist = zeros(1,descr_length);    % 记录128维特征向量
    for i = -radius:radius    % 对关键点邻域中的每一个像素进行操作
        for j = -radius:radius    % i代表行，j代表列；分别对应着y和x
            % 实现旋转不变性
            j_rot = j*cos(feat_ori) - i*sin(feat_ori);
            i_rot = j*sin(feat_ori) + i*cos(feat_ori);
            r_bin = i_rot/hist_width + descr_hist_d/2 - 0.5;    % 对应行
            c_bin = j_rot/hist_width + descr_hist_d/2 - 0.5;    % 对应列
            if (r_bin > -1 && r_bin < descr_hist_d && c_bin > -1 && c_bin < descr_hist_d)
                mag_ori = calcGrad(gauss_img,ddata_x+i,ddata_y+j);
                if (mag_ori(1) ~= -1)
                    ori = mag_ori(2);
                    ori = ori - feat_ori;
                    while (ori < 0)
                        ori = ori + 2*pi;
                    end
                    while (ori >= 2*pi)
                        ori = ori - 2*pi;
                    end
                    % 属于8个bin中的哪一个
                    o_bin = ori * descr_hist_obins / (2*pi);
                    % 又进行高斯加权
                    w = exp(-(j_rot^2 + i_rot^2) / (2*(0.5*descr_hist_d*hist_width)^2));
                    hist = interpHistEntry(hist,r_bin,c_bin,o_bin,mag_ori(1)*w,descr_hist_d,descr_hist_obins);
                end
            end
        end
    end
    % 获得描述子（128维特征向量）
    local_features(feat_index) = hist2Descr(feat,hist,descr_mag_thr);
end

%% 将描述子按照尺度大小排序（整理描述子，利于匹配）
features_scl = [local_features.scl];    % 获得各关键点的描述子的尺度
[~,features_order] = sort(features_scl,'descend');    % 降序排列
descrs = zeros(n,descr_length);    % n×128维的描述子矩阵
locs = zeros(n,2);    % n×2维的关键点位置矩阵
for i = 1:n
    % 描述子的数量要大于关键点的数量，因为一个关键点可能被分配了多个方向
    % 而多个方向可用于生成多个不同的描述子
    descrs(i,:) = local_features(features_order(i)).descr;
    locs(i,1) = local_features(features_order(i)).x;    % 此时的位置是在原图上的位置
    locs(i,2) = local_features(features_order(i)).y;    % 而不是在尺度空间上的位置
end
end