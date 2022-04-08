function flag = predicate(region)
%% 针对于该分割问题而设计的谓词逻辑（不同问题具有不同谓词）
% region：待判断的图像子块
% flag：判断标志位

%% 根据平均值和标准差设计的谓词逻辑
% 标准差大于10，平均值大于0且小于125
flag = (std2(region) > 10) & (mean2(region) > 0) & (mean2(region) < 125);
end