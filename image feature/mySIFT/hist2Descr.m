function feat = hist2Descr(feat,descr,descr_mag_thr)
%% 将直方图转换为描述子
descr = descr/norm(descr);
descr = min(descr_mag_thr,descr);    % 与阈值0.2作比较
descr = descr/norm(descr);
feat.descr = descr;
end