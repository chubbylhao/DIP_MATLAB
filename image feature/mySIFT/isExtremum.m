function flag = isExtremum(intvl,dog_imgs,x,y)
%% 极值点（极大或极小）判断，与周围26个点比较（空间3邻域）
value = dog_imgs(x,y,intvl);
block = dog_imgs(x-1:x+1,y-1:y+1,intvl-1:intvl+1);
if (value == max(block(:)) || value == min(block(:)))
    flag = 1;
else
    flag = 0;
end
end