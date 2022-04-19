function [x,y] = myHarris(img,n)
fx = imfilter(img,[-0.5;0;0.5],'symmetric');
fy = imfilter(img,[-0.5,0,0.5],'symmetric');
h = fspecial('gaussian',7,1);
fx2 = imfilter(fx.^2,h);
fy2 = imfilter(fy.^2,h);
fxy = imfilter(fx.*fy,h);
[rows,cols] = size(img);
H = cell(rows,cols);
R = zeros(rows,cols);
for i = 1:numel(img)
   H{i} = [fx2(i),fxy(i);fxy(i),fy2(i)];
   R(i) = det(H{i}) - 0.04*(trace(H{i}))^2;
end
w = 3;    % 半窗宽
label = zeros(rows,cols);
for i = 1+w:rows-w    % 在7×7邻域内进行非极大值抑制
    for j = 1+w:cols-w
        if R(i,j) == max(max(R(i-w:i+w,j-w:j+w))) ...
                && R(i,j) > 0.01*abs(max(R(:)))
            label(i,j) = 1;
        end
    end
end
[~,ind] = maxk(label(:).*R(:),n);    % 找出前n个响应最强的点
[x,y] = ind2sub([rows,cols],ind);
end