function [x,y] = myDoH(img,n)
fxx = imfilter(img,[1;-2;1],'replicate');
fyy = imfilter(img,[1,-2,1],'replicate');
fxy = imfilter(img,[1;0;-1]*[1,0,-1]/4,'replicate');
[rows,cols] = size(img);
H = cell(rows,cols);
R = zeros(rows,cols);
for i = 1:numel(img)
    H{i} = [fxx(i),fxy(i);fxy(i),fyy(i)];
    R(i) = det(H{i});    % 计算DoH
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