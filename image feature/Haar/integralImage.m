function integral_img = integralImage(img)    % 构建积分图像
[rows,cols] = size(img);
% 积分图像的第一行和第一列应为0（其维度比原图多一行一列）
% 这样可以保证利用索引计算cell中灰度值的和时不会出错
integral_img = zeros(rows+1,cols+1);
for i = 1:rows
    for j = 1:cols
        if i==1 && j==1
            integral_img(i+1,j+1) = img(i,j);
        elseif i==1 && j~=1
            integral_img(i+1,j+1) = integral_img(i+1,j) + img(i,j);
        elseif i~=1 && j==1
            integral_img(i+1,j+1) = integral_img(i,j+1) + img(i,j);
        else
            integral_img(i+1,j+1) = img(i,j) + integral_img(i+1,j) + ...
                integral_img(i,j+1) - integral_img(i,j);
        end
    end
end
end