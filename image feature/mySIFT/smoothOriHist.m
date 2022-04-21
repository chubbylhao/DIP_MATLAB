function smoothOriHist(hist,n)
%% 方向直方图平滑
for i = 1:n
    if (i==1)    % 第一个bin较特殊
        prev = hist(n);
        next = hist(2);
    elseif (i==n)    % 最后一个bin也较特殊
        prev = hist(n-1);
        next = hist(1);
    else
        prev = hist(i-1);
        next = hist(i+1);
    end
    hist(i) = 0.25*prev + 0.5*hist(i) + 0.25*next;    % 加权平滑
end
end

