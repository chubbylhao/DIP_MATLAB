function flag = isEdgeLike(img,x,y,curv_thr)
%% 消除边缘响应（有两个条件）
dxx = img(x,y+1) + img(x,y-1) - 2*img(x,y);
dyy = img(x+1,y) + img(x-1,y) - 2*img(x,y);
dxy = (img(x+1,y+1) + img(x-1,y-1) - img(x+1,y-1) - img(x-1,y+1))/4;
tr = dxx + dyy;    % 迹
det = dxx * dyy - dxy * dxy;    % 行列式
if ((det > 0) && (tr^2/det < (curv_thr + 1)^2/curv_thr))
    flag = 0;
else
    flag = 1;
end
end