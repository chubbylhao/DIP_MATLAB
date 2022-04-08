% “平均误差”越小，融合质量越好
function AD = ADmetric(img_f,img_r)
img_f = double(img_f);
img_r = double(img_r);
AD = sum(sum(abs(img_f-img_r)))/numel(img_f);
end