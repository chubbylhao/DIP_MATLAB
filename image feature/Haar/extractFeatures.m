function [haar_like,counts] = extractFeatures(integral_img,haar_kernel)
[H,W] = size(integral_img);    % 注意这是积分图像的大小，比原图像多一行一列（留心）
counts = zeros(1,numel(haar_kernel));    % 记录每个Haar模板（核）产生的特征矩阵数目
haar_like = [];    % 记录Haar特征值
for haar_kernel_counts = 1:numel(haar_kernel)    % 遍历Haar模板（核）
    [min_h,min_w] = size(haar_kernel{haar_kernel_counts});
    h = min_h*(1:floor(H/min_h));    % Haar窗口窗高的取值（对应行）
    w = min_w*(1:floor(W/min_w));    % Haar窗口窗宽的取值（对应列）
    for i = 1:numel(h)    % 遍历Haar窗高和窗宽的组合
        for j = 1:numel(w)
            op_h = h(i);    % 当前使用的Haar窗口的大小
            op_w = w(j);
            sweep_h = H - op_h;    % Haar窗口沿行、沿列能够扫描的步数
            sweep_w = W - op_w;    % 因为H和W是积分图像的高宽，故不需要加1
            for x = 1:sweep_h    % 每个Haar窗口产生的特征矩阵数目为sweep_h*sweep_w
                for y = 1:sweep_w
                    if isequal(haar_kernel{haar_kernel_counts},[1,-1])
                        white = integral_img(x,y) + integral_img(x+op_h,y+op_w/2) ...
                            - integral_img(x+op_h,y) - integral_img(x,y+op_w/2);
                        black = integral_img(x,y+op_w/2) + integral_img(x+op_h,y+op_w) ...
                            - integral_img(x+op_h,y+op_w/2) - integral_img(x,y+op_w);
                    elseif isequal(haar_kernel{haar_kernel_counts},[-1;1])
                        white = integral_img(x+op_h/2,y) + integral_img(x+op_h,y+op_w) ...
                            - integral_img(x+op_h,y) - integral_img(x+op_h/2,y+op_w);
                        black = integral_img(x,y) + integral_img(x+op_h/2,y+op_w) ...
                            - integral_img(x+op_h/2,y) - integral_img(x,y+op_w);
                    elseif isequal(haar_kernel{haar_kernel_counts},[1,-2,1])
                        white = integral_img(x,y) + integral_img(x+op_h,y+op_w/3) ...
                            - integral_img(x+op_h,y) - integral_img(x,y+op_w/3) ...
                            + integral_img(x,y+2*op_w/3) + integral_img(x+op_h,y+op_w) ...
                            - integral_img(x+op_h,y+2*op_w/3) - integral_img(x,y+op_w);
                        black = 2*(integral_img(x,y+op_w/3) + integral_img(x+op_h,y+2*op_w/3) ...
                            - integral_img(x+op_h,y+op_w/3) - integral_img(x,y+2*op_w/3));
                    elseif isequal(haar_kernel{haar_kernel_counts},[1,-1;-1,1])
                        white = integral_img(x,y) + integral_img(x+op_h/2,y+op_w/2) ...
                            - integral_img(x+op_h/2,y) - integral_img(x,y+op_w/2) ...
                            + integral_img(x+op_h/2,y+op_w/2) + integral_img(x+op_h,y+op_w) ...
                            - integral_img(x+op_h,y+op_w/2) - integral_img(x+op_h/2,y+op_w);
                        black = integral_img(x,y+op_w/2) + integral_img(x+op_h/2,y+op_w) ...
                            - integral_img(x+op_h/2,y+op_w/2) - integral_img(x,y+op_w) ...
                            + integral_img(x+op_h/2,y) + integral_img(x+op_h,y+op_w/2) ...
                            - integral_img(x+op_h,y) - integral_img(x+op_h/2,y+op_w/2);
                    else
                        error("此程序实现的是最早的3类型4形式的Haar特征！");
                    end
                    % 串联所有Haar特征值以构成Haar特征向量
                    haar_like = [haar_like;white - black];
                    counts(haar_kernel_counts) = counts(haar_kernel_counts) + 1;
                end
            end
        end
    end
end
end